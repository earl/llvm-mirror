//===- MustExecute.h - Is an instruction known to execute--------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// Contains a collection of routines for determining if a given instruction is
/// guaranteed to execute if a given point in control flow is reached.  The most
/// common example is an instruction within a loop being provably executed if we
/// branch to the header of it's containing loop.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_ANALYSIS_MUSTEXECUTE_H
#define LLVM_ANALYSIS_MUSTEXECUTE_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/Analysis/EHPersonalities.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instruction.h"

namespace llvm {

class Instruction;
class DominatorTree;
class Loop;

/// Captures loop safety information.
/// It keep information for loop blocks may throw exception or otherwise
/// exit abnormaly on any iteration of the loop which might actually execute
/// at runtime.  The primary way to consume this infromation is via
/// isGuaranteedToExecute below, but some callers bailout or fallback to
/// alternate reasoning if a loop contains any implicit control flow.
/// NOTE: LoopSafetyInfo contains cached information regarding loops and their
/// particular blocks. This information is only dropped on invocation of
/// computeLoopSafetyInfo. If the loop or any of its block is deleted, or if
/// any thrower instructions have been added or removed from them, or if the
/// control flow has changed, or in case of other meaningful modifications, the
/// LoopSafetyInfo needs to be recomputed. If a meaningful modifications to the
/// loop were made and the info wasn't recomputed properly, the behavior of all
/// methods except for computeLoopSafetyInfo is undefined.
class LoopSafetyInfo {
  bool MayThrow = false;       // The current loop contains an instruction which
                               // may throw.
  bool HeaderMayThrow = false; // Same as previous, but specific to loop header

  /// Collect all blocks from \p CurLoop which lie on all possible paths from
  /// the header of \p CurLoop (inclusive) to BB (exclusive) into the set
  /// \p Predecessors. If \p BB is the header, \p Predecessors will be empty.
  void collectTransitivePredecessors(
      const Loop *CurLoop, const BasicBlock *BB,
      SmallPtrSetImpl<const BasicBlock *> &Predecessors) const;

public:
  // Used to update funclet bundle operands.
  DenseMap<BasicBlock *, ColorVector> BlockColors;

  /// Returns true iff the header block of the loop for which this info is
  /// calculated contains an instruction that may throw or otherwise exit
  /// abnormally.
  bool headerMayThrow() const;

  /// Returns true iff any block of the loop for which this info is contains an
  /// instruction that may throw or otherwise exit abnormally.
  bool anyBlockMayThrow() const;

  /// Return true if we must reach the block \p BB under assumption that the
  /// loop \p CurLoop is entered and no instruction throws or otherwise exits
  /// abnormally.
  bool allLoopPathsLeadToBlock(const Loop *CurLoop, const BasicBlock *BB,
                               const DominatorTree *DT) const;

  /// Computes safety information for a loop checks loop body & header for
  /// the possibility of may throw exception, it takes LoopSafetyInfo and loop
  /// as argument. Updates safety information in LoopSafetyInfo argument.
  /// Note: This is defined to clear and reinitialize an already initialized
  /// LoopSafetyInfo.  Some callers rely on this fact.
  void computeLoopSafetyInfo(Loop *);

  LoopSafetyInfo() = default;
};

/// Returns true if the instruction in a loop is guaranteed to execute at least
/// once (under the assumption that the loop is entered).
bool isGuaranteedToExecute(const Instruction &Inst, const DominatorTree *DT,
                           const Loop *CurLoop,
                           const LoopSafetyInfo *SafetyInfo);

}

#endif
