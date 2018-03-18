//===--------------------- Dispatch.cpp -------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file implements methods declared by class RegisterFile, DispatchUnit
/// and RetireControlUnit.
///
//===----------------------------------------------------------------------===//

#include "Dispatch.h"
#include "Backend.h"
#include "HWEventListener.h"
#include "Scheduler.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "llvm-mca"

namespace mca {

void RegisterFile::addRegisterFile(ArrayRef<unsigned> RegisterClasses,
                                   unsigned NumTemps) {
  unsigned RegisterFileIndex = RegisterFiles.size();
  assert(RegisterFileIndex < 32 && "Too many register files!");
  RegisterFiles.emplace_back(NumTemps);

  // Special case where there are no register classes specified.
  // An empty register class set means *all* registers.
  if (RegisterClasses.empty()) {
    for (std::pair<WriteState *, unsigned> &Mapping : RegisterMappings)
      Mapping.second |= 1U << RegisterFileIndex;
  } else {
    for (const unsigned RegClassIndex : RegisterClasses) {
      const MCRegisterClass &RC = MRI.getRegClass(RegClassIndex);
      for (const MCPhysReg Reg : RC)
        RegisterMappings[Reg].second |= 1U << RegisterFileIndex;
    }
  }
}

void RegisterFile::createNewMappings(unsigned RegisterFileMask) {
  assert(RegisterFileMask && "RegisterFileMask cannot be zero!");
  // Notify each register file that contains RegID.
  do {
    unsigned NextRegisterFile = llvm::PowerOf2Floor(RegisterFileMask);
    unsigned RegisterFileIndex = llvm::countTrailingZeros(NextRegisterFile);
    RegisterMappingTracker &RMT = RegisterFiles[RegisterFileIndex];
    RMT.NumUsedMappings++;
    RMT.MaxUsedMappings = std::max(RMT.MaxUsedMappings, RMT.NumUsedMappings);
    RMT.TotalMappingsCreated++;
    RegisterFileMask ^= NextRegisterFile;
  } while (RegisterFileMask);
}

void RegisterFile::removeMappings(unsigned RegisterFileMask) {
  assert(RegisterFileMask && "RegisterFileMask cannot be zero!");
  // Notify each register file that contains RegID.
  do {
    unsigned NextRegisterFile = llvm::PowerOf2Floor(RegisterFileMask);
    unsigned RegisterFileIndex = llvm::countTrailingZeros(NextRegisterFile);
    RegisterMappingTracker &RMT = RegisterFiles[RegisterFileIndex];
    assert(RMT.NumUsedMappings);
    RMT.NumUsedMappings--;
    RegisterFileMask ^= NextRegisterFile;
  } while (RegisterFileMask);
}

void RegisterFile::addRegisterMapping(WriteState &WS) {
  unsigned RegID = WS.getRegisterID();
  assert(RegID && "Adding an invalid register definition?");

  RegisterMapping &Mapping = RegisterMappings[RegID];
  Mapping.first = &WS;
  for (MCSubRegIterator I(RegID, &MRI); I.isValid(); ++I)
    RegisterMappings[*I].first = &WS;

  createNewMappings(Mapping.second);
  // If this is a partial update, then we are done.
  if (!WS.fullyUpdatesSuperRegs())
    return;

  for (MCSuperRegIterator I(RegID, &MRI); I.isValid(); ++I)
    RegisterMappings[*I].first = &WS;
}

void RegisterFile::invalidateRegisterMapping(const WriteState &WS) {
  unsigned RegID = WS.getRegisterID();
  bool ShouldInvalidateSuperRegs = WS.fullyUpdatesSuperRegs();

  assert(RegID != 0 && "Invalidating an already invalid register?");
  assert(WS.getCyclesLeft() != -512 &&
         "Invalidating a write of unknown cycles!");
  assert(WS.getCyclesLeft() <= 0 && "Invalid cycles left for this write!");
  RegisterMapping &Mapping = RegisterMappings[RegID];
  if (!Mapping.first)
    return;

  removeMappings(Mapping.second);

  if (Mapping.first == &WS)
    Mapping.first = nullptr;

  for (MCSubRegIterator I(RegID, &MRI); I.isValid(); ++I)
    if (RegisterMappings[*I].first == &WS)
      RegisterMappings[*I].first = nullptr;

  if (!ShouldInvalidateSuperRegs)
    return;

  for (MCSuperRegIterator I(RegID, &MRI); I.isValid(); ++I)
    if (RegisterMappings[*I].first == &WS)
      RegisterMappings[*I].first = nullptr;
}

// Update the number of used mappings in the event of instruction retired.
// This mehod delegates to the register file the task of invalidating
// register mappings that were created for instruction IS.
void DispatchUnit::invalidateRegisterMappings(const Instruction &IS) {
  for (const std::unique_ptr<WriteState> &WS : IS.getDefs()) {
    DEBUG(dbgs() << "[RAT] Invalidating mapping for: ");
    DEBUG(WS->dump());
    RAT->invalidateRegisterMapping(*WS.get());
  }
}

void RegisterFile::collectWrites(SmallVectorImpl<WriteState *> &Writes,
                                 unsigned RegID) const {
  assert(RegID && RegID < RegisterMappings.size());
  WriteState *WS = RegisterMappings[RegID].first;
  if (WS) {
    DEBUG(dbgs() << "Found a dependent use of RegID=" << RegID << '\n');
    Writes.push_back(WS);
  }

  // Handle potential partial register updates.
  for (MCSubRegIterator I(RegID, &MRI); I.isValid(); ++I) {
    WS = RegisterMappings[*I].first;
    if (WS && std::find(Writes.begin(), Writes.end(), WS) == Writes.end()) {
      DEBUG(dbgs() << "Found a dependent use of subReg " << *I << " (part of "
                   << RegID << ")\n");
      Writes.push_back(WS);
    }
  }
}

unsigned RegisterFile::isAvailable(const ArrayRef<unsigned> Regs) const {
  SmallVector<unsigned, 4> NumTemporaries(getNumRegisterFiles());

  // Find how many new mappings must be created for each register file.
  for (const unsigned RegID : Regs) {
    unsigned RegisterFileMask = RegisterMappings[RegID].second;
    do {
      unsigned NextRegisterFileID = llvm::PowerOf2Floor(RegisterFileMask);
      NumTemporaries[llvm::countTrailingZeros(NextRegisterFileID)]++;
      RegisterFileMask ^= NextRegisterFileID;
    } while (RegisterFileMask);
  }

  unsigned Response = 0;
  for (unsigned I = 0, E = getNumRegisterFiles(); I < E; ++I) {
    unsigned Temporaries = NumTemporaries[I];
    if (!Temporaries)
      continue;

    const RegisterMappingTracker &RMT = RegisterFiles[I];
    if (!RMT.TotalMappings) {
      // The register file has an unbound number of microarchitectural
      // registers.
      continue;
    }

    if (RMT.TotalMappings < Temporaries) {
      // The current register file is too small. This may occur if the number of
      // microarchitectural registers in register file #0 was changed by the
      // users via flag -reg-file-size. Alternatively, the scheduling model
      // specified a too small number of registers for this register file.
      report_fatal_error(
          "Not enough microarchitectural registers in the register file");
    }

    if (RMT.TotalMappings < RMT.NumUsedMappings + Temporaries)
      Response |= (1U << I);
  }

  return Response;
}

#ifndef NDEBUG
void RegisterFile::dump() const {
  for (unsigned I = 0, E = MRI.getNumRegs(); I < E; ++I) {
    const RegisterMapping &RM = RegisterMappings[I];
    dbgs() << MRI.getName(I) << ", " << I << ", Map=" << RM.second << ", ";
    if (RM.first)
      RM.first->dump();
    else
      dbgs() << "(null)\n";
  }

  for (unsigned I = 0, E = getNumRegisterFiles(); I < E; ++I) {
    dbgs() << "Register File #" << I;
    const RegisterMappingTracker &RMT = RegisterFiles[I];
    dbgs() << "\n  TotalMappings:        " << RMT.TotalMappings
           << "\n  TotalMappingsCreated: " << RMT.TotalMappingsCreated
           << "\n  MaxUsedMappings:      " << RMT.MaxUsedMappings
           << "\n  NumUsedMappings:      " << RMT.NumUsedMappings << '\n';
  }
}
#endif

// Reserves a number of slots, and returns a new token.
unsigned RetireControlUnit::reserveSlot(unsigned Index, unsigned NumMicroOps) {
  assert(isAvailable(NumMicroOps));
  unsigned NormalizedQuantity =
      std::min(NumMicroOps, static_cast<unsigned>(Queue.size()));
  // Zero latency instructions may have zero mOps. Artificially bump this
  // value to 1. Although zero latency instructions don't consume scheduler
  // resources, they still consume one slot in the retire queue.
  NormalizedQuantity = std::max(NormalizedQuantity, 1U);
  unsigned TokenID = NextAvailableSlotIdx;
  Queue[NextAvailableSlotIdx] = {Index, NormalizedQuantity, false};
  NextAvailableSlotIdx += NormalizedQuantity;
  NextAvailableSlotIdx %= Queue.size();
  AvailableSlots -= NormalizedQuantity;
  return TokenID;
}

void DispatchUnit::notifyInstructionDispatched(unsigned Index) {
  DEBUG(dbgs() << "[E] Instruction Dispatched: " << Index << '\n');
  Owner->notifyInstructionEvent(
      HWInstructionEvent(HWInstructionEvent::Dispatched, Index));
}

void DispatchUnit::notifyInstructionRetired(unsigned Index) {
  DEBUG(dbgs() << "[E] Instruction Retired: " << Index << '\n');
  Owner->notifyInstructionEvent(
      HWInstructionEvent(HWInstructionEvent::Retired, Index));

  const Instruction &IS = Owner->getInstruction(Index);
  invalidateRegisterMappings(IS);
  Owner->eraseInstruction(Index);
}

void RetireControlUnit::cycleEvent() {
  if (isEmpty())
    return;

  unsigned NumRetired = 0;
  while (!isEmpty()) {
    if (MaxRetirePerCycle != 0 && NumRetired == MaxRetirePerCycle)
      break;
    RUToken &Current = Queue[CurrentInstructionSlotIdx];
    assert(Current.NumSlots && "Reserved zero slots?");
    if (!Current.Executed)
      break;
    Owner->notifyInstructionRetired(Current.Index);
    CurrentInstructionSlotIdx += Current.NumSlots;
    CurrentInstructionSlotIdx %= Queue.size();
    AvailableSlots += Current.NumSlots;
    NumRetired++;
  }
}

void RetireControlUnit::onInstructionExecuted(unsigned TokenID) {
  assert(Queue.size() > TokenID);
  assert(Queue[TokenID].Executed == false && Queue[TokenID].Index != ~0U);
  Queue[TokenID].Executed = true;
}

#ifndef NDEBUG
void RetireControlUnit::dump() const {
  dbgs() << "Retire Unit: { Total Slots=" << Queue.size()
         << ", Available Slots=" << AvailableSlots << " }\n";
}
#endif

bool DispatchUnit::checkRAT(const Instruction &Instr) {
  // Collect register definitions from the WriteStates.
  SmallVector<unsigned, 8> RegDefs;

  for (const std::unique_ptr<WriteState> &Def : Instr.getDefs())
    RegDefs.push_back(Def->getRegisterID());

  unsigned RegisterMask = RAT->isAvailable(RegDefs);
  // A mask with all zeroes means: register files are available.
  if (RegisterMask) {
    // TODO: We currently implement a single hardware counter for all the
    // dispatch stalls caused by the unavailability of registers in one of the
    // register files.  In future, we want to let register files directly notify
    // hardware listeners in the event of a dispatch stall.  This would simplify
    // the logic in Dispatch.[h/cpp], and move all the "hardware counting logic"
    // into a View (for example: BackendStatistics).
    DispatchStalls[DS_RAT_REG_UNAVAILABLE]++;
    return false;
  }

  return true;
}

bool DispatchUnit::checkRCU(const InstrDesc &Desc) {
  unsigned NumMicroOps = Desc.NumMicroOps;
  if (RCU->isAvailable(NumMicroOps))
    return true;
  DispatchStalls[DS_RCU_TOKEN_UNAVAILABLE]++;
  return false;
}

bool DispatchUnit::checkScheduler(const InstrDesc &Desc) {
  // If this is a zero-latency instruction, then it bypasses
  // the scheduler.
  switch (SC->canBeDispatched(Desc)) {
  case Scheduler::HWS_AVAILABLE:
    return true;
  case Scheduler::HWS_QUEUE_UNAVAILABLE:
    DispatchStalls[DS_SQ_TOKEN_UNAVAILABLE]++;
    break;
  case Scheduler::HWS_LD_QUEUE_UNAVAILABLE:
    DispatchStalls[DS_LDQ_TOKEN_UNAVAILABLE]++;
    break;
  case Scheduler::HWS_ST_QUEUE_UNAVAILABLE:
    DispatchStalls[DS_STQ_TOKEN_UNAVAILABLE]++;
    break;
  case Scheduler::HWS_DISPATCH_GROUP_RESTRICTION:
    DispatchStalls[DS_DISPATCH_GROUP_RESTRICTION]++;
  }

  return false;
}

void DispatchUnit::updateRAWDependencies(ReadState &RS,
                                         const MCSubtargetInfo &STI) {
  SmallVector<WriteState *, 4> DependentWrites;

  collectWrites(DependentWrites, RS.getRegisterID());
  RS.setDependentWrites(DependentWrites.size());
  DEBUG(dbgs() << "Found " << DependentWrites.size() << " dependent writes\n");
  // We know that this read depends on all the writes in DependentWrites.
  // For each write, check if we have ReadAdvance information, and use it
  // to figure out in how many cycles this read becomes available.
  const ReadDescriptor &RD = RS.getDescriptor();
  if (!RD.HasReadAdvanceEntries) {
    for (WriteState *WS : DependentWrites)
      WS->addUser(&RS, /* ReadAdvance */ 0);
    return;
  }

  const MCSchedModel &SM = STI.getSchedModel();
  const MCSchedClassDesc *SC = SM.getSchedClassDesc(RD.SchedClassID);
  for (WriteState *WS : DependentWrites) {
    unsigned WriteResID = WS->getWriteResourceID();
    int ReadAdvance = STI.getReadAdvanceCycles(SC, RD.OpIndex, WriteResID);
    WS->addUser(&RS, ReadAdvance);
  }
  // Prepare the set for another round.
  DependentWrites.clear();
}

unsigned DispatchUnit::dispatch(unsigned IID, Instruction *NewInst,
                                const MCSubtargetInfo &STI) {
  assert(!CarryOver && "Cannot dispatch another instruction!");
  unsigned NumMicroOps = NewInst->getDesc().NumMicroOps;
  if (NumMicroOps > DispatchWidth) {
    assert(AvailableEntries == DispatchWidth);
    AvailableEntries = 0;
    CarryOver = NumMicroOps - DispatchWidth;
  } else {
    assert(AvailableEntries >= NumMicroOps);
    AvailableEntries -= NumMicroOps;
  }

  // Update RAW dependencies.
  for (std::unique_ptr<ReadState> &RS : NewInst->getUses())
    updateRAWDependencies(*RS, STI);

  // Allocate new mappings.
  for (std::unique_ptr<WriteState> &WS : NewInst->getDefs())
    addNewRegisterMapping(*WS);

  // Set the cycles left before the write-back stage.
  const InstrDesc &D = NewInst->getDesc();
  NewInst->setCyclesLeft(D.MaxLatency);

  // Reserve slots in the RCU.
  unsigned RCUTokenID = RCU->reserveSlot(IID, NumMicroOps);
  NewInst->setRCUTokenID(RCUTokenID);
  notifyInstructionDispatched(IID);

  SC->scheduleInstruction(IID, NewInst);
  return RCUTokenID;
}

#ifndef NDEBUG
void DispatchUnit::dump() const {
  RAT->dump();
  RCU->dump();

  unsigned DSRAT = DispatchStalls[DS_RAT_REG_UNAVAILABLE];
  unsigned DSRCU = DispatchStalls[DS_RCU_TOKEN_UNAVAILABLE];
  unsigned DSSCHEDQ = DispatchStalls[DS_SQ_TOKEN_UNAVAILABLE];
  unsigned DSLQ = DispatchStalls[DS_LDQ_TOKEN_UNAVAILABLE];
  unsigned DSSQ = DispatchStalls[DS_STQ_TOKEN_UNAVAILABLE];

  dbgs() << "STALLS --- RAT: " << DSRAT << ", RCU: " << DSRCU
         << ", SCHED_QUEUE: " << DSSCHEDQ << ", LOAD_QUEUE: " << DSLQ
         << ", STORE_QUEUE: " << DSSQ << '\n';
}
#endif

} // namespace mca
