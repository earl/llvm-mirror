; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; Fold
;   (%x + %y) u>= %x
; or
;   (%x + %y) u>= %y
; to
;   @llvm.add.with.overflow(%x, %y) + extractvalue + not

define i1 @t0_basic(i8 %x, i8 %y) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp uge i8 %t0, %y
  ret i1 %r
}

define <2 x i1> @t1_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t1_vec(
; CHECK-NEXT:    [[T0:%.*]] = add <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge <2 x i8> [[T0]], [[Y]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %t0 = add <2 x i8> %x, %y
  %r = icmp uge <2 x i8> %t0, %y
  ret <2 x i1> %r
}

; Commutativity

define i1 @t2_symmetry(i8 %x, i8 %y) {
; CHECK-LABEL: @t2_symmetry(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp uge i8 %t0, %x ; can check against either of `add` arguments
  ret i1 %r
}

declare i8 @gen8()

define i1 @t3_commutative(i8 %x) {
; CHECK-LABEL: @t3_commutative(
; CHECK-NEXT:    [[Y:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %y = call i8 @gen8()
  %t0 = add i8 %y, %x ; swapped
  %r = icmp uge i8 %t0, %y
  ret i1 %r
}

define i1 @t4_commutative(i8 %x, i8 %y) {
; CHECK-LABEL: @t4_commutative(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp ule i8 %y, %t0 ; swapped
  ret i1 %r
}

define i1 @t5_commutative(i8 %x) {
; CHECK-LABEL: @t5_commutative(
; CHECK-NEXT:    [[Y:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ule i8 [[Y]], [[T0]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %y = call i8 @gen8()
  %t0 = add i8 %y, %x ; swapped
  %r = icmp ule i8 %y, %t0 ; swapped
  ret i1 %r
}

; Extra-use tests

declare void @use8(i8)

define i1 @t6_extrause0(i8 %x, i8 %y) {
; CHECK-LABEL: @t6_extrause0(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  call void @use8(i8 %t0)
  %r = icmp uge i8 %t0, %y
  ret i1 %r
}

; Negative tests

define i1 @n7_different_y(i8 %x, i8 %y0, i8 %y1) {
; CHECK-LABEL: @n7_different_y(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y0:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp uge i8 [[T0]], [[Y1:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y0
  %r = icmp uge i8 %t0, %y1
  ret i1 %r
}

define i1 @n8_wrong_pred0(i8 %x, i8 %y) {
; CHECK-LABEL: @n8_wrong_pred0(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ule i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp ule i8 %t0, %y
  ret i1 %r
}

define i1 @n9_wrong_pred1(i8 %x, i8 %y) {
; CHECK-LABEL: @n9_wrong_pred1(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp ugt i8 %t0, %y
  ret i1 %r
}

define i1 @n10_wrong_pred2(i8 %x, i8 %y) {
; CHECK-LABEL: @n10_wrong_pred2(
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp eq i8 %t0, %y
  ret i1 %r
}

define i1 @n11_wrong_pred3(i8 %x, i8 %y) {
; CHECK-LABEL: @n11_wrong_pred3(
; CHECK-NEXT:    [[R:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp ne i8 %t0, %y
  ret i1 %r
}

define i1 @n12_wrong_pred4(i8 %x, i8 %y) {
; CHECK-LABEL: @n12_wrong_pred4(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp slt i8 %t0, %y
  ret i1 %r
}

define i1 @n13_wrong_pred5(i8 %x, i8 %y) {
; CHECK-LABEL: @n13_wrong_pred5(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sle i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp sle i8 %t0, %y
  ret i1 %r
}

define i1 @n14_wrong_pred6(i8 %x, i8 %y) {
; CHECK-LABEL: @n14_wrong_pred6(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp sgt i8 %t0, %y
  ret i1 %r
}

define i1 @n15_wrong_pred7(i8 %x, i8 %y) {
; CHECK-LABEL: @n15_wrong_pred7(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sge i8 [[T0]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %t0 = add i8 %x, %y
  %r = icmp sge i8 %t0, %y
  ret i1 %r
}
