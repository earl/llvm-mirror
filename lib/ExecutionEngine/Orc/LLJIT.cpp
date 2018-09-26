//===--------- LLJIT.cpp - An ORC-based JIT for compiling LLVM IR ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/ExecutionEngine/Orc/OrcError.h"
#include "llvm/ExecutionEngine/SectionMemoryManager.h"
#include "llvm/IR/Mangler.h"

namespace llvm {
namespace orc {

Expected<std::unique_ptr<LLJIT>>
LLJIT::Create(std::unique_ptr<TargetMachine> TM, DataLayout DL) {
  return std::unique_ptr<LLJIT>(new LLJIT(llvm::make_unique<ExecutionSession>(),
                                          std::move(TM), std::move(DL)));
}

Error LLJIT::defineAbsolute(StringRef Name, JITEvaluatedSymbol Sym) {
  auto InternedName = ES->getSymbolStringPool().intern(Name);
  SymbolMap Symbols({{InternedName, Sym}});
  return Main.define(absoluteSymbols(std::move(Symbols)));
}

Error LLJIT::addIRModule(JITDylib &JD, ThreadSafeModule TSM) {
  assert(TSM && "Can not add null module");

  if (auto Err = applyDataLayout(*TSM.getModule()))
    return Err;

  auto K = ES->allocateVModule();
  return CompileLayer.add(JD, K, std::move(TSM));
}

Error LLJIT::addObjectFile(JITDylib &JD, std::unique_ptr<MemoryBuffer> Obj) {
  assert(Obj && "Can not add null object");

  auto K = ES->allocateVModule();
  return ObjLinkingLayer.add(JD, K, std::move(Obj));
}

Expected<JITEvaluatedSymbol> LLJIT::lookupLinkerMangled(JITDylib &JD,
                                                        StringRef Name) {
  return llvm::orc::lookup({&JD}, ES->getSymbolStringPool().intern(Name));
}

LLJIT::LLJIT(std::unique_ptr<ExecutionSession> ES,
             std::unique_ptr<TargetMachine> TM, DataLayout DL)
    : ES(std::move(ES)), Main(this->ES->createJITDylib("main")),
      TM(std::move(TM)), DL(std::move(DL)),
      ObjLinkingLayer(*this->ES,
                      [this](VModuleKey K) { return getMemoryManager(K); }),
      CompileLayer(*this->ES, ObjLinkingLayer, SimpleCompiler(*this->TM)),
      CtorRunner(Main), DtorRunner(Main) {}

std::unique_ptr<RuntimeDyld::MemoryManager>
LLJIT::getMemoryManager(VModuleKey K) {
  return llvm::make_unique<SectionMemoryManager>();
}

std::string LLJIT::mangle(StringRef UnmangledName) {
  std::string MangledName;
  {
    raw_string_ostream MangledNameStream(MangledName);
    Mangler::getNameWithPrefix(MangledNameStream, UnmangledName, DL);
  }
  return MangledName;
}

Error LLJIT::applyDataLayout(Module &M) {
  if (M.getDataLayout().isDefault())
    M.setDataLayout(DL);

  if (M.getDataLayout() != DL)
    return make_error<StringError>(
        "Added modules have incompatible data layouts",
        inconvertibleErrorCode());

  return Error::success();
}

void LLJIT::recordCtorDtors(Module &M) {
  CtorRunner.add(getConstructors(M));
  DtorRunner.add(getDestructors(M));
}

Expected<std::unique_ptr<LLLazyJIT>>
LLLazyJIT::Create(std::unique_ptr<TargetMachine> TM, DataLayout DL) {
  auto ES = llvm::make_unique<ExecutionSession>();

  const Triple &TT = TM->getTargetTriple();

  auto LCTMgr = createLocalLazyCallThroughManager(TT, *ES, 0);
  if (!LCTMgr)
    return LCTMgr.takeError();

  auto ISMBuilder = createLocalIndirectStubsManagerBuilder(TT);
  if (!ISMBuilder)
    return make_error<StringError>(
        std::string("No indirect stubs manager builder for ") + TT.str(),
        inconvertibleErrorCode());

  return std::unique_ptr<LLLazyJIT>(
      new LLLazyJIT(std::move(ES), std::move(TM), std::move(DL),
                    std::move(*LCTMgr), std::move(ISMBuilder)));
}

Error LLLazyJIT::addLazyIRModule(JITDylib &JD, ThreadSafeModule TSM) {
  assert(TSM && "Can not add null module");

  if (auto Err = applyDataLayout(*TSM.getModule()))
    return Err;

  makeAllSymbolsExternallyAccessible(*TSM.getModule());

  recordCtorDtors(*TSM.getModule());

  auto K = ES->allocateVModule();
  return CODLayer.add(JD, K, std::move(TSM));
}

LLLazyJIT::LLLazyJIT(
    std::unique_ptr<ExecutionSession> ES, std::unique_ptr<TargetMachine> TM,
    DataLayout DL, std::unique_ptr<LazyCallThroughManager> LCTMgr,
    std::function<std::unique_ptr<IndirectStubsManager>()> ISMBuilder)
    : LLJIT(std::move(ES), std::move(TM), std::move(DL)),
      LCTMgr(std::move(LCTMgr)), TransformLayer(*this->ES, CompileLayer),
      CODLayer(*this->ES, TransformLayer, *this->LCTMgr,
               std::move(ISMBuilder)) {}

} // End namespace orc.
} // End namespace llvm.
