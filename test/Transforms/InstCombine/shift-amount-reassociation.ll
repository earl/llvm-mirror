; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; Given pattern:
;   (x shiftopcode Q) shiftopcode K
; we should rewrite it as
;   x shiftopcode (Q+K)  iff (Q+K) u< bitwidth(x)
; This is valid for any shift, but they must be identical.
; THIS FOLD DOES *NOT* REQUIRE ANY 'exact'/'nuw'/`nsw` FLAGS!

; Basic scalar test

define i32 @t0(i32 %x, i32 %y) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = lshr exact i32 %t1, %t2 ; while there, test that we don't propagate partial 'exact' flag
  ret i32 %t3
}

define <2 x i32> @t1_vec_splat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[T3:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 30, i32 30>
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t0 = sub <2 x i32> <i32 32, i32 32>, %y
  %t1 = lshr <2 x i32> %x, %t0
  %t2 = add <2 x i32> %y, <i32 -2, i32 -2>
  %t3 = lshr <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

define <2 x i32> @t2_vec_nonsplat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @t2_vec_nonsplat(
; CHECK-NEXT:    [[T3:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 30, i32 30>
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t0 = sub <2 x i32> <i32 32, i32 30>, %y
  %t1 = lshr <2 x i32> %x, %t0
  %t2 = add <2 x i32> %y, <i32 -2, i32 0>
  %t3 = lshr <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

; Basic vector tests

define <3 x i32> @t3_vec_nonsplat_undef0(<3 x i32> %x, <3 x i32> %y) {
; CHECK-LABEL: @t3_vec_nonsplat_undef0(
; CHECK-NEXT:    [[T3:%.*]] = lshr <3 x i32> [[X:%.*]], <i32 30, i32 undef, i32 30>
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t0 = sub <3 x i32> <i32 32, i32 undef, i32 32>, %y
  %t1 = lshr <3 x i32> %x, %t0
  %t2 = add <3 x i32> %y, <i32 -2, i32 -2, i32 -2>
  %t3 = lshr <3 x i32> %t1, %t2
  ret <3 x i32> %t3
}

define <3 x i32> @t4_vec_nonsplat_undef1(<3 x i32> %x, <3 x i32> %y) {
; CHECK-LABEL: @t4_vec_nonsplat_undef1(
; CHECK-NEXT:    [[T3:%.*]] = lshr <3 x i32> [[X:%.*]], <i32 30, i32 undef, i32 30>
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t0 = sub <3 x i32> <i32 32, i32 32, i32 32>, %y
  %t1 = lshr <3 x i32> %x, %t0
  %t2 = add <3 x i32> %y, <i32 -2, i32 undef, i32 -2>
  %t3 = lshr <3 x i32> %t1, %t2
  ret <3 x i32> %t3
}

define <3 x i32> @t5_vec_nonsplat_undef1(<3 x i32> %x, <3 x i32> %y) {
; CHECK-LABEL: @t5_vec_nonsplat_undef1(
; CHECK-NEXT:    [[T3:%.*]] = lshr <3 x i32> [[X:%.*]], <i32 30, i32 undef, i32 30>
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t0 = sub <3 x i32> <i32 32, i32 undef, i32 32>, %y
  %t1 = lshr <3 x i32> %x, %t0
  %t2 = add <3 x i32> %y, <i32 -2, i32 undef, i32 -2>
  %t3 = lshr <3 x i32> %t1, %t2
  ret <3 x i32> %t3
}

; Some other shift opcodes
define i32 @t6_shl(i32 %x, i32 %y) {
; CHECK-LABEL: @t6_shl(
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = shl nuw i32 %x, %t0 ; while there, test that we don't propagate partial 'nuw' flag
  %t2 = add i32 %y, -2
  %t3 = shl nsw i32 %t1, %t2 ; while there, test that we don't propagate partial 'nsw' flag
  ret i32 %t3
}
define i32 @t7_ashr(i32 %x, i32 %y) {
; CHECK-LABEL: @t7_ashr(
; CHECK-NEXT:    [[T3:%.*]] = ashr i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = ashr exact i32 %x, %t0 ; while there, test that we don't propagate partial 'exact' flag
  %t2 = add i32 %y, -2
  %t3 = ashr i32 %t1, %t2
  ret i32 %t3
}

; If the same flag is present on both shifts, it can be kept.
define i32 @t8_lshr_exact_flag_preservation(i32 %x, i32 %y) {
; CHECK-LABEL: @t8_lshr_exact_flag_preservation(
; CHECK-NEXT:    [[T3:%.*]] = lshr exact i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = lshr exact i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = lshr exact i32 %t1, %t2
  ret i32 %t3
}
define i32 @t9_ashr_exact_flag_preservation(i32 %x, i32 %y) {
; CHECK-LABEL: @t9_ashr_exact_flag_preservation(
; CHECK-NEXT:    [[T3:%.*]] = ashr exact i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = ashr exact i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = ashr exact i32 %t1, %t2
  ret i32 %t3
}
define i32 @t10_shl_nuw_flag_preservation(i32 %x, i32 %y) {
; CHECK-LABEL: @t10_shl_nuw_flag_preservation(
; CHECK-NEXT:    [[T3:%.*]] = shl nuw i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = shl nuw i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = shl nuw nsw i32 %t1, %t2 ; only 'nuw' should be propagated.
  ret i32 %t3
}
define i32 @t11_shl_nsw_flag_preservation(i32 %x, i32 %y) {
; CHECK-LABEL: @t11_shl_nsw_flag_preservation(
; CHECK-NEXT:    [[T3:%.*]] = shl nsw i32 [[X:%.*]], 30
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = shl nsw i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = shl nsw nuw i32 %t1, %t2 ; only 'nuw' should be propagated.
  ret i32 %t3
}

; Reduced from https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=15587
@X = external global i32
define i64 @constantexpr() {
; CHECK-LABEL: @constantexpr(
; CHECK-NEXT:    ret i64 0
;
  %A = alloca i64
  %L = load i64, i64* %A
  %V = add i64 ptrtoint (i32* @X to i64), 0
  %B2 = shl i64 %V, 0
  %B4 = ashr i64 %B2, %L
  %B = and i64 undef, %B4
  ret i64 %B
}

; No one-use tests since we will only produce a single instruction here.

; Negative tests

; Can't fold, total shift would be 32
define i32 @n12(i32 %x, i32 %y) {
; CHECK-LABEL: @n12(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 30, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], 2
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 30, %y
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %y, 2
  %t3 = lshr i32 %t1, %t2
  ret i32 %t3
}
; Can't fold, for second channel the shift would 32
define <2 x i32> @t13_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @t13_vec(
; CHECK-NEXT:    [[T0:%.*]] = sub <2 x i32> <i32 32, i32 30>, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr <2 x i32> [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add <2 x i32> [[Y]], <i32 -2, i32 2>
; CHECK-NEXT:    [[T3:%.*]] = lshr <2 x i32> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t0 = sub <2 x i32> <i32 32, i32 30>, %y
  %t1 = lshr <2 x i32> %x, %t0
  %t2 = add <2 x i32> %y, <i32 -2, i32 2>
  %t3 = lshr <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

; If we have different right-shifts, in general, we can't do anything with it.
define i32 @n13(i32 %x, i32 %y) {
; CHECK-LABEL: @n13(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -2
; CHECK-NEXT:    [[T3:%.*]] = ashr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = ashr i32 %t1, %t2
  ret i32 %t3
}
define i32 @n14(i32 %x, i32 %y) {
; CHECK-LABEL: @n14(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -1
; CHECK-NEXT:    [[T3:%.*]] = ashr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %y, -1
  %t3 = ashr i32 %t1, %t2
  ret i32 %t3
}
define i32 @n15(i32 %x, i32 %y) {
; CHECK-LABEL: @n15(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -2
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = ashr i32 %x, %t0
  %t2 = add i32 %y, -2
  %t3 = lshr i32 %t1, %t2
  ret i32 %t3
}
define i32 @n16(i32 %x, i32 %y) {
; CHECK-LABEL: @n16(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -1
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = ashr i32 %x, %t0
  %t2 = add i32 %y, -1
  %t3 = lshr i32 %t1, %t2
  ret i32 %t3
}

; If the shift direction is different, then this should be handled elsewhere.
define i32 @n17(i32 %x, i32 %y) {
; CHECK-LABEL: @n17(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = shl i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -1
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = shl i32 %x, %t0
  %t2 = add i32 %y, -1
  %t3 = lshr i32 %t1, %t2
  ret i32 %t3
}
define i32 @n18(i32 %x, i32 %y) {
; CHECK-LABEL: @n18(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = shl i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -1
; CHECK-NEXT:    [[T3:%.*]] = ashr i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = shl i32 %x, %t0
  %t2 = add i32 %y, -1
  %t3 = ashr i32 %t1, %t2
  ret i32 %t3
}
define i32 @n19(i32 %x, i32 %y) {
; CHECK-LABEL: @n19(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -1
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %y, -1
  %t3 = shl i32 %t1, %t2
  ret i32 %t3
}
define i32 @n20(i32 %x, i32 %y) {
; CHECK-LABEL: @n20(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[Y]], -1
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = sub i32 32, %y
  %t1 = ashr i32 %x, %t0
  %t2 = add i32 %y, -1
  %t3 = shl i32 %t1, %t2
  ret i32 %t3
}
