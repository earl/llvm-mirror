//===- llvm/unittest/XRay/FDRRecordPrinterTest.cpp --------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
#include "llvm/Support/raw_ostream.h"
#include "llvm/XRay/FDRRecords.h"
#include "llvm/XRay/RecordPrinter.h"
#include "gmock/gmock.h"
#include "gtest/gtest.h"
#include <string>

namespace llvm {
namespace xray {
namespace {

using ::testing::Eq;

template <class RecordType> struct Helper {};

template <> struct Helper<BufferExtents> {
  static std::unique_ptr<Record> construct() {
    return make_unique<BufferExtents>(1);
  }

  static constexpr char Expected[] = "<Buffer: size = 1 bytes>";
};
const char Helper<BufferExtents>::Expected[];

template <> struct Helper<WallclockRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<WallclockRecord>(1, 2);
  }

  static constexpr char Expected[] = "<Wall Time: seconds = 1.000002>";
};
const char Helper<WallclockRecord>::Expected[];

template <> struct Helper<NewCPUIDRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<NewCPUIDRecord>(1);
  }

  static constexpr char Expected[] = "<CPU ID: 1>";
};
const char Helper<NewCPUIDRecord>::Expected[];

template <> struct Helper<TSCWrapRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<TSCWrapRecord>(1);
  }

  static constexpr char Expected[] = "<TSC Wrap: base = 1>";
};
const char Helper<TSCWrapRecord>::Expected[];

template <> struct Helper<CustomEventRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<CustomEventRecord>(4, 1, "data");
  }

  static constexpr char Expected[] =
      "<Custom Event: tsc = 1, size = 4, data = 'data'>";
};
const char Helper<CustomEventRecord>::Expected[];

template <> struct Helper<CallArgRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<CallArgRecord>(1);
  }

  static constexpr char Expected[] = "<Call Argument: data = 1 (hex = 0x1)>";
};
const char Helper<CallArgRecord>::Expected[];

template <> struct Helper<PIDRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<PIDRecord>(1);
  }

  static constexpr char Expected[] = "<PID: 1>";
};
const char Helper<PIDRecord>::Expected[];

template <> struct Helper<NewBufferRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<NewBufferRecord>(1);
  }

  static constexpr char Expected[] = "<Thread ID: 1>";
};
const char Helper<NewBufferRecord>::Expected[];

template <> struct Helper<EndBufferRecord> {
  static std::unique_ptr<Record> construct() {
    return make_unique<EndBufferRecord>();
  }

  static constexpr char Expected[] = "<End of Buffer>";
};
const char Helper<EndBufferRecord>::Expected[];

template <class T> class PrinterTest : public ::testing::Test {
protected:
  std::string Data;
  raw_string_ostream OS;
  RecordPrinter P;
  std::unique_ptr<Record> R;

public:
  PrinterTest() : Data(), OS(Data), P(OS), R(Helper<T>::construct()) {}
};

TYPED_TEST_CASE_P(PrinterTest);

TYPED_TEST_P(PrinterTest, PrintsRecord) {
  ASSERT_NE(nullptr, this->R);
  ASSERT_FALSE(errorToBool(this->R->apply(this->P)));
  this->OS.flush();
  EXPECT_THAT(this->Data, Eq(Helper<TypeParam>::Expected));
}

REGISTER_TYPED_TEST_CASE_P(PrinterTest, PrintsRecord);
using FDRRecordTypes =
    ::testing::Types<BufferExtents, NewBufferRecord, EndBufferRecord,
                     NewCPUIDRecord, TSCWrapRecord, WallclockRecord,
                     CustomEventRecord, CallArgRecord, BufferExtents,
                     PIDRecord>;
INSTANTIATE_TYPED_TEST_CASE_P(Records, PrinterTest, FDRRecordTypes);

TEST(FDRRecordPrinterTest, WriteFunctionRecordEnter) {
  std::string Data;
  raw_string_ostream OS(Data);
  RecordPrinter P(OS);
  FunctionRecord R(RecordTypes::ENTER, 1, 2);
  ASSERT_FALSE(errorToBool(R.apply(P)));
  OS.flush();
  EXPECT_THAT(Data, Eq("<Function Enter: #1 delta = +1>"));
}

TEST(FDRRecordPrinterTest, WriteFunctionRecordExit) {
  std::string Data;
  raw_string_ostream OS(Data);
  RecordPrinter P(OS);
  FunctionRecord R(RecordTypes::EXIT, 1, 2);
  ASSERT_FALSE(errorToBool(R.apply(P)));
  OS.flush();
  EXPECT_THAT(Data, Eq("<Function Exit: #1 delta = +1>"));
}

TEST(FDRRecordPrinterTest, WriteFunctionRecordTailExit) {
  std::string Data;
  raw_string_ostream OS(Data);
  RecordPrinter P(OS);
  FunctionRecord R(RecordTypes::TAIL_EXIT, 1, 2);
  ASSERT_FALSE(errorToBool(R.apply(P)));
  OS.flush();
  EXPECT_THAT(Data, Eq("<Function Tail Exit: #1 delta = +1>"));
}

TEST(FDRRecordPrinterTest, WriteFunctionRecordEnterArg) {
  std::string Data;
  raw_string_ostream OS(Data);
  RecordPrinter P(OS);
  FunctionRecord R(RecordTypes::ENTER_ARG, 1, 2);
  ASSERT_FALSE(errorToBool(R.apply(P)));
  OS.flush();
  EXPECT_THAT(Data, Eq("<Function Enter With Arg: #1 delta = +1>"));
}

} // namespace
} // namespace xray
} // namespace llvm
