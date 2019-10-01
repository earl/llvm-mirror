; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

define i32 @t0(i64 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = sub nsw i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr i64 %x, 63
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 0, %t1
  ret i32 %r
}
define i32 @t1_exact(i64 %x) {
; CHECK-LABEL: @t1_exact(
; CHECK-NEXT:    [[T0:%.*]] = lshr exact i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = sub nsw i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr exact i64 %x, 63
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 0, %t1
  ret i32 %r
}
define i32 @t2(i64 %x) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[T0:%.*]] = ashr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = sub i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = ashr i64 %x, 63
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 0, %t1
  ret i32 %r
}
define i32 @t3_exact(i64 %x) {
; CHECK-LABEL: @t3_exact(
; CHECK-NEXT:    [[T0:%.*]] = ashr exact i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = sub i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = ashr exact i64 %x, 63
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 0, %t1
  ret i32 %r
}

define <2 x i32> @t4(<2 x i64> %x) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[T0:%.*]] = lshr <2 x i64> [[X:%.*]], <i64 63, i64 63>
; CHECK-NEXT:    [[T1:%.*]] = trunc <2 x i64> [[T0]] to <2 x i32>
; CHECK-NEXT:    [[R:%.*]] = sub nsw <2 x i32> zeroinitializer, [[T1]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t0 = lshr <2 x i64> %x, <i64 63, i64 63>
  %t1 = trunc <2 x i64> %t0 to <2 x i32>
  %r = sub <2 x i32> zeroinitializer, %t1
  ret <2 x i32> %r
}

define <2 x i32> @t5(<2 x i64> %x) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[T0:%.*]] = lshr <2 x i64> [[X:%.*]], <i64 63, i64 undef>
; CHECK-NEXT:    [[T1:%.*]] = trunc <2 x i64> [[T0]] to <2 x i32>
; CHECK-NEXT:    [[R:%.*]] = sub <2 x i32> <i32 0, i32 undef>, [[T1]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %t0 = lshr <2 x i64> %x, <i64 63, i64 undef>
  %t1 = trunc <2 x i64> %t0 to <2 x i32>
  %r = sub <2 x i32> <i32 0, i32 undef>, %t1
  ret <2 x i32> %r
}

declare void @use64(i64)
declare void @use32(i32)

define i32 @t6(i64 %x) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 63
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = sub nsw i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr i64 %x, 63
  call void @use64(i64 %t0)
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 0, %t1
  ret i32 %r
}

define i32 @n7(i64 %x) {
; CHECK-LABEL: @n7(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[R:%.*]] = sub nsw i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr i64 %x, 63
  %t1 = trunc i64 %t0 to i32
  call void @use32(i32 %t1)
  %r = sub i32 0, %t1
  ret i32 %r
}

define i32 @n8(i64 %x) {
; CHECK-LABEL: @n8(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 63
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[R:%.*]] = sub nsw i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr i64 %x, 63
  call void @use64(i64 %t0)
  %t1 = trunc i64 %t0 to i32
  call void @use32(i32 %t1)
  %r = sub i32 0, %t1
  ret i32 %r
}

define i32 @n9(i64 %x) {
; CHECK-LABEL: @n9(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 62
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = sub nsw i32 0, [[T1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr i64 %x, 62
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 0, %t1
  ret i32 %r
}

define i32 @n10(i64 %x) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T1:%.*]] = trunc i64 [[T0]] to i32
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[T1]], 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %t0 = lshr i64 %x, 63
  %t1 = trunc i64 %t0 to i32
  %r = sub i32 1, %t1
  ret i32 %r
}
