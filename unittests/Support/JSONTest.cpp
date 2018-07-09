//===-- JSONTest.cpp - JSON unit tests --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/JSON.h"

#include "gmock/gmock.h"
#include "gtest/gtest.h"

namespace llvm {
namespace json {

namespace {

std::string s(const Value &E) { return llvm::formatv("{0}", E).str(); }
std::string sp(const Value &E) { return llvm::formatv("{0:2}", E).str(); }

TEST(JSONTest, Types) {
  EXPECT_EQ("true", s(true));
  EXPECT_EQ("null", s(nullptr));
  EXPECT_EQ("2.5", s(2.5));
  EXPECT_EQ(R"("foo")", s("foo"));
  EXPECT_EQ("[1,2,3]", s({1, 2, 3}));
  EXPECT_EQ(R"({"x":10,"y":20})", s(Object{{"x", 10}, {"y", 20}}));
}

TEST(JSONTest, Constructors) {
  // Lots of edge cases around empty and singleton init lists.
  EXPECT_EQ("[[[3]]]", s({{{3}}}));
  EXPECT_EQ("[[[]]]", s({{{}}}));
  EXPECT_EQ("[[{}]]", s({{Object{}}}));
  EXPECT_EQ(R"({"A":{"B":{}}})", s(Object{{"A", Object{{"B", Object{}}}}}));
  EXPECT_EQ(R"({"A":{"B":{"X":"Y"}}})",
            s(Object{{"A", Object{{"B", Object{{"X", "Y"}}}}}}));
}

TEST(JSONTest, StringOwnership) {
  char X[] = "Hello";
  Value Alias = static_cast<const char *>(X);
  X[1] = 'a';
  EXPECT_EQ(R"("Hallo")", s(Alias));

  std::string Y = "Hello";
  Value Copy = Y;
  Y[1] = 'a';
  EXPECT_EQ(R"("Hello")", s(Copy));
}

TEST(JSONTest, CanonicalOutput) {
  // Objects are sorted (but arrays aren't)!
  EXPECT_EQ(R"({"a":1,"b":2,"c":3})", s(Object{{"a", 1}, {"c", 3}, {"b", 2}}));
  EXPECT_EQ(R"(["a","c","b"])", s({"a", "c", "b"}));
  EXPECT_EQ("3", s(3.0));
}

TEST(JSONTest, Escaping) {
  std::string test = {
      0,                    // Strings may contain nulls.
      '\b',   '\f',         // Have mnemonics, but we escape numerically.
      '\r',   '\n',   '\t', // Escaped with mnemonics.
      'S',    '\"',   '\\', // Printable ASCII characters.
      '\x7f',               // Delete is not escaped.
      '\xce', '\x94',       // Non-ASCII UTF-8 is not escaped.
  };

  std::string teststring = R"("\u0000\u0008\u000c\r\n\tS\"\\)"
                           "\x7f\xCE\x94\"";

  EXPECT_EQ(teststring, s(test));

  EXPECT_EQ(R"({"object keys are\nescaped":true})",
            s(Object{{"object keys are\nescaped", true}}));
}

TEST(JSONTest, PrettyPrinting) {
  const char str[] = R"({
  "empty_array": [],
  "empty_object": {},
  "full_array": [
    1,
    null
  ],
  "full_object": {
    "nested_array": [
      {
        "property": "value"
      }
    ]
  }
})";

  EXPECT_EQ(str, sp(Object{
                     {"empty_object", Object{}},
                     {"empty_array", {}},
                     {"full_array", {1, nullptr}},
                     {"full_object",
                      Object{
                          {"nested_array",
                           {Object{
                               {"property", "value"},
                           }}},
                      }},
                 }));
}

TEST(JSONTest, Parse) {
  auto Compare = [](llvm::StringRef S, Value Expected) {
    if (auto E = parse(S)) {
      // Compare both string forms and with operator==, in case we have bugs.
      EXPECT_EQ(*E, Expected);
      EXPECT_EQ(sp(*E), sp(Expected));
    } else {
      handleAllErrors(E.takeError(), [S](const llvm::ErrorInfoBase &E) {
        FAIL() << "Failed to parse JSON >>> " << S << " <<<: " << E.message();
      });
    }
  };

  Compare(R"(true)", true);
  Compare(R"(false)", false);
  Compare(R"(null)", nullptr);

  Compare(R"(42)", 42);
  Compare(R"(2.5)", 2.5);
  Compare(R"(2e50)", 2e50);
  Compare(R"(1.2e3456789)", std::numeric_limits<double>::infinity());

  Compare(R"("foo")", "foo");
  Compare(R"("\"\\\b\f\n\r\t")", "\"\\\b\f\n\r\t");
  Compare(R"("\u0000")", llvm::StringRef("\0", 1));
  Compare("\"\x7f\"", "\x7f");
  Compare(R"("\ud801\udc37")", u8"\U00010437"); // UTF16 surrogate pair escape.
  Compare("\"\xE2\x82\xAC\xF0\x9D\x84\x9E\"", u8"\u20ac\U0001d11e"); // UTF8
  Compare(
      R"("LoneLeading=\ud801, LoneTrailing=\udc01, LeadingLeadingTrailing=\ud801\ud801\udc37")",
      u8"LoneLeading=\ufffd, LoneTrailing=\ufffd, "
      u8"LeadingLeadingTrailing=\ufffd\U00010437"); // Invalid unicode.

  Compare(R"({"":0,"":0})", Object{{"", 0}});
  Compare(R"({"obj":{},"arr":[]})", Object{{"obj", Object{}}, {"arr", {}}});
  Compare(R"({"\n":{"\u0000":[[[[]]]]}})",
          Object{{"\n", Object{
                            {llvm::StringRef("\0", 1), {{{{}}}}},
                        }}});
  Compare("\r[\n\t] ", {});
}

TEST(JSONTest, ParseErrors) {
  auto ExpectErr = [](llvm::StringRef Msg, llvm::StringRef S) {
    if (auto E = parse(S)) {
      // Compare both string forms and with operator==, in case we have bugs.
      FAIL() << "Parsed JSON >>> " << S << " <<< but wanted error: " << Msg;
    } else {
      handleAllErrors(E.takeError(), [S, Msg](const llvm::ErrorInfoBase &E) {
        EXPECT_THAT(E.message(), testing::HasSubstr(Msg)) << S;
      });
    }
  };
  ExpectErr("Unexpected EOF", "");
  ExpectErr("Unexpected EOF", "[");
  ExpectErr("Text after end of document", "[][]");
  ExpectErr("Invalid JSON value (false?)", "fuzzy");
  ExpectErr("Expected , or ]", "[2?]");
  ExpectErr("Expected object key", "{a:2}");
  ExpectErr("Expected : after object key", R"({"a",2})");
  ExpectErr("Expected , or } after object property", R"({"a":2 "b":3})");
  ExpectErr("Invalid JSON value", R"([&%!])");
  ExpectErr("Invalid JSON value (number?)", "1e1.0");
  ExpectErr("Unterminated string", R"("abc\"def)");
  ExpectErr("Control character in string", "\"abc\ndef\"");
  ExpectErr("Invalid escape sequence", R"("\030")");
  ExpectErr("Invalid \\u escape sequence", R"("\usuck")");
  ExpectErr("[3:3, byte=19]", R"({
  "valid": 1,
  invalid: 2
})");
}

TEST(JSONTest, Inspection) {
  llvm::Expected<Value> Doc = parse(R"(
    {
      "null": null,
      "boolean": false,
      "number": 2.78,
      "string": "json",
      "array": [null, true, 3.14, "hello", [1,2,3], {"time": "arrow"}],
      "object": {"fruit": "banana"}
    }
  )");
  EXPECT_TRUE(!!Doc);

  Object *O = Doc->getAsObject();
  ASSERT_TRUE(O);

  EXPECT_FALSE(O->getNull("missing"));
  EXPECT_FALSE(O->getNull("boolean"));
  EXPECT_TRUE(O->getNull("null"));

  EXPECT_EQ(O->getNumber("number"), llvm::Optional<double>(2.78));
  EXPECT_FALSE(O->getInteger("number"));
  EXPECT_EQ(O->getString("string"), llvm::Optional<llvm::StringRef>("json"));
  ASSERT_FALSE(O->getObject("missing"));
  ASSERT_FALSE(O->getObject("array"));
  ASSERT_TRUE(O->getObject("object"));
  EXPECT_EQ(*O->getObject("object"), (Object{{"fruit", "banana"}}));

  Array *A = O->getArray("array");
  ASSERT_TRUE(A);
  EXPECT_EQ((*A)[1].getAsBoolean(), llvm::Optional<bool>(true));
  ASSERT_TRUE((*A)[4].getAsArray());
  EXPECT_EQ(*(*A)[4].getAsArray(), (Array{1, 2, 3}));
  EXPECT_EQ((*(*A)[4].getAsArray())[1].getAsInteger(),
            llvm::Optional<int64_t>(2));
  int I = 0;
  for (Value &E : *A) {
    if (I++ == 5) {
      ASSERT_TRUE(E.getAsObject());
      EXPECT_EQ(E.getAsObject()->getString("time"),
                llvm::Optional<llvm::StringRef>("arrow"));
    } else
      EXPECT_FALSE(E.getAsObject());
  }
}

// Sample struct with typical JSON-mapping rules.
struct CustomStruct {
  CustomStruct() : B(false) {}
  CustomStruct(std::string S, llvm::Optional<int> I, bool B)
      : S(S), I(I), B(B) {}
  std::string S;
  llvm::Optional<int> I;
  bool B;
};
inline bool operator==(const CustomStruct &L, const CustomStruct &R) {
  return L.S == R.S && L.I == R.I && L.B == R.B;
}
inline llvm::raw_ostream &operator<<(llvm::raw_ostream &OS,
                                     const CustomStruct &S) {
  return OS << "(" << S.S << ", " << (S.I ? std::to_string(*S.I) : "None")
            << ", " << S.B << ")";
}
bool fromJSON(const Value &E, CustomStruct &R) {
  ObjectMapper O(E);
  if (!O || !O.map("str", R.S) || !O.map("int", R.I))
    return false;
  O.map("bool", R.B);
  return true;
}

TEST(JSONTest, Deserialize) {
  std::map<std::string, std::vector<CustomStruct>> R;
  CustomStruct ExpectedStruct = {"foo", 42, true};
  std::map<std::string, std::vector<CustomStruct>> Expected;
  Value J = Object{
      {"foo",
       Array{
           Object{
               {"str", "foo"},
               {"int", 42},
               {"bool", true},
               {"unknown", "ignored"},
           },
           Object{{"str", "bar"}},
           Object{
               {"str", "baz"}, {"bool", "string"}, // OK, deserialize ignores.
           },
       }}};
  Expected["foo"] = {
      CustomStruct("foo", 42, true),
      CustomStruct("bar", llvm::None, false),
      CustomStruct("baz", llvm::None, false),
  };
  ASSERT_TRUE(fromJSON(J, R));
  EXPECT_EQ(R, Expected);

  CustomStruct V;
  EXPECT_FALSE(fromJSON(nullptr, V)) << "Not an object " << V;
  EXPECT_FALSE(fromJSON(Object{}, V)) << "Missing required field " << V;
  EXPECT_FALSE(fromJSON(Object{{"str", 1}}, V)) << "Wrong type " << V;
  // Optional<T> must parse as the correct type if present.
  EXPECT_FALSE(fromJSON(Object{{"str", 1}, {"int", "string"}}, V))
      << "Wrong type for Optional<T> " << V;
}

} // namespace
} // namespace json
} // namespace llvm
