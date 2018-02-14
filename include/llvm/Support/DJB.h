//===-- llvm/Support/DJB.h ---DJB Hash --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains support for the DJ Bernstein hash function.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_DJB_H
#define LLVM_SUPPORT_DJB_H

#include "llvm/ADT/StringRef.h"

namespace llvm {

/// The Bernstein hash function used by the DWARF accelerator tables.
uint32_t djbHash(StringRef Buffer, uint32_t H = 5381);
} // namespace llvm

#endif // LLVM_SUPPORT_DJB_H
