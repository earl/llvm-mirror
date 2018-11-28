//===- llvm/TextAPI/TextStubCommon.h - Text Stub Common ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Defines common Text Stub YAML mappings.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TEXTAPI_TEXT_STUB_COMMON_H
#define LLVM_TEXTAPI_TEXT_STUB_COMMON_H

#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/Support/YAMLTraits.h"
#include "llvm/TextAPI/MachO/Architecture.h"
#include "llvm/TextAPI/MachO/ArchitectureSet.h"
#include "llvm/TextAPI/MachO/InterfaceFile.h"
#include "llvm/TextAPI/MachO/PackedVersion.h"

using UUID = std::pair<llvm::MachO::Architecture, std::string>;

LLVM_YAML_STRONG_TYPEDEF(llvm::StringRef, FlowStringRef)
LLVM_YAML_STRONG_TYPEDEF(uint8_t, SwiftVersion)
LLVM_YAML_IS_FLOW_SEQUENCE_VECTOR(UUID)
LLVM_YAML_IS_FLOW_SEQUENCE_VECTOR(FlowStringRef)

namespace llvm {
namespace yaml {

template <> struct ScalarTraits<FlowStringRef> {
  static void output(const FlowStringRef &, void *, raw_ostream &);
  static StringRef input(StringRef, void *, FlowStringRef &);
  static QuotingType mustQuote(StringRef);
};

template <> struct ScalarEnumerationTraits<MachO::ObjCConstraint> {
  static void enumeration(IO &, MachO::ObjCConstraint &);
};

template <> struct ScalarTraits<MachO::Platform> {
  static void output(const MachO::Platform &, void *, raw_ostream &);
  static StringRef input(StringRef, void *, MachO::Platform &);
  static QuotingType mustQuote(StringRef);
};

template <> struct ScalarBitSetTraits<MachO::ArchitectureSet> {
  static void bitset(IO &, MachO::ArchitectureSet &);
};

template <> struct ScalarTraits<MachO::Architecture> {
  static void output(const MachO::Architecture &, void *, raw_ostream &);
  static StringRef input(StringRef, void *, MachO::Architecture &);
  static QuotingType mustQuote(StringRef);
};

template <> struct ScalarTraits<MachO::PackedVersion> {
  static void output(const MachO::PackedVersion &, void *, raw_ostream &);
  static StringRef input(StringRef, void *, MachO::PackedVersion &);
  static QuotingType mustQuote(StringRef);
};

template <> struct ScalarTraits<SwiftVersion> {
  static void output(const SwiftVersion &, void *, raw_ostream &);
  static StringRef input(StringRef, void *, SwiftVersion &);
  static QuotingType mustQuote(StringRef);
};

template <> struct ScalarTraits<UUID> {
  static void output(const UUID &, void *, raw_ostream &);
  static StringRef input(StringRef, void *, UUID &);
  static QuotingType mustQuote(StringRef);
};

} // end namespace yaml.
} // end namespace llvm.

#endif // LLVM_TEXTAPI_TEXT_STUB_COMMON_H
