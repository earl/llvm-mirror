; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; If we have a relational comparison with a constant, and said comparison is
; used in a select, and there is a constant in select, see if we can make
; those constants match.

; We can't ever get non-canonical scalar predicates.

; Likewise, while we can get non-canonical vector predicates, there must be an
; extra use on that `icmp`, which precludes the fold from happening.

;------------------------------------------------------------------------------;
; Canonical scalar predicates
;------------------------------------------------------------------------------;

!0 = !{!"branch_weights", i32 2000, i32 1}

define i32 @p0_ult_65536(i32 %x, i32 %y) {
; CHECK-LABEL: @p0_ult_65536(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535, !prof !0
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  %r = select i1 %t, i32 %y, i32 65535, !prof !0
  ret i32 %r
}
define i32 @p1_ugt(i32 %x, i32 %y) {
; CHECK-LABEL: @p1_ugt(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt i32 [[X:%.*]], 65534
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ugt i32 %x, 65534
  %r = select i1 %t, i32 %y, i32 65535
  ret i32 %r
}
define i32 @p2_slt_65536(i32 %x, i32 %y) {
; CHECK-LABEL: @p2_slt_65536(
; CHECK-NEXT:    [[T:%.*]] = icmp slt i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp slt i32 %x, 65536
  %r = select i1 %t, i32 %y, i32 65535
  ret i32 %r
}
define i32 @p3_sgt(i32 %x, i32 %y) {
; CHECK-LABEL: @p3_sgt(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt i32 [[X:%.*]], 65534
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp sgt i32 %x, 65534
  %r = select i1 %t, i32 %y, i32 65535
  ret i32 %r
}

;------------------------------------------------------------------------------;
; Vectors
;------------------------------------------------------------------------------;

define <2 x i32> @p4_vec_splat_ult_65536(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p4_vec_splat_ult_65536(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> [[X:%.*]], <i32 65536, i32 65536>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 65535>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ult <2 x i32> %x, <i32 65536, i32 65536>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 65535>
  ret <2 x i32> %r
}
define <2 x i32> @p5_vec_splat_ugt(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p5_vec_splat_ugt(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt <2 x i32> [[X:%.*]], <i32 65534, i32 65534>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 65535>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ugt <2 x i32> %x, <i32 65534, i32 65534>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 65535>
  ret <2 x i32> %r
}
define <2 x i32> @p6_vec_splat_slt_65536(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p6_vec_splat_slt_65536(
; CHECK-NEXT:    [[T:%.*]] = icmp slt <2 x i32> [[X:%.*]], <i32 65536, i32 65536>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 65535>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp slt <2 x i32> %x, <i32 65536, i32 65536>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 65535>
  ret <2 x i32> %r
}
define <2 x i32> @p7_vec_splat_sgt(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p7_vec_splat_sgt(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt <2 x i32> [[X:%.*]], <i32 65534, i32 65534>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 65535>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp sgt <2 x i32> %x, <i32 65534, i32 65534>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 65535>
  ret <2 x i32> %r
}

; Vectors with undef

define <2 x i32> @p8_vec_nonsplat_undef0(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p8_vec_nonsplat_undef0(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> [[X:%.*]], <i32 65536, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 65535>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ult <2 x i32> %x, <i32 65536, i32 undef>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 65535>
  ret <2 x i32> %r
}
define <2 x i32> @p9_vec_nonsplat_undef1(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p9_vec_nonsplat_undef1(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> [[X:%.*]], <i32 65536, i32 65536>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 undef>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ult <2 x i32> %x, <i32 65536, i32 65536>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 undef>
  ret <2 x i32> %r
}
define <2 x i32> @p10_vec_nonsplat_undef2(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p10_vec_nonsplat_undef2(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> [[X:%.*]], <i32 65536, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 undef>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ult <2 x i32> %x, <i32 65536, i32 undef>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 undef>
  ret <2 x i32> %r
}

; Non-splat vectors

define <2 x i32> @p11_vec_nonsplat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @p11_vec_nonsplat(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> [[X:%.*]], <i32 65536, i32 32768>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 32767>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ult <2 x i32> %x, <i32 65536, i32 32768>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 32767>
  ret <2 x i32> %r
}

;------------------------------------------------------------------------------;
; Extra uses prevent the fold.
;------------------------------------------------------------------------------;

declare void @use1(i1)

define i32 @n12_extrause(i32 %x, i32 %y) {
; CHECK-LABEL: @n12_extrause(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    call void @use1(i1 [[T]])
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  call void @use1(i1 %t)
  %r = select i1 %t, i32 %y, i32 65535
  ret i32 %r
}

;------------------------------------------------------------------------------;
; Commutativity
;------------------------------------------------------------------------------;

; We don't care if the constant in select is true value or false value
define i32 @p13_commutativity0(i32 %x, i32 %y) {
; CHECK-LABEL: @p13_commutativity0(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 65535, i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  %r = select i1 %t, i32 65535, i32 %y
  ret i32 %r
}

; Which means, if both possibilities are constants, we must check both of them.
define i32 @p14_commutativity1(i32 %x, i32 %y) {
; CHECK-LABEL: @p14_commutativity1(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 65535, i32 42
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  %r = select i1 %t, i32 65535, i32 42
  ret i32 %r
}
define i32 @p15_commutativity2(i32 %x, i32 %y) {
; CHECK-LABEL: @p15_commutativity2(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 42, i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  %r = select i1 %t, i32 42, i32 65535
  ret i32 %r
}

;------------------------------------------------------------------------------;
; Negative tests
;------------------------------------------------------------------------------;

; For vectors, make sure we handle edge cases correctly
define <2 x i32> @n17_ult_zero(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @n17_ult_zero(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> [[X:%.*]], <i32 65536, i32 0>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ult <2 x i32> %x, <i32 65536, i32 0>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 -1>
  ret <2 x i32> %r
}
define <2 x i32> @n18_ugt_allones(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @n18_ugt_allones(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt <2 x i32> [[X:%.*]], <i32 65534, i32 -1>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 0>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp ugt <2 x i32> %x, <i32 65534, i32 -1>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 0>
  ret <2 x i32> %r
}
define <2 x i32> @n19_slt_int_min(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @n19_slt_int_min(
; CHECK-NEXT:    [[T:%.*]] = icmp slt <2 x i32> [[X:%.*]], <i32 65536, i32 -2147483648>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 2147483647>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp slt <2 x i32> %x, <i32 65536, i32 -2147483648>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 2147483647>
  ret <2 x i32> %r
}
define <2 x i32> @n20_sgt_int_max(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @n20_sgt_int_max(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt <2 x i32> [[X:%.*]], <i32 65534, i32 2147483647>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[T]], <2 x i32> [[Y:%.*]], <2 x i32> <i32 65535, i32 -2147483648>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t = icmp sgt <2 x i32> %x, <i32 65534, i32 2147483647>
  %r = select <2 x i1> %t, <2 x i32> %y, <2 x i32> <i32 65535, i32 -2147483648>
  ret <2 x i32> %r
}

; We don't do anything for non-relational comparisons.
define i32 @n21_equality(i32 %x, i32 %y) {
; CHECK-LABEL: @n21_equality(
; CHECK-NEXT:    [[T:%.*]] = icmp eq i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 2147483647, i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp eq i32 %x, -2147483648
  %r = select i1 %t, i32 2147483647, i32 %y
  ret i32 %r
}

; We don't touch sign checks
define i32 @n22_sign_check(i32 %x, i32 %y) {
; CHECK-LABEL: @n22_sign_check(
; CHECK-NEXT:    [[T:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 -1, i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp slt i32 %x, 0
  %r = select i1 %t, i32 -1, i32 %y
  ret i32 %r
}

; If the types don't match we currently don't do anything.
define i32 @n23_type_mismatch(i64 %x, i32 %y) {
; CHECK-LABEL: @n23_type_mismatch(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i64 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i64 %x, 65536
  %r = select i1 %t, i32 %y, i32 65535
  ret i32 %r
}

; Don't do wrong tranform
define i32 @n24_ult_65534(i32 %x, i32 %y) {
; CHECK-LABEL: @n24_ult_65534(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65534
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 [[Y:%.*]], i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65534
  %r = select i1 %t, i32 %y, i32 65535
  ret i32 %r
}

; If we already have a match, it's good enough.
define i32 @n25_all_good0(i32 %x, i32 %y) {
; CHECK-LABEL: @n25_all_good0(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 65535, i32 65536
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  %r = select i1 %t, i32 65535, i32 65536
  ret i32 %r
}
define i32 @n26_all_good1(i32 %x, i32 %y) {
; CHECK-LABEL: @n26_all_good1(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 [[X:%.*]], 65536
; CHECK-NEXT:    [[R:%.*]] = select i1 [[T]], i32 65536, i32 65535
; CHECK-NEXT:    ret i32 [[R]]
;
  %t = icmp ult i32 %x, 65536
  %r = select i1 %t, i32 65536, i32 65535
  ret i32 %r
}



; CHECK: !0 = !{!"branch_weights", i32 2000, i32 1}
