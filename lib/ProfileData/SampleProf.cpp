//=-- SampleProf.cpp - Sample profiling format support --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains common definitions used in the reading and writing of
// sample profile data.
//
//===----------------------------------------------------------------------===//

#include "llvm/ProfileData/SampleProf.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Compression.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/LEB128.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/raw_ostream.h"
#include <string>
#include <system_error>

using namespace llvm;
using namespace sampleprof;

namespace llvm {
namespace sampleprof {
SampleProfileFormat FunctionSamples::Format;
} // namespace sampleprof
} // namespace llvm

namespace {

// FIXME: This class is only here to support the transition to llvm::Error. It
// will be removed once this transition is complete. Clients should prefer to
// deal with the Error value directly, rather than converting to error_code.
class SampleProfErrorCategoryType : public std::error_category {
  const char *name() const noexcept override { return "llvm.sampleprof"; }

  std::string message(int IE) const override {
    sampleprof_error E = static_cast<sampleprof_error>(IE);
    switch (E) {
    case sampleprof_error::success:
      return "Success";
    case sampleprof_error::bad_magic:
      return "Invalid sample profile data (bad magic)";
    case sampleprof_error::unsupported_version:
      return "Unsupported sample profile format version";
    case sampleprof_error::too_large:
      return "Too much profile data";
    case sampleprof_error::truncated:
      return "Truncated profile data";
    case sampleprof_error::malformed:
      return "Malformed sample profile data";
    case sampleprof_error::unrecognized_format:
      return "Unrecognized sample profile encoding format";
    case sampleprof_error::unsupported_writing_format:
      return "Profile encoding format unsupported for writing operations";
    case sampleprof_error::truncated_name_table:
      return "Truncated function name table";
    case sampleprof_error::not_implemented:
      return "Unimplemented feature";
    case sampleprof_error::counter_overflow:
      return "Counter overflow";
    case sampleprof_error::ostream_seek_unsupported:
      return "Ostream does not support seek";
    case sampleprof_error::compress_failed:
      return "Compress failure";
    case sampleprof_error::uncompress_failed:
      return "Uncompress failure";
    case sampleprof_error::zlib_unavailable:
      return "Zlib is unavailable";
    }
    llvm_unreachable("A value of sampleprof_error has no message.");
  }
};

} // end anonymous namespace

static ManagedStatic<SampleProfErrorCategoryType> ErrorCategory;

const std::error_category &llvm::sampleprof_category() {
  return *ErrorCategory;
}

void LineLocation::print(raw_ostream &OS) const {
  OS << LineOffset;
  if (Discriminator > 0)
    OS << "." << Discriminator;
}

raw_ostream &llvm::sampleprof::operator<<(raw_ostream &OS,
                                          const LineLocation &Loc) {
  Loc.print(OS);
  return OS;
}

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
LLVM_DUMP_METHOD void LineLocation::dump() const { print(dbgs()); }
#endif

/// Print the sample record to the stream \p OS indented by \p Indent.
void SampleRecord::print(raw_ostream &OS, unsigned Indent) const {
  OS << NumSamples;
  if (hasCalls()) {
    OS << ", calls:";
    for (const auto &I : getSortedCallTargets())
      OS << " " << I.first << ":" << I.second;
  }
  OS << "\n";
}

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
LLVM_DUMP_METHOD void SampleRecord::dump() const { print(dbgs(), 0); }
#endif

raw_ostream &llvm::sampleprof::operator<<(raw_ostream &OS,
                                          const SampleRecord &Sample) {
  Sample.print(OS, 0);
  return OS;
}

/// Print the samples collected for a function on stream \p OS.
void FunctionSamples::print(raw_ostream &OS, unsigned Indent) const {
  OS << TotalSamples << ", " << TotalHeadSamples << ", " << BodySamples.size()
     << " sampled lines\n";

  OS.indent(Indent);
  if (!BodySamples.empty()) {
    OS << "Samples collected in the function's body {\n";
    SampleSorter<LineLocation, SampleRecord> SortedBodySamples(BodySamples);
    for (const auto &SI : SortedBodySamples.get()) {
      OS.indent(Indent + 2);
      OS << SI->first << ": " << SI->second;
    }
    OS.indent(Indent);
    OS << "}\n";
  } else {
    OS << "No samples collected in the function's body\n";
  }

  OS.indent(Indent);
  if (!CallsiteSamples.empty()) {
    OS << "Samples collected in inlined callsites {\n";
    SampleSorter<LineLocation, FunctionSamplesMap> SortedCallsiteSamples(
        CallsiteSamples);
    for (const auto &CS : SortedCallsiteSamples.get()) {
      for (const auto &FS : CS->second) {
        OS.indent(Indent + 2);
        OS << CS->first << ": inlined callee: " << FS.second.getName() << ": ";
        FS.second.print(OS, Indent + 4);
      }
    }
    OS << "}\n";
  } else {
    OS << "No inlined callsites in this function\n";
  }
}

raw_ostream &llvm::sampleprof::operator<<(raw_ostream &OS,
                                          const FunctionSamples &FS) {
  FS.print(OS);
  return OS;
}

unsigned FunctionSamples::getOffset(const DILocation *DIL) {
  return (DIL->getLine() - DIL->getScope()->getSubprogram()->getLine()) &
      0xffff;
}

const FunctionSamples *
FunctionSamples::findFunctionSamples(const DILocation *DIL) const {
  assert(DIL);
  SmallVector<std::pair<LineLocation, StringRef>, 10> S;

  const DILocation *PrevDIL = DIL;
  for (DIL = DIL->getInlinedAt(); DIL; DIL = DIL->getInlinedAt()) {
    S.push_back(std::make_pair(
        LineLocation(getOffset(DIL), DIL->getBaseDiscriminator()),
        PrevDIL->getScope()->getSubprogram()->getLinkageName()));
    PrevDIL = DIL;
  }
  if (S.size() == 0)
    return this;
  const FunctionSamples *FS = this;
  for (int i = S.size() - 1; i >= 0 && FS != nullptr; i--) {
    FS = FS->findFunctionSamplesAt(S[i].first, S[i].second);
  }
  return FS;
}

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
LLVM_DUMP_METHOD void FunctionSamples::dump() const { print(dbgs(), 0); }
#endif

std::error_code ProfileSymbolList::read(uint64_t CompressSize,
                                        uint64_t UncompressSize,
                                        const uint8_t *Data) {
  const char *ListStart = reinterpret_cast<const char *>(Data);
  // CompressSize being non-zero means the profile is compressed and
  // needs to be uncompressed first.
  if (CompressSize) {
    if (!llvm::zlib::isAvailable())
      return sampleprof_error::zlib_unavailable;

    StringRef CompressedStrings(reinterpret_cast<const char *>(Data),
                                CompressSize);
    char *Buffer = Allocator.Allocate<char>(UncompressSize);
    llvm::Error E = zlib::uncompress(CompressedStrings, Buffer, UncompressSize);
    if (E)
      return sampleprof_error::uncompress_failed;
    ListStart = Buffer;
  }

  uint64_t Size = 0;
  while (Size < UncompressSize) {
    StringRef Str(ListStart + Size);
    add(Str);
    Size += Str.size() + 1;
  }
  return sampleprof_error::success;
}

std::error_code ProfileSymbolList::write(raw_ostream &OS) {
  // Sort the symbols before doing compression. It will make the
  // compression much more effective.
  std::vector<StringRef> SortedList;
  SortedList.insert(SortedList.begin(), Syms.begin(), Syms.end());
  llvm::sort(SortedList);

  std::string UncompressedStrings;
  for (auto &Sym : SortedList) {
    UncompressedStrings.append(Sym.str());
    UncompressedStrings.append(1, '\0');
  }

  if (ToCompress) {
    if (!llvm::zlib::isAvailable())
      return sampleprof_error::zlib_unavailable;
    SmallString<128> CompressedStrings;
    llvm::Error E = zlib::compress(UncompressedStrings, CompressedStrings,
                                   zlib::BestSizeCompression);
    if (E)
      return sampleprof_error::compress_failed;
    encodeULEB128(UncompressedStrings.size(), OS);
    encodeULEB128(CompressedStrings.size(), OS);
    OS << CompressedStrings.str();
  } else {
    encodeULEB128(UncompressedStrings.size(), OS);
    // If profile symbol list is not compressed, we will still save
    // a compressed size value, but the value of the size is 0.
    encodeULEB128(0, OS);
    OS << UncompressedStrings;
  }
  return sampleprof_error::success;
}

void ProfileSymbolList::dump(raw_ostream &OS) const {
  OS << "======== Dump profile symbol list ========\n";
  std::vector<StringRef> SortedList;
  SortedList.insert(SortedList.begin(), Syms.begin(), Syms.end());
  llvm::sort(SortedList);

  for (auto &Sym : SortedList)
    OS << Sym << "\n";
}
