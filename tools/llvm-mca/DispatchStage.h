//===----------------------- Dispatch.h -------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file implements classes that are used to model reorder buffers and
/// the hardware dispatch logic.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_MCA_DISPATCH_H
#define LLVM_TOOLS_LLVM_MCA_DISPATCH_H

#include "Instruction.h"
#include "RegisterFile.h"
#include "RetireControlUnit.h"
#include "Stage.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"

namespace mca {

class WriteState;
class Scheduler;
class Backend;

// Implements the hardware dispatch logic.
//
// This class is responsible for the dispatch stage, in which instructions are
// dispatched in groups to the Scheduler.  An instruction can be dispatched if
// functional units are available.
// To be more specific, an instruction can be dispatched to the Scheduler if:
//  1) There are enough entries in the reorder buffer (implemented by class
//     RetireControlUnit) to accommodate all opcodes.
//  2) There are enough temporaries to rename output register operands.
//  3) There are enough entries available in the used buffered resource(s).
//
// The number of micro opcodes that can be dispatched in one cycle is limited by
// the value of field 'DispatchWidth'. A "dynamic dispatch stall" occurs when
// processor resources are not available (i.e. at least one of the
// aforementioned checks fails). Dispatch stall events are counted during the
// entire execution of the code, and displayed by the performance report when
// flag '-verbose' is specified.
//
// If the number of micro opcodes of an instruction is bigger than
// DispatchWidth, then it can only be dispatched at the beginning of one cycle.
// The DispatchStage will still have to wait for a number of cycles (depending
// on the DispatchWidth and the number of micro opcodes) before it can serve
// other instructions.
class DispatchStage : public Stage {
  unsigned DispatchWidth;
  unsigned AvailableEntries;
  unsigned CarryOver;
  Scheduler *SC;
  std::unique_ptr<RegisterFile> RAT;
  std::unique_ptr<RetireControlUnit> RCU;
  Backend *Owner;
  const llvm::MCSubtargetInfo &STI;

  bool checkRAT(const InstRef &IR);
  bool checkRCU(const InstRef &IR);
  bool checkScheduler(const InstRef &IR);
  void dispatch(InstRef IR);
  bool isRCUEmpty() const { return RCU->isEmpty(); }
  void updateRAWDependencies(ReadState &RS, const llvm::MCSubtargetInfo &STI);

  void notifyInstructionDispatched(const InstRef &IR,
                                   llvm::ArrayRef<unsigned> UsedPhysRegs);

  bool isAvailable(unsigned NumEntries) const {
    return NumEntries <= AvailableEntries || AvailableEntries == DispatchWidth;
  }

  bool canDispatch(const InstRef &IR) {
    assert(isAvailable(IR.getInstruction()->getDesc().NumMicroOps));
    return checkRCU(IR) && checkRAT(IR) && checkScheduler(IR);
  }

  void collectWrites(llvm::SmallVectorImpl<WriteState *> &Vec,
                     unsigned RegID) const {
    return RAT->collectWrites(Vec, RegID);
  }

public:
  DispatchStage(Backend *B, const llvm::MCSubtargetInfo &Subtarget,
                const llvm::MCRegisterInfo &MRI, unsigned RegisterFileSize,
                unsigned MaxDispatchWidth, Scheduler *Sched)
      : DispatchWidth(MaxDispatchWidth), AvailableEntries(MaxDispatchWidth),
        CarryOver(0U), SC(Sched),
        RAT(llvm::make_unique<RegisterFile>(Subtarget.getSchedModel(), MRI,
                                            RegisterFileSize)),
        RCU(llvm::make_unique<RetireControlUnit>(Subtarget.getSchedModel(),
                                                 this)),
        Owner(B), STI(Subtarget) {}

  void cycleEvent() {
    RCU->cycleEvent();
    AvailableEntries =
        CarryOver >= DispatchWidth ? 0 : DispatchWidth - CarryOver;
    CarryOver = CarryOver >= DispatchWidth ? CarryOver - DispatchWidth : 0U;
  }

  virtual bool isReady() const override final { return isRCUEmpty(); }
  virtual bool execute(InstRef &IR) override final;
  void notifyInstructionRetired(const InstRef &IR);
  void notifyDispatchStall(const InstRef &IR, unsigned EventType);

  void onInstructionExecuted(unsigned TokenID) {
    RCU->onInstructionExecuted(TokenID);
  }

#ifndef NDEBUG
  void dump() const;
#endif
};
} // namespace mca

#endif
