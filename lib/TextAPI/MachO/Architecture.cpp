//===- llvm/TextAPI/Architecture.cpp - Architecture -------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Implements the architecture helper functions.
///
//===----------------------------------------------------------------------===//

#include "llvm/TextAPI/MachO/Architecture.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/BinaryFormat/MachO.h"

namespace llvm {
namespace MachO {

Architecture getArchitectureFromCpuType(uint32_t CPUType, uint32_t CPUSubType) {
#define ARCHINFO(Arch, Type, Subtype)                                          \
  if (CPUType == (Type) &&                                                     \
      (CPUSubType & ~MachO::CPU_SUBTYPE_MASK) == (Subtype))                    \
    return Architecture::Arch;
#include "llvm/TextAPI/MachO/Architecture.def"
#undef ARCHINFO

  return Architecture::unknown;
}

Architecture getArchitectureFromName(StringRef Name) {
  return StringSwitch<Architecture>(Name)
#define ARCHINFO(Arch, Type, Subtype) .Case(#Arch, Architecture::Arch)
#include "llvm/TextAPI/MachO/Architecture.def"
#undef ARCHINFO
      .Default(Architecture::unknown);
}

StringRef getArchitectureName(Architecture Arch) {
  switch (Arch) {
#define ARCHINFO(Arch, Type, Subtype)                                          \
  case Architecture::Arch:                                                     \
    return #Arch;
#include "llvm/TextAPI/MachO/Architecture.def"
#undef ARCHINFO
  case Architecture::unknown:
    return "unknown";
  }
}

std::pair<uint32_t, uint32_t> getCPUTypeFromArchitecture(Architecture Arch) {
  switch (Arch) {
#define ARCHINFO(Arch, Type, Subtype)                                          \
  case Architecture::Arch:                                                     \
    return std::make_pair(Type, Subtype);
#include "llvm/TextAPI/MachO/Architecture.def"
#undef ARCHINFO
  case Architecture::unknown:
    return std::make_pair(0, 0);
  }
}

raw_ostream &operator<<(raw_ostream &OS, Architecture Arch) {
  OS << getArchitectureName(Arch);
  return OS;
}

} // end namespace MachO.
} // end namespace llvm.
