//===-- WebAssemblyAddMissingPrototypes.cpp - Fix prototypeless functions -===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// Add prototypes to prototypes-less functions.
///
/// WebAssembly has strict function prototype checking so we need functions
/// declarations to match the call sites.  Clang treats prototype-less functions
/// as varargs (foo(...)) which happens to work on existing platforms but
/// doesn't under WebAssembly.  This pass will find all the call sites of each
/// prototype-less function, ensure they agree, and then set the signature
/// on the function declaration accordingly.
///
//===----------------------------------------------------------------------===//

#include "WebAssembly.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
using namespace llvm;

#define DEBUG_TYPE "wasm-add-missing-prototypes"

namespace {
class WebAssemblyAddMissingPrototypes final : public ModulePass {
  StringRef getPassName() const override {
    return "Add prototypes to prototypes-less functions";
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    ModulePass::getAnalysisUsage(AU);
  }

  bool runOnModule(Module &M) override;

public:
  static char ID;
  WebAssemblyAddMissingPrototypes() : ModulePass(ID) {}
};
} // End anonymous namespace

char WebAssemblyAddMissingPrototypes::ID = 0;
INITIALIZE_PASS(WebAssemblyAddMissingPrototypes, DEBUG_TYPE,
                "Add prototypes to prototypes-less functions", false, false)

ModulePass *llvm::createWebAssemblyAddMissingPrototypes() {
  return new WebAssemblyAddMissingPrototypes();
}

bool WebAssemblyAddMissingPrototypes::runOnModule(Module &M) {
  LLVM_DEBUG(dbgs() << "********** Add Missing Prototypes **********\n");

  std::vector<std::pair<Function *, Function *>> Replacements;

  // Find all the prototype-less function declarations
  for (Function &F : M) {
    if (!F.isDeclaration() || !F.hasFnAttribute("no-prototype"))
      continue;

    LLVM_DEBUG(dbgs() << "Found no-prototype function: " << F.getName()
                      << "\n");

    // When clang emits prototype-less C functions it uses (...), i.e. varargs
    // function that take no arguments (have no sentinel).  When we see a
    // no-prototype attribute we expect the function have these properties.
    if (!F.isVarArg())
      report_fatal_error(
          "Functions with 'no-prototype' attribute must take varargs: " +
          F.getName());
    if (F.getFunctionType()->getNumParams() != 0)
      report_fatal_error(
          "Functions with 'no-prototype' attribute should not have params: " +
          F.getName());

    // Create a function prototype based on the first call site (first bitcast)
    // that we find.
    FunctionType *NewType = nullptr;
    Function *NewF = nullptr;
    for (Use &U : F.uses()) {
      LLVM_DEBUG(dbgs() << "prototype-less use: " << F.getName() << "\n");
      if (auto *BC = dyn_cast<BitCastOperator>(U.getUser())) {
        if (auto *DestType = dyn_cast<FunctionType>(
                BC->getDestTy()->getPointerElementType())) {
          if (!NewType) {
            // Create a new function with the correct type
            NewType = DestType;
            NewF = Function::Create(NewType, F.getLinkage(), F.getName() + ".fixed_sig");
            NewF->setAttributes(F.getAttributes());
            NewF->removeFnAttr("no-prototype");
            Replacements.emplace_back(&F, NewF);
          } else {
            if (NewType != DestType) {
              report_fatal_error("Prototypeless function used with "
                                 "conflicting signatures: " +
                                 F.getName());
            }
          }
        }
      }
    }

    if (!NewType) {
      LLVM_DEBUG(
          dbgs() << "could not derive a function prototype from usage: " +
                        F.getName() + "\n");
      continue;
    }
  }

  for (auto &Pair : Replacements) {
    Function *OldF = Pair.first;
    Function *NewF = Pair.second;
    std::string Name = OldF->getName();
    M.getFunctionList().push_back(NewF);
    OldF->replaceAllUsesWith(
      ConstantExpr::getPointerBitCastOrAddrSpaceCast(NewF, OldF->getType()));
    OldF->eraseFromParent();
    NewF->setName(Name);
  }

  return !Replacements.empty();
}
