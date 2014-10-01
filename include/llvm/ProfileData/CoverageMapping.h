//=-- CoverageMapping.h - Code coverage mapping support ---------*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Code coverage mapping data is generated by clang and read by
// llvm-cov to show code coverage statistics for a file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_PROFILEDATA_COVERAGEMAPPING_H_
#define LLVM_PROFILEDATA_COVERAGEMAPPING_H_

#include "llvm/ADT/ArrayRef.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/raw_ostream.h"
#include <system_error>

namespace llvm {
class IndexedInstrProfReader;
namespace coverage {

class ObjectFileCoverageMappingReader;

class CoverageMapping;
struct CounterExpressions;

enum CoverageMappingVersion { CoverageMappingVersion1 };

/// \brief A Counter is an abstract value that describes how to compute the
/// execution count for a region of code using the collected profile count data.
struct Counter {
  enum CounterKind { Zero, CounterValueReference, Expression };
  static const unsigned EncodingTagBits = 2;
  static const unsigned EncodingTagMask = 0x3;
  static const unsigned EncodingCounterTagAndExpansionRegionTagBits =
      EncodingTagBits + 1;

private:
  CounterKind Kind;
  unsigned ID;

  Counter(CounterKind Kind, unsigned ID) : Kind(Kind), ID(ID) {}

public:
  Counter() : Kind(Zero), ID(0) {}

  CounterKind getKind() const { return Kind; }

  bool isZero() const { return Kind == Zero; }

  bool isExpression() const { return Kind == Expression; }

  unsigned getCounterID() const { return ID; }

  unsigned getExpressionID() const { return ID; }

  bool operator==(const Counter &Other) const {
    return Kind == Other.Kind && ID == Other.ID;
  }

  friend bool operator<(const Counter &LHS, const Counter &RHS) {
    return std::tie(LHS.Kind, LHS.ID) < std::tie(RHS.Kind, RHS.ID);
  }

  /// \brief Return the counter that represents the number zero.
  static Counter getZero() { return Counter(); }

  /// \brief Return the counter that corresponds to a specific profile counter.
  static Counter getCounter(unsigned CounterId) {
    return Counter(CounterValueReference, CounterId);
  }

  /// \brief Return the counter that corresponds to a specific
  /// addition counter expression.
  static Counter getExpression(unsigned ExpressionId) {
    return Counter(Expression, ExpressionId);
  }
};

/// \brief A Counter expression is a value that represents an arithmetic
/// operation with two counters.
struct CounterExpression {
  enum ExprKind { Subtract, Add };
  ExprKind Kind;
  Counter LHS, RHS;

  CounterExpression(ExprKind Kind, Counter LHS, Counter RHS)
      : Kind(Kind), LHS(LHS), RHS(RHS) {}

  bool operator==(const CounterExpression &Other) const {
    return Kind == Other.Kind && LHS == Other.LHS && RHS == Other.RHS;
  }
};

/// \brief A Counter expression builder is used to construct the
/// counter expressions. It avoids unecessary duplication
/// and simplifies algebraic expressions.
class CounterExpressionBuilder {
  /// \brief A list of all the counter expressions
  llvm::SmallVector<CounterExpression, 16> Expressions;
  /// \brief An array of terms used in expression simplification.
  llvm::SmallVector<int, 16> Terms;

  /// \brief Return the counter which corresponds to the given expression.
  ///
  /// If the given expression is already stored in the builder, a counter
  /// that references that expression is returned. Otherwise, the given
  /// expression is added to the builder's collection of expressions.
  Counter get(const CounterExpression &E);

  /// \brief Convert the expression tree represented by a counter
  /// into a polynomial in the form of K1Counter1 + .. + KNCounterN
  /// where K1 .. KN are integer constants that are stored in the Terms array.
  void extractTerms(Counter C, int Sign = 1);

  /// \brief Simplifies the given expression tree
  /// by getting rid of algebraically redundant operations.
  Counter simplify(Counter ExpressionTree);

public:
  CounterExpressionBuilder(unsigned NumCounterValues);

  ArrayRef<CounterExpression> getExpressions() const { return Expressions; }

  /// \brief Return a counter that represents the expression
  /// that adds LHS and RHS.
  Counter add(Counter LHS, Counter RHS);

  /// \brief Return a counter that represents the expression
  /// that subtracts RHS from LHS.
  Counter subtract(Counter LHS, Counter RHS);
};

/// \brief A Counter mapping region associates a source range with
/// a specific counter.
struct CounterMappingRegion {
  enum RegionKind {
    /// \brief A CodeRegion associates some code with a counter
    CodeRegion,

    /// \brief An ExpansionRegion represents a file expansion region that
    /// associates a source range with the expansion of a virtual source file,
    /// such as for a macro instantiation or #include file.
    ExpansionRegion,

    /// \brief A SkippedRegion represents a source range with code that
    /// was skipped by a preprocessor or similar means.
    SkippedRegion
  };

  static const unsigned EncodingHasCodeBeforeBits = 1;

  Counter Count;
  unsigned FileID, ExpandedFileID;
  unsigned LineStart, ColumnStart, LineEnd, ColumnEnd;
  RegionKind Kind;
  /// \brief A flag that is set to true when there is already code before
  /// this region on the same line.
  /// This is useful to accurately compute the execution counts for a line.
  bool HasCodeBefore;

  CounterMappingRegion(Counter Count, unsigned FileID, unsigned LineStart,
                       unsigned ColumnStart, unsigned LineEnd,
                       unsigned ColumnEnd, bool HasCodeBefore = false,
                       RegionKind Kind = CodeRegion)
      : Count(Count), FileID(FileID), ExpandedFileID(0), LineStart(LineStart),
        ColumnStart(ColumnStart), LineEnd(LineEnd), ColumnEnd(ColumnEnd),
        Kind(Kind), HasCodeBefore(HasCodeBefore) {}

  inline std::pair<unsigned, unsigned> startLoc() const {
    return std::pair<unsigned, unsigned>(LineStart, ColumnStart);
  }

  inline std::pair<unsigned, unsigned> endLoc() const {
    return std::pair<unsigned, unsigned>(LineEnd, ColumnEnd);
  }

  bool operator<(const CounterMappingRegion &Other) const {
    if (FileID != Other.FileID)
      return FileID < Other.FileID;
    return startLoc() < Other.startLoc();
  }

  bool contains(const CounterMappingRegion &Other) const {
    if (FileID != Other.FileID)
      return false;
    if (startLoc() > Other.startLoc())
      return false;
    if (endLoc() < Other.endLoc())
      return false;
    return true;
  }
};

/// \brief Associates a source range with an execution count.
struct CountedRegion : public CounterMappingRegion {
  uint64_t ExecutionCount;

  CountedRegion(const CounterMappingRegion &R, uint64_t ExecutionCount)
      : CounterMappingRegion(R), ExecutionCount(ExecutionCount) {}
};

/// \brief A Counter mapping context is used to connect the counters,
/// expressions and the obtained counter values.
class CounterMappingContext {
  ArrayRef<CounterExpression> Expressions;
  ArrayRef<uint64_t> CounterValues;

public:
  CounterMappingContext(ArrayRef<CounterExpression> Expressions,
                        ArrayRef<uint64_t> CounterValues = ArrayRef<uint64_t>())
      : Expressions(Expressions), CounterValues(CounterValues) {}

  void dump(const Counter &C, llvm::raw_ostream &OS) const;
  void dump(const Counter &C) const { dump(C, llvm::outs()); }

  /// \brief Return the number of times that a region of code associated with
  /// this counter was executed.
  ErrorOr<int64_t> evaluate(const Counter &C) const;
};

/// \brief Code coverage information for a single function.
struct FunctionRecord {
  /// \brief Raw function name.
  std::string Name;
  /// \brief Associated files.
  std::vector<std::string> Filenames;
  /// \brief Regions in the function along with their counts.
  std::vector<CountedRegion> CountedRegions;
  /// \brief The number of times this function was executed.
  uint64_t ExecutionCount;

  FunctionRecord(StringRef Name, ArrayRef<StringRef> Filenames,
                 uint64_t ExecutionCount)
      : Name(Name), Filenames(Filenames.begin(), Filenames.end()),
        ExecutionCount(ExecutionCount) {}
};

/// \brief Coverage information for a macro expansion or #included file.
///
/// When covered code has pieces that can be expanded for more detail, such as a
/// preprocessor macro use and its definition, these are represented as
/// expansions whose coverage can be looked up independently.
struct ExpansionRecord {
  /// \brief The abstract file this expansion covers.
  unsigned FileID;
  /// \brief The region that expands to this record.
  const CountedRegion &Region;
  /// \brief Coverage for the expansion.
  const FunctionRecord &Function;

  ExpansionRecord(const CountedRegion &Region,
                  const FunctionRecord &Function)
      : FileID(Region.ExpandedFileID), Region(Region), Function(Function) {}
};

/// \brief The execution count information starting at a point in a file.
///
/// A sequence of CoverageSegments gives execution counts for a file in format
/// that's simple to iterate through for processing.
struct CoverageSegment {
  /// \brief The line where this segment begins.
  unsigned Line;
  /// \brief The column where this segment begins.
  unsigned Col;
  /// \brief The execution count, or zero if no count was recorded.
  uint64_t Count;
  /// \brief When false, the segment was uninstrumented or skipped.
  bool HasCount;
  /// \brief Whether this enters a new region or returns to a previous count.
  bool IsRegionEntry;

  CoverageSegment(unsigned Line, unsigned Col, bool IsRegionEntry)
      : Line(Line), Col(Col), Count(0), HasCount(false),
        IsRegionEntry(IsRegionEntry) {}
  void setCount(uint64_t NewCount) {
    Count = NewCount;
    HasCount = true;
  }
  void addCount(uint64_t NewCount) { setCount(Count + NewCount); }
};

/// \brief Coverage information to be processed or displayed.
///
/// This represents the coverage of an entire file, expansion, or function. It
/// provides a sequence of CoverageSegments to iterate through, as well as the
/// list of expansions that can be further processed.
class CoverageData {
  std::string Filename;
  std::vector<CoverageSegment> Segments;
  std::vector<ExpansionRecord> Expansions;
  friend class CoverageMapping;

public:
  CoverageData() {}

  CoverageData(StringRef Filename) : Filename(Filename) {}

  CoverageData(CoverageData &&RHS)
      : Filename(std::move(RHS.Filename)), Segments(std::move(RHS.Segments)),
        Expansions(std::move(RHS.Expansions)) {}

  /// \brief Get the name of the file this data covers.
  StringRef getFilename() { return Filename; }

  std::vector<CoverageSegment>::iterator begin() { return Segments.begin(); }
  std::vector<CoverageSegment>::iterator end() { return Segments.end(); }
  bool empty() { return Segments.empty(); }

  /// \brief Expansions that can be further processed.
  std::vector<ExpansionRecord> getExpansions() { return Expansions; }
};

/// \brief The mapping of profile information to coverage data.
///
/// This is the main interface to get coverage information, using a profile to
/// fill out execution counts.
class CoverageMapping {
  std::vector<FunctionRecord> Functions;
  unsigned MismatchedFunctionCount;

  CoverageMapping() : MismatchedFunctionCount(0) {}

public:
  /// \brief Load the coverage mapping using the given readers.
  static ErrorOr<std::unique_ptr<CoverageMapping>>
  load(ObjectFileCoverageMappingReader &CoverageReader,
       IndexedInstrProfReader &ProfileReader);

  /// \brief Load the coverage mapping from the given files.
  static ErrorOr<std::unique_ptr<CoverageMapping>>
  load(StringRef ObjectFilename, StringRef ProfileFilename);

  /// \brief The number of functions that couldn't have their profiles mapped.
  ///
  /// This is a count of functions whose profile is out of date or otherwise
  /// can't be associated with any coverage information.
  unsigned getMismatchedCount() { return MismatchedFunctionCount; }

  /// \brief Returns the list of files that are covered.
  std::vector<StringRef> getUniqueSourceFiles();

  /// \brief Get the coverage for a particular file.
  ///
  /// The given filename must be the name as recorded in the coverage
  /// information. That is, only names returned from getUniqueSourceFiles will
  /// yield a result.
  CoverageData getCoverageForFile(StringRef Filename);

  /// \brief Gets all of the functions covered by this profile.
  ArrayRef<FunctionRecord> getCoveredFunctions() {
    return ArrayRef<FunctionRecord>(Functions.data(), Functions.size());
  }

  /// \brief Get the list of function instantiations in the file.
  ///
  /// Fucntions that are instantiated more than once, such as C++ template
  /// specializations, have distinct coverage records for each instantiation.
  std::vector<const FunctionRecord *> getInstantiations(StringRef Filename);

  /// \brief Get the coverage for a particular function.
  CoverageData getCoverageForFunction(const FunctionRecord &Function);

  /// \brief Get the coverage for an expansion within a coverage set.
  CoverageData getCoverageForExpansion(const ExpansionRecord &Expansion);
};

} // end namespace coverage
} // end namespace llvm

#endif // LLVM_PROFILEDATA_COVERAGEMAPPING_H_
