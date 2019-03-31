; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @test_nuw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_and_unsigned_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[Y]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp ult i64 %y, 3
  ret i1 %z
}

define i1 @test_nsw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_nsw_and_signed_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nsw i64 3, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i64 [[Y]], 10
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i64 3, %x
  %z = icmp sgt i64 %y, 10
  ret i1 %z
}

define i1 @test_nuw_nsw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_nsw_and_unsigned_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw nsw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[Y]], 4
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw nsw i64 10, %x
  %z = icmp ule i64 %y, 3
  ret i1 %z
}

define i1 @test_nuw_nsw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_nsw_and_signed_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw nsw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i64 [[Y]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw nsw i64 10, %x
  %z = icmp slt i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_nuw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_negative_nuw_and_signed_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i64 [[Y]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp slt i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_nsw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_negative_nsw_and_unsigned_pred(
; CHECK-NEXT:    [[Y:%.*]] = sub nsw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[Y]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i64 10, %x
  %z = icmp ult i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_combined_sub_unsigned_overflow(i64 %x) {
; CHECK-LABEL: @test_negative_combined_sub_unsigned_overflow(
; CHECK-NEXT:    [[Y:%.*]] = sub nuw i64 10, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[Y]], 11
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp ult i64 %y, 11
  ret i1 %z
}

define i1 @test_negative_combined_sub_signed_overflow(i8 %x) {
; CHECK-LABEL: @test_negative_combined_sub_signed_overflow(
; CHECK-NEXT:    [[Y:%.*]] = sub nsw i8 127, [[X:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i8 [[Y]], -1
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i8 127, %x
  %z = icmp slt i8 %y, -1
  ret i1 %z
}
