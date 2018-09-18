#include "Target.h"

#include <cassert>
#include <memory>

#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

namespace exegesis {

void InitializeAArch64ExegesisTarget();

namespace {

using llvm::APInt;
using llvm::MCInst;
using testing::Gt;
using testing::IsEmpty;
using testing::Not;
using testing::NotNull;

constexpr const char kTriple[] = "aarch64-unknown-linux";
constexpr const char kGenericCpu[] = "generic";
constexpr const char kNoFeatures[] = "";

class AArch64TargetTest : public ::testing::Test {
protected:
  AArch64TargetTest()
      : ExegesisTarget_(ExegesisTarget::lookup(llvm::Triple(kTriple))) {
    EXPECT_THAT(ExegesisTarget_, NotNull());
    std::string error;
    Target_ = llvm::TargetRegistry::lookupTarget(kTriple, error);
    EXPECT_THAT(Target_, NotNull());
    STI_.reset(
        Target_->createMCSubtargetInfo(kTriple, kGenericCpu, kNoFeatures));
  }

  static void SetUpTestCase() {
    LLVMInitializeAArch64TargetInfo();
    LLVMInitializeAArch64Target();
    LLVMInitializeAArch64TargetMC();
    InitializeAArch64ExegesisTarget();
  }

  std::vector<MCInst> setRegTo(unsigned Reg, const APInt &Value) {
    return ExegesisTarget_->setRegTo(*STI_, Reg, Value);
  }

  const llvm::Target *Target_;
  const ExegesisTarget *const ExegesisTarget_;
  std::unique_ptr<llvm::MCSubtargetInfo> STI_;
};

TEST_F(AArch64TargetTest, SetRegToConstant) {
  // The AArch64 target currently doesn't know how to set register values.
  const auto Insts = setRegTo(llvm::AArch64::X0, llvm::APInt());
  EXPECT_THAT(Insts, Not(IsEmpty()));
}

} // namespace
} // namespace exegesis
