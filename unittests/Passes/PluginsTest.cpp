//===- unittests/Passes/Plugins/PluginsTest.cpp ---------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/Path.h"
#include "llvm/Transforms/Scalar/LoopPassManager.h"
#include "gtest/gtest.h"

#include "TestPlugin.h"

#include <cstdint>

using namespace llvm;

void anchor() {}

static std::string LibPath(const std::string Name = "TestPlugin") {
  const std::vector<testing::internal::string> &Argvs =
      testing::internal::GetArgvs();
  const char *Argv0 = Argvs.size() > 0 ? Argvs[0].c_str() : "PluginsTests";
  void *Ptr = (void *)(intptr_t)anchor;
  std::string Path = sys::fs::getMainExecutable(Argv0, Ptr);
  llvm::SmallString<256> Buf{sys::path::parent_path(Path)};
  sys::path::append(Buf, (Name + ".so").c_str());
  return Buf.str();
}

TEST(PluginsTests, LoadPlugin) {
  auto PluginPath = LibPath();
  ASSERT_NE("", PluginPath);

  Expected<PassPlugin> Plugin = PassPlugin::Load(PluginPath);
  ASSERT_TRUE(!!Plugin) << "Plugin path: " << PluginPath;

  ASSERT_EQ(TEST_PLUGIN_NAME, Plugin->getPluginName());
  ASSERT_EQ(TEST_PLUGIN_VERSION, Plugin->getPluginVersion());

  PassBuilder PB;
  ModulePassManager PM;
  ASSERT_FALSE(PB.parsePassPipeline(PM, "plugin-pass"));

  Plugin->registerPassBuilderCallbacks(PB);
  ASSERT_TRUE(PB.parsePassPipeline(PM, "plugin-pass"));
}
