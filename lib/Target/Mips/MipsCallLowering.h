//===- MipsCallLowering.h ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
/// \file
/// This file describes how to lower LLVM calls to machine code calls.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_MIPS_MIPSCALLLOWERING_H
#define LLVM_LIB_TARGET_MIPS_MIPSCALLLOWERING_H

#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/GlobalISel/CallLowering.h"
#include "llvm/CodeGen/ValueTypes.h"

namespace llvm {

class MipsTargetLowering;

class MipsCallLowering : public CallLowering {

public:
  class MipsHandler {
  public:
    MipsHandler(MachineIRBuilder &MIRBuilder, MachineRegisterInfo &MRI)
        : MIRBuilder(MIRBuilder), MRI(MRI) {}

    virtual ~MipsHandler() = default;

  protected:
    virtual void assignValueToReg(unsigned ValVReg, unsigned PhysReg) = 0;

    bool assign(const CCValAssign &VA, unsigned vreg);

    MachineIRBuilder &MIRBuilder;
    MachineRegisterInfo &MRI;
  };

  MipsCallLowering(const MipsTargetLowering &TLI);

  bool lowerReturn(MachineIRBuilder &MIRBuiler, const Value *Val,
                   unsigned VReg) const override;

  bool lowerFormalArguments(MachineIRBuilder &MIRBuilder, const Function &F,
                            ArrayRef<unsigned> VRegs) const override;

private:
  using FunTy =
      std::function<void(ISD::ArgFlagsTy flags, EVT vt, EVT argvt, bool used,
                         unsigned origIdx, unsigned partOffs)>;

  /// Based on registers available on target machine split or extend
  /// type if needed, also change pointer type to appropriate integer
  /// type. Lambda will fill some info so we can tell MipsCCState to
  /// assign physical registers.
  void subTargetRegTypeForCallingConv(MachineIRBuilder &MIRBuilder,
                                      ArrayRef<ArgInfo> Args,
                                      ArrayRef<unsigned> OrigArgIndices,
                                      const FunTy &PushBack) const;

  /// Split structures and arrays, save original argument indices since
  /// Mips calling conv needs info about original argument type.
  void splitToValueTypes(const ArgInfo &OrigArg, unsigned OriginalIndex,
                         SmallVectorImpl<ArgInfo> &SplitArgs,
                         SmallVectorImpl<unsigned> &SplitArgsOrigIndices) const;
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_MIPS_MIPSCALLLOWERING_H
