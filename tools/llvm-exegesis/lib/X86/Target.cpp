//===-- Target.cpp ----------------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
#include "../Target.h"

#include "../Latency.h"
#include "../Uops.h"
#include "MCTargetDesc/X86BaseInfo.h"
#include "MCTargetDesc/X86MCTargetDesc.h"
#include "X86.h"
#include "X86RegisterInfo.h"
#include "llvm/MC/MCInstBuilder.h"

namespace exegesis {

namespace {

// Common code for X86 Uops and Latency runners.
template <typename Impl> class X86BenchmarkRunner : public Impl {
  using Impl::Impl;

  llvm::Expected<SnippetPrototype>
  generatePrototype(unsigned Opcode) const override {
    // Test whether we can generate a snippet for this instruction.
    const auto &InstrInfo = this->State.getInstrInfo();
    const auto OpcodeName = InstrInfo.getName(Opcode);
    if (OpcodeName.startswith("POPF") || OpcodeName.startswith("PUSHF") ||
        OpcodeName.startswith("ADJCALLSTACK")) {
      return llvm::make_error<BenchmarkFailure>(
          "Unsupported opcode: Push/Pop/AdjCallStack");
    }

    // Handle X87.
    const auto &InstrDesc = InstrInfo.get(Opcode);
    const unsigned FPInstClass = InstrDesc.TSFlags & llvm::X86II::FPTypeMask;
    const Instruction Instr(InstrDesc, this->RATC);
    switch (FPInstClass) {
    case llvm::X86II::NotFP:
      break;
    case llvm::X86II::ZeroArgFP:
      return Impl::handleZeroArgFP(Instr);
    case llvm::X86II::OneArgFP:
      return Impl::handleOneArgFP(Instr); // fstp ST(0)
    case llvm::X86II::OneArgFPRW:
    case llvm::X86II::TwoArgFP: {
      // These are instructions like
      //   - `ST(0) = fsqrt(ST(0))` (OneArgFPRW)
      //   - `ST(0) = ST(0) + ST(i)` (TwoArgFP)
      // They are intrinsically serial and do not modify the state of the stack.
      // We generate the same code for latency and uops.
      return this->generateSelfAliasingPrototype(Instr);
    }
    case llvm::X86II::CompareFP:
      return Impl::handleCompareFP(Instr);
    case llvm::X86II::CondMovFP:
      return Impl::handleCondMovFP(Instr);
    case llvm::X86II::SpecialFP:
      return Impl::handleSpecialFP(Instr);
    default:
      llvm_unreachable("Unknown FP Type!");
    }

    // Fallback to generic implementation.
    return Impl::Base::generatePrototype(Opcode);
  }
};

class X86LatencyImpl : public LatencyBenchmarkRunner {
protected:
  using Base = LatencyBenchmarkRunner;
  using Base::Base;
  llvm::Expected<SnippetPrototype>
  handleZeroArgFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 ZeroArgFP");
  }
  llvm::Expected<SnippetPrototype>
  handleOneArgFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 OneArgFP");
  }
  llvm::Expected<SnippetPrototype>
  handleCompareFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 CompareFP");
  }
  llvm::Expected<SnippetPrototype>
  handleCondMovFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 CondMovFP");
  }
  llvm::Expected<SnippetPrototype>
  handleSpecialFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 SpecialFP");
  }
};

class X86UopsImpl : public UopsBenchmarkRunner {
protected:
  using Base = UopsBenchmarkRunner;
  using Base::Base;
  llvm::Expected<SnippetPrototype>
  handleZeroArgFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 ZeroArgFP");
  }
  llvm::Expected<SnippetPrototype>
  handleOneArgFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 OneArgFP");
  }
  llvm::Expected<SnippetPrototype>
  handleCompareFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 CompareFP");
  }
  llvm::Expected<SnippetPrototype>
  handleCondMovFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 CondMovFP");
  }
  llvm::Expected<SnippetPrototype>
  handleSpecialFP(const Instruction &Instr) const {
    return llvm::make_error<BenchmarkFailure>("Unsupported x87 SpecialFP");
  }
};

class ExegesisX86Target : public ExegesisTarget {
  void addTargetSpecificPasses(llvm::PassManagerBase &PM) const override {
    // Lowers FP pseudo-instructions, e.g. ABS_Fp32 -> ABS_F.
    // FIXME: Enable when the exegesis assembler no longer does
    // Properties.reset(TracksLiveness);
    PM.add(llvm::createX86FloatingPointStackifierPass());
  }

  std::vector<llvm::MCInst>
  setRegToConstant(unsigned Reg) const override {
    if (llvm::X86::GR8RegClass.contains(Reg)) {
      return {llvm::MCInstBuilder(llvm::X86::MOV8ri).addReg(Reg).addImm(1)};
    }
    if (llvm::X86::GR16RegClass.contains(Reg)) {
      return {llvm::MCInstBuilder(llvm::X86::MOV16ri).addReg(Reg).addImm(1)};
    }
    if (llvm::X86::GR32RegClass.contains(Reg)) {
      return {llvm::MCInstBuilder(llvm::X86::MOV32ri).addReg(Reg).addImm(1)};
    }
    if (llvm::X86::GR64RegClass.contains(Reg)) {
      return {llvm::MCInstBuilder(llvm::X86::MOV64ri32).addReg(Reg).addImm(1)};
    }
    if (llvm::X86::VR128XRegClass.contains(Reg)) {
      return setVectorRegToConstant(Reg, 16, llvm::X86::VMOVDQUrm);
    }
    if (llvm::X86::VR256XRegClass.contains(Reg)) {
      return setVectorRegToConstant(Reg, 32, llvm::X86::VMOVDQUYrm);
    }
    if (llvm::X86::VR512RegClass.contains(Reg)) {
      return setVectorRegToConstant(Reg, 64, llvm::X86::VMOVDQU64Zrm);
    }
    if (llvm::X86::RFP32RegClass.contains(Reg) ||
        llvm::X86::RFP64RegClass.contains(Reg) ||
        llvm::X86::RFP80RegClass.contains(Reg)) {
      return setVectorRegToConstant(Reg, 8, llvm::X86::LD_Fp64m);
    }
    return {};
  }

  std::unique_ptr<BenchmarkRunner>
  createLatencyBenchmarkRunner(const LLVMState &State) const override {
    return llvm::make_unique<X86BenchmarkRunner<X86LatencyImpl>>(
        State);
  }

  std::unique_ptr<BenchmarkRunner>
  createUopsBenchmarkRunner(const LLVMState &State) const override {
    return llvm::make_unique<X86BenchmarkRunner<X86UopsImpl>>(State);
  }

  bool matchesArch(llvm::Triple::ArchType Arch) const override {
    return Arch == llvm::Triple::x86_64 || Arch == llvm::Triple::x86;
  }

private:
  // setRegToConstant() specialized for a vector register of size
  // `RegSizeBytes`. `RMOpcode` is the opcode used to do a memory -> vector
  // register load.
  static std::vector<llvm::MCInst>
  setVectorRegToConstant(const unsigned Reg, const unsigned RegSizeBytes,
                         const unsigned RMOpcode) {
    // There is no instruction to directly set XMM, go through memory.
    // Since vector values can be interpreted as integers of various sizes (8
    // to 64 bits) as well as floats and double, so we chose an immediate
    // value that has set bits for all byte values and is a normal float/
    // double. 0x40404040 is ~32.5 when interpreted as a double and ~3.0f when
    // interpreted as a float.
    constexpr const uint64_t kImmValue = 0x40404040ull;
    std::vector<llvm::MCInst> Result;
    // Allocate scratch memory on the stack.
    Result.push_back(llvm::MCInstBuilder(llvm::X86::SUB64ri8)
                         .addReg(llvm::X86::RSP)
                         .addReg(llvm::X86::RSP)
                         .addImm(RegSizeBytes));
    // Fill scratch memory.
    for (unsigned Disp = 0; Disp < RegSizeBytes; Disp += 4) {
      Result.push_back(llvm::MCInstBuilder(llvm::X86::MOV32mi)
                           // Address = ESP
                           .addReg(llvm::X86::RSP) // BaseReg
                           .addImm(1)              // ScaleAmt
                           .addReg(0)              // IndexReg
                           .addImm(Disp)           // Disp
                           .addReg(0)              // Segment
                           // Immediate.
                           .addImm(kImmValue));
    }
    // Load Reg from scratch memory.
    Result.push_back(llvm::MCInstBuilder(RMOpcode)
                         .addReg(Reg)
                         // Address = ESP
                         .addReg(llvm::X86::RSP) // BaseReg
                         .addImm(1)              // ScaleAmt
                         .addReg(0)              // IndexReg
                         .addImm(0)              // Disp
                         .addReg(0));            // Segment
    // Release scratch memory.
    Result.push_back(llvm::MCInstBuilder(llvm::X86::ADD64ri8)
                         .addReg(llvm::X86::RSP)
                         .addReg(llvm::X86::RSP)
                         .addImm(RegSizeBytes));
    return Result;
  }
};

} // namespace

static ExegesisTarget *getTheExegesisX86Target() {
  static ExegesisX86Target Target;
  return &Target;
}

void InitializeX86ExegesisTarget() {
  ExegesisTarget::registerTarget(getTheExegesisX86Target());
}

} // namespace exegesis
