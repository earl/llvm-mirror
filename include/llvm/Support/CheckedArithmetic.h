//==-- llvm/Support/CheckedArithmetic.h - Safe arithmetical operations *- C++ //
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains generic functions for operating on integers which
// give the indication on whether the operation has overflown.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_CHECKEDARITHMETIC_H
#define LLVM_SUPPORT_CHECKEDARITHMETIC_H

#include "llvm/ADT/APInt.h"
#include "llvm/ADT/Optional.h"

#include <type_traits>

namespace {

/// Utility function to apply a given method of \c APInt \p F to \p LHS and
/// \p RHS.
/// \return Empty optional if the operation overflows, or result otherwise.
template <typename T, typename F>
typename std::enable_if<std::is_integral<T>::value && sizeof(T) * 8 <= 64,
                        llvm::Optional<T>>::type
checkedOp(T LHS, T RHS, F Op, bool Signed = true) {
  llvm::APInt ALHS(/*BitSize=*/sizeof(T) * 8, LHS, Signed);
  llvm::APInt ARHS(/*BitSize=*/sizeof(T) * 8, RHS, Signed);
  bool Overflow;
  llvm::APInt Out = (ALHS.*Op)(ARHS, Overflow);
  if (Overflow)
    return llvm::None;
  return Signed ? Out.getSExtValue() : Out.getZExtValue();
}
}

namespace llvm {

/// Add two signed integers \p LHS and \p RHS, return wrapped result if
/// available.
template <typename T>
typename std::enable_if<std::is_signed<T>::value, llvm::Optional<T>>::type
checkedAdd(T LHS, T RHS) {
  return checkedOp(LHS, RHS, &llvm::APInt::sadd_ov);
}

/// Multiply two signed integers \p LHS and \p RHS, return wrapped result
/// if available.
template <typename T>
typename std::enable_if<std::is_signed<T>::value, llvm::Optional<T>>::type
checkedMul(T LHS, T RHS) {
  return checkedOp(LHS, RHS, &llvm::APInt::smul_ov);
}

/// Add two unsigned integers \p LHS and \p RHS, return wrapped result
/// if available.
template <typename T>
typename std::enable_if<std::is_unsigned<T>::value, llvm::Optional<T>>::type
checkedAddUnsigned(T LHS, T RHS) {
  return checkedOp(LHS, RHS, &llvm::APInt::uadd_ov, /*Signed=*/false);
}

/// Multiply two unsigned integers \p LHS and \p RHS, return wrapped result
/// if available.
template <typename T>
typename std::enable_if<std::is_unsigned<T>::value, llvm::Optional<T>>::type
checkedMulUnsigned(T LHS, T RHS) {
  return checkedOp(LHS, RHS, &llvm::APInt::umul_ov, /*Signed=*/false);
}

} // End llvm namespace

#endif
