//===-- TestRunner.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "TestRunner.h"

using namespace llvm;

/// Gets Current Working Directory and tries to create a Tmp Directory
static SmallString<128> initializeTmpDirectory() {
  SmallString<128> CWD;
  if (std::error_code EC = sys::fs::current_path(CWD)) {
    errs() << "Error getting current directory: " << EC.message() << "!\n";
    exit(1);
  }

  SmallString<128> TmpDirectory;
  sys::path::append(TmpDirectory, CWD, "tmp");
  if (std::error_code EC = sys::fs::create_directory(TmpDirectory))
    errs() << "Error creating tmp directory: " << EC.message() << "!\n";

  return TmpDirectory;
}

TestRunner::TestRunner(StringRef TestName, std::vector<std::string> TestArgs)
    : TestName(TestName), TestArgs(std::move(TestArgs)) {
  TmpDirectory = initializeTmpDirectory();
}

/// Runs the interestingness test, passes file to be tested as first argument
/// and other specified test arguments after that.
int TestRunner::run(StringRef Filename) {
  std::vector<StringRef> ProgramArgs;
  ProgramArgs.push_back(TestName);

  for (const auto &Arg : TestArgs)
    ProgramArgs.push_back(Arg);

  ProgramArgs.push_back(Filename);

  std::string ErrMsg;
  int Result = sys::ExecuteAndWait(
      TestName, ProgramArgs, /*Env=*/None, /*Redirects=*/None,
      /*SecondsToWait=*/0, /*MemoryLimit=*/0, &ErrMsg);

  if (Result < 0) {
    Error E = make_error<StringError>("Error running interesting-ness test: " +
                                          ErrMsg,
                                      inconvertibleErrorCode());
    errs() << toString(std::move(E));
    exit(1);
  }

  return !Result;
}
