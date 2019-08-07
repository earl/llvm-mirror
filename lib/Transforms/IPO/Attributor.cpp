//===- Attributor.cpp - Module-wide attribute deduction -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements an inter procedural pass that deduces and/or propagating
// attributes. This is done in an abstract interpretation style fixpoint
// iteration. See the Attributor.h file comment and the class descriptions in
// that file for more information.
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/IPO/Attributor.h"

#include "llvm/ADT/DepthFirstIterator.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/CaptureTracking.h"
#include "llvm/Analysis/EHPersonalities.h"
#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/Loads.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/Local.h"

#include <cassert>

using namespace llvm;

#define DEBUG_TYPE "attributor"

STATISTIC(NumFnWithExactDefinition,
          "Number of function with exact definitions");
STATISTIC(NumFnWithoutExactDefinition,
          "Number of function without exact definitions");
STATISTIC(NumAttributesTimedOut,
          "Number of abstract attributes timed out before fixpoint");
STATISTIC(NumAttributesValidFixpoint,
          "Number of abstract attributes in a valid fixpoint state");
STATISTIC(NumAttributesManifested,
          "Number of abstract attributes manifested in IR");
STATISTIC(NumFnNoUnwind, "Number of functions marked nounwind");

STATISTIC(NumFnUniqueReturned, "Number of function with unique return");
STATISTIC(NumFnKnownReturns, "Number of function with known return values");
STATISTIC(NumFnArgumentReturned,
          "Number of function arguments marked returned");
STATISTIC(NumFnNoSync, "Number of functions marked nosync");
STATISTIC(NumFnNoFree, "Number of functions marked nofree");
STATISTIC(NumFnReturnedNonNull,
          "Number of function return values marked nonnull");
STATISTIC(NumFnArgumentNonNull, "Number of function arguments marked nonnull");
STATISTIC(NumCSArgumentNonNull, "Number of call site arguments marked nonnull");
STATISTIC(NumFnWillReturn, "Number of functions marked willreturn");
STATISTIC(NumFnArgumentNoAlias, "Number of function arguments marked noalias");
STATISTIC(NumFnReturnedDereferenceable,
          "Number of function return values marked dereferenceable");
STATISTIC(NumFnArgumentDereferenceable,
          "Number of function arguments marked dereferenceable");
STATISTIC(NumCSArgumentDereferenceable,
          "Number of call site arguments marked dereferenceable");
STATISTIC(NumFnReturnedAlign, "Number of function return values marked align");
STATISTIC(NumFnArgumentAlign, "Number of function arguments marked align");
STATISTIC(NumCSArgumentAlign, "Number of call site arguments marked align");
STATISTIC(NumFnNoReturn, "Number of functions marked noreturn");

// TODO: Determine a good default value.
//
// In the LLVM-TS and SPEC2006, 32 seems to not induce compile time overheads
// (when run with the first 5 abstract attributes). The results also indicate
// that we never reach 32 iterations but always find a fixpoint sooner.
//
// This will become more evolved once we perform two interleaved fixpoint
// iterations: bottom-up and top-down.
static cl::opt<unsigned>
    MaxFixpointIterations("attributor-max-iterations", cl::Hidden,
                          cl::desc("Maximal number of fixpoint iterations."),
                          cl::init(32));

static cl::opt<bool> DisableAttributor(
    "attributor-disable", cl::Hidden,
    cl::desc("Disable the attributor inter-procedural deduction pass."),
    cl::init(true));

static cl::opt<bool> VerifyAttributor(
    "attributor-verify", cl::Hidden,
    cl::desc("Verify the Attributor deduction and "
             "manifestation of attributes -- may issue false-positive errors"),
    cl::init(false));

/// Logic operators for the change status enum class.
///
///{
ChangeStatus llvm::operator|(ChangeStatus l, ChangeStatus r) {
  return l == ChangeStatus::CHANGED ? l : r;
}
ChangeStatus llvm::operator&(ChangeStatus l, ChangeStatus r) {
  return l == ChangeStatus::UNCHANGED ? l : r;
}
///}

/// Helper to adjust the statistics.
static void bookkeeping(IRPosition::Kind PK, const Attribute &Attr) {
  if (!AreStatisticsEnabled())
    return;

  switch (Attr.getKindAsEnum()) {
  case Attribute::Alignment:
    switch (PK) {
    case IRPosition::IRP_RETURNED:
      NumFnReturnedAlign++;
      break;
    case IRPosition::IRP_ARGUMENT:
      NumFnArgumentAlign++;
      break;
    case IRPosition::IRP_CALL_SITE_ARGUMENT:
      NumCSArgumentAlign++;
      break;
    default:
      break;
    }
    break;
  case Attribute::Dereferenceable:
    switch (PK) {
    case IRPosition::IRP_RETURNED:
      NumFnReturnedDereferenceable++;
      break;
    case IRPosition::IRP_ARGUMENT:
      NumFnArgumentDereferenceable++;
      break;
    case IRPosition::IRP_CALL_SITE_ARGUMENT:
      NumCSArgumentDereferenceable++;
      break;
    default:
      break;
    }
    break;
  case Attribute::NoUnwind:
    NumFnNoUnwind++;
    return;
  case Attribute::Returned:
    NumFnArgumentReturned++;
    return;
  case Attribute::NoSync:
    NumFnNoSync++;
    break;
  case Attribute::NoFree:
    NumFnNoFree++;
    break;
  case Attribute::NonNull:
    switch (PK) {
    case IRPosition::IRP_RETURNED:
      NumFnReturnedNonNull++;
      break;
    case IRPosition::IRP_ARGUMENT:
      NumFnArgumentNonNull++;
      break;
    case IRPosition::IRP_CALL_SITE_ARGUMENT:
      NumCSArgumentNonNull++;
      break;
    default:
      break;
    }
    break;
  case Attribute::WillReturn:
    NumFnWillReturn++;
    break;
  case Attribute::NoReturn:
    NumFnNoReturn++;
    return;
  case Attribute::NoAlias:
    NumFnArgumentNoAlias++;
    return;
  default:
    return;
  }
}

template <typename StateTy>
using followValueCB_t = std::function<bool(Value *, StateTy &State)>;
template <typename StateTy>
using visitValueCB_t = std::function<void(Value *, StateTy &State)>;

/// Recursively visit all values that might become \p InitV at some point. This
/// will be done by looking through cast instructions, selects, phis, and calls
/// with the "returned" attribute. The callback \p FollowValueCB is asked before
/// a potential origin value is looked at. If no \p FollowValueCB is passed, a
/// default one is used that will make sure we visit every value only once. Once
/// we cannot look through the value any further, the callback \p VisitValueCB
/// is invoked and passed the current value and the \p State. To limit how much
/// effort is invested, we will never visit more than \p MaxValues values.
template <typename StateTy>
static bool genericValueTraversal(
    Value *InitV, StateTy &State, visitValueCB_t<StateTy> &VisitValueCB,
    followValueCB_t<StateTy> *FollowValueCB = nullptr, int MaxValues = 8) {

  SmallPtrSet<Value *, 16> Visited;
  followValueCB_t<bool> DefaultFollowValueCB = [&](Value *Val, bool &) {
    return Visited.insert(Val).second;
  };

  if (!FollowValueCB)
    FollowValueCB = &DefaultFollowValueCB;

  SmallVector<Value *, 16> Worklist;
  Worklist.push_back(InitV);

  int Iteration = 0;
  do {
    Value *V = Worklist.pop_back_val();

    // Check if we should process the current value. To prevent endless
    // recursion keep a record of the values we followed!
    if (!(*FollowValueCB)(V, State))
      continue;

    // Make sure we limit the compile time for complex expressions.
    if (Iteration++ >= MaxValues)
      return false;

    // Explicitly look through calls with a "returned" attribute if we do
    // not have a pointer as stripPointerCasts only works on them.
    if (V->getType()->isPointerTy()) {
      V = V->stripPointerCasts();
    } else {
      CallSite CS(V);
      if (CS && CS.getCalledFunction()) {
        Value *NewV = nullptr;
        for (Argument &Arg : CS.getCalledFunction()->args())
          if (Arg.hasReturnedAttr()) {
            NewV = CS.getArgOperand(Arg.getArgNo());
            break;
          }
        if (NewV) {
          Worklist.push_back(NewV);
          continue;
        }
      }
    }

    // Look through select instructions, visit both potential values.
    if (auto *SI = dyn_cast<SelectInst>(V)) {
      Worklist.push_back(SI->getTrueValue());
      Worklist.push_back(SI->getFalseValue());
      continue;
    }

    // Look through phi nodes, visit all operands.
    if (auto *PHI = dyn_cast<PHINode>(V)) {
      Worklist.append(PHI->op_begin(), PHI->op_end());
      continue;
    }

    // Once a leaf is reached we inform the user through the callback.
    VisitValueCB(V, State);
  } while (!Worklist.empty());

  // All values have been visited.
  return true;
}

/// Return true if \p New is equal or worse than \p Old.
static bool isEqualOrWorse(const Attribute &New, const Attribute &Old) {
  if (!Old.isIntAttribute())
    return true;

  return Old.getValueAsInt() >= New.getValueAsInt();
}

/// Return true if the information provided by \p Attr was added to the
/// attribute list \p Attrs. This is only the case if it was not already present
/// in \p Attrs at the position describe by \p PK and \p AttrIdx.
static bool addIfNotExistent(LLVMContext &Ctx, const Attribute &Attr,
                             AttributeList &Attrs, int AttrIdx) {

  if (Attr.isEnumAttribute()) {
    Attribute::AttrKind Kind = Attr.getKindAsEnum();
    if (Attrs.hasAttribute(AttrIdx, Kind))
      if (isEqualOrWorse(Attr, Attrs.getAttribute(AttrIdx, Kind)))
        return false;
    Attrs = Attrs.addAttribute(Ctx, AttrIdx, Attr);
    return true;
  }
  if (Attr.isStringAttribute()) {
    StringRef Kind = Attr.getKindAsString();
    if (Attrs.hasAttribute(AttrIdx, Kind))
      if (isEqualOrWorse(Attr, Attrs.getAttribute(AttrIdx, Kind)))
        return false;
    Attrs = Attrs.addAttribute(Ctx, AttrIdx, Attr);
    return true;
  }
  if (Attr.isIntAttribute()) {
    Attribute::AttrKind Kind = Attr.getKindAsEnum();
    if (Attrs.hasAttribute(AttrIdx, Kind))
      if (isEqualOrWorse(Attr, Attrs.getAttribute(AttrIdx, Kind)))
        return false;
    Attrs = Attrs.removeAttribute(Ctx, AttrIdx, Kind);
    Attrs = Attrs.addAttribute(Ctx, AttrIdx, Attr);
    return true;
  }

  llvm_unreachable("Expected enum or string attribute!");
}

ChangeStatus AbstractAttribute::update(Attributor &A,
                                       InformationCache &InfoCache) {
  ChangeStatus HasChanged = ChangeStatus::UNCHANGED;
  if (getState().isAtFixpoint())
    return HasChanged;

  LLVM_DEBUG(dbgs() << "[Attributor] Update: " << *this << "\n");

  HasChanged = updateImpl(A, InfoCache);

  LLVM_DEBUG(dbgs() << "[Attributor] Update " << HasChanged << " " << *this
                    << "\n");

  return HasChanged;
}

 ChangeStatus IRAttributeManifest::manifestAttrs(Attributor &A, IRPosition
     &IRP, const ArrayRef<Attribute> &DeducedAttrs) {
  assert(IRP.getAssociatedValue() &&
         "Attempted to manifest an attribute without associated value!");

  ChangeStatus HasChanged = ChangeStatus::UNCHANGED;

  Function &ScopeFn = IRP.getAnchorScope();
  LLVMContext &Ctx = ScopeFn.getContext();
  IRPosition::Kind PK = IRP.getPositionKind();

  // In the following some generic code that will manifest attributes in
  // DeducedAttrs if they improve the current IR. Due to the different
  // annotation positions we use the underlying AttributeList interface.

  AttributeList Attrs;
  switch (PK) {
  case IRPosition::IRP_ARGUMENT:
  case IRPosition::IRP_FUNCTION:
  case IRPosition::IRP_RETURNED:
    Attrs = ScopeFn.getAttributes();
    break;
  case IRPosition::IRP_CALL_SITE_ARGUMENT:
    Attrs = ImmutableCallSite(&IRP.getAnchorValue()).getAttributes();
    break;
  }

  for (const Attribute &Attr : DeducedAttrs) {
    if (!addIfNotExistent(Ctx, Attr, Attrs, IRP.getAttrIdx()))
      continue;

    HasChanged = ChangeStatus::CHANGED;
    bookkeeping(PK, Attr);
  }

  if (HasChanged == ChangeStatus::UNCHANGED)
    return HasChanged;

  switch (PK) {
  case IRPosition::IRP_ARGUMENT:
  case IRPosition::IRP_FUNCTION:
  case IRPosition::IRP_RETURNED:
    ScopeFn.setAttributes(Attrs);
    break;
  case IRPosition::IRP_CALL_SITE_ARGUMENT:
    CallSite(&IRP.getAnchorValue()).setAttributes(Attrs);
  }

  return HasChanged;
}

/// -----------------------NoUnwind Function Attribute--------------------------

struct AANoUnwindImpl : AANoUnwind, BooleanState {
  IRPositionConstructorForward(AANoUnwindImpl, AANoUnwind);

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  const std::string getAsStr() const override {
    return getAssumed() ? "nounwind" : "may-unwind";
  }

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;

  /// See AANoUnwind::isAssumedNoUnwind().
  bool isAssumedNoUnwind() const override { return getAssumed(); }

  /// See AANoUnwind::isKnownNoUnwind().
  bool isKnownNoUnwind() const override { return getKnown(); }
};

struct AANoUnwindFunction final : public AANoUnwindImpl {
  AANoUnwindFunction(Function &F) : AANoUnwindImpl(F, IRP_FUNCTION) {}
};

ChangeStatus AANoUnwindImpl::updateImpl(Attributor &A,
                                        InformationCache &InfoCache) {
  Function &F = getAnchorScope();

  // The map from instruction opcodes to those instructions in the function.
  auto Opcodes = {
      (unsigned)Instruction::Invoke,      (unsigned)Instruction::CallBr,
      (unsigned)Instruction::Call,        (unsigned)Instruction::CleanupRet,
      (unsigned)Instruction::CatchSwitch, (unsigned)Instruction::Resume};

  auto CheckForNoUnwind = [&](Instruction &I) {
    if (!I.mayThrow())
      return true;

    auto *NoUnwindAA = A.getAAFor<AANoUnwind>(*this, I);
    return NoUnwindAA && NoUnwindAA->isAssumedNoUnwind();
  };

  if (!A.checkForAllInstructions(F, CheckForNoUnwind, *this, InfoCache,
                                 Opcodes))
    return indicatePessimisticFixpoint();

  return ChangeStatus::UNCHANGED;
}

/// --------------------- Function Return Values -------------------------------

/// "Attribute" that collects all potential returned values and the return
/// instructions that they arise from.
///
/// If there is a unique returned value R, the manifest method will:
///   - mark R with the "returned" attribute, if R is an argument.
class AAReturnedValuesImpl : public AAReturnedValues, public AbstractState {

  /// Mapping of values potentially returned by the associated function to the
  /// return instructions that might return them.
  DenseMap<Value *, SmallPtrSet<ReturnInst *, 2>> ReturnedValues;

  /// State flags
  ///
  ///{
  bool IsFixed;
  bool IsValidState;
  bool HasOverdefinedReturnedCalls;
  ///}

  /// Collect values that could become \p V in the set \p Values, each mapped to
  /// \p ReturnInsts.
  void collectValuesRecursively(
      Attributor &A, Value *V, SmallPtrSetImpl<ReturnInst *> &ReturnInsts,
      DenseMap<Value *, SmallPtrSet<ReturnInst *, 2>> &Values) {

    visitValueCB_t<bool> VisitValueCB = [&](Value *Val, bool &) {
      assert(!isa<Instruction>(Val) ||
             &getAnchorScope() == cast<Instruction>(Val)->getFunction());
      Values[Val].insert(ReturnInsts.begin(), ReturnInsts.end());
    };

    bool UnusedBool;
    bool Success = genericValueTraversal(V, UnusedBool, VisitValueCB);

    // If we did abort the above traversal we haven't see all the values.
    // Consequently, we cannot know if the information we would derive is
    // accurate so we give up early.
    if (!Success)
      indicatePessimisticFixpoint();
  }

public:
  IRPositionConstructorForward(AAReturnedValuesImpl, AAReturnedValues);

  /// See AbstractAttribute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    // Reset the state.
    AssociatedVal = nullptr;
    IsFixed = false;
    IsValidState = true;
    HasOverdefinedReturnedCalls = false;
    ReturnedValues.clear();

    Function &F = cast<Function>(getAnchorValue());

    // The map from instruction opcodes to those instructions in the function.
    auto &OpcodeInstMap = InfoCache.getOpcodeInstMapForFunction(F);

    // Look through all arguments, if one is marked as returned we are done.
    for (Argument &Arg : F.args()) {
      if (Arg.hasReturnedAttr()) {

        auto &ReturnInstSet = ReturnedValues[&Arg];
        for (Instruction *RI : OpcodeInstMap[Instruction::Ret])
          ReturnInstSet.insert(cast<ReturnInst>(RI));

        indicateOptimisticFixpoint();
        return;
      }
    }

    // If no argument was marked as returned we look at all return instructions
    // and collect potentially returned values.
    for (Instruction *RI : OpcodeInstMap[Instruction::Ret]) {
      SmallPtrSet<ReturnInst *, 1> RISet({cast<ReturnInst>(RI)});
      collectValuesRecursively(A, cast<ReturnInst>(RI)->getReturnValue(), RISet,
                               ReturnedValues);
    }
  }

  /// See AbstractAttribute::manifest(...).
  ChangeStatus manifest(Attributor &A) override;

  /// See AbstractAttribute::getState(...).
  AbstractState &getState() override { return *this; }

  /// See AbstractAttribute::getState(...).
  const AbstractState &getState() const override { return *this; }

  /// See AbstractAttribute::updateImpl(Attributor &A).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;

  /// Return the number of potential return values, -1 if unknown.
  size_t getNumReturnValues() const {
    return isValidState() ? ReturnedValues.size() : -1;
  }

  /// Return an assumed unique return value if a single candidate is found. If
  /// there cannot be one, return a nullptr. If it is not clear yet, return the
  /// Optional::NoneType.
  Optional<Value *>
  getAssumedUniqueReturnValue(const AAIsDead *LivenessAA) const;

  /// See AbstractState::checkForallReturnedValues(...).
  bool checkForallReturnedValues(
      std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> &Pred)
      const override;

  /// Pretty print the attribute similar to the IR representation.
  const std::string getAsStr() const override;

  /// See AbstractState::isAtFixpoint().
  bool isAtFixpoint() const override { return IsFixed; }

  /// See AbstractState::isValidState().
  bool isValidState() const override { return IsValidState; }

  /// See AbstractState::indicateOptimisticFixpoint(...).
  ChangeStatus indicateOptimisticFixpoint() override {
    IsFixed = true;
    IsValidState &= true;
    return ChangeStatus::UNCHANGED;
  }

  ChangeStatus indicatePessimisticFixpoint() override {
    IsFixed = true;
    IsValidState = false;
    return ChangeStatus::CHANGED;
  }
};

struct AAReturnedValuesFunction final : public AAReturnedValuesImpl {
  AAReturnedValuesFunction(Function &F)
      : AAReturnedValuesImpl(F, IRP_FUNCTION) {}
};

ChangeStatus AAReturnedValuesImpl::manifest(Attributor &A) {
  ChangeStatus Changed = ChangeStatus::UNCHANGED;

  // Bookkeeping.
  assert(isValidState());
  NumFnKnownReturns++;

  auto *LivenessAA = A.getAAFor<AAIsDead>(*this, getAnchorScope());

  // Check if we have an assumed unique return value that we could manifest.
  Optional<Value *> UniqueRV = getAssumedUniqueReturnValue(LivenessAA);

  if (!UniqueRV.hasValue() || !UniqueRV.getValue())
    return Changed;

  // Bookkeeping.
  NumFnUniqueReturned++;

  // If the assumed unique return value is an argument, annotate it.
  if (auto *UniqueRVArg = dyn_cast<Argument>(UniqueRV.getValue())) {
    setAssociatedValue(UniqueRVArg);
    setAttributeIdx(UniqueRVArg->getArgNo() + AttributeList::FirstArgIndex);
    Changed = IRAttribute::manifest(A) | Changed;
  }

  return Changed;
}

const std::string AAReturnedValuesImpl::getAsStr() const {
  return (isAtFixpoint() ? "returns(#" : "may-return(#") +
         (isValidState() ? std::to_string(getNumReturnValues()) : "?") +
         ")[OD: " + std::to_string(HasOverdefinedReturnedCalls) + "]";
}

Optional<Value *> AAReturnedValuesImpl::getAssumedUniqueReturnValue(
    const AAIsDead *LivenessAA) const {
  // If checkForallReturnedValues provides a unique value, ignoring potential
  // undef values that can also be present, it is assumed to be the actual
  // return value and forwarded to the caller of this method. If there are
  // multiple, a nullptr is returned indicating there cannot be a unique
  // returned value.
  Optional<Value *> UniqueRV;

  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> Pred =
      [&](Value &RV, const SmallPtrSetImpl<ReturnInst *> &RetInsts) -> bool {
    // If all ReturnInsts are dead, then ReturnValue is dead as well
    // and can be ignored.
    if (LivenessAA &&
        !LivenessAA->isLiveInstSet(RetInsts.begin(), RetInsts.end()))
      return true;

    // If we found a second returned value and neither the current nor the saved
    // one is an undef, there is no unique returned value. Undefs are special
    // since we can pretend they have any value.
    if (UniqueRV.hasValue() && UniqueRV != &RV &&
        !(isa<UndefValue>(RV) || isa<UndefValue>(UniqueRV.getValue()))) {
      UniqueRV = nullptr;
      return false;
    }

    // Do not overwrite a value with an undef.
    if (!UniqueRV.hasValue() || !isa<UndefValue>(RV))
      UniqueRV = &RV;

    return true;
  };

  if (!checkForallReturnedValues(Pred))
    UniqueRV = nullptr;

  return UniqueRV;
}

bool AAReturnedValuesImpl::checkForallReturnedValues(
    std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> &Pred)
    const {
  if (!isValidState())
    return false;

  // Check all returned values but ignore call sites as long as we have not
  // encountered an overdefined one during an update.
  for (auto &It : ReturnedValues) {
    Value *RV = It.first;
    const SmallPtrSetImpl<ReturnInst *> &RetInsts = It.second;

    ImmutableCallSite ICS(RV);
    if (ICS && !HasOverdefinedReturnedCalls)
      continue;

    if (!Pred(*RV, RetInsts))
      return false;
  }

  return true;
}

ChangeStatus AAReturnedValuesImpl::updateImpl(Attributor &A,
                                              InformationCache &InfoCache) {

  // Check if we know of any values returned by the associated function,
  // if not, we are done.
  if (getNumReturnValues() == 0) {
    indicateOptimisticFixpoint();
    return ChangeStatus::UNCHANGED;
  }

  // Check if any of the returned values is a call site we can refine.
  decltype(ReturnedValues) AddRVs;
  bool HasCallSite = false;

  // Keep track of any change to trigger updates on dependent attributes.
  ChangeStatus Changed = ChangeStatus::UNCHANGED;

  auto *LivenessAA = A.getAAFor<AAIsDead>(*this, getAnchorScope());

  // Look at all returned call sites.
  for (auto &It : ReturnedValues) {
    SmallPtrSet<ReturnInst *, 2> &ReturnInsts = It.second;
    Value *RV = It.first;

    LLVM_DEBUG(dbgs() << "[AAReturnedValues] Potentially returned value " << *RV
                      << "\n");

    // Only call sites can change during an update, ignore the rest.
    CallSite RetCS(RV);
    if (!RetCS)
      continue;

    // For now, any call site we see will prevent us from directly fixing the
    // state. However, if the information on the callees is fixed, the call
    // sites will be removed and we will fix the information for this state.
    HasCallSite = true;

    // Ignore dead ReturnValues.
    if (LivenessAA &&
        !LivenessAA->isLiveInstSet(ReturnInsts.begin(), ReturnInsts.end())) {
      LLVM_DEBUG(dbgs() << "[AAReturnedValues] all returns are assumed dead, "
                           "skip it for now\n");
      continue;
    }

    // Try to find a assumed unique return value for the called function.
    auto *RetCSAA = A.getAAFor<AAReturnedValuesImpl>(*this, *RV);
    if (!RetCSAA) {
      if (!HasOverdefinedReturnedCalls)
        Changed = ChangeStatus::CHANGED;
      HasOverdefinedReturnedCalls = true;
      LLVM_DEBUG(dbgs() << "[AAReturnedValues] Returned call site (" << *RV
                        << ") with " << (RetCSAA ? "invalid" : "no")
                        << " associated state\n");
      continue;
    }

    auto *LivenessCSAA = A.getAAFor<AAIsDead>(*this, RetCSAA->getAnchorScope());

    // Try to find a assumed unique return value for the called function.
    Optional<Value *> AssumedUniqueRV =
        RetCSAA->getAssumedUniqueReturnValue(LivenessCSAA);

    // If no assumed unique return value was found due to the lack of
    // candidates, we may need to resolve more calls (through more update
    // iterations) or the called function will not return. Either way, we simply
    // stick with the call sites as return values. Because there were not
    // multiple possibilities, we do not treat it as overdefined.
    if (!AssumedUniqueRV.hasValue())
      continue;

    // If multiple, non-refinable values were found, there cannot be a unique
    // return value for the called function. The returned call is overdefined!
    if (!AssumedUniqueRV.getValue()) {
      if (!HasOverdefinedReturnedCalls)
        Changed = ChangeStatus::CHANGED;
      HasOverdefinedReturnedCalls = true;
      LLVM_DEBUG(dbgs() << "[AAReturnedValues] Returned call site has multiple "
                           "potentially returned values\n");
      continue;
    }

    LLVM_DEBUG({
      bool UniqueRVIsKnown = RetCSAA->isAtFixpoint();
      dbgs() << "[AAReturnedValues] Returned call site "
             << (UniqueRVIsKnown ? "known" : "assumed")
             << " unique return value: " << *AssumedUniqueRV << "\n";
    });

    // The assumed unique return value.
    Value *AssumedRetVal = AssumedUniqueRV.getValue();

    // If the assumed unique return value is an argument, lookup the matching
    // call site operand and recursively collect new returned values.
    // If it is not an argument, it is just put into the set of returned values
    // as we would have already looked through casts, phis, and similar values.
    if (Argument *AssumedRetArg = dyn_cast<Argument>(AssumedRetVal))
      collectValuesRecursively(A,
                               RetCS.getArgOperand(AssumedRetArg->getArgNo()),
                               ReturnInsts, AddRVs);
    else
      AddRVs[AssumedRetVal].insert(ReturnInsts.begin(), ReturnInsts.end());
  }

  for (auto &It : AddRVs) {
    assert(!It.second.empty() && "Entry does not add anything.");
    auto &ReturnInsts = ReturnedValues[It.first];
    for (ReturnInst *RI : It.second)
      if (ReturnInsts.insert(RI).second) {
        LLVM_DEBUG(dbgs() << "[AAReturnedValues] Add new returned value "
                          << *It.first << " => " << *RI << "\n");
        Changed = ChangeStatus::CHANGED;
      }
  }

  // If there is no call site in the returned values we are done.
  if (!HasCallSite) {
    indicateOptimisticFixpoint();
    return ChangeStatus::CHANGED;
  }

  return Changed;
}

/// ------------------------ NoSync Function Attribute -------------------------

struct AANoSyncImpl : AANoSync, BooleanState {
  IRPositionConstructorForward(AANoSyncImpl, AANoSync);

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  const std::string getAsStr() const override {
    return getAssumed() ? "nosync" : "may-sync";
  }

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;

  /// See AANoSync::isAssumedNoSync()
  bool isAssumedNoSync() const override { return getAssumed(); }

  /// See AANoSync::isKnownNoSync()
  bool isKnownNoSync() const override { return getKnown(); }

  /// Helper function used to determine whether an instruction is non-relaxed
  /// atomic. In other words, if an atomic instruction does not have unordered
  /// or monotonic ordering
  static bool isNonRelaxedAtomic(Instruction *I);

  /// Helper function used to determine whether an instruction is volatile.
  static bool isVolatile(Instruction *I);

  /// Helper function uset to check if intrinsic is volatile (memcpy, memmove,
  /// memset).
  static bool isNoSyncIntrinsic(Instruction *I);
};

struct AANoSyncFunction final : public AANoSyncImpl {
  AANoSyncFunction(Function &F) : AANoSyncImpl(F, IRP_FUNCTION) {}
};

bool AANoSyncImpl::isNonRelaxedAtomic(Instruction *I) {
  if (!I->isAtomic())
    return false;

  AtomicOrdering Ordering;
  switch (I->getOpcode()) {
  case Instruction::AtomicRMW:
    Ordering = cast<AtomicRMWInst>(I)->getOrdering();
    break;
  case Instruction::Store:
    Ordering = cast<StoreInst>(I)->getOrdering();
    break;
  case Instruction::Load:
    Ordering = cast<LoadInst>(I)->getOrdering();
    break;
  case Instruction::Fence: {
    auto *FI = cast<FenceInst>(I);
    if (FI->getSyncScopeID() == SyncScope::SingleThread)
      return false;
    Ordering = FI->getOrdering();
    break;
  }
  case Instruction::AtomicCmpXchg: {
    AtomicOrdering Success = cast<AtomicCmpXchgInst>(I)->getSuccessOrdering();
    AtomicOrdering Failure = cast<AtomicCmpXchgInst>(I)->getFailureOrdering();
    // Only if both are relaxed, than it can be treated as relaxed.
    // Otherwise it is non-relaxed.
    if (Success != AtomicOrdering::Unordered &&
        Success != AtomicOrdering::Monotonic)
      return true;
    if (Failure != AtomicOrdering::Unordered &&
        Failure != AtomicOrdering::Monotonic)
      return true;
    return false;
  }
  default:
    llvm_unreachable(
        "New atomic operations need to be known in the attributor.");
  }

  // Relaxed.
  if (Ordering == AtomicOrdering::Unordered ||
      Ordering == AtomicOrdering::Monotonic)
    return false;
  return true;
}

/// Checks if an intrinsic is nosync. Currently only checks mem* intrinsics.
/// FIXME: We should ipmrove the handling of intrinsics.
bool AANoSyncImpl::isNoSyncIntrinsic(Instruction *I) {
  if (auto *II = dyn_cast<IntrinsicInst>(I)) {
    switch (II->getIntrinsicID()) {
    /// Element wise atomic memory intrinsics are can only be unordered,
    /// therefore nosync.
    case Intrinsic::memset_element_unordered_atomic:
    case Intrinsic::memmove_element_unordered_atomic:
    case Intrinsic::memcpy_element_unordered_atomic:
      return true;
    case Intrinsic::memset:
    case Intrinsic::memmove:
    case Intrinsic::memcpy:
      if (!cast<MemIntrinsic>(II)->isVolatile())
        return true;
      return false;
    default:
      return false;
    }
  }
  return false;
}

bool AANoSyncImpl::isVolatile(Instruction *I) {
  assert(!ImmutableCallSite(I) && !isa<CallBase>(I) &&
         "Calls should not be checked here");

  switch (I->getOpcode()) {
  case Instruction::AtomicRMW:
    return cast<AtomicRMWInst>(I)->isVolatile();
  case Instruction::Store:
    return cast<StoreInst>(I)->isVolatile();
  case Instruction::Load:
    return cast<LoadInst>(I)->isVolatile();
  case Instruction::AtomicCmpXchg:
    return cast<AtomicCmpXchgInst>(I)->isVolatile();
  default:
    return false;
  }
}

ChangeStatus AANoSyncImpl::updateImpl(Attributor &A,
                                      InformationCache &InfoCache) {
  Function &F = getAnchorScope();

  auto CheckRWInstForNoSync = [&](Instruction &I) {
    /// We are looking for volatile instructions or Non-Relaxed atomics.
    /// FIXME: We should ipmrove the handling of intrinsics.

    ImmutableCallSite ICS(&I);
    auto *NoSyncAA = A.getAAFor<AANoSyncImpl>(*this, I);

    if (isa<IntrinsicInst>(&I) && isNoSyncIntrinsic(&I))
      return true;

    if (ICS && (!NoSyncAA || !NoSyncAA->isAssumedNoSync()) &&
        !ICS.hasFnAttr(Attribute::NoSync))
      return false;

    if (ICS)
      return true;

    if (!isVolatile(&I) && !isNonRelaxedAtomic(&I))
      return true;

    return false;
  };

  auto CheckForNoSync = [&](Instruction &I) {
    // At this point we handled all read/write effects and they are all
    // nosync, so they can be skipped.
    if (I.mayReadOrWriteMemory())
      return true;

    // non-convergent and readnone imply nosync.
    return !ImmutableCallSite(&I).isConvergent();
  };

  if (!A.checkForAllReadWriteInstructions(F, CheckRWInstForNoSync, *this,
                                          InfoCache) ||
      !A.checkForAllCallLikeInstructions(F, CheckForNoSync, *this, InfoCache))
    return indicatePessimisticFixpoint();

  return ChangeStatus::UNCHANGED;
}

/// ------------------------ No-Free Attributes ----------------------------

struct AANoFreeImpl : public AANoFree, BooleanState {
  IRPositionConstructorForward(AANoFreeImpl, AANoFree);

  /// See AbstractAttribute::getState()
  ///{
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  ///}

  /// See AbstractAttribute::getAsStr().
  const std::string getAsStr() const override {
    return getAssumed() ? "nofree" : "may-free";
  }

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;

  /// Return true if "nofree" is assumed.
  bool isAssumedNoFree() const override { return getAssumed(); }

  /// Return true if "nofree" is known.
  bool isKnownNoFree() const override { return getKnown(); }
};

struct AANoFreeFunction final : public AANoFreeImpl {
  AANoFreeFunction(Function &F) : AANoFreeImpl(F, IRP_FUNCTION) {}
};

ChangeStatus AANoFreeImpl::updateImpl(Attributor &A,
                                      InformationCache &InfoCache) {
  Function &F = getAnchorScope();

  auto CheckForNoFree = [&](Instruction &I) {
    if (ImmutableCallSite(&I).hasFnAttr(Attribute::NoFree))
      return true;

    auto *NoFreeAA = A.getAAFor<AANoFreeImpl>(*this, I);
    return NoFreeAA && NoFreeAA->isAssumedNoFree();
  };

  if (!A.checkForAllCallLikeInstructions(F, CheckForNoFree, *this, InfoCache))
    return indicatePessimisticFixpoint();
  return ChangeStatus::UNCHANGED;
}

/// ------------------------ NonNull Argument Attribute ------------------------
struct AANonNullImpl : AANonNull, BooleanState {
  IRPositionConstructorForward(AANonNullImpl, AANonNull);

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  /// See AbstractAttribute::getAsStr().
  const std::string getAsStr() const override {
    return getAssumed() ? "nonnull" : "may-null";
  }

  /// See AANonNull::isAssumedNonNull().
  bool isAssumedNonNull() const override { return getAssumed(); }

  /// See AANonNull::isKnownNonNull().
  bool isKnownNonNull() const override { return getKnown(); }

  /// Generate a predicate that checks if a given value is assumed nonnull.
  /// The generated function returns true if a value satisfies any of
  /// following conditions.
  /// (i) A value is known nonZero(=nonnull).
  /// (ii) A value is associated with AANonNull and its isAssumedNonNull() is
  /// true.
  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)>
  generatePredicate(Attributor &);
};

std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)>
AANonNullImpl::generatePredicate(Attributor &A) {
  // FIXME: The `AAReturnedValues` should provide the predicate with the
  // `ReturnInst` vector as well such that we can use the control flow sensitive
  // version of `isKnownNonZero`. This should fix `test11` in
  // `test/Transforms/FunctionAttrs/nonnull.ll`

  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> Pred =
      [&](Value &RV, const SmallPtrSetImpl<ReturnInst *> &RetInsts) -> bool {
    Function &F = getAnchorScope();

    if (isKnownNonZero(&RV, F.getParent()->getDataLayout()))
      return true;

    auto *NonNullAA = A.getAAFor<AANonNull>(*this, RV);

    ImmutableCallSite ICS(&RV);

    if ((!NonNullAA || !NonNullAA->isAssumedNonNull()) &&
        (!ICS || !ICS.hasRetAttr(Attribute::NonNull)))
      return false;

    return true;
  };

  return Pred;
}

/// NonNull attribute for function return value.
struct AANonNullReturned : AANonNullImpl {

  AANonNullReturned(Function &F) : AANonNullImpl(F, IRP_RETURNED) {}

  /// See AbstractAttriubute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    Function &F = getAnchorScope();

    // Already nonnull.
    if (F.getAttributes().hasAttribute(AttributeList::ReturnIndex,
                                       Attribute::NonNull) ||
        F.getAttributes().hasAttribute(AttributeList::ReturnIndex,
                                       Attribute::Dereferenceable))
      indicateOptimisticFixpoint();
  }

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

ChangeStatus AANonNullReturned::updateImpl(Attributor &A,
                                           InformationCache &InfoCache) {
  Function &F = getAnchorScope();

  auto *AARetVal = A.getAAFor<AAReturnedValues>(*this, F);
  if (!AARetVal)
    return indicatePessimisticFixpoint();

  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> Pred =
      this->generatePredicate(A);

  if (!AARetVal->checkForallReturnedValues(Pred))
    return indicatePessimisticFixpoint();
  return ChangeStatus::UNCHANGED;
}

/// NonNull attribute for function argument.
struct AANonNullArgument : AANonNullImpl {

  AANonNullArgument(Argument &A) : AANonNullImpl(A) {}

  /// See AbstractAttriubute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    Argument *Arg = cast<Argument>(getAssociatedValue());
    if (Arg->hasNonNullAttr())
      indicateOptimisticFixpoint();
  }

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

/// NonNull attribute for a call site argument.
struct AANonNullCallSiteArgument : AANonNullImpl {

  /// See AANonNullImpl::AANonNullImpl(...).
  AANonNullCallSiteArgument(Instruction &I, unsigned ArgNo)
      : AANonNullImpl(CallSite(&I).getArgOperand(ArgNo), I, ArgNo) {}

  /// See AbstractAttribute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    CallSite CS(&getAnchorValue());
    if (CS.paramHasAttr(getArgNo(), getAttrKind()) ||
        CS.paramHasAttr(getArgNo(), Attribute::Dereferenceable) ||
        isKnownNonZero(getAssociatedValue(),
                       getAnchorScope().getParent()->getDataLayout()))
      indicateOptimisticFixpoint();
  }

  /// See AbstractAttribute::updateImpl(Attributor &A).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

ChangeStatus AANonNullArgument::updateImpl(Attributor &A,
                                           InformationCache &InfoCache) {
  Function &F = getAnchorScope();
  Argument &Arg = cast<Argument>(getAnchorValue());

  unsigned ArgNo = Arg.getArgNo();

  // Callback function
  std::function<bool(CallSite)> CallSiteCheck = [&](CallSite CS) {
    assert(CS && "Sanity check: Call site was not initialized properly!");

    auto *NonNullAA = A.getAAFor<AANonNull>(*this, *CS.getInstruction(), ArgNo);

    // Check that NonNullAA is AANonNullCallSiteArgument.
    if (NonNullAA) {
      ImmutableCallSite ICS(&NonNullAA->getIRPosition().getAnchorValue());
      if (ICS && CS.getInstruction() == ICS.getInstruction())
        return NonNullAA->isAssumedNonNull();
      return false;
    }

    if (CS.paramHasAttr(ArgNo, Attribute::NonNull))
      return true;

    Value *V = CS.getArgOperand(ArgNo);
    if (isKnownNonZero(V, getAnchorScope().getParent()->getDataLayout()))
      return true;

    return false;
  };
  if (!A.checkForAllCallSites(F, CallSiteCheck, *this, true))
    return indicatePessimisticFixpoint();
  return ChangeStatus::UNCHANGED;
}

ChangeStatus
AANonNullCallSiteArgument::updateImpl(Attributor &A,
                                      InformationCache &InfoCache) {
  // NOTE: Never look at the argument of the callee in this method.
  //       If we do this, "nonnull" is always deduced because of the assumption.

  Value &V = *getAssociatedValue();

  auto *NonNullAA = A.getAAFor<AANonNull>(*this, V);

  if (!NonNullAA || !NonNullAA->isAssumedNonNull())
    return indicatePessimisticFixpoint();

  return ChangeStatus::UNCHANGED;
}

/// ------------------------ Will-Return Attributes ----------------------------

struct AAWillReturnImpl : public AAWillReturn, BooleanState {
  IRPositionConstructorForward(AAWillReturnImpl, AAWillReturn);

  /// See AAWillReturn::isKnownWillReturn().
  bool isKnownWillReturn() const override { return getKnown(); }

  /// See AAWillReturn::isAssumedWillReturn().
  bool isAssumedWillReturn() const override { return getAssumed(); }

  /// See AbstractAttribute::getState(...).
  AbstractState &getState() override { return *this; }

  /// See AbstractAttribute::getState(...).
  const AbstractState &getState() const override { return *this; }

  /// See AbstractAttribute::getAsStr()
  const std::string getAsStr() const override {
    return getAssumed() ? "willreturn" : "may-noreturn";
  }
};

struct AAWillReturnFunction final : AAWillReturnImpl {

  /// See AbstractAttribute::AbstractAttribute(...).
  AAWillReturnFunction(Function &F) : AAWillReturnImpl(F, IRP_FUNCTION) {}

  /// See AbstractAttribute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override;

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

// Helper function that checks whether a function has any cycle.
// TODO: Replace with more efficent code
bool containsCycle(Function &F) {
  SmallPtrSet<BasicBlock *, 32> Visited;

  // Traverse BB by dfs and check whether successor is already visited.
  for (BasicBlock *BB : depth_first(&F)) {
    Visited.insert(BB);
    for (auto *SuccBB : successors(BB)) {
      if (Visited.count(SuccBB))
        return true;
    }
  }
  return false;
}

// Helper function that checks the function have a loop which might become an
// endless loop
// FIXME: Any cycle is regarded as endless loop for now.
//        We have to allow some patterns.
bool containsPossiblyEndlessLoop(Function &F) { return containsCycle(F); }

void AAWillReturnFunction::initialize(Attributor &A,
                                      InformationCache &InfoCache) {
  Function &F = getAnchorScope();

  if (containsPossiblyEndlessLoop(F))
    indicatePessimisticFixpoint();
}

ChangeStatus AAWillReturnFunction::updateImpl(Attributor &A,
                                              InformationCache &InfoCache) {
  const Function &F = getAnchorScope();
  // The map from instruction opcodes to those instructions in the function.

  auto CheckForWillReturn = [&](Instruction &I) {
    ImmutableCallSite ICS(&I);
    if (ICS.hasFnAttr(Attribute::WillReturn))
      return true;

    auto *WillReturnAA = A.getAAFor<AAWillReturn>(*this, I);
    if (!WillReturnAA || !WillReturnAA->isAssumedWillReturn())
      return false;

    // FIXME: Prohibit any recursion for now.
    if (ICS.hasFnAttr(Attribute::NoRecurse))
      return true;

    auto *NoRecurseAA = A.getAAFor<AANoRecurse>(*this, I);
    return NoRecurseAA && NoRecurseAA->isAssumedNoRecurse();
  };

  if (!A.checkForAllCallLikeInstructions(F, CheckForWillReturn, *this,
                                         InfoCache))
    return indicatePessimisticFixpoint();

  return ChangeStatus::UNCHANGED;
}

/// ------------------------ NoAlias Argument Attribute ------------------------

struct AANoAliasImpl : AANoAlias, BooleanState {
  IRPositionConstructorForward(AANoAliasImpl, AANoAlias);

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  const std::string getAsStr() const override {
    return getAssumed() ? "noalias" : "may-alias";
  }

  /// See AANoAlias::isAssumedNoAlias().
  bool isAssumedNoAlias() const override { return getAssumed(); }

  /// See AANoAlias::isKnowndNoAlias().
  bool isKnownNoAlias() const override { return getKnown(); }
};

/// NoAlias attribute for function return value.
struct AANoAliasReturned : AANoAliasImpl {

  AANoAliasReturned(Function &F) : AANoAliasImpl(F, IRP_RETURNED) {}

  /// See AbstractAttriubute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    Function &F = getAnchorScope();

    // Already noalias.
    if (F.returnDoesNotAlias()) {
      indicateOptimisticFixpoint();
      return;
    }
  }

  /// See AbstractAttribute::updateImpl(...).
  virtual ChangeStatus updateImpl(Attributor &A,
                                  InformationCache &InfoCache) override;
};

ChangeStatus AANoAliasReturned::updateImpl(Attributor &A,
                                           InformationCache &InfoCache) {
  Function &F = getAnchorScope();

  auto *AARetValImpl = A.getAAFor<AAReturnedValuesImpl>(*this, F);
  if (!AARetValImpl)
    return indicatePessimisticFixpoint();

  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> Pred =
      [&](Value &RV, const SmallPtrSetImpl<ReturnInst *> &RetInsts) -> bool {
    if (Constant *C = dyn_cast<Constant>(&RV))
      if (C->isNullValue() || isa<UndefValue>(C))
        return true;

    /// For now, we can only deduce noalias if we have call sites.
    /// FIXME: add more support.
    ImmutableCallSite ICS(&RV);
    if (!ICS)
      return false;

    auto *NoAliasAA = A.getAAFor<AANoAlias>(*this, RV);

    if (!ICS.returnDoesNotAlias() &&
        (!NoAliasAA || !NoAliasAA->isAssumedNoAlias()))
      return false;

    /// FIXME: We can improve capture check in two ways:
    /// 1. Use the AANoCapture facilities.
    /// 2. Use the location of return insts for escape queries.
    if (PointerMayBeCaptured(&RV, /* ReturnCaptures */ false,
                             /* StoreCaptures */ true))
      return false;

    return true;
  };

  if (!AARetValImpl->checkForallReturnedValues(Pred))
    return indicatePessimisticFixpoint();

  return ChangeStatus::UNCHANGED;
}

/// -------------------AAIsDead Function Attribute-----------------------

struct AAIsDeadImpl : public AAIsDead, BooleanState {
  IRPositionConstructorForward(AAIsDeadImpl, AAIsDead);

  void initialize(Attributor &A, InformationCache &InfoCache) override {
    Function &F = getAnchorScope();

    ToBeExploredPaths.insert(&(F.getEntryBlock().front()));
    AssumedLiveBlocks.insert(&(F.getEntryBlock()));
    for (size_t i = 0; i < ToBeExploredPaths.size(); ++i)
      if (const Instruction *NextNoReturnI =
              findNextNoReturn(A, ToBeExploredPaths[i]))
        NoReturnCalls.insert(NextNoReturnI);
  }

  /// Find the next assumed noreturn instruction in the block of \p I starting
  /// from, thus including, \p I.
  ///
  /// The caller is responsible to monitor the ToBeExploredPaths set as new
  /// instructions discovered in other basic block will be placed in there.
  ///
  /// \returns The next assumed noreturn instructions in the block of \p I
  ///          starting from, thus including, \p I.
  const Instruction *findNextNoReturn(Attributor &A, const Instruction *I);

  const std::string getAsStr() const override {
    return "LiveBBs(" + std::to_string(AssumedLiveBlocks.size()) + "/" +
           std::to_string(getAnchorScope().size()) + ")";
  }

  /// See AbstractAttribute::manifest(...).
  ChangeStatus manifest(Attributor &A) override {
    assert(getState().isValidState() &&
           "Attempted to manifest an invalid state!");

    ChangeStatus HasChanged = ChangeStatus::UNCHANGED;
    const Function &F = getAnchorScope();

    // Flag to determine if we can change an invoke to a call assuming the callee
    // is nounwind. This is not possible if the personality of the function allows
    // to catch asynchronous exceptions.
    bool Invoke2CallAllowed = !mayCatchAsynchronousExceptions(F);

    for (const Instruction *NRC : NoReturnCalls) {
      Instruction *I = const_cast<Instruction *>(NRC);
      BasicBlock *BB = I->getParent();
      Instruction *SplitPos = I->getNextNode();

      if (auto *II = dyn_cast<InvokeInst>(I)) {
        // If we keep the invoke the split position is at the beginning of the
        // normal desitination block (it invokes a noreturn function after all).
        BasicBlock *NormalDestBB = II->getNormalDest();
        SplitPos = &NormalDestBB->front();

        /// Invoke is replaced with a call and unreachable is placed after it if
        /// the callee is nounwind and noreturn. Otherwise, we keep the invoke
        /// and only place an unreachable in the normal successor.
        if (Invoke2CallAllowed) {
          if (Function *Callee = II->getCalledFunction()) {
            auto *AANoUnw = A.getAAFor<AANoUnwind>(*this, *Callee);
            if (Callee->hasFnAttribute(Attribute::NoUnwind) ||
                (AANoUnw && AANoUnw->isAssumedNoUnwind())) {
              LLVM_DEBUG(dbgs()
                         << "[AAIsDead] Replace invoke with call inst\n");
              // We do not need an invoke (II) but instead want a call followed
              // by an unreachable. However, we do not remove II as other
              // abstract attributes might have it cached as part of their
              // results. Given that we modify the CFG anyway, we simply keep II
              // around but in a new dead block. To avoid II being live through
              // a different edge we have to ensure the block we place it in is
              // only reached from the current block of II and then not reached
              // at all when we insert the unreachable.
              SplitBlockPredecessors(NormalDestBB, {BB}, ".i2c");
              CallInst *CI = createCallMatchingInvoke(II);
              CI->insertBefore(II);
              CI->takeName(II);
              II->replaceAllUsesWith(CI);
              SplitPos = CI->getNextNode();
            }
          }
        }
      }

      BB = SplitPos->getParent();
      SplitBlock(BB, SplitPos);
      changeToUnreachable(BB->getTerminator(), /* UseLLVMTrap */ false);
      HasChanged = ChangeStatus::CHANGED;
    }

    return HasChanged;
  }

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;

  /// See AAIsDead::isAssumedDead(BasicBlock *).
  bool isAssumedDead(const BasicBlock *BB) const override {
    assert(BB->getParent() == &getAnchorScope() &&
           "BB must be in the same anchor scope function.");

    if (!getAssumed())
      return false;
    return !AssumedLiveBlocks.count(BB);
  }

  /// See AAIsDead::isKnownDead(BasicBlock *).
  bool isKnownDead(const BasicBlock *BB) const override {
    return getKnown() && isAssumedDead(BB);
  }

  /// See AAIsDead::isAssumed(Instruction *I).
  bool isAssumedDead(const Instruction *I) const override {
    assert(I->getParent()->getParent() == &getAnchorScope() &&
           "Instruction must be in the same anchor scope function.");

    if (!getAssumed())
      return false;

    // If it is not in AssumedLiveBlocks then it for sure dead.
    // Otherwise, it can still be after noreturn call in a live block.
    if (!AssumedLiveBlocks.count(I->getParent()))
      return true;

    // If it is not after a noreturn call, than it is live.
    return isAfterNoReturn(I);
  }

  /// See AAIsDead::isKnownDead(Instruction *I).
  bool isKnownDead(const Instruction *I) const override {
    return getKnown() && isAssumedDead(I);
  }

  /// Check if instruction is after noreturn call, in other words, assumed dead.
  bool isAfterNoReturn(const Instruction *I) const;

  /// Determine if \p F might catch asynchronous exceptions.
  static bool mayCatchAsynchronousExceptions(const Function &F) {
    return F.hasPersonalityFn() && !canSimplifyInvokeNoUnwind(&F);
  }

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  /// Collection of to be explored paths.
  SmallSetVector<const Instruction *, 8> ToBeExploredPaths;

  /// Collection of all assumed live BasicBlocks.
  DenseSet<const BasicBlock *> AssumedLiveBlocks;

  /// Collection of calls with noreturn attribute, assumed or knwon.
  SmallSetVector<const Instruction *, 4> NoReturnCalls;
};

struct AAIsDeadFunction final : public AAIsDeadImpl {
  AAIsDeadFunction(Function &F) : AAIsDeadImpl(F, IRP_FUNCTION) {}
};

bool AAIsDeadImpl::isAfterNoReturn(const Instruction *I) const {
  const Instruction *PrevI = I->getPrevNode();
  while (PrevI) {
    if (NoReturnCalls.count(PrevI))
      return true;
    PrevI = PrevI->getPrevNode();
  }
  return false;
}

const Instruction *AAIsDeadImpl::findNextNoReturn(Attributor &A,
                                                  const Instruction *I) {
  const BasicBlock *BB = I->getParent();
  const Function &F = *BB->getParent();

  // Flag to determine if we can change an invoke to a call assuming the callee
  // is nounwind. This is not possible if the personality of the function allows
  // to catch asynchronous exceptions.
  bool Invoke2CallAllowed = !mayCatchAsynchronousExceptions(F);

  // TODO: We should have a function that determines if an "edge" is dead.
  //       Edges could be from an instruction to the next or from a terminator
  //       to the successor. For now, we need to special case the unwind block
  //       of InvokeInst below.

  while (I) {
    ImmutableCallSite ICS(I);

    if (ICS) {
      // Regarless of the no-return property of an invoke instruction we only
      // learn that the regular successor is not reachable through this
      // instruction but the unwind block might still be.
      if (auto *Invoke = dyn_cast<InvokeInst>(I)) {
        // Use nounwind to justify the unwind block is dead as well.
        auto *AANoUnw = A.getAAFor<AANoUnwind>(*this, *Invoke);
        if (!Invoke2CallAllowed ||
            (!AANoUnw || !AANoUnw->isAssumedNoUnwind())) {
          AssumedLiveBlocks.insert(Invoke->getUnwindDest());
          ToBeExploredPaths.insert(&Invoke->getUnwindDest()->front());
        }
      }

      auto *NoReturnAA = A.getAAFor<AANoReturn>(*this, *I);
      if (ICS.hasFnAttr(Attribute::NoReturn) ||
          (NoReturnAA && NoReturnAA->isAssumedNoReturn()))
        return I;
    }

    I = I->getNextNode();
  }

  // get new paths (reachable blocks).
  for (const BasicBlock *SuccBB : successors(BB)) {
    AssumedLiveBlocks.insert(SuccBB);
    ToBeExploredPaths.insert(&SuccBB->front());
  }

  // No noreturn instruction found.
  return nullptr;
}

ChangeStatus AAIsDeadImpl::updateImpl(Attributor &A,
                                      InformationCache &InfoCache) {
  // Temporary collection to iterate over existing noreturn instructions. This
  // will alow easier modification of NoReturnCalls collection
  SmallVector<const Instruction *, 8> NoReturnChanged;
  ChangeStatus Status = ChangeStatus::UNCHANGED;

  for (const Instruction *I : NoReturnCalls)
    NoReturnChanged.push_back(I);

  for (const Instruction *I : NoReturnChanged) {
    size_t Size = ToBeExploredPaths.size();

    const Instruction *NextNoReturnI = findNextNoReturn(A, I);
    if (NextNoReturnI != I) {
      Status = ChangeStatus::CHANGED;
      NoReturnCalls.remove(I);
      if (NextNoReturnI)
        NoReturnCalls.insert(NextNoReturnI);
    }

    // Explore new paths.
    while (Size != ToBeExploredPaths.size()) {
      Status = ChangeStatus::CHANGED;
      if (const Instruction *NextNoReturnI =
              findNextNoReturn(A, ToBeExploredPaths[Size++]))
        NoReturnCalls.insert(NextNoReturnI);
    }
  }

  LLVM_DEBUG(
      dbgs() << "[AAIsDead] AssumedLiveBlocks: " << AssumedLiveBlocks.size()
             << " Total number of blocks: " << getAnchorScope().size() << "\n");

  return Status;
}

/// -------------------- Dereferenceable Argument Attribute --------------------

struct DerefState : AbstractState {

  /// State representing for dereferenceable bytes.
  IntegerState DerefBytesState;

  /// State representing that whether the value is nonnull or global.
  IntegerState NonNullGlobalState;

  /// Bits encoding for NonNullGlobalState.
  enum {
    DEREF_NONNULL = 1 << 0,
    DEREF_GLOBAL = 1 << 1,
  };

  /// See AbstractState::isValidState()
  bool isValidState() const override { return DerefBytesState.isValidState(); }

  /// See AbstractState::isAtFixpoint()
  bool isAtFixpoint() const override {
    return !isValidState() || (DerefBytesState.isAtFixpoint() &&
                               NonNullGlobalState.isAtFixpoint());
  }

  /// See AbstractState::indicateOptimisticFixpoint(...)
  ChangeStatus indicateOptimisticFixpoint() override {
    DerefBytesState.indicateOptimisticFixpoint();
    NonNullGlobalState.indicateOptimisticFixpoint();
    return ChangeStatus::UNCHANGED;
  }

  /// See AbstractState::indicatePessimisticFixpoint(...)
  ChangeStatus indicatePessimisticFixpoint() override {
    DerefBytesState.indicatePessimisticFixpoint();
    NonNullGlobalState.indicatePessimisticFixpoint();
    return ChangeStatus::CHANGED;
  }

  /// Update known dereferenceable bytes.
  void takeKnownDerefBytesMaximum(uint64_t Bytes) {
    DerefBytesState.takeKnownMaximum(Bytes);
  }

  /// Update assumed dereferenceable bytes.
  void takeAssumedDerefBytesMinimum(uint64_t Bytes) {
    DerefBytesState.takeAssumedMinimum(Bytes);
  }

  /// Update assumed NonNullGlobalState
  void updateAssumedNonNullGlobalState(bool IsNonNull, bool IsGlobal) {
    if (!IsNonNull)
      NonNullGlobalState.removeAssumedBits(DEREF_NONNULL);
    if (!IsGlobal)
      NonNullGlobalState.removeAssumedBits(DEREF_GLOBAL);
  }

  /// Equality for DerefState.
  bool operator==(const DerefState &R) {
    return this->DerefBytesState == R.DerefBytesState &&
           this->NonNullGlobalState == R.NonNullGlobalState;
  }
};

struct AADereferenceableImpl : AADereferenceable, DerefState {
  IRPositionConstructorForward(AADereferenceableImpl, AADereferenceable);

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  /// See AADereferenceable::getAssumedDereferenceableBytes().
  uint32_t getAssumedDereferenceableBytes() const override {
    return DerefBytesState.getAssumed();
  }

  /// See AADereferenceable::getKnownDereferenceableBytes().
  uint32_t getKnownDereferenceableBytes() const override {
    return DerefBytesState.getKnown();
  }

  // Helper function for syncing nonnull state.
  void syncNonNull(const AANonNull *NonNullAA) {
    if (!NonNullAA) {
      NonNullGlobalState.removeAssumedBits(DEREF_NONNULL);
      return;
    }

    if (NonNullAA->isKnownNonNull())
      NonNullGlobalState.addKnownBits(DEREF_NONNULL);

    if (!NonNullAA->isAssumedNonNull())
      NonNullGlobalState.removeAssumedBits(DEREF_NONNULL);
  }

  /// See AADereferenceable::isAssumedGlobal().
  bool isAssumedGlobal() const override {
    return NonNullGlobalState.isAssumed(DEREF_GLOBAL);
  }

  /// See AADereferenceable::isKnownGlobal().
  bool isKnownGlobal() const override {
    return NonNullGlobalState.isKnown(DEREF_GLOBAL);
  }

  /// See AADereferenceable::isAssumedNonNull().
  bool isAssumedNonNull() const override {
    return NonNullGlobalState.isAssumed(DEREF_NONNULL);
  }

  /// See AADereferenceable::isKnownNonNull().
  bool isKnownNonNull() const override {
    return NonNullGlobalState.isKnown(DEREF_NONNULL);
  }

  void getDeducedAttributes(LLVMContext &Ctx,
                            SmallVectorImpl<Attribute> &Attrs) const override {
    // TODO: Add *_globally support
    if (isAssumedNonNull())
      Attrs.emplace_back(Attribute::getWithDereferenceableBytes(
          Ctx, getAssumedDereferenceableBytes()));
    else
      Attrs.emplace_back(Attribute::getWithDereferenceableOrNullBytes(
          Ctx, getAssumedDereferenceableBytes()));
  }
  uint64_t computeAssumedDerefenceableBytes(Attributor &A, Value &V,
                                            bool &IsNonNull, bool &IsGlobal);

  void initialize(Attributor &A, InformationCache &InfoCache) override {
    Function &F = getAnchorScope();
    unsigned AttrIdx = getIRPosition().getAttrIdx();

    for (Attribute::AttrKind AK :
         {Attribute::Dereferenceable, Attribute::DereferenceableOrNull})
      if (F.getAttributes().hasAttribute(AttrIdx, AK))
        takeKnownDerefBytesMaximum(F.getAttribute(AttrIdx, AK).getValueAsInt());
  }

  /// See AbstractAttribute::getAsStr().
  const std::string getAsStr() const override {
    if (!getAssumedDereferenceableBytes())
      return "unknown-dereferenceable";
    return std::string("dereferenceable") +
           (isAssumedNonNull() ? "" : "_or_null") +
           (isAssumedGlobal() ? "_globally" : "") + "<" +
           std::to_string(getKnownDereferenceableBytes()) + "-" +
           std::to_string(getAssumedDereferenceableBytes()) + ">";
  }
};

struct AADereferenceableReturned : AADereferenceableImpl {
  AADereferenceableReturned(Function &F)
      : AADereferenceableImpl(F, IRP_RETURNED) {}

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

// Helper function that returns dereferenceable bytes.
static uint64_t calcDifferenceIfBaseIsNonNull(int64_t DerefBytes,
                                              int64_t Offset, bool IsNonNull) {
  if (!IsNonNull)
    return 0;
  return std::max((int64_t)0, DerefBytes - Offset);
}

uint64_t AADereferenceableImpl::computeAssumedDerefenceableBytes(
    Attributor &A, Value &V, bool &IsNonNull, bool &IsGlobal) {
  // TODO: Tracking the globally flag.
  IsGlobal = false;

  // First, we try to get information about V from Attributor.
  if (auto *DerefAA = A.getAAFor<AADereferenceable>(*this, V)) {
    IsNonNull &= DerefAA->isAssumedNonNull();
    return DerefAA->getAssumedDereferenceableBytes();
  }

  // Otherwise, we try to compute assumed bytes from base pointer.
  const DataLayout &DL = getAnchorScope().getParent()->getDataLayout();
  unsigned IdxWidth =
      DL.getIndexSizeInBits(V.getType()->getPointerAddressSpace());
  APInt Offset(IdxWidth, 0);
  Value *Base = V.stripAndAccumulateInBoundsConstantOffsets(DL, Offset);

  if (auto *BaseDerefAA = A.getAAFor<AADereferenceable>(*this, *Base)) {
    IsNonNull &= Offset != 0;
    return calcDifferenceIfBaseIsNonNull(
        BaseDerefAA->getAssumedDereferenceableBytes(), Offset.getSExtValue(),
        Offset != 0 || BaseDerefAA->isAssumedNonNull());
  }

  // Then, use IR information.

  if (isDereferenceablePointer(Base, Base->getType(), DL))
    return calcDifferenceIfBaseIsNonNull(
        DL.getTypeStoreSize(Base->getType()->getPointerElementType()),
        Offset.getSExtValue(),
        !NullPointerIsDefined(&getAnchorScope(),
                              V.getType()->getPointerAddressSpace()));

  IsNonNull = false;
  return 0;
}

ChangeStatus
AADereferenceableReturned::updateImpl(Attributor &A,
                                      InformationCache &InfoCache) {
  Function &F = getAnchorScope();
  auto BeforeState = static_cast<DerefState>(*this);

  syncNonNull(A.getAAFor<AANonNull>(*this, F));

  auto *AARetVal = A.getAAFor<AAReturnedValues>(*this, F);
  if (!AARetVal)
    return indicatePessimisticFixpoint();

  bool IsNonNull = isAssumedNonNull();
  bool IsGlobal = isAssumedGlobal();

  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> Pred =
      [&](Value &RV, const SmallPtrSetImpl<ReturnInst *> &RetInsts) -> bool {
    takeAssumedDerefBytesMinimum(
        computeAssumedDerefenceableBytes(A, RV, IsNonNull, IsGlobal));
    return isValidState();
  };

  if (AARetVal->checkForallReturnedValues(Pred)) {
    updateAssumedNonNullGlobalState(IsNonNull, IsGlobal);
    return BeforeState == static_cast<DerefState>(*this)
               ? ChangeStatus::UNCHANGED
               : ChangeStatus::CHANGED;
  }
  return indicatePessimisticFixpoint();
}

struct AADereferenceableArgument : AADereferenceableImpl {
  AADereferenceableArgument(Argument &A) : AADereferenceableImpl(A) {}

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

ChangeStatus
AADereferenceableArgument::updateImpl(Attributor &A,
                                      InformationCache &InfoCache) {
  Function &F = getAnchorScope();
  Argument &Arg = cast<Argument>(getAnchorValue());

  auto BeforeState = static_cast<DerefState>(*this);

  unsigned ArgNo = Arg.getArgNo();

  syncNonNull(A.getAAFor<AANonNull>(*this, F, ArgNo));

  bool IsNonNull = isAssumedNonNull();
  bool IsGlobal = isAssumedGlobal();

  // Callback function
  std::function<bool(CallSite)> CallSiteCheck = [&](CallSite CS) -> bool {
    assert(CS && "Sanity check: Call site was not initialized properly!");

    // Check that DereferenceableAA is AADereferenceableCallSiteArgument.
    if (auto *DereferenceableAA =
            A.getAAFor<AADereferenceable>(*this, *CS.getInstruction(), ArgNo)) {
      ImmutableCallSite ICS(
          &DereferenceableAA->getIRPosition().getAnchorValue());
      if (ICS && CS.getInstruction() == ICS.getInstruction()) {
        takeAssumedDerefBytesMinimum(
            DereferenceableAA->getAssumedDereferenceableBytes());
        IsNonNull &= DereferenceableAA->isAssumedNonNull();
        IsGlobal &= DereferenceableAA->isAssumedGlobal();
        return isValidState();
      }
    }

    takeAssumedDerefBytesMinimum(computeAssumedDerefenceableBytes(
        A, *CS.getArgOperand(ArgNo), IsNonNull, IsGlobal));

    return isValidState();
  };

  if (!A.checkForAllCallSites(F, CallSiteCheck, *this, true))
    return indicatePessimisticFixpoint();

  updateAssumedNonNullGlobalState(IsNonNull, IsGlobal);

  return BeforeState == static_cast<DerefState>(*this) ? ChangeStatus::UNCHANGED
                                                       : ChangeStatus::CHANGED;
}

/// Dereferenceable attribute for a call site argument.
struct AADereferenceableCallSiteArgument : AADereferenceableImpl {

  /// See AADereferenceableImpl::AADereferenceableImpl(...).
  AADereferenceableCallSiteArgument(Instruction &I, unsigned ArgNo)
      : AADereferenceableImpl(CallSite(&I).getArgOperand(ArgNo), I, ArgNo) {}

  /// See AbstractAttribute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    CallSite CS(&getAnchorValue());
    if (CS.paramHasAttr(getArgNo(), Attribute::Dereferenceable))
      takeKnownDerefBytesMaximum(CS.getDereferenceableBytes(getArgNo()));

    if (CS.paramHasAttr(getArgNo(), Attribute::DereferenceableOrNull))
      takeKnownDerefBytesMaximum(CS.getDereferenceableOrNullBytes(getArgNo()));
  }

  /// See AbstractAttribute::updateImpl(Attributor &A).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

ChangeStatus
AADereferenceableCallSiteArgument::updateImpl(Attributor &A,
                                              InformationCache &InfoCache) {
  // NOTE: Never look at the argument of the callee in this method.
  //       If we do this, "dereferenceable" is always deduced because of the
  //       assumption.

  Value &V = *getAssociatedValue();

  auto BeforeState = static_cast<DerefState>(*this);

  syncNonNull(A.getAAFor<AANonNull>(*this, getAnchorValue(), getArgNo()));
  bool IsNonNull = isAssumedNonNull();
  bool IsGlobal = isKnownGlobal();

  takeAssumedDerefBytesMinimum(
      computeAssumedDerefenceableBytes(A, V, IsNonNull, IsGlobal));
  updateAssumedNonNullGlobalState(IsNonNull, IsGlobal);

  return BeforeState == static_cast<DerefState>(*this) ? ChangeStatus::UNCHANGED
                                                       : ChangeStatus::CHANGED;
}

// ------------------------ Align Argument Attribute ------------------------

struct AAAlignImpl : AAAlign, IntegerState {
  IRPositionConstructorForward(AAAlignImpl, AAAlign);

  // Max alignemnt value allowed in IR
  static const unsigned MAX_ALIGN = 1U << 29;

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  virtual const std::string getAsStr() const override {
    return getAssumedAlign() ? ("align<" + std::to_string(getKnownAlign()) +
                                "-" + std::to_string(getAssumedAlign()) + ">")
                             : "unknown-align";
  }

  /// See AAAlign::getAssumedAlign().
  unsigned getAssumedAlign() const override { return getAssumed(); }

  /// See AAAlign::getKnownAlign().
  unsigned getKnownAlign() const override { return getKnown(); }

  /// See AbstractAttriubute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    takeAssumedMinimum(MAX_ALIGN);

    Function &F = getAnchorScope();

    unsigned AttrIdx = getIRPosition().getAttrIdx();

    // Already the function has align attribute on return value or argument.
    if (F.getAttributes().hasAttribute(AttrIdx, Attribute::Alignment))
      addKnownBits(
          F.getAttribute(AttrIdx, Attribute::Alignment).getAlignment());
  }

  /// See AbstractAttribute::getDeducedAttributes
  virtual void
  getDeducedAttributes(LLVMContext &Ctx,
                       SmallVectorImpl<Attribute> &Attrs) const override {
    Attrs.emplace_back(Attribute::getWithAlignment(Ctx, getAssumedAlign()));
  }
};

/// Align attribute for function return value.
struct AAAlignReturned final : AAAlignImpl {

  AAAlignReturned(Function &F) : AAAlignImpl(F, IRP_RETURNED) {}

  /// See AbstractAttribute::updateImpl(...).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

ChangeStatus AAAlignReturned::updateImpl(Attributor &A,
                                         InformationCache &InfoCache) {
  Function &F = getAnchorScope();
  auto *AARetValImpl = A.getAAFor<AAReturnedValuesImpl>(*this, F);
  if (!AARetValImpl)
    return indicatePessimisticFixpoint();

  // Currently, align<n> is deduced if alignments in return values are assumed
  // as greater than n. We reach pessimistic fixpoint if any of the return value
  // wouldn't have align. If no assumed state was used for reasoning, an
  // optimistic fixpoint is reached earlier.

  base_t BeforeState = getAssumed();
  std::function<bool(Value &, const SmallPtrSetImpl<ReturnInst *> &)> Pred =
      [&](Value &RV, const SmallPtrSetImpl<ReturnInst *> &RetInsts) -> bool {
    auto *AlignAA = A.getAAFor<AAAlign>(*this, RV);

    if (AlignAA)
      takeAssumedMinimum(AlignAA->getAssumedAlign());
    else
      // Use IR information.
      takeAssumedMinimum(RV.getPointerAlignment(
          getAnchorScope().getParent()->getDataLayout()));

    return isValidState();
  };

  if (!AARetValImpl->checkForallReturnedValues(Pred))
    return indicatePessimisticFixpoint();

  return (getAssumed() != BeforeState) ? ChangeStatus::CHANGED
                                       : ChangeStatus::UNCHANGED;
}

/// Align attribute for function argument.
struct AAAlignArgument final : AAAlignImpl {

  AAAlignArgument(Argument &A) : AAAlignImpl(A) {}

  /// See AbstractAttribute::updateImpl(...).
  virtual ChangeStatus updateImpl(Attributor &A,
                                  InformationCache &InfoCache) override;
};

ChangeStatus AAAlignArgument::updateImpl(Attributor &A,
                                         InformationCache &InfoCache) {

  Function &F = getAnchorScope();
  Argument &Arg = cast<Argument>(getAnchorValue());

  unsigned ArgNo = Arg.getArgNo();
  const DataLayout &DL = F.getParent()->getDataLayout();

  auto BeforeState = getAssumed();

  // Callback function
  std::function<bool(CallSite)> CallSiteCheck = [&](CallSite CS) {
    assert(CS && "Sanity check: Call site was not initialized properly!");

    auto *AlignAA = A.getAAFor<AAAlign>(*this, *CS.getInstruction(), ArgNo);

    // Check that AlignAA is AAAlignCallSiteArgument.
    if (AlignAA) {
      ImmutableCallSite ICS(&AlignAA->getIRPosition().getAnchorValue());
      if (ICS && CS.getInstruction() == ICS.getInstruction()) {
        takeAssumedMinimum(AlignAA->getAssumedAlign());
        return isValidState();
      }
    }

    Value *V = CS.getArgOperand(ArgNo);
    takeAssumedMinimum(V->getPointerAlignment(DL));
    return isValidState();
  };

  if (!A.checkForAllCallSites(F, CallSiteCheck, *this, true))
    indicatePessimisticFixpoint();

  return BeforeState == getAssumed() ? ChangeStatus::UNCHANGED
                                     : ChangeStatus ::CHANGED;
}

struct AAAlignCallSiteArgument final : AAAlignImpl {

  /// See AANonNullImpl::AANonNullImpl(...).
  AAAlignCallSiteArgument(Instruction &I, unsigned ArgNo)
      : AAAlignImpl(CallSite(&I).getArgOperand(ArgNo), I, ArgNo) {}

  /// See AbstractAttribute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    CallSite CS(&getAnchorValue());
    takeKnownMaximum(getAssociatedValue()->getPointerAlignment(
        getAnchorScope().getParent()->getDataLayout()));
  }

  /// See AbstractAttribute::updateImpl(Attributor &A).
  ChangeStatus updateImpl(Attributor &A, InformationCache &InfoCache) override;
};

ChangeStatus AAAlignCallSiteArgument::updateImpl(Attributor &A,
                                                 InformationCache &InfoCache) {
  // NOTE: Never look at the argument of the callee in this method.
  //       If we do this, "align" is always deduced because of the assumption.

  auto BeforeState = getAssumed();

  Value &V = *getAssociatedValue();

  auto *AlignAA = A.getAAFor<AAAlign>(*this, V);

  if (AlignAA)
    takeAssumedMinimum(AlignAA->getAssumedAlign());
  else
    indicatePessimisticFixpoint();

  return BeforeState == getAssumed() ? ChangeStatus::UNCHANGED
                                     : ChangeStatus::CHANGED;
}

/// ------------------ Function No-Return Attribute ----------------------------
struct AANoReturnImpl : public AANoReturn, BooleanState {
  IRPositionConstructorForward(AANoReturnImpl, AANoReturn);

  /// See AbstractAttribute::getState()
  /// {
  AbstractState &getState() override { return *this; }
  const AbstractState &getState() const override { return *this; }
  /// }

  /// Return true if the underlying object is known to never return.
  bool isKnownNoReturn() const override { return getKnown(); }

  /// Return true if the underlying object is assumed to never return.
  bool isAssumedNoReturn() const override { return getAssumed(); }

  /// See AbstractAttribute::getAsStr().
  const std::string getAsStr() const override {
    return getAssumed() ? "noreturn" : "may-return";
  }

  /// See AbstractAttribute::initialize(...).
  void initialize(Attributor &A, InformationCache &InfoCache) override {
    Function &F = getAnchorScope();
    if (F.hasFnAttribute(getAttrKind()))
      indicateOptimisticFixpoint();
  }

  /// See AbstractAttribute::updateImpl(Attributor &A).
  virtual ChangeStatus updateImpl(Attributor &A,
                                  InformationCache &InfoCache) override {
    const Function &F = getAnchorScope();
    auto CheckForNoReturn = [](Instruction &) { return false; };
    if (!A.checkForAllInstructions(F, CheckForNoReturn, *this, InfoCache,
                                   {(unsigned)Instruction::Ret}))
      return indicatePessimisticFixpoint();
    return ChangeStatus::UNCHANGED;
  }
};

struct AANoReturnFunction final : AANoReturnImpl {
  AANoReturnFunction(Function &F) : AANoReturnImpl(F, IRP_FUNCTION) {}
};

/// ----------------------------------------------------------------------------
///                               Attributor
/// ----------------------------------------------------------------------------

bool Attributor::checkForAllCallSites(Function &F,
                                      std::function<bool(CallSite)> &Pred,
                                      AbstractAttribute &QueryingAA,
                                      bool RequireAllCallSites) {
  // We can try to determine information from
  // the call sites. However, this is only possible all call sites are known,
  // hence the function has internal linkage.
  if (RequireAllCallSites && !F.hasInternalLinkage()) {
    LLVM_DEBUG(
        dbgs()
        << "Attributor: Function " << F.getName()
        << " has no internal linkage, hence not all call sites are known\n");
    return false;
  }

  for (const Use &U : F.uses()) {
    Instruction *I = cast<Instruction>(U.getUser());
    Function *AnchorValue = I->getParent()->getParent();

    auto *LivenessAA = getAAFor<AAIsDead>(QueryingAA, *AnchorValue);

    // Skip dead calls.
    if (LivenessAA && LivenessAA->isAssumedDead(I))
      continue;

    CallSite CS(U.getUser());
    if (!CS || !CS.isCallee(&U) || !CS.getCaller()->hasExactDefinition()) {
      if (!RequireAllCallSites)
        continue;

      LLVM_DEBUG(dbgs() << "Attributor: User " << *U.getUser()
                        << " is an invalid use of " << F.getName() << "\n");
      return false;
    }

    if (Pred(CS))
      continue;

    LLVM_DEBUG(dbgs() << "Attributor: Call site callback failed for "
                      << *CS.getInstruction() << "\n");
    return false;
  }

  return true;
}

bool Attributor::checkForAllInstructions(
    const Function &F, const llvm::function_ref<bool(Instruction &)> &Pred,
    AbstractAttribute &QueryingAA, InformationCache &InfoCache,
    const ArrayRef<unsigned> &Opcodes) {

  auto *LivenessAA = getAAFor<AAIsDead>(QueryingAA, F);

  auto &OpcodeInstMap = InfoCache.getOpcodeInstMapForFunction(F);
  for (unsigned Opcode : Opcodes) {
    for (Instruction *I : OpcodeInstMap[Opcode]) {
      // Skip dead instructions.
      if (LivenessAA && LivenessAA->isAssumedDead(I))
        continue;

      if (!Pred(*I))
        return false;
    }
  }

  return true;
}

bool Attributor::checkForAllReadWriteInstructions(
    const Function &F, const llvm::function_ref<bool(Instruction &)> &Pred,
    AbstractAttribute &QueryingAA, InformationCache &InfoCache) {

  auto *LivenessAA = getAAFor<AAIsDead>(QueryingAA, F);

  for (Instruction *I : InfoCache.getReadOrWriteInstsForFunction(F)) {
    // Skip dead instructions.
    if (LivenessAA && LivenessAA->isAssumedDead(I))
      continue;

    if (!Pred(*I))
      return false;
  }

  return true;
}

ChangeStatus Attributor::run(InformationCache &InfoCache) {
  // Initialize all abstract attributes.
  for (AbstractAttribute *AA : AllAbstractAttributes)
    AA->initialize(*this, InfoCache);

  LLVM_DEBUG(dbgs() << "[Attributor] Identified and initialized "
                    << AllAbstractAttributes.size()
                    << " abstract attributes.\n");

  // Now that all abstract attributes are collected and initialized we start
  // the abstract analysis.

  unsigned IterationCounter = 1;

  SmallVector<AbstractAttribute *, 64> ChangedAAs;
  SetVector<AbstractAttribute *> Worklist;
  Worklist.insert(AllAbstractAttributes.begin(), AllAbstractAttributes.end());

  do {
    LLVM_DEBUG(dbgs() << "\n\n[Attributor] #Iteration: " << IterationCounter
                      << ", Worklist size: " << Worklist.size() << "\n");

    // Add all abstract attributes that are potentially dependent on one that
    // changed to the work list.
    for (AbstractAttribute *ChangedAA : ChangedAAs) {
      auto &QuerriedAAs = QueryMap[ChangedAA];
      Worklist.insert(QuerriedAAs.begin(), QuerriedAAs.end());
    }

    // Reset the changed set.
    ChangedAAs.clear();

    // Update all abstract attribute in the work list and record the ones that
    // changed.
    for (AbstractAttribute *AA : Worklist)
      if (AA->update(*this, InfoCache) == ChangeStatus::CHANGED)
        ChangedAAs.push_back(AA);

    // Reset the work list and repopulate with the changed abstract attributes.
    // Note that dependent ones are added above.
    Worklist.clear();
    Worklist.insert(ChangedAAs.begin(), ChangedAAs.end());

  } while (!Worklist.empty() && ++IterationCounter < MaxFixpointIterations);

  LLVM_DEBUG(dbgs() << "\n[Attributor] Fixpoint iteration done after: "
                    << IterationCounter << "/" << MaxFixpointIterations
                    << " iterations\n");

  bool FinishedAtFixpoint = Worklist.empty();

  // Reset abstract arguments not settled in a sound fixpoint by now. This
  // happens when we stopped the fixpoint iteration early. Note that only the
  // ones marked as "changed" *and* the ones transitively depending on them
  // need to be reverted to a pessimistic state. Others might not be in a
  // fixpoint state but we can use the optimistic results for them anyway.
  SmallPtrSet<AbstractAttribute *, 32> Visited;
  for (unsigned u = 0; u < ChangedAAs.size(); u++) {
    AbstractAttribute *ChangedAA = ChangedAAs[u];
    if (!Visited.insert(ChangedAA).second)
      continue;

    AbstractState &State = ChangedAA->getState();
    if (!State.isAtFixpoint()) {
      State.indicatePessimisticFixpoint();

      NumAttributesTimedOut++;
    }

    auto &QuerriedAAs = QueryMap[ChangedAA];
    ChangedAAs.append(QuerriedAAs.begin(), QuerriedAAs.end());
  }

  LLVM_DEBUG({
    if (!Visited.empty())
      dbgs() << "\n[Attributor] Finalized " << Visited.size()
             << " abstract attributes.\n";
  });

  unsigned NumManifested = 0;
  unsigned NumAtFixpoint = 0;
  ChangeStatus ManifestChange = ChangeStatus::UNCHANGED;
  for (AbstractAttribute *AA : AllAbstractAttributes) {
    AbstractState &State = AA->getState();

    // If there is not already a fixpoint reached, we can now take the
    // optimistic state. This is correct because we enforced a pessimistic one
    // on abstract attributes that were transitively dependent on a changed one
    // already above.
    if (!State.isAtFixpoint())
      State.indicateOptimisticFixpoint();

    // If the state is invalid, we do not try to manifest it.
    if (!State.isValidState())
      continue;

    // Manifest the state and record if we changed the IR.
    ChangeStatus LocalChange = AA->manifest(*this);
    ManifestChange = ManifestChange | LocalChange;

    NumAtFixpoint++;
    NumManifested += (LocalChange == ChangeStatus::CHANGED);
  }

  (void)NumManifested;
  (void)NumAtFixpoint;
  LLVM_DEBUG(dbgs() << "\n[Attributor] Manifested " << NumManifested
                    << " arguments while " << NumAtFixpoint
                    << " were in a valid fixpoint state\n");

  // If verification is requested, we finished this run at a fixpoint, and the
  // IR was changed, we re-run the whole fixpoint analysis, starting at
  // re-initialization of the arguments. This re-run should not result in an IR
  // change. Though, the (virtual) state of attributes at the end of the re-run
  // might be more optimistic than the known state or the IR state if the better
  // state cannot be manifested.
  if (VerifyAttributor && FinishedAtFixpoint &&
      ManifestChange == ChangeStatus::CHANGED) {
    VerifyAttributor = false;
    ChangeStatus VerifyStatus = run(InfoCache);
    if (VerifyStatus != ChangeStatus::UNCHANGED)
      llvm_unreachable(
          "Attributor verification failed, re-run did result in an IR change "
          "even after a fixpoint was reached in the original run. (False "
          "positives possible!)");
    VerifyAttributor = true;
  }

  NumAttributesManifested += NumManifested;
  NumAttributesValidFixpoint += NumAtFixpoint;

  return ManifestChange;
}

/// Helper function that checks if an abstract attribute of type \p AAType
/// should be created for \p V (with argument number \p ArgNo) and if so creates
/// and registers it with the Attributor \p A.
///
/// This method will look at the provided whitelist. If one is given and the
/// kind \p AAType::ID is not contained, no abstract attribute is created.
///
/// \returns The created abstract argument, or nullptr if none was created.
template <typename AAType, typename ValueType, typename... ArgsTy>
static AAType *checkAndRegisterAA(const Function &F, Attributor &A,
                                  DenseSet<const char *> *Whitelist,
                                  ValueType &V, int ArgNo, ArgsTy... Args) {
  if (Whitelist && !Whitelist->count(&AAType::ID))
    return nullptr;

  return &A.registerAA<AAType>(*new AAType(V, Args...), ArgNo);
}

void Attributor::identifyDefaultAbstractAttributes(
    Function &F, InformationCache &InfoCache,
    DenseSet<const char *> *Whitelist) {

  // Check for dead BasicBlocks in every function.
  // We need dead instruction detection because we do not want to deal with
  // broken IR in which SSA rules do not apply.
  checkAndRegisterAA<AAIsDeadFunction>(F, *this, /* Whitelist */ nullptr, F,
                                       -1);

  // Every function might be "will-return".
  checkAndRegisterAA<AAWillReturnFunction>(F, *this, Whitelist, F, -1);

  // Every function can be nounwind.
  checkAndRegisterAA<AANoUnwindFunction>(F, *this, Whitelist, F, -1);

  // Every function might be marked "nosync"
  checkAndRegisterAA<AANoSyncFunction>(F, *this, Whitelist, F, -1);

  // Every function might be "no-free".
  checkAndRegisterAA<AANoFreeFunction>(F, *this, Whitelist, F, -1);

  // Every function might be "no-return".
  checkAndRegisterAA<AANoReturnFunction>(F, *this, Whitelist, F, -1);

  // Return attributes are only appropriate if the return type is non void.
  Type *ReturnType = F.getReturnType();
  if (!ReturnType->isVoidTy()) {
    // Argument attribute "returned" --- Create only one per function even
    // though it is an argument attribute.
    checkAndRegisterAA<AAReturnedValuesFunction>(F, *this, Whitelist, F, -1);

    if (ReturnType->isPointerTy()) {
      // Every function with pointer return type might be marked align.
      checkAndRegisterAA<AAAlignReturned>(F, *this, Whitelist, F, -1);

      // Every function with pointer return type might be marked nonnull.
      checkAndRegisterAA<AANonNullReturned>(F, *this, Whitelist, F, -1);

      // Every function with pointer return type might be marked noalias.
      checkAndRegisterAA<AANoAliasReturned>(F, *this, Whitelist, F, -1);

      // Every function with pointer return type might be marked
      // dereferenceable.
      checkAndRegisterAA<AADereferenceableReturned>(F, *this, Whitelist, F, -1);
    }
  }

  for (Argument &Arg : F.args()) {
    if (Arg.getType()->isPointerTy()) {
      // Every argument with pointer type might be marked nonnull.
      checkAndRegisterAA<AANonNullArgument>(F, *this, Whitelist, Arg,
                                            Arg.getArgNo());

      // Every argument with pointer type might be marked dereferenceable.
      checkAndRegisterAA<AADereferenceableArgument>(F, *this, Whitelist, Arg,
                                                    Arg.getArgNo());

      // Every argument with pointer type might be marked align.
      checkAndRegisterAA<AAAlignArgument>(F, *this, Whitelist, Arg,
                                          Arg.getArgNo());
    }
  }

  // Walk all instructions to find more attribute opportunities and also
  // interesting instructions that might be queried by abstract attributes
  // during their initialization or update.
  auto &ReadOrWriteInsts = InfoCache.FuncRWInstsMap[&F];
  auto &InstOpcodeMap = InfoCache.FuncInstOpcodeMap[&F];

  for (Instruction &I : instructions(&F)) {
    bool IsInterestingOpcode = false;

    // To allow easy access to all instructions in a function with a given
    // opcode we store them in the InfoCache. As not all opcodes are interesting
    // to concrete attributes we only cache the ones that are as identified in
    // the following switch.
    // Note: There are no concrete attributes now so this is initially empty.
    switch (I.getOpcode()) {
    default:
      assert((!ImmutableCallSite(&I)) && (!isa<CallBase>(&I)) &&
             "New call site/base instruction type needs to be known int the "
             "attributor.");
      break;
    case Instruction::Call:
    case Instruction::CallBr:
    case Instruction::Invoke:
    case Instruction::CleanupRet:
    case Instruction::CatchSwitch:
    case Instruction::Resume:
    case Instruction::Ret:
      IsInterestingOpcode = true;
    }
    if (IsInterestingOpcode)
      InstOpcodeMap[I.getOpcode()].push_back(&I);
    if (I.mayReadOrWriteMemory())
      ReadOrWriteInsts.push_back(&I);

    CallSite CS(&I);
    if (CS && CS.getCalledFunction()) {
      for (int i = 0, e = CS.getCalledFunction()->arg_size(); i < e; i++) {
        if (!CS.getArgument(i)->getType()->isPointerTy())
          continue;

        // Call site argument attribute "non-null".
        checkAndRegisterAA<AANonNullCallSiteArgument>(F, *this, Whitelist, I, i,
                                                      i);

        // Call site argument attribute "dereferenceable".
        checkAndRegisterAA<AADereferenceableCallSiteArgument>(
            F, *this, Whitelist, I, i, i);

        // Call site argument attribute "align".
        checkAndRegisterAA<AAAlignCallSiteArgument>(F, *this, Whitelist, I, i,
                                                    i);
      }
    }
  }
}

/// Helpers to ease debugging through output streams and print calls.
///
///{
raw_ostream &llvm::operator<<(raw_ostream &OS, ChangeStatus S) {
  return OS << (S == ChangeStatus::CHANGED ? "changed" : "unchanged");
}

raw_ostream &llvm::operator<<(raw_ostream &OS, IRPosition::Kind AP) {
  switch (AP) {
  case IRPosition::IRP_ARGUMENT:
    return OS << "arg";
  case IRPosition::IRP_CALL_SITE_ARGUMENT:
    return OS << "cs_arg";
  case IRPosition::IRP_FUNCTION:
    return OS << "fn";
  case IRPosition::IRP_RETURNED:
    return OS << "fn_ret";
  }
  llvm_unreachable("Unknown attribute position!");
}

raw_ostream &llvm::operator<<(raw_ostream &OS, const IRPosition &Pos) {
  const Value *AV = Pos.getAssociatedValue();
  return OS << "{" << Pos.getPositionKind() << ":"
            << (AV ? AV->getName() : "n/a") << " ["
            << Pos.getAnchorValue().getName() << "@" << Pos.getArgNo() << "]}";
}

raw_ostream &llvm::operator<<(raw_ostream &OS, const AbstractState &S) {
  return OS << (!S.isValidState() ? "top" : (S.isAtFixpoint() ? "fix" : ""));
}

raw_ostream &llvm::operator<<(raw_ostream &OS, const AbstractAttribute &AA) {
  AA.print(OS);
  return OS;
}

void AbstractAttribute::print(raw_ostream &OS) const {
  OS << "[P: " << getIRPosition() << "][" << getAsStr() << "][S: " << getState()
     << "]";
}
///}

/// ----------------------------------------------------------------------------
///                       Pass (Manager) Boilerplate
/// ----------------------------------------------------------------------------

static bool runAttributorOnModule(Module &M) {
  if (DisableAttributor)
    return false;

  LLVM_DEBUG(dbgs() << "[Attributor] Run on module with " << M.size()
                    << " functions.\n");

  // Create an Attributor and initially empty information cache that is filled
  // while we identify default attribute opportunities.
  Attributor A;
  InformationCache InfoCache;

  for (Function &F : M) {
    // TODO: Not all attributes require an exact definition. Find a way to
    //       enable deduction for some but not all attributes in case the
    //       definition might be changed at runtime, see also
    //       http://lists.llvm.org/pipermail/llvm-dev/2018-February/121275.html.
    // TODO: We could always determine abstract attributes and if sufficient
    //       information was found we could duplicate the functions that do not
    //       have an exact definition.
    if (!F.hasExactDefinition()) {
      NumFnWithoutExactDefinition++;
      continue;
    }

    // For now we ignore naked and optnone functions.
    if (F.hasFnAttribute(Attribute::Naked) ||
        F.hasFnAttribute(Attribute::OptimizeNone))
      continue;

    NumFnWithExactDefinition++;

    // Populate the Attributor with abstract attribute opportunities in the
    // function and the information cache with IR information.
    A.identifyDefaultAbstractAttributes(F, InfoCache);
  }

  return A.run(InfoCache) == ChangeStatus::CHANGED;
}

PreservedAnalyses AttributorPass::run(Module &M, ModuleAnalysisManager &AM) {
  if (runAttributorOnModule(M)) {
    // FIXME: Think about passes we will preserve and add them here.
    return PreservedAnalyses::none();
  }
  return PreservedAnalyses::all();
}

namespace {

struct AttributorLegacyPass : public ModulePass {
  static char ID;

  AttributorLegacyPass() : ModulePass(ID) {
    initializeAttributorLegacyPassPass(*PassRegistry::getPassRegistry());
  }

  bool runOnModule(Module &M) override {
    if (skipModule(M))
      return false;
    return runAttributorOnModule(M);
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    // FIXME: Think about passes we will preserve and add them here.
    AU.setPreservesCFG();
  }
};

} // end anonymous namespace

Pass *llvm::createAttributorLegacyPass() { return new AttributorLegacyPass(); }

char AttributorLegacyPass::ID = 0;

const char AAReturnedValues::ID = 0;
const char AANoUnwind::ID = 0;
const char AANoSync::ID = 0;
const char AANoFree::ID = 0;
const char AANonNull::ID = 0;
const char AANoRecurse::ID = 0;
const char AAWillReturn::ID = 0;
const char AANoAlias::ID = 0;
const char AANoReturn::ID = 0;
const char AAIsDead::ID = 0;
const char AADereferenceable::ID = 0;
const char AAAlign::ID = 0;

INITIALIZE_PASS_BEGIN(AttributorLegacyPass, "attributor",
                      "Deduce and propagate attributes", false, false)
INITIALIZE_PASS_END(AttributorLegacyPass, "attributor",
                    "Deduce and propagate attributes", false, false)
