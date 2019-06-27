; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @and_consts(i32 %k, i32 %c1, i32 %c2) {
; CHECK-LABEL: @and_consts(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[K:%.*]], 12
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP1]], 12
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %t1 = and i32 4, %k
  %t2 = icmp eq i32 %t1, 0
  %t5 = and i32 8, %k
  %t6 = icmp eq i32 %t5, 0
  %or = or i1 %t2, %t6
  ret i1 %or
}

define i1 @foo1_and(i32 %k, i32 %c1, i32 %c2) {
; CHECK-LABEL: @foo1_and(
; CHECK-NEXT:    [[T:%.*]] = shl i32 1, [[C1:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = lshr i32 -2147483648, [[C2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[T]], [[T4]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[K:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %t = shl i32 1, %c1
  %t4 = lshr i32 -2147483648, %c2
  %t1 = and i32 %t, %k
  %t2 = icmp eq i32 %t1, 0
  %t5 = and i32 %t4, %k
  %t6 = icmp eq i32 %t5, 0
  %or = or i1 %t2, %t6
  ret i1 %or
}

; Same as above but with operands commuted one of the ands, but not the other.
define i1 @foo1_and_commuted(i32 %k, i32 %c1, i32 %c2) {
; CHECK-LABEL: @foo1_and_commuted(
; CHECK-NEXT:    [[K2:%.*]] = mul i32 [[K:%.*]], [[K]]
; CHECK-NEXT:    [[T:%.*]] = shl i32 1, [[C1:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = lshr i32 -2147483648, [[C2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[T]], [[T4]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[K2]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %k2 = mul i32 %k, %k ; to trick the complexity sorting
  %t = shl i32 1, %c1
  %t4 = lshr i32 -2147483648, %c2
  %t1 = and i32 %k2, %t
  %t2 = icmp eq i32 %t1, 0
  %t5 = and i32 %t4, %k2
  %t6 = icmp eq i32 %t5, 0
  %or = or i1 %t2, %t6
  ret i1 %or
}

define i1 @or_consts(i32 %k, i32 %c1, i32 %c2) {
; CHECK-LABEL: @or_consts(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[K:%.*]], 12
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], 12
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %t1 = and i32 4, %k
  %t2 = icmp ne i32 %t1, 0
  %t5 = and i32 8, %k
  %t6 = icmp ne i32 %t5, 0
  %or = and i1 %t2, %t6
  ret i1 %or
}

define i1 @foo1_or(i32 %k, i32 %c1, i32 %c2) {
; CHECK-LABEL: @foo1_or(
; CHECK-NEXT:    [[T:%.*]] = shl i32 1, [[C1:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = lshr i32 -2147483648, [[C2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[T]], [[T4]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[K:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %t = shl i32 1, %c1
  %t4 = lshr i32 -2147483648, %c2
  %t1 = and i32 %t, %k
  %t2 = icmp ne i32 %t1, 0
  %t5 = and i32 %t4, %k
  %t6 = icmp ne i32 %t5, 0
  %or = and i1 %t2, %t6
  ret i1 %or
}

; Same as above but with operands commuted one of the ors, but not the other.
define i1 @foo1_or_commuted(i32 %k, i32 %c1, i32 %c2) {
; CHECK-LABEL: @foo1_or_commuted(
; CHECK-NEXT:    [[K2:%.*]] = mul i32 [[K:%.*]], [[K]]
; CHECK-NEXT:    [[T:%.*]] = shl i32 1, [[C1:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = lshr i32 -2147483648, [[C2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[T]], [[T4]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[K2]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %k2 = mul i32 %k, %k ; to trick the complexity sorting
  %t = shl i32 1, %c1
  %t4 = lshr i32 -2147483648, %c2
  %t1 = and i32 %k2, %t
  %t2 = icmp ne i32 %t1, 0
  %t5 = and i32 %t4, %k2
  %t6 = icmp ne i32 %t5, 0
  %or = and i1 %t2, %t6
  ret i1 %or
}
