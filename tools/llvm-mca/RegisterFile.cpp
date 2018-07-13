//===--------------------- RegisterFile.cpp ---------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file defines a register mapping file class.  This class is responsible
/// for managing hardware register files and the tracking of data dependencies
/// between registers.
///
//===----------------------------------------------------------------------===//

#include "RegisterFile.h"
#include "Instruction.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "llvm-mca"

namespace mca {

RegisterFile::RegisterFile(const llvm::MCSchedModel &SM,
                           const llvm::MCRegisterInfo &mri, unsigned NumRegs)
    : MRI(mri), RegisterMappings(mri.getNumRegs(), {WriteRef(), {0, 0}}) {
  initialize(SM, NumRegs);
}

void RegisterFile::initialize(const MCSchedModel &SM, unsigned NumRegs) {
  // Create a default register file that "sees" all the machine registers
  // declared by the target. The number of physical registers in the default
  // register file is set equal to `NumRegs`. A value of zero for `NumRegs`
  // means: this register file has an unbounded number of physical registers.
  addRegisterFile({} /* all registers */, NumRegs);
  if (!SM.hasExtraProcessorInfo())
    return;

  // For each user defined register file, allocate a RegisterMappingTracker
  // object. The size of every register file, as well as the mapping between
  // register files and register classes is specified via tablegen.
  const MCExtraProcessorInfo &Info = SM.getExtraProcessorInfo();
  for (unsigned I = 0, E = Info.NumRegisterFiles; I < E; ++I) {
    const MCRegisterFileDesc &RF = Info.RegisterFiles[I];
    // Skip invalid register files with zero physical registers.
    unsigned Length = RF.NumRegisterCostEntries;
    if (!RF.NumPhysRegs)
      continue;
    // The cost of a register definition is equivalent to the number of
    // physical registers that are allocated at register renaming stage.
    const MCRegisterCostEntry *FirstElt =
        &Info.RegisterCostTable[RF.RegisterCostEntryIdx];
    addRegisterFile(ArrayRef<MCRegisterCostEntry>(FirstElt, Length),
                    RF.NumPhysRegs);
  }
}

void RegisterFile::addRegisterFile(ArrayRef<MCRegisterCostEntry> Entries,
                                   unsigned NumPhysRegs) {
  // A default register file is always allocated at index #0. That register file
  // is mainly used to count the total number of mappings created by all
  // register files at runtime. Users can limit the number of available physical
  // registers in register file #0 through the command line flag
  // `-register-file-size`.
  unsigned RegisterFileIndex = RegisterFiles.size();
  RegisterFiles.emplace_back(NumPhysRegs);

  // Special case where there is no register class identifier in the set.
  // An empty set of register classes means: this register file contains all
  // the physical registers specified by the target.
  if (Entries.empty()) {
    for (std::pair<WriteRef, IndexPlusCostPairTy> &Mapping : RegisterMappings)
      Mapping.second = std::make_pair(RegisterFileIndex, 1U);
    return;
  }

  // Now update the cost of individual registers.
  for (const MCRegisterCostEntry &RCE : Entries) {
    const MCRegisterClass &RC = MRI.getRegClass(RCE.RegisterClassID);
    for (const MCPhysReg Reg : RC) {
      IndexPlusCostPairTy &Entry = RegisterMappings[Reg].second;
      if (Entry.first) {
        // The only register file that is allowed to overlap is the default
        // register file at index #0. The analysis is inaccurate if register
        // files overlap.
        errs() << "warning: register " << MRI.getName(Reg)
               << " defined in multiple register files.";
      }
      Entry.first = RegisterFileIndex;
      Entry.second = RCE.Cost;
    }
  }
}

void RegisterFile::allocatePhysRegs(IndexPlusCostPairTy Entry,
                                    MutableArrayRef<unsigned> UsedPhysRegs) {
  unsigned RegisterFileIndex = Entry.first;
  unsigned Cost = Entry.second;
  if (RegisterFileIndex) {
    RegisterMappingTracker &RMT = RegisterFiles[RegisterFileIndex];
    RMT.NumUsedPhysRegs += Cost;
    UsedPhysRegs[RegisterFileIndex] += Cost;
  }

  // Now update the default register mapping tracker.
  RegisterFiles[0].NumUsedPhysRegs += Cost;
  UsedPhysRegs[0] += Cost;
}

void RegisterFile::freePhysRegs(IndexPlusCostPairTy Entry,
                                MutableArrayRef<unsigned> FreedPhysRegs) {
  unsigned RegisterFileIndex = Entry.first;
  unsigned Cost = Entry.second;
  if (RegisterFileIndex) {
    RegisterMappingTracker &RMT = RegisterFiles[RegisterFileIndex];
    RMT.NumUsedPhysRegs -= Cost;
    FreedPhysRegs[RegisterFileIndex] += Cost;
  }

  // Now update the default register mapping tracker.
  RegisterFiles[0].NumUsedPhysRegs -= Cost;
  FreedPhysRegs[0] += Cost;
}

void RegisterFile::addRegisterWrite(WriteRef Write,
                                    MutableArrayRef<unsigned> UsedPhysRegs,
                                    bool ShouldAllocatePhysRegs) {
  const WriteState &WS = *Write.getWriteState();
  unsigned RegID = WS.getRegisterID();
  assert(RegID && "Adding an invalid register definition?");

  RegisterMapping &Mapping = RegisterMappings[RegID];
  Mapping.first = Write;
  for (MCSubRegIterator I(RegID, &MRI); I.isValid(); ++I)
    RegisterMappings[*I].first = Write;

  // No physical registers are allocated for instructions that are optimized in
  // hardware. For example, zero-latency data-dependency breaking instructions
  // don't consume physical registers.
  if (ShouldAllocatePhysRegs)
    allocatePhysRegs(Mapping.second, UsedPhysRegs);

  // If this is a partial update, then we are done.
  if (!WS.clearsSuperRegisters())
    return;

  for (MCSuperRegIterator I(RegID, &MRI); I.isValid(); ++I)
    RegisterMappings[*I].first = Write;
}

void RegisterFile::removeRegisterWrite(const WriteState &WS,
                                       MutableArrayRef<unsigned> FreedPhysRegs,
                                       bool ShouldFreePhysRegs) {
  unsigned RegID = WS.getRegisterID();
  bool ShouldInvalidateSuperRegs = WS.clearsSuperRegisters();

  assert(RegID != 0 && "Invalidating an already invalid register?");
  assert(WS.getCyclesLeft() != -512 &&
         "Invalidating a write of unknown cycles!");
  assert(WS.getCyclesLeft() <= 0 && "Invalid cycles left for this write!");
  RegisterMapping &Mapping = RegisterMappings[RegID];
  WriteRef &WR = Mapping.first;
  if (!WR.isValid())
    return;

  if (ShouldFreePhysRegs)
    freePhysRegs(Mapping.second, FreedPhysRegs);

  if (WR.getWriteState() == &WS)
    WR.invalidate();

  for (MCSubRegIterator I(RegID, &MRI); I.isValid(); ++I) {
    WR = RegisterMappings[*I].first;
    if (WR.getWriteState() == &WS)
      WR.invalidate();
  }

  if (!ShouldInvalidateSuperRegs)
    return;

  for (MCSuperRegIterator I(RegID, &MRI); I.isValid(); ++I) {
    WR = RegisterMappings[*I].first;
    if (WR.getWriteState() == &WS)
      WR.invalidate();
  }
}

void RegisterFile::collectWrites(SmallVectorImpl<WriteRef> &Writes,
                                 unsigned RegID) const {
  assert(RegID && RegID < RegisterMappings.size());
  const WriteRef &WR = RegisterMappings[RegID].first;
  if (WR.isValid())
    Writes.push_back(WR);

  // Handle potential partial register updates.
  for (MCSubRegIterator I(RegID, &MRI); I.isValid(); ++I) {
    const WriteRef &WR = RegisterMappings[*I].first;
    if (WR.isValid())
      Writes.push_back(WR);
  }

  // Remove duplicate entries and resize the input vector.
  llvm::sort(Writes.begin(), Writes.end(),
             [](const WriteRef &Lhs, const WriteRef &Rhs) {
               return Lhs.getWriteState() < Rhs.getWriteState();
             });
  auto It = std::unique(Writes.begin(), Writes.end());
  Writes.resize(std::distance(Writes.begin(), It));

  LLVM_DEBUG({
    for (const WriteRef &WR : Writes) {
      const WriteState &WS = *WR.getWriteState();
      dbgs() << "[PRF] Found a dependent use of Register "
             << MRI.getName(WS.getRegisterID()) << " (defined by intruction #"
             << WR.getSourceIndex() << ")\n";
    }
  });
}

unsigned RegisterFile::isAvailable(ArrayRef<unsigned> Regs) const {
  SmallVector<unsigned, 4> NumPhysRegs(getNumRegisterFiles());

  // Find how many new mappings must be created for each register file.
  for (const unsigned RegID : Regs) {
    const IndexPlusCostPairTy &Entry = RegisterMappings[RegID].second;
    if (Entry.first)
      NumPhysRegs[Entry.first] += Entry.second;
    NumPhysRegs[0] += Entry.second;
  }

  unsigned Response = 0;
  for (unsigned I = 0, E = getNumRegisterFiles(); I < E; ++I) {
    unsigned NumRegs = NumPhysRegs[I];
    if (!NumRegs)
      continue;

    const RegisterMappingTracker &RMT = RegisterFiles[I];
    if (!RMT.NumPhysRegs) {
      // The register file has an unbounded number of microarchitectural
      // registers.
      continue;
    }

    if (RMT.NumPhysRegs < NumRegs) {
      // The current register file is too small. This may occur if the number of
      // microarchitectural registers in register file #0 was changed by the
      // users via flag -reg-file-size. Alternatively, the scheduling model
      // specified a too small number of registers for this register file.
      report_fatal_error(
          "Not enough microarchitectural registers in the register file");
    }

    if (RMT.NumPhysRegs < (RMT.NumUsedPhysRegs + NumRegs))
      Response |= (1U << I);
  }

  return Response;
}

#ifndef NDEBUG
void RegisterFile::dump() const {
  for (unsigned I = 0, E = MRI.getNumRegs(); I < E; ++I) {
    const RegisterMapping &RM = RegisterMappings[I];
    if (!RM.first.getWriteState())
      continue;
    const std::pair<unsigned, unsigned> &IndexPlusCost = RM.second;
    dbgs() << MRI.getName(I) << ", " << I << ", PRF=" << IndexPlusCost.first
           << ", Cost=" << IndexPlusCost.second 
           << ", ";
    RM.first.dump();
    dbgs() << '\n';
  }

  for (unsigned I = 0, E = getNumRegisterFiles(); I < E; ++I) {
    dbgs() << "Register File #" << I;
    const RegisterMappingTracker &RMT = RegisterFiles[I];
    dbgs() << "\n  TotalMappings:        " << RMT.NumPhysRegs
           << "\n  NumUsedMappings:      " << RMT.NumUsedPhysRegs << '\n';
  }
}
#endif

} // namespace mca
