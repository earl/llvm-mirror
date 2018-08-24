//===--------------------- Scheduler.cpp ------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// A scheduler for processor resource units and processor resource groups.
//
//===----------------------------------------------------------------------===//

#include "Scheduler.h"
#include "Support.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

namespace mca {

using namespace llvm;

#define DEBUG_TYPE "llvm-mca"

ResourceStrategy::~ResourceStrategy() = default;

void Scheduler::initializeStrategy(std::unique_ptr<SchedulerStrategy> S) {
  // Ensure we have a valid (non-null) strategy object.
  Strategy = S ? std::move(S) : llvm::make_unique<DefaultSchedulerStrategy>();
}

void DefaultResourceStrategy::skipMask(uint64_t Mask) {
  NextInSequenceMask &= (~Mask);
  if (!NextInSequenceMask) {
    NextInSequenceMask = ResourceUnitMask ^ RemovedFromNextInSequence;
    RemovedFromNextInSequence = 0;
  }
}

uint64_t DefaultResourceStrategy::select(uint64_t ReadyMask) {
  // This method assumes that ReadyMask cannot be zero.
  uint64_t CandidateMask = llvm::PowerOf2Floor(NextInSequenceMask);
  while (!(ReadyMask & CandidateMask)) {
    skipMask(CandidateMask);
    CandidateMask = llvm::PowerOf2Floor(NextInSequenceMask);
  }
  return CandidateMask;
}

void DefaultResourceStrategy::used(uint64_t Mask) {
  if (Mask > NextInSequenceMask) {
    RemovedFromNextInSequence |= Mask;
    return;
  }
  skipMask(Mask);
}

ResourceState::ResourceState(const llvm::MCProcResourceDesc &Desc,
                             unsigned Index, uint64_t Mask)
    : ProcResourceDescIndex(Index), ResourceMask(Mask),
      BufferSize(Desc.BufferSize) {
  if (llvm::countPopulation(ResourceMask) > 1)
    ResourceSizeMask = ResourceMask ^ llvm::PowerOf2Floor(ResourceMask);
  else
    ResourceSizeMask = (1ULL << Desc.NumUnits) - 1;
  ReadyMask = ResourceSizeMask;
  AvailableSlots = BufferSize == -1 ? 0U : static_cast<unsigned>(BufferSize);
  Unavailable = false;
}

bool ResourceState::isReady(unsigned NumUnits) const {
  return (!isReserved() || isADispatchHazard()) &&
         llvm::countPopulation(ReadyMask) >= NumUnits;
}

ResourceStateEvent ResourceState::isBufferAvailable() const {
  if (isADispatchHazard() && isReserved())
    return RS_RESERVED;
  if (!isBuffered() || AvailableSlots)
    return RS_BUFFER_AVAILABLE;
  return RS_BUFFER_UNAVAILABLE;
}

#ifndef NDEBUG
void ResourceState::dump() const {
  dbgs() << "MASK: " << ResourceMask << ", SIZE_MASK: " << ResourceSizeMask
         << ", RDYMASK: " << ReadyMask << ", BufferSize=" << BufferSize
         << ", AvailableSlots=" << AvailableSlots
         << ", Reserved=" << Unavailable << '\n';
}
#endif

static unsigned getResourceStateIndex(uint64_t Mask) {
  return std::numeric_limits<uint64_t>::digits - llvm::countLeadingZeros(Mask);
}

static std::unique_ptr<ResourceStrategy>
getStrategyFor(const ResourceState &RS) {
  if (RS.isAResourceGroup() || RS.getNumUnits() > 1)
    return llvm::make_unique<DefaultResourceStrategy>(RS.getReadyMask());
  return std::unique_ptr<ResourceStrategy>(nullptr);
}

ResourceManager::ResourceManager(const llvm::MCSchedModel &SM)
    : ProcResID2Mask(SM.getNumProcResourceKinds()) {
  computeProcResourceMasks(SM, ProcResID2Mask);
  Resources.resize(SM.getNumProcResourceKinds());
  Strategies.resize(SM.getNumProcResourceKinds());

  for (unsigned I = 0, E = SM.getNumProcResourceKinds(); I < E; ++I) {
    uint64_t Mask = ProcResID2Mask[I];
    unsigned Index = getResourceStateIndex(Mask);
    Resources[Index] =
        llvm::make_unique<ResourceState>(*SM.getProcResource(I), I, Mask);
    Strategies[Index] = getStrategyFor(*Resources[Index]);
  }
}

void ResourceManager::setCustomStrategyImpl(std::unique_ptr<ResourceStrategy> S,
                                            uint64_t ResourceMask) {
  unsigned Index = getResourceStateIndex(ResourceMask);
  assert(Index < Resources.size() && "Invalid processor resource index!");
  assert(S && "Unexpected null strategy in input!");
  Strategies[Index] = std::move(S);
}

unsigned ResourceManager::resolveResourceMask(uint64_t Mask) const {
  return Resources[getResourceStateIndex(Mask)]->getProcResourceID();
}

unsigned ResourceManager::getNumUnits(uint64_t ResourceID) const {
  return Resources[getResourceStateIndex(ResourceID)]->getNumUnits();
}

// Returns the actual resource consumed by this Use.
// First, is the primary resource ID.
// Second, is the specific sub-resource ID.
ResourceRef ResourceManager::selectPipe(uint64_t ResourceID) {
  unsigned Index = getResourceStateIndex(ResourceID);
  ResourceState &RS = *Resources[Index];
  assert(RS.isReady() && "No available units to select!");

  // Special case where RS is not a group, and it only declares a single
  // resource unit.
  if (!RS.isAResourceGroup() && RS.getNumUnits() == 1)
    return std::make_pair(ResourceID, RS.getReadyMask());

  uint64_t SubResourceID = Strategies[Index]->select(RS.getReadyMask());
  if (RS.isAResourceGroup())
    return selectPipe(SubResourceID);
  return std::make_pair(ResourceID, SubResourceID);
}

void ResourceManager::use(const ResourceRef &RR) {
  // Mark the sub-resource referenced by RR as used.
  ResourceState &RS = *Resources[getResourceStateIndex(RR.first)];
  RS.markSubResourceAsUsed(RR.second);
  // If there are still available units in RR.first,
  // then we are done.
  if (RS.isReady())
    return;

  // Notify to other resources that RR.first is no longer available.
  for (std::unique_ptr<ResourceState> &Res : Resources) {
    ResourceState &Current = *Res;
    if (!Current.isAResourceGroup() || Current.getResourceMask() == RR.first)
      continue;

    if (Current.containsResource(RR.first)) {
      unsigned Index = getResourceStateIndex(Current.getResourceMask());
      Current.markSubResourceAsUsed(RR.first);
      Strategies[Index]->used(RR.first);
    }
  }
}

void ResourceManager::release(const ResourceRef &RR) {
  ResourceState &RS = *Resources[getResourceStateIndex(RR.first)];
  bool WasFullyUsed = !RS.isReady();
  RS.releaseSubResource(RR.second);
  if (!WasFullyUsed)
    return;

  for (std::unique_ptr<ResourceState> &Res : Resources) {
    ResourceState &Current = *Res;
    if (!Current.isAResourceGroup() || Current.getResourceMask() == RR.first)
      continue;

    if (Current.containsResource(RR.first))
      Current.releaseSubResource(RR.first);
  }
}

ResourceStateEvent
ResourceManager::canBeDispatched(ArrayRef<uint64_t> Buffers) const {
  ResourceStateEvent Result = ResourceStateEvent::RS_BUFFER_AVAILABLE;
  for (uint64_t Buffer : Buffers) {
    ResourceState &RS = *Resources[getResourceStateIndex(Buffer)];
    Result = RS.isBufferAvailable();
    if (Result != ResourceStateEvent::RS_BUFFER_AVAILABLE)
      break;
  }
  return Result;
}

void ResourceManager::reserveBuffers(ArrayRef<uint64_t> Buffers) {
  for (const uint64_t Buffer : Buffers) {
    ResourceState &RS = *Resources[getResourceStateIndex(Buffer)];
    assert(RS.isBufferAvailable() == ResourceStateEvent::RS_BUFFER_AVAILABLE);
    RS.reserveBuffer();

    if (RS.isADispatchHazard()) {
      assert(!RS.isReserved());
      RS.setReserved();
    }
  }
}

void ResourceManager::releaseBuffers(ArrayRef<uint64_t> Buffers) {
  for (const uint64_t R : Buffers)
    Resources[getResourceStateIndex(R)]->releaseBuffer();
}

bool ResourceManager::canBeIssued(const InstrDesc &Desc) const {
  return std::all_of(Desc.Resources.begin(), Desc.Resources.end(),
                     [&](const std::pair<uint64_t, const ResourceUsage> &E) {
                       unsigned NumUnits =
                           E.second.isReserved() ? 0U : E.second.NumUnits;
                       unsigned Index = getResourceStateIndex(E.first);
                       return Resources[Index]->isReady(NumUnits);
                     });
}

// Returns true if all resources are in-order, and there is at least one
// resource which is a dispatch hazard (BufferSize = 0).
bool ResourceManager::mustIssueImmediately(const InstrDesc &Desc) const {
  if (!canBeIssued(Desc))
    return false;
  bool AllInOrderResources = all_of(Desc.Buffers, [&](uint64_t BufferMask) {
    unsigned Index = getResourceStateIndex(BufferMask);
    const ResourceState &Resource = *Resources[Index];
    return Resource.isInOrder() || Resource.isADispatchHazard();
  });
  if (!AllInOrderResources)
    return false;

  return any_of(Desc.Buffers, [&](uint64_t BufferMask) {
    return Resources[getResourceStateIndex(BufferMask)]->isADispatchHazard();
  });
}

void ResourceManager::issueInstruction(
    const InstrDesc &Desc,
    SmallVectorImpl<std::pair<ResourceRef, double>> &Pipes) {
  for (const std::pair<uint64_t, ResourceUsage> &R : Desc.Resources) {
    const CycleSegment &CS = R.second.CS;
    if (!CS.size()) {
      releaseResource(R.first);
      continue;
    }

    assert(CS.begin() == 0 && "Invalid {Start, End} cycles!");
    if (!R.second.isReserved()) {
      ResourceRef Pipe = selectPipe(R.first);
      use(Pipe);
      BusyResources[Pipe] += CS.size();
      // Replace the resource mask with a valid processor resource index.
      const ResourceState &RS = *Resources[getResourceStateIndex(Pipe.first)];
      Pipe.first = RS.getProcResourceID();
      Pipes.emplace_back(
          std::pair<ResourceRef, double>(Pipe, static_cast<double>(CS.size())));
    } else {
      assert((countPopulation(R.first) > 1) && "Expected a group!");
      // Mark this group as reserved.
      assert(R.second.isReserved());
      reserveResource(R.first);
      BusyResources[ResourceRef(R.first, R.first)] += CS.size();
    }
  }
}

void ResourceManager::cycleEvent(SmallVectorImpl<ResourceRef> &ResourcesFreed) {
  for (std::pair<ResourceRef, unsigned> &BR : BusyResources) {
    if (BR.second)
      BR.second--;
    if (!BR.second) {
      // Release this resource.
      const ResourceRef &RR = BR.first;

      if (countPopulation(RR.first) == 1)
        release(RR);

      releaseResource(RR.first);
      ResourcesFreed.push_back(RR);
    }
  }

  for (const ResourceRef &RF : ResourcesFreed)
    BusyResources.erase(RF);
}

void ResourceManager::reserveResource(uint64_t ResourceID) {
  ResourceState &Resource = *Resources[getResourceStateIndex(ResourceID)];
  assert(!Resource.isReserved());
  Resource.setReserved();
}

void ResourceManager::releaseResource(uint64_t ResourceID) {
  ResourceState &Resource = *Resources[getResourceStateIndex(ResourceID)];
  Resource.clearReserved();
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

Scheduler::Status Scheduler::isAvailable(const InstRef &IR) const {
  const InstrDesc &Desc = IR.getInstruction()->getDesc();

  switch (Resources->canBeDispatched(Desc.Buffers)) {
  case ResourceStateEvent::RS_BUFFER_UNAVAILABLE:
    return Scheduler::SC_BUFFERS_FULL;
  case ResourceStateEvent::RS_RESERVED:
    return Scheduler::SC_DISPATCH_GROUP_STALL;
  case ResourceStateEvent::RS_BUFFER_AVAILABLE:
    break;
  }

  // Give lower priority to LSUnit stall events.
  switch (LSU->isAvailable(IR)) {
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
    SmallVectorImpl<std::pair<ResourceRef, double>> &UsedResources) {
  Instruction *IS = IR.getInstruction();
  const InstrDesc &D = IS->getDesc();

  // Issue the instruction and collect all the consumed resources
  // into a vector. That vector is then used to notify the listener.
  Resources->issueInstruction(D, UsedResources);

  // Notify the instruction that it started executing.
  // This updates the internal state of each write.
  IS->execute();

  if (IS->isExecuting())
    IssuedSet.emplace_back(IR);
  else if (IS->isExecuted())
    LSU->onInstructionExecuted(IR);
}

// Release the buffered resources and issue the instruction.
void Scheduler::issueInstruction(
    InstRef &IR, SmallVectorImpl<std::pair<ResourceRef, double>> &UsedResources,
    SmallVectorImpl<InstRef> &ReadyInstructions) {
  const Instruction &Inst = *IR.getInstruction();
  bool HasDependentUsers = Inst.hasDependentUsers();

  Resources->releaseBuffers(Inst.getDesc().Buffers);
  issueInstructionImpl(IR, UsedResources);
  // Instructions that have been issued during this cycle might have unblocked
  // other dependent instructions. Dependent instructions may be issued during
  // this same cycle if operands have ReadAdvance entries.  Promote those
  // instructions to the ReadySet and notify the caller that those are ready.
  if (HasDependentUsers)
    promoteToReadySet(ReadyInstructions);
}

void Scheduler::promoteToReadySet(SmallVectorImpl<InstRef> &Ready) {
  // Scan the set of waiting instructions and promote them to the
  // ready queue if operands are all ready.
  unsigned RemovedElements = 0;
  for (auto I = WaitSet.begin(), E = WaitSet.end(); I != E;) {
    InstRef &IR = *I;
    if (!IR.isValid())
      break;

    // Check if this instruction is now ready. In case, force
    // a transition in state using method 'update()'.
    Instruction &IS = *IR.getInstruction();
    if (!IS.isReady())
      IS.update();

    // Check if there are still unsolved data dependencies.
    if (!isReady(IR)) {
      ++I;
      continue;
    }

    Ready.emplace_back(IR);
    ReadySet.emplace_back(IR);

    IR.invalidate();
    ++RemovedElements;
    std::iter_swap(I, E - RemovedElements);
  }

  WaitSet.resize(WaitSet.size() - RemovedElements);
}

InstRef Scheduler::select() {
  unsigned QueueIndex = ReadySet.size();
  for (unsigned I = 0, E = ReadySet.size(); I != E; ++I) {
    const InstRef &IR = ReadySet[I];
    if (QueueIndex == ReadySet.size() ||
        Strategy->compare(IR, ReadySet[QueueIndex])) {
      const InstrDesc &D = IR.getInstruction()->getDesc();
      if (Resources->canBeIssued(D))
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
    if (!IR.isValid())
      break;
    Instruction &IS = *IR.getInstruction();
    if (!IS.isExecuted()) {
      LLVM_DEBUG(dbgs() << "[SCHEDULER]: Instruction #" << IR
                        << " is still executing.\n");
      ++I;
      continue;
    }

    // Instruction IR has completed execution.
    LSU->onInstructionExecuted(IR);
    Executed.emplace_back(IR);
    ++RemovedElements;
    IR.invalidate();
    std::iter_swap(I, E - RemovedElements);
  }

  IssuedSet.resize(IssuedSet.size() - RemovedElements);
}

void Scheduler::cycleEvent(SmallVectorImpl<ResourceRef> &Freed,
                           SmallVectorImpl<InstRef> &Executed,
                           SmallVectorImpl<InstRef> &Ready) {
  // Release consumed resources.
  Resources->cycleEvent(Freed);

  // Propagate the cycle event to the 'Issued' and 'Wait' sets.
  for (InstRef &IR : IssuedSet)
    IR.getInstruction()->cycleEvent();

  updateIssuedSet(Executed);

  for (InstRef &IR : WaitSet)
    IR.getInstruction()->cycleEvent();

  promoteToReadySet(Ready);
}

bool Scheduler::mustIssueImmediately(const InstRef &IR) const {
  // Instructions that use an in-order dispatch/issue processor resource must be
  // issued immediately to the pipeline(s). Any other in-order buffered
  // resources (i.e. BufferSize=1) is consumed.
  const InstrDesc &Desc = IR.getInstruction()->getDesc();
  return Desc.isZeroLatency() || Resources->mustIssueImmediately(Desc);
}

void Scheduler::dispatch(const InstRef &IR) {
  const InstrDesc &Desc = IR.getInstruction()->getDesc();
  Resources->reserveBuffers(Desc.Buffers);

  // If necessary, reserve queue entries in the load-store unit (LSU).
  bool IsMemOp = Desc.MayLoad || Desc.MayStore;
  if (IsMemOp)
    LSU->dispatch(IR);

  if (!isReady(IR)) {
    LLVM_DEBUG(dbgs() << "[SCHEDULER] Adding #" << IR << " to the WaitSet\n");
    WaitSet.push_back(IR);
    return;
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
}

bool Scheduler::isReady(const InstRef &IR) const {
  const InstrDesc &Desc = IR.getInstruction()->getDesc();
  bool IsMemOp = Desc.MayLoad || Desc.MayStore;
  return IR.getInstruction()->isReady() && (!IsMemOp || LSU->isReady(IR));
}

} // namespace mca
