//===--- Legacy.h -- Adapters for ExecutionEngine API interop ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Contains core ORC APIs.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_EXECUTIONENGINE_ORC_LEGACY_H
#define LLVM_EXECUTIONENGINE_ORC_LEGACY_H

#include "llvm/ExecutionEngine/JITSymbol.h"
#include "llvm/ExecutionEngine/Orc/Core.h"

namespace llvm {
namespace orc {

class JITSymbolResolverAdapter : public JITSymbolResolver {
public:
  JITSymbolResolverAdapter(ExecutionSession &ES, SymbolResolver &R);
  Expected<LookupResult> lookup(const LookupSet &Symbols) override;
  Expected<LookupFlagsResult> lookupFlags(const LookupSet &Symbols) override;

private:
  ExecutionSession &ES;
  std::set<SymbolStringPtr> ResolvedStrings;
  SymbolResolver &R;
};

/// @brief Use the given legacy-style FindSymbol function (i.e. a function that
///        takes a const std::string& or StringRef and returns a JITSymbol) to
///        find the flags for each symbol in Symbols and store their flags in
///        FlagsMap. If any JITSymbol returned by FindSymbol is in an error
///        state the function returns immediately with that error, otherwise it
///        returns the set of symbols not found.
///
/// Useful for implementing lookupFlags bodies that query legacy resolvers.
template <typename FindSymbolFn>
Expected<LookupFlagsResult>
lookupFlagsWithLegacyFn(const SymbolNameSet &Symbols, FindSymbolFn FindSymbol) {
  SymbolFlagsMap SymbolFlags;
  SymbolNameSet SymbolsNotFound;

  for (auto &S : Symbols) {
    if (JITSymbol Sym = FindSymbol(*S))
      SymbolFlags[S] = Sym.getFlags();
    else if (auto Err = Sym.takeError())
      return std::move(Err);
    else
      SymbolsNotFound.insert(S);
  }

  return LookupFlagsResult{std::move(SymbolFlags), std::move(SymbolsNotFound)};
}

/// @brief Use the given legacy-style FindSymbol function (i.e. a function that
///        takes a const std::string& or StringRef and returns a JITSymbol) to
///        find the address and flags for each symbol in Symbols and store the
///        result in Query. If any JITSymbol returned by FindSymbol is in an
///        error then Query.setFailed(...) is called with that error and the
///        function returns immediately. On success, returns the set of symbols
///         not found.
///
/// Useful for implementing lookup bodies that query legacy resolvers.
template <typename FindSymbolFn>
SymbolNameSet lookupWithLegacyFn(AsynchronousSymbolQuery &Query,
                                 const SymbolNameSet &Symbols,
                                 FindSymbolFn FindSymbol) {
  SymbolNameSet SymbolsNotFound;

  for (auto &S : Symbols) {
    if (JITSymbol Sym = FindSymbol(*S)) {
      if (auto Addr = Sym.getAddress()) {
        Query.setDefinition(S, JITEvaluatedSymbol(*Addr, Sym.getFlags()));
        Query.notifySymbolFinalized();
      } else {
        Query.setFailed(Addr.takeError());
        return {};
      }
    } else if (auto Err = Sym.takeError()) {
      Query.setFailed(std::move(Err));
      return {};
    } else
      SymbolsNotFound.insert(S);
  }

  return SymbolsNotFound;
}

} // End namespace orc
} // End namespace llvm

#endif // LLVM_EXECUTIONENGINE_ORC_LEGACY_H
