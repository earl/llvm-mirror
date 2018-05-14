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

namespace exegesis {

bool operator==(const BenchmarkMeasure &A, const BenchmarkMeasure &B) {
  return std::tie(A.Key, A.Value) == std::tie(B.Key, B.Value);
}

namespace {

TEST(BenchmarkResultTest, WriteToAndReadFromDisk) {
  InstructionBenchmark ToDisk;

  ToDisk.AsmTmpl.Name = "name";
  ToDisk.CpuName = "cpu_name";
  ToDisk.LLVMTriple = "llvm_triple";
  ToDisk.NumRepetitions = 1;
  ToDisk.Measurements.push_back(BenchmarkMeasure{"a", 1, "debug a"});
  ToDisk.Measurements.push_back(BenchmarkMeasure{"b", 2, ""});
  ToDisk.Error = "error";

  llvm::SmallString<64> Filename;
  std::error_code EC;
  EC = llvm::sys::fs::createUniqueDirectory("BenchmarkResultTestDir", Filename);
  ASSERT_FALSE(EC);
  llvm::sys::path::append(Filename, "data.yaml");

  ToDisk.writeYamlOrDie(Filename);

  {
    // One-element version.
    const auto FromDisk = InstructionBenchmark::readYamlOrDie(Filename);

    EXPECT_EQ(FromDisk.AsmTmpl.Name, ToDisk.AsmTmpl.Name);
    EXPECT_EQ(FromDisk.CpuName, ToDisk.CpuName);
    EXPECT_EQ(FromDisk.LLVMTriple, ToDisk.LLVMTriple);
    EXPECT_EQ(FromDisk.NumRepetitions, ToDisk.NumRepetitions);
    EXPECT_THAT(FromDisk.Measurements, ToDisk.Measurements);
    EXPECT_THAT(FromDisk.Error, ToDisk.Error);
  }
  {
    // Vector version.
    const auto FromDiskVector = InstructionBenchmark::readYamlsOrDie(Filename);
    ASSERT_EQ(FromDiskVector.size(), size_t{1});
    const auto FromDisk = FromDiskVector[0];
    EXPECT_EQ(FromDisk.AsmTmpl.Name, ToDisk.AsmTmpl.Name);
    EXPECT_EQ(FromDisk.CpuName, ToDisk.CpuName);
    EXPECT_EQ(FromDisk.LLVMTriple, ToDisk.LLVMTriple);
    EXPECT_EQ(FromDisk.NumRepetitions, ToDisk.NumRepetitions);
    EXPECT_THAT(FromDisk.Measurements, ToDisk.Measurements);
    EXPECT_THAT(FromDisk.Error, ToDisk.Error);
  }
}

} // namespace
} // namespace exegesis
