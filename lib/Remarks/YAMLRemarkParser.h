//===-- YAMLRemarkParser.h - Parser for YAML remarks ------------*- C++/-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides the impementation of the YAML remark parser.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_REMARKS_YAML_REMARK_PARSER_H
#define LLVM_REMARKS_YAML_REMARK_PARSER_H

#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Remarks/Remark.h"
#include "llvm/Remarks/RemarkParser.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/YAMLParser.h"
#include "llvm/Support/YAMLTraits.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

namespace llvm {
namespace remarks {

class YAMLParseError : public ErrorInfo<YAMLParseError> {
public:
  static char ID;

  YAMLParseError(StringRef Message, SourceMgr &SM, yaml::Stream &Stream,
                 yaml::Node &Node);

  YAMLParseError(StringRef Message) : Message(Message) {}

  void log(raw_ostream &OS) const override { OS << Message; }
  std::error_code convertToErrorCode() const override {
    return inconvertibleErrorCode();
  }

private:
  std::string Message;
};

/// Regular YAML to Remark parser.
struct YAMLRemarkParser : public Parser {
  /// The string table used for parsing strings.
  Optional<const ParsedStringTable *> StrTab;
  /// Last error message that can come from the YAML parser diagnostics.
  /// We need this for catching errors in the constructor.
  std::string LastErrorMessage;
  /// Source manager for better error messages.
  SourceMgr SM;
  /// Stream for yaml parsing.
  yaml::Stream Stream;
  /// Iterator in the YAML stream.
  yaml::document_iterator YAMLIt;

  YAMLRemarkParser(StringRef Buf);

  Expected<std::unique_ptr<Remark>> next() override;

  static bool classof(const Parser *P) {
    return P->ParserFormat == Format::YAML;
  }

protected:
  YAMLRemarkParser(StringRef Buf, Optional<const ParsedStringTable *> StrTab);
  /// Create a YAMLParseError error from an existing error generated by the YAML
  /// parser.
  /// If there is no error, this returns Success.
  Error error();
  /// Create a YAMLParseError error referencing a specific node.
  Error error(StringRef Message, yaml::Node &Node);
  /// Parse a YAML remark to a remarks::Remark object.
  Expected<std::unique_ptr<Remark>> parseRemark(yaml::Document &Remark);
  /// Parse the type of a remark to an enum type.
  Expected<Type> parseType(yaml::MappingNode &Node);
  /// Parse one key to a string.
  Expected<StringRef> parseKey(yaml::KeyValueNode &Node);
  /// Parse one value to a string.
  virtual Expected<StringRef> parseStr(yaml::KeyValueNode &Node);
  /// Parse one value to an unsigned.
  Expected<unsigned> parseUnsigned(yaml::KeyValueNode &Node);
  /// Parse a debug location.
  Expected<RemarkLocation> parseDebugLoc(yaml::KeyValueNode &Node);
  /// Parse an argument.
  Expected<Argument> parseArg(yaml::Node &Node);
};

/// YAML with a string table to Remark parser.
struct YAMLStrTabRemarkParser : public YAMLRemarkParser {
  YAMLStrTabRemarkParser(StringRef Buf, const ParsedStringTable &StrTab)
      : YAMLRemarkParser(Buf, &StrTab) {}

  static bool classof(const Parser *P) {
    return P->ParserFormat == Format::YAMLStrTab;
  }

protected:
  /// Parse one value to a string.
  Expected<StringRef> parseStr(yaml::KeyValueNode &Node) override;
};
} // end namespace remarks
} // end namespace llvm

#endif /* LLVM_REMARKS_YAML_REMARK_PARSER_H */
