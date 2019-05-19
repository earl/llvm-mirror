; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

; Infinity

define i1 @inf0(double %arg) {
; CHECK-LABEL: @inf0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ogt double %arg, 0x7FF0000000000000
  ret i1 %tmp
}

define i1 @inf1(double %arg) {
; CHECK-LABEL: @inf1(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp ule double %arg, 0x7FF0000000000000
  ret i1 %tmp
}

; Negative infinity

define i1 @ninf0(double %arg) {
; CHECK-LABEL: @ninf0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp olt double %arg, 0xFFF0000000000000
  ret i1 %tmp
}

define i1 @ninf1(double %arg) {
; CHECK-LABEL: @ninf1(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp uge double %arg, 0xFFF0000000000000
  ret i1 %tmp
}

; NaNs

define i1 @nan0(double %arg) {
; CHECK-LABEL: @nan0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ord double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan1(double %arg) {
; CHECK-LABEL: @nan1(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp oeq double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan2(double %arg) {
; CHECK-LABEL: @nan2(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp olt double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan3(double %arg) {
; CHECK-LABEL: @nan3(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp uno double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan4(double %arg) {
; CHECK-LABEL: @nan4(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp une double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan5(double %arg) {
; CHECK-LABEL: @nan5(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp ult double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

; Negative NaN.

define i1 @nnan0(double %arg) {
; CHECK-LABEL: @nnan0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ord double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan1(double %arg) {
; CHECK-LABEL: @nnan1(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp oeq double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan2(double %arg) {
; CHECK-LABEL: @nnan2(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp olt double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan3(double %arg) {
; CHECK-LABEL: @nnan3(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp uno double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan4(double %arg) {
; CHECK-LABEL: @nnan4(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp une double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan5(double %arg) {
; CHECK-LABEL: @nnan5(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp ult double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

; Negative zero.

define i1 @nzero0() {
; CHECK-LABEL: @nzero0(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp oeq double 0.0, -0.0
  ret i1 %tmp
}

define i1 @nzero1() {
; CHECK-LABEL: @nzero1(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ogt double 0.0, -0.0
  ret i1 %tmp
}

; No enlightenment here.

define i1 @one_with_self(double %arg) {
; CHECK-LABEL: @one_with_self(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp one double %arg, %arg
  ret i1 %tmp
}

; These tests choose arbitrarily between float and double,
; and between uge and olt, to give reasonble coverage
; without combinatorial explosion.

declare half @llvm.fabs.f16(half)
declare float @llvm.fabs.f32(float)
declare double @llvm.fabs.f64(double)
declare <2 x float> @llvm.fabs.v2f32(<2 x float>)
declare <3 x float> @llvm.fabs.v3f32(<3 x float>)
declare <2 x double> @llvm.fabs.v2f64(<2 x double>)
declare float @llvm.sqrt.f32(float)
declare double @llvm.powi.f64(double,i32)
declare float @llvm.exp.f32(float)
declare float @llvm.minnum.f32(float, float)
declare <2 x float> @llvm.minnum.v2f32(<2 x float>, <2 x float>)
declare float @llvm.maxnum.f32(float, float)
declare <2 x float> @llvm.maxnum.v2f32(<2 x float>, <2 x float>)
declare float @llvm.maximum.f32(float, float)
declare double @llvm.exp2.f64(double)
declare float @llvm.fma.f32(float,float,float)

declare void @expect_equal(i1,i1)

define i1 @orderedLessZeroTree(float,float,float,float) {
; CHECK-LABEL: @orderedLessZeroTree(
; CHECK-NEXT:    ret i1 true
;
  %square = fmul float %0, %0
  %abs = call float @llvm.fabs.f32(float %1)
  %sqrt = call float @llvm.sqrt.f32(float %2)
  %fma = call float @llvm.fma.f32(float %3, float %3, float %sqrt)
  %div = fdiv float %square, %abs
  %rem = frem float %sqrt, %fma
  %add = fadd float %div, %rem
  %uge = fcmp uge float %add, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroExpExt(float) {
; CHECK-LABEL: @orderedLessZeroExpExt(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = fpext float %a to double
  %uge = fcmp uge double %b, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroExp2Trunc(double) {
; CHECK-LABEL: @orderedLessZeroExp2Trunc(
; CHECK-NEXT:    ret i1 false
;
  %a = call double @llvm.exp2.f64(double %0)
  %b = fptrunc double %a to float
  %olt = fcmp olt float %b, 0.000000e+00
  ret i1 %olt
}

define i1 @orderedLessZeroPowi(double,double) {
; CHECK-LABEL: @orderedLessZeroPowi(
; CHECK-NEXT:    ret i1 false
;
  ; Even constant exponent
  %a = call double @llvm.powi.f64(double %0, i32 2)
  %square = fmul double %1, %1
  ; Odd constant exponent with provably non-negative base
  %b = call double @llvm.powi.f64(double %square, i32 3)
  %c = fadd double %a, %b
  %olt = fcmp olt double %b, 0.000000e+00
  ret i1 %olt
}

define i1 @UIToFP_is_nan_or_positive_or_zero(i32 %x) {
; CHECK-LABEL: @UIToFP_is_nan_or_positive_or_zero(
; CHECK-NEXT:    ret i1 true
;
  %a = uitofp i32 %x to float
  %r = fcmp uge float %a, 0.000000e+00
  ret i1 %r
}

define <2 x i1> @UIToFP_is_nan_or_positive_or_zero_vec(<2 x i32> %x) {
; CHECK-LABEL: @UIToFP_is_nan_or_positive_or_zero_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %a = uitofp <2 x i32> %x to <2 x float>
  %r = fcmp uge <2 x float> %a, zeroinitializer
  ret <2 x i1> %r
}

define i1 @UIToFP_nnan_is_positive_or_zero(i32 %x) {
; CHECK-LABEL: @UIToFP_nnan_is_positive_or_zero(
; CHECK-NEXT:    ret i1 true
;
  %a = uitofp i32 %x to float
  %r = fcmp nnan oge float %a, 0.000000e+00
  ret i1 %r
}

define <2 x i1> @UIToFP_nnan_is_positive_or_zero_vec(<2 x i32> %x) {
; CHECK-LABEL: @UIToFP_nnan_is_positive_or_zero_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %a = uitofp <2 x i32> %x to <2 x float>
  %r = fcmp nnan oge <2 x float> %a, zeroinitializer
  ret <2 x i1> %r
}

define i1 @UIToFP_is_not_negative(i32 %x) {
; CHECK-LABEL: @UIToFP_is_not_negative(
; CHECK-NEXT:    ret i1 false
;
  %a = uitofp i32 %x to float
  %r = fcmp olt float %a, 0.000000e+00
  ret i1 %r
}

define <2 x i1> @UIToFP_is_not_negative_vec(<2 x i32> %x) {
; CHECK-LABEL: @UIToFP_is_not_negative_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %a = uitofp <2 x i32> %x to <2 x float>
  %r = fcmp olt <2 x float> %a, zeroinitializer
  ret <2 x i1> %r
}

define i1 @UIToFP_nnan_is_not_negative(i32 %x) {
; CHECK-LABEL: @UIToFP_nnan_is_not_negative(
; CHECK-NEXT:    ret i1 false
;
  %a = uitofp i32 %x to float
  %r = fcmp nnan ult float %a, 0.000000e+00
  ret i1 %r
}

define <2 x i1> @UIToFP_nnan_is_not_negative_vec(<2 x i32> %x) {
; CHECK-LABEL: @UIToFP_nnan_is_not_negative_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %a = uitofp <2 x i32> %x to <2 x float>
  %r = fcmp nnan ult <2 x float> %a, zeroinitializer
  ret <2 x i1> %r
}

define i1 @fabs_is_nan_or_positive_or_zero(double %x) {
; CHECK-LABEL: @fabs_is_nan_or_positive_or_zero(
; CHECK-NEXT:    ret i1 true
;
  %fabs = tail call double @llvm.fabs.f64(double %x)
  %cmp = fcmp uge double %fabs, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_is_nan_or_positive_or_zero_vec(<2 x double> %x) {
; CHECK-LABEL: @fabs_is_nan_or_positive_or_zero_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %fabs = tail call <2 x double> @llvm.fabs.v2f64(<2 x double> %x)
  %cmp = fcmp uge <2 x double> %fabs, zeroinitializer
  ret <2 x i1> %cmp
}

define i1 @fabs_nnan_is_positive_or_zero(double %x) {
; CHECK-LABEL: @fabs_nnan_is_positive_or_zero(
; CHECK-NEXT:    ret i1 true
;
  %fabs = tail call double @llvm.fabs.f64(double %x)
  %cmp = fcmp nnan oge double %fabs, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_nnan_is_positive_or_zero_vec(<2 x double> %x) {
; CHECK-LABEL: @fabs_nnan_is_positive_or_zero_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %fabs = tail call <2 x double> @llvm.fabs.v2f64(<2 x double> %x)
  %cmp = fcmp nnan oge <2 x double> %fabs, zeroinitializer
  ret <2 x i1> %cmp
}

define i1 @fabs_is_not_negative(double %x) {
; CHECK-LABEL: @fabs_is_not_negative(
; CHECK-NEXT:    ret i1 false
;
  %fabs = tail call double @llvm.fabs.f64(double %x)
  %cmp = fcmp olt double %fabs, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_is_not_negative_vec(<2 x double> %x) {
; CHECK-LABEL: @fabs_is_not_negative_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %fabs = tail call <2 x double> @llvm.fabs.v2f64(<2 x double> %x)
  %cmp = fcmp olt <2 x double> %fabs, zeroinitializer
  ret <2 x i1> %cmp
}

define i1 @fabs_nnan_is_not_negative(double %x) {
; CHECK-LABEL: @fabs_nnan_is_not_negative(
; CHECK-NEXT:    ret i1 false
;
  %fabs = tail call double @llvm.fabs.f64(double %x)
  %cmp = fcmp nnan ult double %fabs, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_nnan_is_not_negative_vec(<2 x double> %x) {
; CHECK-LABEL: @fabs_nnan_is_not_negative_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %fabs = tail call <2 x double> @llvm.fabs.v2f64(<2 x double> %x)
  %cmp = fcmp nnan ult <2 x double> %fabs, zeroinitializer
  ret <2 x i1> %cmp
}

define <2 x i1> @fabs_is_not_negative_negzero(<2 x float> %V) {
; CHECK-LABEL: @fabs_is_not_negative_negzero(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %abs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %V)
  %cmp = fcmp olt <2 x float> %abs, <float -0.0, float -0.0>
  ret <2 x i1> %cmp
}

define <2 x i1> @fabs_is_not_negative_poszero(<2 x float> %V) {
; CHECK-LABEL: @fabs_is_not_negative_poszero(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %abs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %V)
  %cmp = fcmp olt <2 x float> %abs, <float 0.0, float 0.0>
  ret <2 x i1> %cmp
}

define <2 x i1> @fabs_is_not_negative_anyzero(<2 x float> %V) {
; CHECK-LABEL: @fabs_is_not_negative_anyzero(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %abs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %V)
  %cmp = fcmp olt <2 x float> %abs, <float 0.0, float -0.0>
  ret <2 x i1> %cmp
}

define <3 x i1> @fabs_is_not_negative_negzero_undef(<3 x float> %V) {
; CHECK-LABEL: @fabs_is_not_negative_negzero_undef(
; CHECK-NEXT:    ret <3 x i1> zeroinitializer
;
  %abs = call <3 x float> @llvm.fabs.v3f32(<3 x float> %V)
  %cmp = fcmp olt <3 x float> %abs, <float -0.0, float -0.0, float undef>
  ret <3 x i1> %cmp
}

define <3 x i1> @fabs_is_not_negative_poszero_undef(<3 x float> %V) {
; CHECK-LABEL: @fabs_is_not_negative_poszero_undef(
; CHECK-NEXT:    ret <3 x i1> zeroinitializer
;
  %abs = call <3 x float> @llvm.fabs.v3f32(<3 x float> %V)
  %cmp = fcmp olt <3 x float> %abs, <float 0.0, float 0.0, float undef>
  ret <3 x i1> %cmp
}

define <3 x i1> @fabs_is_not_negative_anyzero_undef(<3 x float> %V) {
; CHECK-LABEL: @fabs_is_not_negative_anyzero_undef(
; CHECK-NEXT:    ret <3 x i1> zeroinitializer
;
  %abs = call <3 x float> @llvm.fabs.v3f32(<3 x float> %V)
  %cmp = fcmp olt <3 x float> %abs, <float 0.0, float -0.0, float undef>
  ret <3 x i1> %cmp
}

define i1 @orderedLessZeroSelect(float, float) {
; CHECK-LABEL: @orderedLessZeroSelect(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.fabs.f32(float %1)
  %c = fcmp olt float %0, %1
  %d = select i1 %c, float %a, float %b
  %e = fadd float %d, 1.0
  %uge = fcmp uge float %e, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroMinNum(float, float) {
; CHECK-LABEL: @orderedLessZeroMinNum(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.fabs.f32(float %1)
  %c = call float @llvm.minnum.f32(float %a, float %b)
  %uge = fcmp uge float %c, 0.000000e+00
  ret i1 %uge
}

; PR37776: https://bugs.llvm.org/show_bug.cgi?id=37776
; exp() may return nan, leaving %1 as the unknown result, so we can't simplify.

define i1 @orderedLessZeroMaxNum(float, float) {
; CHECK-LABEL: @orderedLessZeroMaxNum(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.exp.f32(float [[TMP0:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.maxnum.f32(float [[A]], float [[TMP1:%.*]])
; CHECK-NEXT:    [[UGE:%.*]] = fcmp uge float [[B]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[UGE]]
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.maxnum.f32(float %a, float %1)
  %uge = fcmp uge float %b, 0.000000e+00
  ret i1 %uge
}

; But using maximum, we can simplify, since the NaN would be propagated

define i1 @orderedLessZeroMaximum(float, float) {
; CHECK-LABEL: @orderedLessZeroMaximum(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.maximum.f32(float %a, float %1)
  %uge = fcmp uge float %b, 0.000000e+00
  ret i1 %uge
}

define i1 @minnum_non_nan(float %x) {
; CHECK-LABEL: @minnum_non_nan(
; CHECK-NEXT:    ret i1 true
;
  %min = call float @llvm.minnum.f32(float 0.5, float %x)
  %cmp = fcmp ord float %min, 1.0
  ret i1 %cmp
}

define i1 @maxnum_non_nan(float %x) {
; CHECK-LABEL: @maxnum_non_nan(
; CHECK-NEXT:    ret i1 false
;
  %min = call float @llvm.maxnum.f32(float %x, float 42.0)
  %cmp = fcmp uno float %min, 12.0
  ret i1 %cmp
}

; min(x, 0.5) == 1.0 --> false

define i1 @minnum_oeq_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_oeq_small_min_constant(
; CHECK-NEXT:    ret i1 false
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp oeq float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) > 1.0 --> false

define i1 @minnum_ogt_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_ogt_small_min_constant(
; CHECK-NEXT:    ret i1 false
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp ogt float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) >= 1.0 --> false

define i1 @minnum_oge_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_oge_small_min_constant(
; CHECK-NEXT:    ret i1 false
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp oge float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) == 1.0 --> false

define i1 @minnum_ueq_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_ueq_small_min_constant(
; CHECK-NEXT:    ret i1 false
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp ueq float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) > 1.0 --> false

define i1 @minnum_ugt_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_ugt_small_min_constant(
; CHECK-NEXT:    ret i1 false
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp ugt float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) >= 1.0 --> false

define <2 x i1> @minnum_uge_small_min_constant(<2 x float> %x) {
; CHECK-LABEL: @minnum_uge_small_min_constant(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %min = call <2 x float> @llvm.minnum.v2f32(<2 x float> %x, <2 x float> <float 0.5, float 0.5>)
  %cmp = fcmp uge <2 x float> %min, <float 1.0, float 1.0>
  ret <2 x i1> %cmp
}

; min(x, 0.5) < 1.0 --> true

define <2 x i1> @minnum_olt_small_min_constant(<2 x float> %x) {
; CHECK-LABEL: @minnum_olt_small_min_constant(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %min = call <2 x float> @llvm.minnum.v2f32(<2 x float> %x, <2 x float> <float 0.5, float 0.5>)
  %cmp = fcmp olt <2 x float> %min, <float 1.0, float 1.0>
  ret <2 x i1> %cmp
}

; min(x, 0.5) <= 1.0 --> true

define i1 @minnum_ole_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_ole_small_min_constant(
; CHECK-NEXT:    ret i1 true
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp ole float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) != 1.0 --> true

define i1 @minnum_one_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_one_small_min_constant(
; CHECK-NEXT:    ret i1 true
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp one float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) < 1.0 --> true

define i1 @minnum_ult_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_ult_small_min_constant(
; CHECK-NEXT:    ret i1 true
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp ult float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) <= 1.0 --> true

define i1 @minnum_ule_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_ule_small_min_constant(
; CHECK-NEXT:    ret i1 true
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp ule float %min, 1.0
  ret i1 %cmp
}

; min(x, 0.5) != 1.0 --> true

define i1 @minnum_une_small_min_constant(float %x) {
; CHECK-LABEL: @minnum_une_small_min_constant(
; CHECK-NEXT:    ret i1 true
;
  %min = call float @llvm.minnum.f32(float %x, float 0.5)
  %cmp = fcmp une float %min, 1.0
  ret i1 %cmp
}

; Negative test:
; min(x, 1.0) != 1.0 --> ?

define i1 @minnum_une_equal_min_constant(float %x) {
; CHECK-LABEL: @minnum_une_equal_min_constant(
; CHECK-NEXT:    [[MIN:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 1.000000e+00)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[MIN]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %min = call float @llvm.minnum.f32(float %x, float 1.0)
  %cmp = fcmp une float %min, 1.0
  ret i1 %cmp
}

; Negative test:
; min(x, 2.0) != 1.0 --> ?

define i1 @minnum_une_large_min_constant(float %x) {
; CHECK-LABEL: @minnum_une_large_min_constant(
; CHECK-NEXT:    [[MIN:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 2.000000e+00)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[MIN]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %min = call float @llvm.minnum.f32(float %x, float 2.0)
  %cmp = fcmp une float %min, 1.0
  ret i1 %cmp
}

; Partial negative test (the minnum simplifies):
; min(x, NaN) != 1.0 --> x != 1.0

define i1 @minnum_une_nan_min_constant(float %x) {
; CHECK-LABEL: @minnum_une_nan_min_constant(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %min = call float @llvm.minnum.f32(float %x, float 0x7FF8000000000000)
  %cmp = fcmp une float %min, 1.0
  ret i1 %cmp
}

; max(x, 1.5) == 1.0 --> false

define i1 @maxnum_oeq_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_oeq_large_max_constant(
; CHECK-NEXT:    ret i1 false
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp oeq float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) < 1.0 --> false

define i1 @maxnum_olt_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_olt_large_max_constant(
; CHECK-NEXT:    ret i1 false
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp olt float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) <= 1.0 --> false

define i1 @maxnum_ole_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_ole_large_max_constant(
; CHECK-NEXT:    ret i1 false
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp ole float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) == 1.0 --> false

define i1 @maxnum_ueq_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_ueq_large_max_constant(
; CHECK-NEXT:    ret i1 false
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp ueq float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) < 1.0 --> false

define i1 @maxnum_ult_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_ult_large_max_constant(
; CHECK-NEXT:    ret i1 false
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp ult float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) <= 1.0 --> false

define <2 x i1> @maxnum_ule_large_max_constant(<2 x float> %x) {
; CHECK-LABEL: @maxnum_ule_large_max_constant(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %max = call <2 x float> @llvm.maxnum.v2f32(<2 x float> %x, <2 x float> <float 1.5, float 1.5>)
  %cmp = fcmp ule <2 x float> %max, <float 1.0, float 1.0>
  ret <2 x i1> %cmp
}

; max(x, 1.5) > 1.0 --> true

define <2 x i1> @maxnum_ogt_large_max_constant(<2 x float> %x) {
; CHECK-LABEL: @maxnum_ogt_large_max_constant(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %max = call <2 x float> @llvm.maxnum.v2f32(<2 x float> %x, <2 x float> <float 1.5, float 1.5>)
  %cmp = fcmp ogt <2 x float> %max, <float 1.0, float 1.0>
  ret <2 x i1> %cmp
}

; max(x, 1.5) >= 1.0 --> true

define i1 @maxnum_oge_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_oge_large_max_constant(
; CHECK-NEXT:    ret i1 true
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp oge float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) != 1.0 --> true

define i1 @maxnum_one_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_one_large_max_constant(
; CHECK-NEXT:    ret i1 true
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp one float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) > 1.0 --> true

define i1 @maxnum_ugt_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_ugt_large_max_constant(
; CHECK-NEXT:    ret i1 true
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp ugt float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) >= 1.0 --> true

define i1 @maxnum_uge_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_uge_large_max_constant(
; CHECK-NEXT:    ret i1 true
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp uge float %max, 1.0
  ret i1 %cmp
}

; max(x, 1.5) != 1.0 --> true

define i1 @maxnum_une_large_max_constant(float %x) {
; CHECK-LABEL: @maxnum_une_large_max_constant(
; CHECK-NEXT:    ret i1 true
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.5)
  %cmp = fcmp une float %max, 1.0
  ret i1 %cmp
}

; Negative test:
; max(x, 1.0) != 1.0 --> ?

define i1 @maxnum_une_equal_max_constant(float %x) {
; CHECK-LABEL: @maxnum_une_equal_max_constant(
; CHECK-NEXT:    [[MAX:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float 1.000000e+00)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[MAX]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %max = call float @llvm.maxnum.f32(float %x, float 1.0)
  %cmp = fcmp une float %max, 1.0
  ret i1 %cmp
}

; Negative test:
; max(x, 0.5) != 1.0 --> ?

define i1 @maxnum_une_small_max_constant(float %x) {
; CHECK-LABEL: @maxnum_une_small_max_constant(
; CHECK-NEXT:    [[MAX:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float 5.000000e-01)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[MAX]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %max = call float @llvm.maxnum.f32(float %x, float 0.5)
  %cmp = fcmp une float %max, 1.0
  ret i1 %cmp
}

; Partial negative test (the maxnum simplifies):
; max(x, NaN) != 1.0 --> x != 1.0

define i1 @maxnum_une_nan_max_constant(float %x) {
; CHECK-LABEL: @maxnum_une_nan_max_constant(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %max = call float @llvm.maxnum.f32(float %x, float 0x7FF8000000000000)
  %cmp = fcmp une float %max, 1.0
  ret i1 %cmp
}

define i1 @known_positive_olt_with_negative_constant(double %a) {
; CHECK-LABEL: @known_positive_olt_with_negative_constant(
; CHECK-NEXT:    ret i1 false
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp olt double %call, -1.0
  ret i1 %cmp
}

define <2 x i1> @known_positive_ole_with_negative_constant_splat_vec(<2 x i32> %a) {
; CHECK-LABEL: @known_positive_ole_with_negative_constant_splat_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %call = uitofp <2 x i32> %a to <2 x double>
  %cmp = fcmp ole <2 x double> %call, <double -2.0, double -2.0>
  ret <2 x i1> %cmp
}

define i1 @known_positive_ugt_with_negative_constant(i32 %a) {
; CHECK-LABEL: @known_positive_ugt_with_negative_constant(
; CHECK-NEXT:    ret i1 true
;
  %call = uitofp i32 %a to float
  %cmp = fcmp ugt float %call, -3.0
  ret i1 %cmp
}

define <2 x i1> @known_positive_uge_with_negative_constant_splat_vec(<2 x float> %a) {
; CHECK-LABEL: @known_positive_uge_with_negative_constant_splat_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp uge <2 x float> %call, <float -4.0, float -4.0>
  ret <2 x i1> %cmp
}

define i1 @known_positive_oeq_with_negative_constant(half %a) {
; CHECK-LABEL: @known_positive_oeq_with_negative_constant(
; CHECK-NEXT:    ret i1 false
;
  %call = call half @llvm.fabs.f16(half %a)
  %cmp = fcmp oeq half %call, -5.0
  ret i1 %cmp
}

define <2 x i1> @known_positive_une_with_negative_constant_splat_vec(<2 x i32> %a) {
; CHECK-LABEL: @known_positive_une_with_negative_constant_splat_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %call = uitofp <2 x i32> %a to <2 x half>
  %cmp = fcmp une <2 x half> %call, <half -6.0, half -6.0>
  ret <2 x i1> %cmp
}

define i1 @nonans1(double %in1, double %in2) {
; CHECK-LABEL: @nonans1(
; CHECK-NEXT:    ret i1 false
;
  %cmp = fcmp nnan uno double %in1, %in2
  ret i1 %cmp
}

define i1 @nonans2(double %in1, double %in2) {
; CHECK-LABEL: @nonans2(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp nnan ord double %in1, %in2
  ret i1 %cmp
}

define <2 x i1> @orderedCompareWithNaNVector(<2 x double> %A) {
; CHECK-LABEL: @orderedCompareWithNaNVector(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cmp = fcmp olt <2 x double> %A, <double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF>
  ret <2 x i1> %cmp
}

define <2 x i1> @orderedCompareWithNaNVector_undef_elt(<2 x double> %A) {
; CHECK-LABEL: @orderedCompareWithNaNVector_undef_elt(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cmp = fcmp olt <2 x double> %A, <double 0xFFFFFFFFFFFFFFFF, double undef>
  ret <2 x i1> %cmp
}

define <2 x i1> @unorderedCompareWithNaNVector_undef_elt(<2 x double> %A) {
; CHECK-LABEL: @unorderedCompareWithNaNVector_undef_elt(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %cmp = fcmp ult <2 x double> %A, <double undef, double 0xFFFFFFFFFFFFFFFF>
  ret <2 x i1> %cmp
}
