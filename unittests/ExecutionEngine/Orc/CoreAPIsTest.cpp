//===----------- CoreAPIsTest.cpp - Unit tests for Core ORC APIs ----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ExecutionEngine/Orc/Core.h"
#include "OrcTestCommon.h"
#include "gtest/gtest.h"

#include <set>

using namespace llvm;
using namespace llvm::orc;

namespace {

class SimpleSource : public SymbolSource {
public:
  using MaterializeFunction = std::function<Error(VSO&, SymbolNameSet)>;
  using DiscardFunction = std::function<void(VSO&, SymbolStringPtr)>;

  SimpleSource(MaterializeFunction Materialize, DiscardFunction Discard)
    : Materialize(std::move(Materialize)), Discard(std::move(Discard)) {}

  Error materialize(VSO &V, SymbolNameSet Symbols) override {
    return Materialize(V, std::move(Symbols));
  }

  void discard(VSO &V, SymbolStringPtr Name) override {
    Discard(V, std::move(Name));
  }

private:
  MaterializeFunction Materialize;
  DiscardFunction Discard;
};

TEST(CoreAPIsTest, AsynchronousSymbolQuerySuccessfulResolutionOnly) {
  SymbolStringPool SP;
  auto Foo = SP.intern("foo");
  constexpr JITTargetAddress FakeAddr = 0xdeadbeef;
  SymbolNameSet Names({Foo});

  bool OnResolutionRun = false;
  bool OnReadyRun = false;
  auto OnResolution =
    [&](Expected<SymbolMap> Result) {
      EXPECT_TRUE(!!Result) << "Resolution unexpectedly returned error";
      auto I = Result->find(Foo);
      EXPECT_NE(I, Result->end()) << "Could not find symbol definition";
      EXPECT_EQ(cantFail(I->second.getAddress()), FakeAddr)
        << "Resolution returned incorrect result";
      OnResolutionRun = true;
    };
  auto OnReady = 
    [&](Error Err) {
      cantFail(std::move(Err));
      OnResolutionRun = true;
    };

  AsynchronousSymbolQuery Q(Names, OnResolution, OnReady);

  Q.setDefinition(Foo, JITSymbol(FakeAddr, JITSymbolFlags::Exported));

  EXPECT_TRUE(OnResolutionRun) << "OnResolutionCallback was not run";
  EXPECT_FALSE(OnReadyRun) << "OnReady unexpectedly run";
}

TEST(CoreAPIsTest, AsynchronousSymbolQueryResolutionErrorOnly) {
  SymbolStringPool SP;
  auto Foo = SP.intern("foo");
  SymbolNameSet Names({Foo});

  bool OnResolutionRun = false;
  bool OnReadyRun = false;

  auto OnResolution =
    [&](Expected<SymbolMap> Result) {
      EXPECT_FALSE(!!Result) << "Resolution unexpectedly returned success";
      auto Msg = toString(Result.takeError());
      EXPECT_EQ(Msg, "xyz")
        << "Resolution returned incorrect result";
      OnResolutionRun = true;
    };
  auto OnReady =
    [&](Error Err) {
      cantFail(std::move(Err));
      OnReadyRun = true;
    };

  AsynchronousSymbolQuery Q(Names, OnResolution, OnReady);

  Q.setFailed(make_error<StringError>("xyz", inconvertibleErrorCode()));

  EXPECT_TRUE(OnResolutionRun) << "OnResolutionCallback was not run";
  EXPECT_FALSE(OnReadyRun) << "OnReady unexpectedly run";
}

TEST(CoreAPIsTest, SimpleAsynchronousSymbolQueryAgainstVSO) {
  SymbolStringPool SP;
  auto Foo = SP.intern("foo");
  constexpr JITTargetAddress FakeAddr = 0xdeadbeef;
  SymbolNameSet Names({Foo});

  bool OnResolutionRun = false;
  bool OnReadyRun = false;

  auto OnResolution =
    [&](Expected<SymbolMap> Result) {
      EXPECT_TRUE(!!Result) << "Query unexpectedly returned error";
      auto I = Result->find(Foo);
      EXPECT_NE(I, Result->end()) << "Could not find symbol definition";
      EXPECT_EQ(cantFail(I->second.getAddress()), FakeAddr)
        << "Resolution returned incorrect result";
      OnResolutionRun = true;
    };

  auto OnReady =
    [&](Error Err) {
      cantFail(std::move(Err));
      OnReadyRun = true;
    };

  AsynchronousSymbolQuery Q(Names, OnResolution, OnReady);
  VSO V;

  SymbolMap Defs;
  Defs.insert(
    std::make_pair(Foo, JITSymbol(FakeAddr, JITSymbolFlags::Exported)));
  cantFail(V.define(std::move(Defs)));
  V.lookup(Q, Names);

  EXPECT_TRUE(OnResolutionRun) << "OnResolutionCallback was not run";
  EXPECT_TRUE(OnReadyRun) << "OnReady was not run";
}

TEST(CoreAPIsTest, AddAndMaterializeLazySymbol) {

  constexpr JITTargetAddress FakeFooAddr = 0xdeadbeef;
  constexpr JITTargetAddress FakeBarAddr = 0xcafef00d;

  SymbolStringPool SP;
  auto Foo = SP.intern("foo");
  auto Bar = SP.intern("bar");
  
  bool FooMaterialized = false;
  bool BarDiscarded = false;

  VSO V;

  auto Source =
    std::make_shared<SimpleSource>(
      [&](VSO &V, SymbolNameSet Symbols) {
        EXPECT_EQ(Symbols.size(), 1U)
          << "Expected Symbols set size to be 1 ({ Foo })";
        EXPECT_EQ(*Symbols.begin(), Foo)
          << "Expected Symbols == { Foo }";

        SymbolMap SymbolsToResolve;
        SymbolsToResolve.insert(
          std::make_pair(Foo, JITSymbol(FakeFooAddr,
                                        JITSymbolFlags::Exported)));
        V.resolve(std::move(SymbolsToResolve));
        SymbolNameSet SymbolsToFinalize;
        SymbolsToFinalize.insert(Foo);
        V.finalize(SymbolsToFinalize);
        FooMaterialized = true;
        return Error::success();
      },
      [&](VSO &V, SymbolStringPtr Name) {
        EXPECT_EQ(Name, Bar) << "Expected Name to be Bar";
        BarDiscarded = true;
      });

  SymbolFlagsMap InitialSymbols({
      {Foo, JITSymbolFlags::Exported},
      {Bar, static_cast<JITSymbolFlags::FlagNames>(JITSymbolFlags::Exported |
                                                   JITSymbolFlags::Weak)}
    });
  cantFail(V.defineLazy(InitialSymbols, *Source));

  SymbolMap BarOverride;
  BarOverride.insert(
    std::make_pair(Bar, JITSymbol(FakeBarAddr, JITSymbolFlags::Exported)));
  cantFail(V.define(std::move(BarOverride)));

  SymbolNameSet Names({Foo});

  bool OnResolutionRun = false;
  bool OnReadyRun = false;

  auto OnResolution =
    [&](Expected<SymbolMap> Result) {
      EXPECT_TRUE(!!Result) << "Resolution unexpectedly returned error";
      auto I = Result->find(Foo);
      EXPECT_NE(I, Result->end()) << "Could not find symbol definition";
      EXPECT_EQ(cantFail(I->second.getAddress()), FakeFooAddr)
        << "Resolution returned incorrect result";
      OnResolutionRun = true;
    };

  auto OnReady =
    [&](Error Err) {
      cantFail(std::move(Err));
      OnReadyRun = true;
    };

  AsynchronousSymbolQuery Q(Names, OnResolution, OnReady);

  auto LR = V.lookup(Q, Names);

  for (auto &SWKV : LR.MaterializationWork)
    cantFail(SWKV.first->materialize(V, std::move(SWKV.second)));

  EXPECT_TRUE(LR.UnresolvedSymbols.empty()) << "Could not find Foo in dylib";
  EXPECT_TRUE(FooMaterialized) << "Foo was not materialized";
  EXPECT_TRUE(BarDiscarded) << "Bar was not discarded";
  EXPECT_TRUE(OnResolutionRun) << "OnResolutionCallback was not run";
  EXPECT_TRUE(OnReadyRun) << "OnReady was not run";
}

}
