//===- llvm-objcopy.cpp ---------------------------------------------------===//
//
//                      The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm-objcopy.h"
#include "Object.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/Object/Binary.h"
#include "llvm/Object/ELFObjectFile.h"
#include "llvm/Object/ELFTypes.h"
#include "llvm/Object/Error.h"
#include "llvm/Option/Arg.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Option/Option.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/FileOutputBuffer.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <functional>
#include <iterator>
#include <memory>
#include <string>
#include <system_error>
#include <utility>

using namespace llvm;
using namespace object;
using namespace ELF;

namespace {

enum ObjcopyID {
  OBJCOPY_INVALID = 0, // This is not an option ID.
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  OBJCOPY_##ID,
#include "ObjcopyOpts.inc"
#undef OPTION
};

#define PREFIX(NAME, VALUE) const char *const OBJCOPY_##NAME[] = VALUE;
#include "ObjcopyOpts.inc"
#undef PREFIX

static const opt::OptTable::Info ObjcopyInfoTable[] = {
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  {OBJCOPY_##PREFIX,                                                           \
   NAME,                                                                       \
   HELPTEXT,                                                                   \
   METAVAR,                                                                    \
   OBJCOPY_##ID,                                                               \
   opt::Option::KIND##Class,                                                   \
   PARAM,                                                                      \
   FLAGS,                                                                      \
   OBJCOPY_##GROUP,                                                            \
   OBJCOPY_##ALIAS,                                                            \
   ALIASARGS,                                                                  \
   VALUES},
#include "ObjcopyOpts.inc"
#undef OPTION
};

class ObjcopyOptTable : public opt::OptTable {
public:
  ObjcopyOptTable() : OptTable(ObjcopyInfoTable, true) {}
};

enum StripID {
  STRIP_INVALID = 0, // This is not an option ID.
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  STRIP_##ID,
#include "StripOpts.inc"
#undef OPTION
};

#define PREFIX(NAME, VALUE) const char *const STRIP_##NAME[] = VALUE;
#include "StripOpts.inc"
#undef PREFIX

static const opt::OptTable::Info StripInfoTable[] = {
#define OPTION(PREFIX, NAME, ID, KIND, GROUP, ALIAS, ALIASARGS, FLAGS, PARAM,  \
               HELPTEXT, METAVAR, VALUES)                                      \
  {STRIP_##PREFIX, NAME,       HELPTEXT,                                       \
   METAVAR,        STRIP_##ID, opt::Option::KIND##Class,                       \
   PARAM,          FLAGS,      STRIP_##GROUP,                                  \
   STRIP_##ALIAS,  ALIASARGS,  VALUES},
#include "StripOpts.inc"
#undef OPTION
};

class StripOptTable : public opt::OptTable {
public:
  StripOptTable() : OptTable(StripInfoTable, true) {}
};

} // namespace

// The name this program was invoked as.
static StringRef ToolName;

namespace llvm {

LLVM_ATTRIBUTE_NORETURN void error(Twine Message) {
  errs() << ToolName << ": " << Message << ".\n";
  errs().flush();
  exit(1);
}

LLVM_ATTRIBUTE_NORETURN void reportError(StringRef File, std::error_code EC) {
  assert(EC);
  errs() << ToolName << ": '" << File << "': " << EC.message() << ".\n";
  exit(1);
}

LLVM_ATTRIBUTE_NORETURN void reportError(StringRef File, Error E) {
  assert(E);
  std::string Buf;
  raw_string_ostream OS(Buf);
  logAllUnhandledErrors(std::move(E), OS, "");
  OS.flush();
  errs() << ToolName << ": '" << File << "': " << Buf;
  exit(1);
}

} // end namespace llvm

struct CopyConfig {
  StringRef OutputFilename;
  StringRef InputFilename;
  StringRef OutputFormat;
  StringRef InputFormat;
  StringRef BinaryArch;

  StringRef SplitDWO;
  StringRef AddGnuDebugLink;
  std::vector<StringRef> ToRemove;
  std::vector<StringRef> Keep;
  std::vector<StringRef> OnlyKeep;
  std::vector<StringRef> AddSection;
  std::vector<StringRef> SymbolsToLocalize;
  std::vector<StringRef> SymbolsToGlobalize;
  std::vector<StringRef> SymbolsToWeaken;
  std::vector<StringRef> SymbolsToRemove;
  std::vector<StringRef> SymbolsToKeep;
  StringMap<StringRef> SymbolsToRename;
  bool StripAll = false;
  bool StripAllGNU = false;
  bool StripDebug = false;
  bool StripSections = false;
  bool StripNonAlloc = false;
  bool StripDWO = false;
  bool StripUnneeded = false;
  bool ExtractDWO = false;
  bool LocalizeHidden = false;
  bool Weaken = false;
  bool DiscardAll = false;
  bool OnlyKeepDebug = false;
  bool KeepFileSymbols = false;
};

using SectionPred = std::function<bool(const SectionBase &Sec)>;

bool IsDWOSection(const SectionBase &Sec) { return Sec.Name.endswith(".dwo"); }

bool OnlyKeepDWOPred(const Object &Obj, const SectionBase &Sec) {
  // We can't remove the section header string table.
  if (&Sec == Obj.SectionNames)
    return false;
  // Short of keeping the string table we want to keep everything that is a DWO
  // section and remove everything else.
  return !IsDWOSection(Sec);
}

std::unique_ptr<Writer> CreateWriter(const CopyConfig &Config, Object &Obj,
                                     StringRef File, ElfType OutputElfType) {
  if (Config.OutputFormat == "binary") {
    return llvm::make_unique<BinaryWriter>(File, Obj);
  }
  // Depending on the initial ELFT and OutputFormat we need a different Writer.
  switch (OutputElfType) {
  case ELFT_ELF32LE:
    return llvm::make_unique<ELFWriter<ELF32LE>>(File, Obj,
                                                 !Config.StripSections);
  case ELFT_ELF64LE:
    return llvm::make_unique<ELFWriter<ELF64LE>>(File, Obj,
                                                 !Config.StripSections);
  case ELFT_ELF32BE:
    return llvm::make_unique<ELFWriter<ELF32BE>>(File, Obj,
                                                 !Config.StripSections);
  case ELFT_ELF64BE:
    return llvm::make_unique<ELFWriter<ELF64BE>>(File, Obj,
                                                 !Config.StripSections);
  }
  llvm_unreachable("Invalid output format");
}

void SplitDWOToFile(const CopyConfig &Config, const Reader &Reader,
                    StringRef File, ElfType OutputElfType) {
  auto DWOFile = Reader.create();
  DWOFile->removeSections(
      [&](const SectionBase &Sec) { return OnlyKeepDWOPred(*DWOFile, Sec); });
  auto Writer = CreateWriter(Config, *DWOFile, File, OutputElfType);
  Writer->finalize();
  Writer->write();
}

// This function handles the high level operations of GNU objcopy including
// handling command line options. It's important to outline certain properties
// we expect to hold of the command line operations. Any operation that "keeps"
// should keep regardless of a remove. Additionally any removal should respect
// any previous removals. Lastly whether or not something is removed shouldn't
// depend a) on the order the options occur in or b) on some opaque priority
// system. The only priority is that keeps/copies overrule removes.
void HandleArgs(const CopyConfig &Config, Object &Obj, const Reader &Reader,
                ElfType OutputElfType) {

  if (!Config.SplitDWO.empty()) {
    SplitDWOToFile(Config, Reader, Config.SplitDWO, OutputElfType);
  }

  // TODO: update or remove symbols only if there is an option that affects
  // them.
  if (Obj.SymbolTable) {
    Obj.SymbolTable->updateSymbols([&](Symbol &Sym) {
      if ((Config.LocalizeHidden &&
           (Sym.Visibility == STV_HIDDEN || Sym.Visibility == STV_INTERNAL)) ||
          (!Config.SymbolsToLocalize.empty() &&
           is_contained(Config.SymbolsToLocalize, Sym.Name)))
        Sym.Binding = STB_LOCAL;

      if (!Config.SymbolsToGlobalize.empty() &&
          is_contained(Config.SymbolsToGlobalize, Sym.Name))
        Sym.Binding = STB_GLOBAL;

      if (!Config.SymbolsToWeaken.empty() &&
          is_contained(Config.SymbolsToWeaken, Sym.Name) &&
          Sym.Binding == STB_GLOBAL)
        Sym.Binding = STB_WEAK;

      if (Config.Weaken && Sym.Binding == STB_GLOBAL &&
          Sym.getShndx() != SHN_UNDEF)
        Sym.Binding = STB_WEAK;

      const auto I = Config.SymbolsToRename.find(Sym.Name);
      if (I != Config.SymbolsToRename.end())
        Sym.Name = I->getValue();
    });

    // The purpose of this loop is to mark symbols referenced by sections
    // (like GroupSection or RelocationSection). This way, we know which
    // symbols are still 'needed' and wich are not.
    if (Config.StripUnneeded) {
      for (auto &Section : Obj.sections())
        Section.markSymbols();
    }

    Obj.removeSymbols([&](const Symbol &Sym) {
      if ((!Config.SymbolsToKeep.empty() &&
           is_contained(Config.SymbolsToKeep, Sym.Name)) ||
          (Config.KeepFileSymbols && Sym.Type == STT_FILE))
        return false;

      if (Config.DiscardAll && Sym.Binding == STB_LOCAL &&
          Sym.getShndx() != SHN_UNDEF && Sym.Type != STT_FILE &&
          Sym.Type != STT_SECTION)
        return true;

      if (Config.StripAll || Config.StripAllGNU)
        return true;

      if (!Config.SymbolsToRemove.empty() &&
          is_contained(Config.SymbolsToRemove, Sym.Name)) {
        return true;
      }

      if (Config.StripUnneeded && !Sym.Referenced &&
          (Sym.Binding == STB_LOCAL || Sym.getShndx() == SHN_UNDEF) &&
          Sym.Type != STT_FILE && Sym.Type != STT_SECTION)
        return true;

      return false;
    });
  }

  SectionPred RemovePred = [](const SectionBase &) { return false; };

  // Removes:
  if (!Config.ToRemove.empty()) {
    RemovePred = [&Config](const SectionBase &Sec) {
      return std::find(std::begin(Config.ToRemove), std::end(Config.ToRemove),
                       Sec.Name) != std::end(Config.ToRemove);
    };
  }

  if (Config.StripDWO || !Config.SplitDWO.empty())
    RemovePred = [RemovePred](const SectionBase &Sec) {
      return IsDWOSection(Sec) || RemovePred(Sec);
    };

  if (Config.ExtractDWO)
    RemovePred = [RemovePred, &Obj](const SectionBase &Sec) {
      return OnlyKeepDWOPred(Obj, Sec) || RemovePred(Sec);
    };

  if (Config.StripAllGNU)
    RemovePred = [RemovePred, &Obj](const SectionBase &Sec) {
      if (RemovePred(Sec))
        return true;
      if ((Sec.Flags & SHF_ALLOC) != 0)
        return false;
      if (&Sec == Obj.SectionNames)
        return false;
      switch (Sec.Type) {
      case SHT_SYMTAB:
      case SHT_REL:
      case SHT_RELA:
      case SHT_STRTAB:
        return true;
      }
      return Sec.Name.startswith(".debug");
    };

  if (Config.StripSections) {
    RemovePred = [RemovePred](const SectionBase &Sec) {
      return RemovePred(Sec) || (Sec.Flags & SHF_ALLOC) == 0;
    };
  }

  if (Config.StripDebug) {
    RemovePred = [RemovePred](const SectionBase &Sec) {
      return RemovePred(Sec) || Sec.Name.startswith(".debug");
    };
  }

  if (Config.StripNonAlloc)
    RemovePred = [RemovePred, &Obj](const SectionBase &Sec) {
      if (RemovePred(Sec))
        return true;
      if (&Sec == Obj.SectionNames)
        return false;
      return (Sec.Flags & SHF_ALLOC) == 0;
    };

  if (Config.StripAll)
    RemovePred = [RemovePred, &Obj](const SectionBase &Sec) {
      if (RemovePred(Sec))
        return true;
      if (&Sec == Obj.SectionNames)
        return false;
      if (Sec.Name.startswith(".gnu.warning"))
        return false;
      return (Sec.Flags & SHF_ALLOC) == 0;
    };

  // Explicit copies:
  if (!Config.OnlyKeep.empty()) {
    RemovePred = [&Config, RemovePred, &Obj](const SectionBase &Sec) {
      // Explicitly keep these sections regardless of previous removes.
      if (std::find(std::begin(Config.OnlyKeep), std::end(Config.OnlyKeep),
                    Sec.Name) != std::end(Config.OnlyKeep))
        return false;

      // Allow all implicit removes.
      if (RemovePred(Sec))
        return true;

      // Keep special sections.
      if (Obj.SectionNames == &Sec)
        return false;
      if (Obj.SymbolTable == &Sec || Obj.SymbolTable->getStrTab() == &Sec)
        return false;

      // Remove everything else.
      return true;
    };
  }

  if (!Config.Keep.empty()) {
    RemovePred = [Config, RemovePred](const SectionBase &Sec) {
      // Explicitly keep these sections regardless of previous removes.
      if (std::find(std::begin(Config.Keep), std::end(Config.Keep), Sec.Name) !=
          std::end(Config.Keep))
        return false;
      // Otherwise defer to RemovePred.
      return RemovePred(Sec);
    };
  }

  // This has to be the last predicate assignment.
  // If the option --keep-symbol has been specified
  // and at least one of those symbols is present
  // (equivalently, the updated symbol table is not empty)
  // the symbol table and the string table should not be removed.
  if ((!Config.SymbolsToKeep.empty() || Config.KeepFileSymbols) &&
      !Obj.SymbolTable->empty()) {
    RemovePred = [&Obj, RemovePred](const SectionBase &Sec) {
      if (&Sec == Obj.SymbolTable || &Sec == Obj.SymbolTable->getStrTab())
        return false;
      return RemovePred(Sec);
    };
  }

  Obj.removeSections(RemovePred);

  if (!Config.AddSection.empty()) {
    for (const auto &Flag : Config.AddSection) {
      auto SecPair = Flag.split("=");
      auto SecName = SecPair.first;
      auto File = SecPair.second;
      auto BufOrErr = MemoryBuffer::getFile(File);
      if (!BufOrErr)
        reportError(File, BufOrErr.getError());
      auto Buf = std::move(*BufOrErr);
      auto BufPtr = reinterpret_cast<const uint8_t *>(Buf->getBufferStart());
      auto BufSize = Buf->getBufferSize();
      Obj.addSection<OwnedDataSection>(SecName,
                                       ArrayRef<uint8_t>(BufPtr, BufSize));
    }
  }

  if (!Config.AddGnuDebugLink.empty())
    Obj.addSection<GnuDebugLinkSection>(Config.AddGnuDebugLink);
}

std::unique_ptr<Reader> CreateReader(StringRef InputFilename,
                                     ElfType &OutputElfType) {
  // Right now we can only read ELF files so there's only one reader;
  auto Out = llvm::make_unique<ELFReader>(InputFilename);
  // We need to set the default ElfType for output.
  OutputElfType = Out->getElfType();
  return std::move(Out);
}

void ExecuteElfObjcopy(const CopyConfig &Config) {
  ElfType OutputElfType;
  auto Reader = CreateReader(Config.InputFilename, OutputElfType);
  auto Obj = Reader->create();
  auto Writer =
      CreateWriter(Config, *Obj, Config.OutputFilename, OutputElfType);
  HandleArgs(Config, *Obj, *Reader, OutputElfType);
  Writer->finalize();
  Writer->write();
}

// ParseObjcopyOptions returns the config and sets the input arguments. If a
// help flag is set then ParseObjcopyOptions will print the help messege and
// exit.
CopyConfig ParseObjcopyOptions(ArrayRef<const char *> ArgsArr) {
  ObjcopyOptTable T;
  unsigned MissingArgumentIndex, MissingArgumentCount;
  llvm::opt::InputArgList InputArgs =
      T.ParseArgs(ArgsArr, MissingArgumentIndex, MissingArgumentCount);

  if (InputArgs.size() == 0) {
    T.PrintHelp(errs(), "llvm-objcopy <input> [ <output> ]", "objcopy tool");
    exit(1);
  }

  if (InputArgs.hasArg(OBJCOPY_help)) {
    T.PrintHelp(outs(), "llvm-objcopy <input> [ <output> ]", "objcopy tool");
    exit(0);
  }

  SmallVector<const char *, 2> Positional;

  for (auto Arg : InputArgs.filtered(OBJCOPY_UNKNOWN))
    error("unknown argument '" + Arg->getAsString(InputArgs) + "'");

  for (auto Arg : InputArgs.filtered(OBJCOPY_INPUT))
    Positional.push_back(Arg->getValue());

  if (Positional.empty())
    error("No input file specified");

  if (Positional.size() > 2)
    error("Too many positional arguments");

  CopyConfig Config;
  Config.InputFilename = Positional[0];
  Config.OutputFilename = Positional[Positional.size() == 1 ? 0 : 1];
  Config.InputFormat = InputArgs.getLastArgValue(OBJCOPY_input_target);
  Config.OutputFormat = InputArgs.getLastArgValue(OBJCOPY_output_target);
  Config.BinaryArch = InputArgs.getLastArgValue(OBJCOPY_binary_architecture);

  Config.SplitDWO = InputArgs.getLastArgValue(OBJCOPY_split_dwo);
  Config.AddGnuDebugLink = InputArgs.getLastArgValue(OBJCOPY_add_gnu_debuglink);

  for (auto Arg : InputArgs.filtered(OBJCOPY_redefine_symbol)) {
    if (!StringRef(Arg->getValue()).contains('='))
      error("Bad format for --redefine-sym");
    auto Old2New = StringRef(Arg->getValue()).split('=');
    if (!Config.SymbolsToRename.insert(Old2New).second)
      error("Multiple redefinition of symbol " + Old2New.first);
  }

  for (auto Arg : InputArgs.filtered(OBJCOPY_remove_section))
    Config.ToRemove.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_keep))
    Config.Keep.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_only_keep))
    Config.OnlyKeep.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_add_section))
    Config.AddSection.push_back(Arg->getValue());
  Config.StripAll = InputArgs.hasArg(OBJCOPY_strip_all);
  Config.StripAllGNU = InputArgs.hasArg(OBJCOPY_strip_all_gnu);
  Config.StripDebug = InputArgs.hasArg(OBJCOPY_strip_debug);
  Config.StripDWO = InputArgs.hasArg(OBJCOPY_strip_dwo);
  Config.StripSections = InputArgs.hasArg(OBJCOPY_strip_sections);
  Config.StripNonAlloc = InputArgs.hasArg(OBJCOPY_strip_non_alloc);
  Config.StripUnneeded = InputArgs.hasArg(OBJCOPY_strip_unneeded);
  Config.ExtractDWO = InputArgs.hasArg(OBJCOPY_extract_dwo);
  Config.LocalizeHidden = InputArgs.hasArg(OBJCOPY_localize_hidden);
  Config.Weaken = InputArgs.hasArg(OBJCOPY_weaken);
  Config.DiscardAll = InputArgs.hasArg(OBJCOPY_discard_all);
  Config.OnlyKeepDebug = InputArgs.hasArg(OBJCOPY_only_keep_debug);
  Config.KeepFileSymbols = InputArgs.hasArg(OBJCOPY_keep_file_symbols);
  for (auto Arg : InputArgs.filtered(OBJCOPY_localize_symbol))
    Config.SymbolsToLocalize.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_globalize_symbol))
    Config.SymbolsToGlobalize.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_weaken_symbol))
    Config.SymbolsToWeaken.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_strip_symbol))
    Config.SymbolsToRemove.push_back(Arg->getValue());
  for (auto Arg : InputArgs.filtered(OBJCOPY_keep_symbol))
    Config.SymbolsToKeep.push_back(Arg->getValue());

  return Config;
}

// ParseStripOptions returns the config and sets the input arguments. If a
// help flag is set then ParseStripOptions will print the help messege and
// exit.
CopyConfig ParseStripOptions(ArrayRef<const char *> ArgsArr) {
  StripOptTable T;
  unsigned MissingArgumentIndex, MissingArgumentCount;
  llvm::opt::InputArgList InputArgs =
      T.ParseArgs(ArgsArr, MissingArgumentIndex, MissingArgumentCount);

  if (InputArgs.size() == 0) {
    T.PrintHelp(errs(), "llvm-strip <input> [ <output> ]", "strip tool");
    exit(1);
  }

  if (InputArgs.hasArg(STRIP_help)) {
    T.PrintHelp(outs(), "llvm-strip <input> [ <output> ]", "strip tool");
    exit(0);
  }

  SmallVector<const char *, 2> Positional;
  for (auto Arg : InputArgs.filtered(STRIP_UNKNOWN))
    error("unknown argument '" + Arg->getAsString(InputArgs) + "'");
  for (auto Arg : InputArgs.filtered(STRIP_INPUT))
    Positional.push_back(Arg->getValue());

  if (Positional.empty())
    error("No input file specified");

  if (Positional.size() > 2)
    error("Support for multiple input files is not implemented yet");

  CopyConfig Config;
  Config.InputFilename = Positional[0];
  Config.OutputFilename =
      InputArgs.getLastArgValue(STRIP_output, Positional[0]);

  // Strip debug info only.
  Config.StripDebug = InputArgs.hasArg(STRIP_strip_debug);
  if (!Config.StripDebug)
    Config.StripAll = true;

  for (auto Arg : InputArgs.filtered(STRIP_remove_section))
    Config.ToRemove.push_back(Arg->getValue());

  for (auto Arg : InputArgs.filtered(STRIP_keep_symbol))
    Config.SymbolsToKeep.push_back(Arg->getValue());

  return Config;
}

int main(int argc, char **argv) {
  InitLLVM X(argc, argv);
  ToolName = argv[0];
  CopyConfig Config;
  if (sys::path::stem(ToolName).endswith_lower("strip"))
    Config = ParseStripOptions(makeArrayRef(argv + 1, argc));
  else
    Config = ParseObjcopyOptions(makeArrayRef(argv + 1, argc));
  ExecuteElfObjcopy(Config);
}
