//===-- BenchmarkResultTest.cpp ---------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "BenchmarkResult.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/YAMLTraits.h"
#include "llvm/Support/raw_ostream.h"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

using ::testing::AllOf;
using ::testing::Eq;
using ::testing::get;
using ::testing::Pointwise;
using ::testing::Property;

namespace exegesis {

bool operator==(const BenchmarkMeasure &A, const BenchmarkMeasure &B) {
  return std::tie(A.Key, A.Value) == std::tie(B.Key, B.Value);
}

MATCHER(EqMCInst, "") {
  return get<0>(arg).getOpcode() == get<1>(arg).getOpcode();
}

namespace {

static constexpr const unsigned kInstrId = 5;
static constexpr const char kInstrName[] = "Instruction5";

TEST(BenchmarkResultTest, WriteToAndReadFromDisk) {
  BenchmarkResultContext Ctx;
  Ctx.addInstrEntry(kInstrId, kInstrName);

  InstructionBenchmark ToDisk;

  ToDisk.Key.OpcodeName = "name";
  ToDisk.Key.Instructions.push_back(llvm::MCInstBuilder(kInstrId));
  ToDisk.Key.Mode = InstructionBenchmarkKey::Latency;
  ToDisk.Key.Config = "config";
  ToDisk.CpuName = "cpu_name";
  ToDisk.LLVMTriple = "llvm_triple";
  ToDisk.NumRepetitions = 1;
  ToDisk.Measurements.push_back(BenchmarkMeasure{"a", 1, "debug a"});
  ToDisk.Measurements.push_back(BenchmarkMeasure{"b", 2, ""});
  ToDisk.Error = "error";
  ToDisk.Info = "info";

  llvm::SmallString<64> Filename;
  std::error_code EC;
  EC = llvm::sys::fs::createUniqueDirectory("BenchmarkResultTestDir", Filename);
  ASSERT_FALSE(EC);
  llvm::sys::path::append(Filename, "data.yaml");
  ToDisk.writeYamlOrDie(Ctx, Filename);

  {
    // One-element version.
    const auto FromDisk = InstructionBenchmark::readYamlOrDie(Ctx, Filename);

    EXPECT_EQ(FromDisk.Key.OpcodeName, ToDisk.Key.OpcodeName);
    EXPECT_THAT(FromDisk.Key.Instructions,
                Pointwise(EqMCInst(), ToDisk.Key.Instructions));
    EXPECT_EQ(FromDisk.Key.Mode, ToDisk.Key.Mode);
    EXPECT_EQ(FromDisk.Key.Config, ToDisk.Key.Config);
    EXPECT_EQ(FromDisk.CpuName, ToDisk.CpuName);
    EXPECT_EQ(FromDisk.LLVMTriple, ToDisk.LLVMTriple);
    EXPECT_EQ(FromDisk.NumRepetitions, ToDisk.NumRepetitions);
    EXPECT_THAT(FromDisk.Measurements, ToDisk.Measurements);
    EXPECT_THAT(FromDisk.Error, ToDisk.Error);
    EXPECT_EQ(FromDisk.Info, ToDisk.Info);
  }
  {
    // Vector version.
    const auto FromDiskVector =
        InstructionBenchmark::readYamlsOrDie(Ctx, Filename);
    ASSERT_EQ(FromDiskVector.size(), size_t{1});
    const auto FromDisk = FromDiskVector[0];
    EXPECT_EQ(FromDisk.Key.OpcodeName, ToDisk.Key.OpcodeName);
    EXPECT_THAT(FromDisk.Key.Instructions,
                Pointwise(EqMCInst(), ToDisk.Key.Instructions));
    EXPECT_EQ(FromDisk.Key.Mode, ToDisk.Key.Mode);
    EXPECT_EQ(FromDisk.Key.Config, ToDisk.Key.Config);
    EXPECT_EQ(FromDisk.CpuName, ToDisk.CpuName);
    EXPECT_EQ(FromDisk.LLVMTriple, ToDisk.LLVMTriple);
    EXPECT_EQ(FromDisk.NumRepetitions, ToDisk.NumRepetitions);
    EXPECT_THAT(FromDisk.Measurements, ToDisk.Measurements);
    EXPECT_THAT(FromDisk.Error, ToDisk.Error);
    EXPECT_EQ(FromDisk.Info, ToDisk.Info);
  }
}

TEST(BenchmarkResultTest, BenchmarkMeasureStats) {
  BenchmarkMeasureStats Stats;
  Stats.push(BenchmarkMeasure{"a", 0.5, "debug a"});
  Stats.push(BenchmarkMeasure{"a", 1.5, "debug a"});
  Stats.push(BenchmarkMeasure{"a", -1.0, "debug a"});
  Stats.push(BenchmarkMeasure{"a", 0.0, "debug a"});
  EXPECT_EQ(Stats.min(), -1.0);
  EXPECT_EQ(Stats.max(), 1.5);
  EXPECT_EQ(Stats.avg(), 0.25); // (0.5+1.5-1.0+0.0) / 4
}
} // namespace
} // namespace exegesis
