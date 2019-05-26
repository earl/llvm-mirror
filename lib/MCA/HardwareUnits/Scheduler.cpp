//===--------------------- Scheduler.cpp ------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// A scheduler for processor resource units and processor resource groups.
//
//===----------------------------------------------------------------------===//

#include "llvm/MCA/HardwareUnits/Scheduler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

namespace llvm {
namespace mca {

#define DEBUG_TYPE "llvm-mca"

void Scheduler::initializeStrategy(std::unique_ptr<SchedulerStrategy> S) {
  // Ensure we have a valid (non-null) strategy object.
  Strategy = S ? std::move(S) : llvm::make_unique<DefaultSchedulerStrategy>();
}

// Anchor the vtable of SchedulerStrategy and DefaultSchedulerStrategy.
SchedulerStrategy::~SchedulerStrategy() = default;
DefaultSchedulerStrategy::~DefaultSchedulerStrategy() = default;

#ifndef NDEBUG
void Scheduler::dump() const {
  dbgs() << "[SCHEDULER]: WaitSet size is: " << WaitSet.size() << '\n';
  dbgs() << "[SCHEDULER]: ReadySet size is: " << ReadySet.size() << '\n';
  dbgs() << "[SCHEDULER]: IssuedSet size is: " << IssuedSet.size() << '\n';
  Resources->dump();
}
#endif

Scheduler::Status Scheduler::isAvailable(const InstRef &IR) {
  const InstrDesc &Desc = IR.getInstruction()->getDesc();

  ResourceStateEvent RSE = Resources->canBeDispatched(Desc.Buffers);
  HadTokenStall = RSE != RS_BUFFER_AVAILABLE;

  switch (RSE) {
  case ResourceStateEvent::RS_BUFFER_UNAVAILABLE:
    return Scheduler::SC_BUFFERS_FULL;
  case ResourceStateEvent::RS_RESERVED:
    return Scheduler::SC_DISPATCH_GROUP_STALL;
  case ResourceStateEvent::RS_BUFFER_AVAILABLE:
    break;
  }

  // Give lower priority to LSUnit stall events.
  LSUnit::Status LSS = LSU.isAvailable(IR);
  HadTokenStall = LSS != LSUnit::LSU_AVAILABLE;

  switch (LSS) {
  case LSUnit::LSU_LQUEUE_FULL:
    return Scheduler::SC_LOAD_QUEUE_FULL;
  case LSUnit::LSU_SQUEUE_FULL:
    return Scheduler::SC_STORE_QUEUE_FULL;
  case LSUnit::LSU_AVAILABLE:
    return Scheduler::SC_AVAILABLE;
  }

  llvm_unreachable("Don't know how to process this LSU state result!");
}

void Scheduler::issueInstructionImpl(
    InstRef &IR,
    SmallVectorImpl<std::pair<ResourceRef, ResourceCycles>> &UsedResources) {
  Instruction *IS = IR.getInstruction();
  const InstrDesc &D = IS->getDesc();

  // Issue the instruction and collect all the consumed resources
  // into a vector. That vector is then used to notify the listener.
  Resources->issueInstruction(D, UsedResources);

  // Notify the instruction that it started executing.
  // This updates the internal state of each write.
  IS->execute(IR.getSourceIndex());

  IS->computeCriticalRegDep();

  if (IS->isExecuting())
    IssuedSet.emplace_back(IR);
  else if (IS->isExecuted())
    LSU.onInstructionExecuted(IR);
}

// Release the buffered resources and issue the instruction.
void Scheduler::issueInstruction(
    InstRef &IR,
    SmallVectorImpl<std::pair<ResourceRef, ResourceCycles>> &UsedResources,
    SmallVectorImpl<InstRef> &PendingInstructions,
    SmallVectorImpl<InstRef> &ReadyInstructions) {
  const Instruction &Inst = *IR.getInstruction();
  bool HasDependentUsers = Inst.hasDependentUsers();

  Resources->releaseBuffers(Inst.getDesc().Buffers);
  issueInstructionImpl(IR, UsedResources);
  // Instructions that have been issued during this cycle might have unblocked
  // other dependent instructions. Dependent instructions may be issued during
  // this same cycle if operands have ReadAdvance entries.  Promote those
  // instructions to the ReadySet and notify the caller that those are ready.
  if (HasDependentUsers && promoteToPendingSet(PendingInstructions))
    promoteToReadySet(ReadyInstructions);
}

static bool initializeCriticalMemDepInfo(InstRef &IR, const LSUnit &LSU) {
  Instruction &IS = *IR.getInstruction();
  assert(IS.isMemOp() && "Not a memory operation!");

  // Check if this instruction depends on another memory operation.
  InstRef DependentMemOp = LSU.isReady(IR);
  const Instruction *MemOp = DependentMemOp.getInstruction();
  IS.setCurrentMemDep(MemOp);

  // Initialize the CriticalMemDep structure.
  unsigned Cycles = 0;
  if (MemOp->isExecuting())
    Cycles = static_cast<unsigned>(MemOp->getCyclesLeft());
  IS.setCriticalMemDep(DependentMemOp.getSourceIndex(), Cycles);
  return IR.getSourceIndex() == DependentMemOp.getSourceIndex();
}

static bool updateMemoryDependencyInfo(InstRef &IR, const LSUnit &LSU) {
  Instruction &IS = *IR.getInstruction();
  assert(IS.isMemOp() && "Not a memory operation!");

  const Instruction *MemOp = IS.getCurrentMemDep();
  if (!MemOp && initializeCriticalMemDepInfo(IR, LSU))
    return true;

  MemOp = IS.getCurrentMemDep();
  if (MemOp == IR.getInstruction())
    return true;

  const CriticalDependency &CMD = IS.getCriticalMemDep();
  if (MemOp->isExecuting() && !CMD.Cycles) {
    // Update the critical memory dependency info.
    IS.setCriticalMemDep(CMD.IID, MemOp->getCyclesLeft());
    return false;
  }

  if (!MemOp->isExecuted() && !MemOp->isRetired())
    return false;

  // Check if there are still unsolved memory dependencies.
  InstRef DependentMemOp = LSU.isReady(IR);
  MemOp = DependentMemOp.getInstruction();
  IS.setCurrentMemDep(MemOp);
  if (DependentMemOp == IR)
    return true;

  unsigned Cycles = 0;
  if (MemOp->isExecuting())
    Cycles = static_cast<unsigned>(MemOp->getCyclesLeft());
  IS.setCriticalMemDep(DependentMemOp.getSourceIndex(), Cycles);
  return false;
}

bool Scheduler::promoteToReadySet(SmallVectorImpl<InstRef> &Ready) {
  // Scan the set of waiting instructions and promote them to the
  // ready set if operands are all ready.
  unsigned PromotedElements = 0;
  for (auto I = PendingSet.begin(), E = PendingSet.end(); I != E;) {
    InstRef &IR = *I;
    if (!IR)
      break;

    // Check if there are unsolved memory dependencies.
    Instruction &IS = *IR.getInstruction();
    if (IS.isMemOp() && !updateMemoryDependencyInfo(IR, LSU)) {
      ++I;
      continue;
    }

    // Check if there are unsolved register dependencies.
    if (!IS.isReady() && !IS.updatePending()) {
      ++I;
      continue;
    }
    LLVM_DEBUG(dbgs() << "[SCHEDULER]: Instruction #" << IR
                      << " promoted to the READY set.\n");

    Ready.emplace_back(IR);
    ReadySet.emplace_back(IR);

    IR.invalidate();
    ++PromotedElements;
    std::iter_swap(I, E - PromotedElements);
  }

  PendingSet.resize(PendingSet.size() - PromotedElements);
  return PromotedElements;
}

bool Scheduler::promoteToPendingSet(SmallVectorImpl<InstRef> &Pending) {
  // Scan the set of waiting instructions and promote them to the
  // pending set if operands are all ready.
  unsigned RemovedElements = 0;
  for (auto I = WaitSet.begin(), E = WaitSet.end(); I != E;) {
    InstRef &IR = *I;
    if (!IR)
      break;

    // Check if this instruction is now ready. In case, force
    // a transition in state using method 'updateDispatched()'.
    Instruction &IS = *IR.getInstruction();
    if (IS.isDispatched() && !IS.updateDispatched()) {
      ++I;
      continue;
    }
    LLVM_DEBUG(dbgs() << "[SCHEDULER]: Instruction #" << IR
                      << " promoted to the PENDING set.\n");

    Pending.emplace_back(IR);
    PendingSet.emplace_back(IR);

    IR.invalidate();
    ++RemovedElements;
    std::iter_swap(I, E - RemovedElements);
  }

  WaitSet.resize(WaitSet.size() - RemovedElements);
  return RemovedElements;
}

InstRef Scheduler::select() {
  unsigned QueueIndex = ReadySet.size();
  for (unsigned I = 0, E = ReadySet.size(); I != E; ++I) {
    InstRef &IR = ReadySet[I];
    if (QueueIndex == ReadySet.size() ||
        Strategy->compare(IR, ReadySet[QueueIndex])) {
      Instruction &IS = *IR.getInstruction();
      uint64_t BusyResourceMask = Resources->checkAvailability(IS.getDesc());
      IS.setCriticalResourceMask(BusyResourceMask);
      BusyResourceUnits |= BusyResourceMask;
      if (!BusyResourceMask)
        QueueIndex = I;
    }
  }

  if (QueueIndex == ReadySet.size())
    return InstRef();

  // We found an instruction to issue.
  InstRef IR = ReadySet[QueueIndex];
  std::swap(ReadySet[QueueIndex], ReadySet[ReadySet.size() - 1]);
  ReadySet.pop_back();
  return IR;
}

void Scheduler::updateIssuedSet(SmallVectorImpl<InstRef> &Executed) {
  unsigned RemovedElements = 0;
  for (auto I = IssuedSet.begin(), E = IssuedSet.end(); I != E;) {
    InstRef &IR = *I;
    if (!IR)
      break;
    Instruction &IS = *IR.getInstruction();
    if (!IS.isExecuted()) {
      LLVM_DEBUG(dbgs() << "[SCHEDULER]: Instruction #" << IR
                        << " is still executing.\n");
      ++I;
      continue;
    }

    // Instruction IR has completed execution.
    LSU.onInstructionExecuted(IR);
    Executed.emplace_back(IR);
    ++RemovedElements;
    IR.invalidate();
    std::iter_swap(I, E - RemovedElements);
  }

  IssuedSet.resize(IssuedSet.size() - RemovedElements);
}

uint64_t Scheduler::analyzeResourcePressure(SmallVectorImpl<InstRef> &Insts) {
  Insts.insert(Insts.end(), ReadySet.begin(), ReadySet.end());
  return BusyResourceUnits;
}

void Scheduler::analyzeDataDependencies(SmallVectorImpl<InstRef> &RegDeps,
                                        SmallVectorImpl<InstRef> &MemDeps) {
  const auto EndIt = PendingSet.end() - NumDispatchedToThePendingSet;
  for (InstRef &IR : make_range(PendingSet.begin(), EndIt)) {
    Instruction &IS = *IR.getInstruction();
    if (Resources->checkAvailability(IS.getDesc()))
      continue;

    if (IS.isReady() || (IS.isMemOp() && LSU.isReady(IR) != IR))
      MemDeps.emplace_back(IR);
    else
      RegDeps.emplace_back(IR);
  }
}

void Scheduler::cycleEvent(SmallVectorImpl<ResourceRef> &Freed,
                           SmallVectorImpl<InstRef> &Executed,
                           SmallVectorImpl<InstRef> &Pending,
                           SmallVectorImpl<InstRef> &Ready) {
  // Release consumed resources.
  Resources->cycleEvent(Freed);

  for (InstRef &IR : IssuedSet)
    IR.getInstruction()->cycleEvent();
  updateIssuedSet(Executed);

  for (InstRef &IR : PendingSet)
    IR.getInstruction()->cycleEvent();

  for (InstRef &IR : WaitSet)
    IR.getInstruction()->cycleEvent();

  promoteToPendingSet(Pending);
  promoteToReadySet(Ready);

  NumDispatchedToThePendingSet = 0;
  BusyResourceUnits = 0;
}

bool Scheduler::mustIssueImmediately(const InstRef &IR) const {
  const InstrDesc &Desc = IR.getInstruction()->getDesc();
  if (Desc.isZeroLatency())
    return true;
  // Instructions that use an in-order dispatch/issue processor resource must be
  // issued immediately to the pipeline(s). Any other in-order buffered
  // resources (i.e. BufferSize=1) is consumed.
  return Desc.MustIssueImmediately;
}

bool Scheduler::dispatch(const InstRef &IR) {
  const Instruction &IS = *IR.getInstruction();
  const InstrDesc &Desc = IS.getDesc();
  Resources->reserveBuffers(Desc.Buffers);

  // If necessary, reserve queue entries in the load-store unit (LSU).
  if (IS.isMemOp())
    LSU.dispatch(IR);

  if (IS.isPending()) {
    LLVM_DEBUG(dbgs() << "[SCHEDULER] Adding #" << IR
                      << " to the PendingSet\n");
    PendingSet.push_back(IR);
    ++NumDispatchedToThePendingSet;
    return false;
  }

  // Memory operations that are not in a ready state are initially assigned to
  // the WaitSet.
  if (!IS.isReady() || (IS.isMemOp() && LSU.isReady(IR) != IR)) {
    LLVM_DEBUG(dbgs() << "[SCHEDULER] Adding #" << IR << " to the WaitSet\n");
    WaitSet.push_back(IR);
    return false;
  }

  // Don't add a zero-latency instruction to the Ready queue.
  // A zero-latency instruction doesn't consume any scheduler resources. That is
  // because it doesn't need to be executed, and it is often removed at register
  // renaming stage. For example, register-register moves are often optimized at
  // register renaming stage by simply updating register aliases. On some
  // targets, zero-idiom instructions (for example: a xor that clears the value
  // of a register) are treated specially, and are often eliminated at register
  // renaming stage.
  if (!mustIssueImmediately(IR)) {
    LLVM_DEBUG(dbgs() << "[SCHEDULER] Adding #" << IR << " to the ReadySet\n");
    ReadySet.push_back(IR);
  }

  return true;
}

} // namespace mca
} // namespace llvm
