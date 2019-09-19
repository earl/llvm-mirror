//===- ReduceArguments.cpp - Specialized Delta Pass -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a function which calls the Generic Delta pass in order
// to reduce uninteresting Arguments from defined functions.
//
//===----------------------------------------------------------------------===//

#include "ReduceInstructions.h"

using namespace llvm;

/// Removes out-of-chunk arguments from functions, and modifies their calls
/// accordingly. It also removes allocations of out-of-chunk arguments.
static void extractInstrFromModule(std::vector<Chunk> ChunksToKeep,
                                   Module *Program) {
  int I = 0, InstCount = 0;
  std::set<Instruction *> InstToKeep;

  for (auto &F : *Program)
    for (auto &BB : F)
      for (auto &Inst : BB)
        if (I < (int)ChunksToKeep.size()) {
          if (ChunksToKeep[I].contains(++InstCount))
            InstToKeep.insert(&Inst);
          if (ChunksToKeep[I].end == InstCount)
            ++I;
        }

  std::vector<Instruction *> InstToDelete;
  for (auto &F : *Program)
    for (auto &BB : F)
      for (auto &Inst : BB)
        if (!InstToKeep.count(&Inst)) {
          Inst.replaceAllUsesWith(UndefValue::get(Inst.getType()));
          InstToDelete.push_back(&Inst);
        }

  for (auto &I : InstToDelete)
    I->eraseFromParent();
}

/// Counts the amount of basic blocks and prints their name & respective index
static unsigned countInstructions(Module *Program) {
  // TODO: Silence index with --quiet flag
  outs() << "----------------------------\n";
  int InstCount = 0;
  for (auto &F : *Program)
    for (auto &BB : F)
        InstCount += BB.getInstList().size();
  outs() << "Number of instructions: " << InstCount << "\n";

  return InstCount;
}

void llvm::reduceInstructionsDeltaPass(TestRunner &Test) {
  outs() << "*** Reducing Insructions...\n";
  unsigned InstCount = countInstructions(Test.getProgram());
  runDeltaPass(Test, InstCount, extractInstrFromModule);
}
