//===- PatternMatchTest.cpp -----------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/GlobalISel/MIPatternMatch.h"
#include "llvm/CodeGen/GlobalISel/MachineIRBuilder.h"
#include "llvm/CodeGen/GlobalISel/Utils.h"
#include "llvm/CodeGen/MIRParser/MIRParser.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "gtest/gtest.h"

using namespace llvm;
using namespace MIPatternMatch;

namespace {

void initLLVM() {
  InitializeAllTargets();
  InitializeAllTargetMCs();
  InitializeAllAsmPrinters();
  InitializeAllAsmParsers();

  PassRegistry *Registry = PassRegistry::getPassRegistry();
  initializeCore(*Registry);
  initializeCodeGen(*Registry);
}

/// Create a TargetMachine. As we lack a dedicated always available target for
/// unittests, we go for "AArch64".
std::unique_ptr<TargetMachine> createTargetMachine() {
  Triple TargetTriple("aarch64--");
  std::string Error;
  const Target *T = TargetRegistry::lookupTarget("", TargetTriple, Error);
  if (!T)
    return nullptr;

  TargetOptions Options;
  return std::unique_ptr<TargetMachine>(T->createTargetMachine(
      "AArch64", "", "", Options, None, None, CodeGenOpt::Aggressive));
}

std::unique_ptr<Module> parseMIR(LLVMContext &Context,
                                 std::unique_ptr<MIRParser> &MIR,
                                 const TargetMachine &TM, StringRef MIRCode,
                                 const char *FuncName, MachineModuleInfo &MMI) {
  SMDiagnostic Diagnostic;
  std::unique_ptr<MemoryBuffer> MBuffer = MemoryBuffer::getMemBuffer(MIRCode);
  MIR = createMIRParser(std::move(MBuffer), Context);
  if (!MIR)
    return nullptr;

  std::unique_ptr<Module> M = MIR->parseIRModule();
  if (!M)
    return nullptr;

  M->setDataLayout(TM.createDataLayout());

  if (MIR->parseMachineFunctions(*M, MMI))
    return nullptr;

  return M;
}

std::pair<std::unique_ptr<Module>, std::unique_ptr<MachineModuleInfo>>
createDummyModule(LLVMContext &Context, const TargetMachine &TM,
                  StringRef MIRFunc) {
  SmallString<512> S;
  StringRef MIRString = (Twine(R"MIR(
---
...
name: func
registers:
  - { id: 0, class: _ }
  - { id: 1, class: _ }
  - { id: 2, class: _ }
  - { id: 3, class: _ }
body: |
  bb.1:
    %0(s64) = COPY $x0
    %1(s64) = COPY $x1
    %2(s64) = COPY $x2
)MIR") + Twine(MIRFunc) + Twine("...\n"))
                            .toNullTerminatedStringRef(S);
  std::unique_ptr<MIRParser> MIR;
  auto MMI = make_unique<MachineModuleInfo>(&TM);
  std::unique_ptr<Module> M =
      parseMIR(Context, MIR, TM, MIRString, "func", *MMI);
  return make_pair(std::move(M), std::move(MMI));
}

static MachineFunction *getMFFromMMI(const Module *M,
                                     const MachineModuleInfo *MMI) {
  Function *F = M->getFunction("func");
  auto *MF = MMI->getMachineFunction(*F);
  return MF;
}

static void collectCopies(SmallVectorImpl<unsigned> &Copies,
                          MachineFunction *MF) {
  for (auto &MBB : *MF)
    for (MachineInstr &MI : MBB) {
      if (MI.getOpcode() == TargetOpcode::COPY)
        Copies.push_back(MI.getOperand(0).getReg());
    }
}

TEST(PatternMatchInstr, MatchIntConstant) {
  LLVMContext Context;
  std::unique_ptr<TargetMachine> TM = createTargetMachine();
  if (!TM)
    return;
  auto ModuleMMIPair = createDummyModule(Context, *TM, "");
  MachineFunction *MF =
      getMFFromMMI(ModuleMMIPair.first.get(), ModuleMMIPair.second.get());
  SmallVector<unsigned, 4> Copies;
  collectCopies(Copies, MF);
  MachineBasicBlock *EntryMBB = &*MF->begin();
  MachineIRBuilder B(*MF);
  MachineRegisterInfo &MRI = MF->getRegInfo();
  B.setInsertPt(*EntryMBB, EntryMBB->end());
  auto MIBCst = B.buildConstant(LLT::scalar(64), 42);
  uint64_t Cst;
  bool match = mi_match(MIBCst->getOperand(0).getReg(), MRI, m_ICst(Cst));
  ASSERT_TRUE(match);
  ASSERT_EQ(Cst, (uint64_t)42);
}

TEST(PatternMatchInstr, MatchBinaryOp) {
  LLVMContext Context;
  std::unique_ptr<TargetMachine> TM = createTargetMachine();
  if (!TM)
    return;
  auto ModuleMMIPair = createDummyModule(Context, *TM, "");
  MachineFunction *MF =
      getMFFromMMI(ModuleMMIPair.first.get(), ModuleMMIPair.second.get());
  SmallVector<unsigned, 4> Copies;
  collectCopies(Copies, MF);
  MachineBasicBlock *EntryMBB = &*MF->begin();
  MachineIRBuilder B(*MF);
  MachineRegisterInfo &MRI = MF->getRegInfo();
  B.setInsertPt(*EntryMBB, EntryMBB->end());
  LLT s64 = LLT::scalar(64);
  auto MIBAdd = B.buildAdd(s64, Copies[0], Copies[1]);
  // Test case for no bind.
  bool match =
      mi_match(MIBAdd->getOperand(0).getReg(), MRI, m_GAdd(m_Reg(), m_Reg()));
  ASSERT_TRUE(match);
  unsigned Src0, Src1, Src2;
  match = mi_match(MIBAdd->getOperand(0).getReg(), MRI,
                   m_GAdd(m_Reg(Src0), m_Reg(Src1)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);
  ASSERT_EQ(Src1, Copies[1]);

  // Build MUL(ADD %0, %1), %2
  auto MIBMul = B.buildMul(s64, MIBAdd, Copies[2]);

  // Try to match MUL.
  match = mi_match(MIBMul->getOperand(0).getReg(), MRI,
                   m_GMul(m_Reg(Src0), m_Reg(Src1)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, MIBAdd->getOperand(0).getReg());
  ASSERT_EQ(Src1, Copies[2]);

  // Try to match MUL(ADD)
  match = mi_match(MIBMul->getOperand(0).getReg(), MRI,
                   m_GMul(m_GAdd(m_Reg(Src0), m_Reg(Src1)), m_Reg(Src2)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);
  ASSERT_EQ(Src1, Copies[1]);
  ASSERT_EQ(Src2, Copies[2]);

  // Test Commutativity.
  auto MIBMul2 = B.buildMul(s64, Copies[0], B.buildConstant(s64, 42));
  // Try to match MUL(Cst, Reg) on src of MUL(Reg, Cst) to validate
  // commutativity.
  uint64_t Cst;
  match = mi_match(MIBMul2->getOperand(0).getReg(), MRI,
                   m_GMul(m_ICst(Cst), m_Reg(Src0)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Cst, (uint64_t)42);
  ASSERT_EQ(Src0, Copies[0]);

  // Make sure commutative doesn't work with something like SUB.
  auto MIBSub = B.buildSub(s64, Copies[0], B.buildConstant(s64, 42));
  match = mi_match(MIBSub->getOperand(0).getReg(), MRI,
                   m_GSub(m_ICst(Cst), m_Reg(Src0)));
  ASSERT_FALSE(match);

  auto MIBFMul = B.buildInstr(TargetOpcode::G_FMUL, s64, Copies[0],
                              B.buildConstant(s64, 42));
  // Match and test commutativity for FMUL.
  match = mi_match(MIBFMul->getOperand(0).getReg(), MRI,
                   m_GFMul(m_ICst(Cst), m_Reg(Src0)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Cst, (uint64_t)42);
  ASSERT_EQ(Src0, Copies[0]);
}

TEST(PatternMatchInstr, MatchExtendsTrunc) {
  LLVMContext Context;
  std::unique_ptr<TargetMachine> TM = createTargetMachine();
  if (!TM)
    return;
  auto ModuleMMIPair = createDummyModule(Context, *TM, "");
  MachineFunction *MF =
      getMFFromMMI(ModuleMMIPair.first.get(), ModuleMMIPair.second.get());
  SmallVector<unsigned, 4> Copies;
  collectCopies(Copies, MF);
  MachineBasicBlock *EntryMBB = &*MF->begin();
  MachineIRBuilder B(*MF);
  MachineRegisterInfo &MRI = MF->getRegInfo();
  B.setInsertPt(*EntryMBB, EntryMBB->end());
  LLT s64 = LLT::scalar(64);
  LLT s32 = LLT::scalar(32);

  auto MIBTrunc = B.buildTrunc(s32, Copies[0]);
  auto MIBAExt = B.buildAnyExt(s64, MIBTrunc);
  auto MIBZExt = B.buildZExt(s64, MIBTrunc);
  auto MIBSExt = B.buildSExt(s64, MIBTrunc);
  unsigned Src0;
  bool match =
      mi_match(MIBTrunc->getOperand(0).getReg(), MRI, m_GTrunc(m_Reg(Src0)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);
  match =
      mi_match(MIBAExt->getOperand(0).getReg(), MRI, m_GAnyExt(m_Reg(Src0)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, MIBTrunc->getOperand(0).getReg());

  match = mi_match(MIBSExt->getOperand(0).getReg(), MRI, m_GSExt(m_Reg(Src0)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, MIBTrunc->getOperand(0).getReg());

  match = mi_match(MIBZExt->getOperand(0).getReg(), MRI, m_GZExt(m_Reg(Src0)));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, MIBTrunc->getOperand(0).getReg());

  // Match ext(trunc src)
  match = mi_match(MIBAExt->getOperand(0).getReg(), MRI,
                   m_GAnyExt(m_GTrunc(m_Reg(Src0))));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);

  match = mi_match(MIBSExt->getOperand(0).getReg(), MRI,
                   m_GSExt(m_GTrunc(m_Reg(Src0))));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);

  match = mi_match(MIBZExt->getOperand(0).getReg(), MRI,
                   m_GZExt(m_GTrunc(m_Reg(Src0))));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);
}

TEST(PatternMatchInstr, MatchSpecificType) {
  LLVMContext Context;
  std::unique_ptr<TargetMachine> TM = createTargetMachine();
  if (!TM)
    return;
  auto ModuleMMIPair = createDummyModule(Context, *TM, "");
  MachineFunction *MF =
      getMFFromMMI(ModuleMMIPair.first.get(), ModuleMMIPair.second.get());
  SmallVector<unsigned, 4> Copies;
  collectCopies(Copies, MF);
  MachineBasicBlock *EntryMBB = &*MF->begin();
  MachineIRBuilder B(*MF);
  MachineRegisterInfo &MRI = MF->getRegInfo();
  B.setInsertPt(*EntryMBB, EntryMBB->end());
  LLT s64 = LLT::scalar(64);
  LLT s32 = LLT::scalar(32);
  auto MIBAdd = B.buildAdd(s64, Copies[0], Copies[1]);

  // Try to match a 64bit add.
  ASSERT_FALSE(mi_match(MIBAdd->getOperand(0).getReg(), MRI,
                        m_GAdd(m_SpecificType(s32), m_Reg())));
  ASSERT_TRUE(mi_match(MIBAdd->getOperand(0).getReg(), MRI,
                       m_GAdd(m_SpecificType(s64), m_Reg())));
}

TEST(PatternMatchInstr, MatchCombinators) {
  LLVMContext Context;
  std::unique_ptr<TargetMachine> TM = createTargetMachine();
  if (!TM)
    return;
  auto ModuleMMIPair = createDummyModule(Context, *TM, "");
  MachineFunction *MF =
      getMFFromMMI(ModuleMMIPair.first.get(), ModuleMMIPair.second.get());
  SmallVector<unsigned, 4> Copies;
  collectCopies(Copies, MF);
  MachineBasicBlock *EntryMBB = &*MF->begin();
  MachineIRBuilder B(*MF);
  MachineRegisterInfo &MRI = MF->getRegInfo();
  B.setInsertPt(*EntryMBB, EntryMBB->end());
  LLT s64 = LLT::scalar(64);
  LLT s32 = LLT::scalar(32);
  auto MIBAdd = B.buildAdd(s64, Copies[0], Copies[1]);
  unsigned Src0, Src1;
  bool match =
      mi_match(MIBAdd->getOperand(0).getReg(), MRI,
               m_all_of(m_SpecificType(s64), m_GAdd(m_Reg(Src0), m_Reg(Src1))));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);
  ASSERT_EQ(Src1, Copies[1]);
  // Check for s32 (which should fail).
  match =
      mi_match(MIBAdd->getOperand(0).getReg(), MRI,
               m_all_of(m_SpecificType(s32), m_GAdd(m_Reg(Src0), m_Reg(Src1))));
  ASSERT_FALSE(match);
  match =
      mi_match(MIBAdd->getOperand(0).getReg(), MRI,
               m_any_of(m_SpecificType(s32), m_GAdd(m_Reg(Src0), m_Reg(Src1))));
  ASSERT_TRUE(match);
  ASSERT_EQ(Src0, Copies[0]);
  ASSERT_EQ(Src1, Copies[1]);
}
} // namespace

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  initLLVM();
  return RUN_ALL_TESTS();
}
