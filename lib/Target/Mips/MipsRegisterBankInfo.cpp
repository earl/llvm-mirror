//===- MipsRegisterBankInfo.cpp ---------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for Mips.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MipsRegisterBankInfo.h"
#include "MipsInstrInfo.h"
#include "llvm/CodeGen/GlobalISel/GISelChangeObserver.h"
#include "llvm/CodeGen/GlobalISel/LegalizationArtifactCombiner.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

#define GET_TARGET_REGBANK_IMPL

#include "MipsGenRegisterBank.inc"

namespace llvm {
namespace Mips {
enum PartialMappingIdx {
  PMI_GPR,
  PMI_SPR,
  PMI_DPR,
  PMI_Min = PMI_GPR,
};

RegisterBankInfo::PartialMapping PartMappings[]{
    {0, 32, GPRBRegBank},
    {0, 32, FPRBRegBank},
    {0, 64, FPRBRegBank}
};

enum ValueMappingIdx {
    InvalidIdx = 0,
    GPRIdx = 1,
    SPRIdx = 4,
    DPRIdx = 7
};

RegisterBankInfo::ValueMapping ValueMappings[] = {
    // invalid
    {nullptr, 0},
    // up to 3 operands in GPRs
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    // up to 3 ops operands FPRs - single precission
    {&PartMappings[PMI_SPR - PMI_Min], 1},
    {&PartMappings[PMI_SPR - PMI_Min], 1},
    {&PartMappings[PMI_SPR - PMI_Min], 1},
    // up to 3 ops operands FPRs - double precission
    {&PartMappings[PMI_DPR - PMI_Min], 1},
    {&PartMappings[PMI_DPR - PMI_Min], 1},
    {&PartMappings[PMI_DPR - PMI_Min], 1}
};

} // end namespace Mips
} // end namespace llvm

using namespace llvm;

MipsRegisterBankInfo::MipsRegisterBankInfo(const TargetRegisterInfo &TRI)
    : MipsGenRegisterBankInfo() {}

const RegisterBank &MipsRegisterBankInfo::getRegBankFromRegClass(
    const TargetRegisterClass &RC) const {
  using namespace Mips;

  switch (RC.getID()) {
  case Mips::GPR32RegClassID:
  case Mips::CPU16Regs_and_GPRMM16ZeroRegClassID:
  case Mips::GPRMM16MovePPairFirstRegClassID:
  case Mips::CPU16Regs_and_GPRMM16MovePPairSecondRegClassID:
  case Mips::GPRMM16MoveP_and_CPU16Regs_and_GPRMM16ZeroRegClassID:
  case Mips::GPRMM16MovePPairFirst_and_GPRMM16MovePPairSecondRegClassID:
  case Mips::SP32RegClassID:
  case Mips::GP32RegClassID:
    return getRegBank(Mips::GPRBRegBankID);
  case Mips::FGRCCRegClassID:
  case Mips::FGR32RegClassID:
  case Mips::FGR64RegClassID:
  case Mips::AFGR64RegClassID:
    return getRegBank(Mips::FPRBRegBankID);
  default:
    llvm_unreachable("Register class not supported");
  }
}

// Instructions where all register operands are floating point.
static bool isFloatingPointOpcode(unsigned Opc) {
  switch (Opc) {
  case TargetOpcode::G_FCONSTANT:
  case TargetOpcode::G_FADD:
  case TargetOpcode::G_FSUB:
  case TargetOpcode::G_FMUL:
  case TargetOpcode::G_FDIV:
  case TargetOpcode::G_FABS:
  case TargetOpcode::G_FSQRT:
  case TargetOpcode::G_FCEIL:
  case TargetOpcode::G_FFLOOR:
  case TargetOpcode::G_FPEXT:
  case TargetOpcode::G_FPTRUNC:
    return true;
  default:
    return false;
  }
}

// Instructions where use operands are floating point registers.
// Def operands are general purpose.
static bool isFloatingPointOpcodeUse(unsigned Opc) {
  switch (Opc) {
  case TargetOpcode::G_FPTOSI:
  case TargetOpcode::G_FPTOUI:
  case TargetOpcode::G_FCMP:
  case Mips::MFC1:
  case Mips::ExtractElementF64:
  case Mips::ExtractElementF64_64:
    return true;
  default:
    return isFloatingPointOpcode(Opc);
  }
}

// Instructions where def operands are floating point registers.
// Use operands are general purpose.
static bool isFloatingPointOpcodeDef(unsigned Opc) {
  switch (Opc) {
  case TargetOpcode::G_SITOFP:
  case TargetOpcode::G_UITOFP:
  case Mips::MTC1:
  case Mips::BuildPairF64:
  case Mips::BuildPairF64_64:
    return true;
  default:
    return isFloatingPointOpcode(Opc);
  }
}

static bool isAmbiguous(unsigned Opc) {
  switch (Opc) {
  case TargetOpcode::G_LOAD:
  case TargetOpcode::G_STORE:
  case TargetOpcode::G_PHI:
  case TargetOpcode::G_SELECT:
    return true;
  default:
    return false;
  }
}

void MipsRegisterBankInfo::AmbiguousRegDefUseContainer::addDefUses(
    Register Reg, const MachineRegisterInfo &MRI) {
  assert(!MRI.getType(Reg).isPointer() &&
         "Pointers are gprb, they should not be considered as ambiguous.\n");
  for (MachineInstr &UseMI : MRI.use_instructions(Reg)) {
    if (UseMI.getOpcode() == TargetOpcode::COPY &&
        !TargetRegisterInfo::isPhysicalRegister(UseMI.getOperand(0).getReg()))
      // Copies of non-physical registers are not supported
      return;

    DefUses.push_back(&UseMI);
  }
}

void MipsRegisterBankInfo::AmbiguousRegDefUseContainer::addUseDef(
    Register Reg, const MachineRegisterInfo &MRI) {
  assert(!MRI.getType(Reg).isPointer() &&
         "Pointers are gprb, they should not be considered as ambiguous.\n");
  MachineInstr *DefMI = MRI.getVRegDef(Reg);
  if (DefMI->getOpcode() == TargetOpcode::COPY &&
      !TargetRegisterInfo::isPhysicalRegister(DefMI->getOperand(1).getReg()))
    // Copies from non-physical registers are not supported.
    return;

  UseDefs.push_back(DefMI);
}

MipsRegisterBankInfo::AmbiguousRegDefUseContainer::AmbiguousRegDefUseContainer(
    const MachineInstr *MI) {
  assert(isAmbiguous(MI->getOpcode()) &&
         "Not implemented for non Ambiguous opcode.\n");

  const MachineRegisterInfo &MRI = MI->getMF()->getRegInfo();

  if (MI->getOpcode() == TargetOpcode::G_LOAD)
    addDefUses(MI->getOperand(0).getReg(), MRI);

  if (MI->getOpcode() == TargetOpcode::G_STORE)
    addUseDef(MI->getOperand(0).getReg(), MRI);

  if (MI->getOpcode() == TargetOpcode::G_SELECT) {
    addDefUses(MI->getOperand(0).getReg(), MRI);

    addUseDef(MI->getOperand(2).getReg(), MRI);
    addUseDef(MI->getOperand(3).getReg(), MRI);
  }
}

bool MipsRegisterBankInfo::TypeInfoForMF::visit(const MachineInstr *MI) {
  assert(isAmbiguous(MI->getOpcode()) && "Visiting non-Ambiguous opcode.\n");

  startVisit(MI);
  AmbiguousRegDefUseContainer DefUseContainer(MI);

  // Visit instructions where MI's DEF operands are USED.
  if (visitAdjacentInstrs(MI, DefUseContainer.getDefUses(), true))
    return true;

  // Visit instructions that DEFINE MI's USE operands.
  if (visitAdjacentInstrs(MI, DefUseContainer.getUseDefs(), false))
    return true;

  return false;
}

bool MipsRegisterBankInfo::TypeInfoForMF::visitAdjacentInstrs(
    const MachineInstr *MI, SmallVectorImpl<MachineInstr *> &AdjacentInstrs,
    bool isDefUse) {
  while (!AdjacentInstrs.empty()) {
    MachineInstr *AdjMI = AdjacentInstrs.pop_back_val();

    if (isDefUse ? isFloatingPointOpcodeUse(AdjMI->getOpcode())
                 : isFloatingPointOpcodeDef(AdjMI->getOpcode())) {
      setTypes(MI, InstType::FloatingPoint);
      return true;
    }

    // Determine InstType from register bank of phys register that is
    // 'isDefUse ? def : use' of this copy.
    if (AdjMI->getOpcode() == TargetOpcode::COPY) {
      setTypesAccordingToPhysicalRegister(MI, AdjMI, isDefUse ? 0 : 1);
      return true;
    }

    if (isAmbiguous(AdjMI->getOpcode())) {
      // Chains of ambiguous instructions are not supported.
      return false;
    }

    // Defaults to integer instruction. Includes G_MERGE_VALUES and
    // G_UNMERGE_VALUES.
    setTypes(MI, InstType::Integer);
    return true;
  }
  return false;
}

void MipsRegisterBankInfo::TypeInfoForMF::setTypes(const MachineInstr *MI,
                                                   InstType InstTy) {
  changeRecordedTypeForInstr(MI, InstTy);
}

void MipsRegisterBankInfo::TypeInfoForMF::setTypesAccordingToPhysicalRegister(
    const MachineInstr *MI, const MachineInstr *CopyInst, unsigned Op) {
  assert((TargetRegisterInfo::isPhysicalRegister(
             CopyInst->getOperand(Op).getReg())) &&
         "Copies of non physical registers should not be considered here.\n");

  const MachineFunction &MF = *CopyInst->getMF();
  const MachineRegisterInfo &MRI = MF.getRegInfo();
  const TargetRegisterInfo &TRI = *MF.getSubtarget().getRegisterInfo();
  const RegisterBankInfo &RBI =
      *CopyInst->getMF()->getSubtarget().getRegBankInfo();
  const RegisterBank *Bank =
      RBI.getRegBank(CopyInst->getOperand(Op).getReg(), MRI, TRI);

  if (Bank == &Mips::FPRBRegBank)
    setTypes(MI, InstType::FloatingPoint);
  else if (Bank == &Mips::GPRBRegBank)
    setTypes(MI, InstType::Integer);
  else
    llvm_unreachable("Unsupported register bank.\n");
}

MipsRegisterBankInfo::InstType
MipsRegisterBankInfo::TypeInfoForMF::determineInstType(const MachineInstr *MI) {
  visit(MI);
  return getRecordedTypeForInstr(MI);
}

void MipsRegisterBankInfo::TypeInfoForMF::cleanupIfNewFunction(
    llvm::StringRef FunctionName) {
  if (MFName != FunctionName) {
    MFName = FunctionName;
    Types.clear();
  }
}

const RegisterBankInfo::InstructionMapping &
MipsRegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {

  static TypeInfoForMF TI;

  // Reset TI internal data when MF changes.
  TI.cleanupIfNewFunction(MI.getMF()->getName());

  unsigned Opc = MI.getOpcode();
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();

  const RegisterBankInfo::InstructionMapping &Mapping = getInstrMappingImpl(MI);
  if (Mapping.isValid())
    return Mapping;

  using namespace TargetOpcode;

  unsigned NumOperands = MI.getNumOperands();
  const ValueMapping *OperandsMapping = &Mips::ValueMappings[Mips::GPRIdx];
  unsigned MappingID = DefaultMappingID;
  const unsigned CustomMappingID = 1;

  switch (Opc) {
  case G_TRUNC:
  case G_ADD:
  case G_SUB:
  case G_MUL:
  case G_UMULH:
  case G_ZEXTLOAD:
  case G_SEXTLOAD:
  case G_GEP:
  case G_AND:
  case G_OR:
  case G_XOR:
  case G_SHL:
  case G_ASHR:
  case G_LSHR:
  case G_SDIV:
  case G_UDIV:
  case G_SREM:
  case G_UREM:
    OperandsMapping = &Mips::ValueMappings[Mips::GPRIdx];
    break;
  case G_LOAD: {
    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    InstType InstTy = InstType::Integer;
    if (!MRI.getType(MI.getOperand(0).getReg()).isPointer()) {
      InstTy = TI.determineInstType(&MI);
    }

    if (InstTy == InstType::FloatingPoint) { // fprb
      OperandsMapping =
          getOperandsMapping({Size == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                                         : &Mips::ValueMappings[Mips::DPRIdx],
                              &Mips::ValueMappings[Mips::GPRIdx]});
      break;
    } else { // gprb
      OperandsMapping =
          getOperandsMapping({Size <= 32 ? &Mips::ValueMappings[Mips::GPRIdx]
                                         : &Mips::ValueMappings[Mips::DPRIdx],
                              &Mips::ValueMappings[Mips::GPRIdx]});
      if (Size == 64)
        MappingID = CustomMappingID;
    }

    break;
  }
  case G_STORE: {
    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    InstType InstTy = InstType::Integer;
    if (!MRI.getType(MI.getOperand(0).getReg()).isPointer()) {
      InstTy = TI.determineInstType(&MI);
    }

    if (InstTy == InstType::FloatingPoint) { // fprb
      OperandsMapping =
          getOperandsMapping({Size == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                                         : &Mips::ValueMappings[Mips::DPRIdx],
                              &Mips::ValueMappings[Mips::GPRIdx]});
      break;
    } else { // gprb
      OperandsMapping =
          getOperandsMapping({Size <= 32 ? &Mips::ValueMappings[Mips::GPRIdx]
                                         : &Mips::ValueMappings[Mips::DPRIdx],
                              &Mips::ValueMappings[Mips::GPRIdx]});
      if (Size == 64)
        MappingID = CustomMappingID;
    }
    break;
  }
  case G_SELECT: {
    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    InstType InstTy = InstType::Integer;
    if (!MRI.getType(MI.getOperand(0).getReg()).isPointer()) {
      InstTy = TI.determineInstType(&MI);
    }

    if (InstTy == InstType::FloatingPoint) { // fprb
      const RegisterBankInfo::ValueMapping *Bank =
          Size == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                     : &Mips::ValueMappings[Mips::DPRIdx];
      OperandsMapping = getOperandsMapping(
          {Bank, &Mips::ValueMappings[Mips::GPRIdx], Bank, Bank});
      break;
    } else { // gprb
      const RegisterBankInfo::ValueMapping *Bank =
          Size <= 32 ? &Mips::ValueMappings[Mips::GPRIdx]
                     : &Mips::ValueMappings[Mips::DPRIdx];
      OperandsMapping = getOperandsMapping(
          {Bank, &Mips::ValueMappings[Mips::GPRIdx], Bank, Bank});
      if (Size == 64)
        MappingID = CustomMappingID;
    }
    break;
  }
  case G_UNMERGE_VALUES: {
    OperandsMapping = getOperandsMapping({&Mips::ValueMappings[Mips::GPRIdx],
                                          &Mips::ValueMappings[Mips::GPRIdx],
                                          &Mips::ValueMappings[Mips::DPRIdx]});
    MappingID = CustomMappingID;
    break;
  }
  case G_MERGE_VALUES: {
    OperandsMapping = getOperandsMapping({&Mips::ValueMappings[Mips::DPRIdx],
                                          &Mips::ValueMappings[Mips::GPRIdx],
                                          &Mips::ValueMappings[Mips::GPRIdx]});
    MappingID = CustomMappingID;
    break;
  }
  case G_FADD:
  case G_FSUB:
  case G_FMUL:
  case G_FDIV:
  case G_FABS:
  case G_FSQRT:{
    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    assert((Size == 32 || Size == 64) && "Unsupported floating point size");
    OperandsMapping = Size == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                                 : &Mips::ValueMappings[Mips::DPRIdx];
    break;
  }
  case G_FCONSTANT: {
    unsigned Size = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    assert((Size == 32 || Size == 64) && "Unsupported floating point size");
    const RegisterBankInfo::ValueMapping *FPRValueMapping =
        Size == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                   : &Mips::ValueMappings[Mips::DPRIdx];
    OperandsMapping = getOperandsMapping({FPRValueMapping, nullptr});
    break;
  }
  case G_FCMP: {
    unsigned Size = MRI.getType(MI.getOperand(2).getReg()).getSizeInBits();
    assert((Size == 32 || Size == 64) && "Unsupported floating point size");
    const RegisterBankInfo::ValueMapping *FPRValueMapping =
        Size == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                   : &Mips::ValueMappings[Mips::DPRIdx];
    OperandsMapping =
        getOperandsMapping({&Mips::ValueMappings[Mips::GPRIdx], nullptr,
                            FPRValueMapping, FPRValueMapping});
    break;
  }
  case G_FPEXT:
    OperandsMapping = getOperandsMapping({&Mips::ValueMappings[Mips::DPRIdx],
                                          &Mips::ValueMappings[Mips::SPRIdx]});
    break;
  case G_FPTRUNC:
    OperandsMapping = getOperandsMapping({&Mips::ValueMappings[Mips::SPRIdx],
                                          &Mips::ValueMappings[Mips::DPRIdx]});
    break;
  case G_FPTOSI: {
    unsigned SizeFP = MRI.getType(MI.getOperand(1).getReg()).getSizeInBits();
    assert((MRI.getType(MI.getOperand(0).getReg()).getSizeInBits() == 32) &&
           "Unsupported integer size");
    assert((SizeFP == 32 || SizeFP == 64) && "Unsupported floating point size");
    OperandsMapping = getOperandsMapping({
        &Mips::ValueMappings[Mips::GPRIdx],
        SizeFP == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                     : &Mips::ValueMappings[Mips::DPRIdx],
    });
    break;
  }
  case G_SITOFP: {
    unsigned SizeInt = MRI.getType(MI.getOperand(1).getReg()).getSizeInBits();
    unsigned SizeFP = MRI.getType(MI.getOperand(0).getReg()).getSizeInBits();
    (void)SizeInt;
    assert((SizeInt == 32) && "Unsupported integer size");
    assert((SizeFP == 32 || SizeFP == 64) && "Unsupported floating point size");
    OperandsMapping =
        getOperandsMapping({SizeFP == 32 ? &Mips::ValueMappings[Mips::SPRIdx]
                                         : &Mips::ValueMappings[Mips::DPRIdx],
                            &Mips::ValueMappings[Mips::GPRIdx]});
    break;
  }
  case G_CONSTANT:
  case G_FRAME_INDEX:
  case G_GLOBAL_VALUE:
  case G_BRCOND:
    OperandsMapping =
        getOperandsMapping({&Mips::ValueMappings[Mips::GPRIdx], nullptr});
    break;
  case G_ICMP:
    OperandsMapping =
        getOperandsMapping({&Mips::ValueMappings[Mips::GPRIdx], nullptr,
                            &Mips::ValueMappings[Mips::GPRIdx],
                            &Mips::ValueMappings[Mips::GPRIdx]});
    break;
  default:
    return getInvalidInstructionMapping();
  }

  return getInstructionMapping(MappingID, /*Cost=*/1, OperandsMapping,
                               NumOperands);
}

using InstListTy = GISelWorkList<4>;
namespace {
class InstManager : public GISelChangeObserver {
  InstListTy &InstList;

public:
  InstManager(InstListTy &Insts) : InstList(Insts) {}

  void createdInstr(MachineInstr &MI) override { InstList.insert(&MI); }
  void erasingInstr(MachineInstr &MI) override {}
  void changingInstr(MachineInstr &MI) override {}
  void changedInstr(MachineInstr &MI) override {}
};
} // end anonymous namespace

/// Here we have to narrowScalar s64 operands to s32, combine away
/// G_MERGE/G_UNMERGE and erase instructions that became dead in the process.
/// We manually assign 32 bit gprb to register operands of all new instructions
/// that got created in the process since they will not end up in RegBankSelect
/// loop. Careful not to delete instruction after MI i.e. MI.getIterator()++.
void MipsRegisterBankInfo::applyMappingImpl(
    const OperandsMapper &OpdMapper) const {
  MachineInstr &MI = OpdMapper.getMI();
  InstListTy NewInstrs;
  MachineIRBuilder B(MI);
  MachineFunction *MF = MI.getMF();
  MachineRegisterInfo &MRI = OpdMapper.getMRI();

  InstManager NewInstrObserver(NewInstrs);
  GISelObserverWrapper WrapperObserver(&NewInstrObserver);
  LegalizerHelper Helper(*MF, WrapperObserver, B);
  LegalizationArtifactCombiner ArtCombiner(
      B, MF->getRegInfo(), *MF->getSubtarget().getLegalizerInfo());

  switch (MI.getOpcode()) {
  case TargetOpcode::G_LOAD:
  case TargetOpcode::G_STORE:
  case TargetOpcode::G_SELECT: {
    Helper.narrowScalar(MI, 0, LLT::scalar(32));
    // Handle new instructions.
    while (!NewInstrs.empty()) {
      MachineInstr *NewMI = NewInstrs.pop_back_val();
      // This is new G_UNMERGE that was created during narrowScalar and will
      // not be considered for regbank selection. RegBankSelect for mips
      // visits/makes corresponding G_MERGE first. Combine them here.
      if (NewMI->getOpcode() == TargetOpcode::G_UNMERGE_VALUES) {
        SmallVector<MachineInstr *, 2> DeadInstrs;
        ArtCombiner.tryCombineMerges(*NewMI, DeadInstrs);
        for (MachineInstr *DeadMI : DeadInstrs)
          DeadMI->eraseFromParent();
      }
      // This G_MERGE will be combined away when its corresponding G_UNMERGE
      // gets regBankSelected.
      else if (NewMI->getOpcode() == TargetOpcode::G_MERGE_VALUES)
        continue;
      else
        // Manually set register banks for all register operands to 32 bit gprb.
        for (auto Op : NewMI->operands()) {
          if (Op.isReg()) {
            assert(MRI.getType(Op.getReg()).getSizeInBits() == 32 &&
                   "Only 32 bit gprb is handled here.\n");
            MRI.setRegBank(Op.getReg(), getRegBank(Mips::GPRBRegBankID));
          }
        }
    }
    return;
  }
  case TargetOpcode::G_UNMERGE_VALUES: {
    SmallVector<MachineInstr *, 2> DeadInstrs;
    ArtCombiner.tryCombineMerges(MI, DeadInstrs);
    for (MachineInstr *DeadMI : DeadInstrs)
      DeadMI->eraseFromParent();
    return;
  }
  default:
    break;
  }

  return applyDefaultMapping(OpdMapper);
}
