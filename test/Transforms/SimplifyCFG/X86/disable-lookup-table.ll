; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -switch-to-lookup -S -mtriple=x86_64-unknown-linux-gnu | FileCheck %s
; RUN: opt < %s -passes='simplify-cfg<switch-to-lookup>' -S -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
; In the presence of "-no-jump-tables"="true", simplifycfg should not convert switches to lookup tables.

; CHECK: @switch.table.bar = private unnamed_addr constant [4 x i32] [i32 55, i32 123, i32 0, i32 -1]
; CHECK-LABEL: foo
; CHECK-NOT: @switch.table.foo = private unnamed_addr constant [4 x i32] [i32 55, i32 123, i32 0, i32 -1]

define i32 @foo(i32 %c) "no-jump-tables"="true" {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 [[C:%.*]], 42
; CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[RETURN:%.*]]
; CHECK-NEXT:    i32 1, label [[SW_BB1:%.*]]
; CHECK-NEXT:    i32 2, label [[SW_BB2:%.*]]
; CHECK-NEXT:    i32 3, label [[SW_BB3:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb1:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb2:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb3:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.default:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ 15, [[SW_DEFAULT]] ], [ -1, [[SW_BB3]] ], [ 0, [[SW_BB2]] ], [ 123, [[SW_BB1]] ], [ 55, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  switch i32 %c, label %sw.default [
  i32 42, label %return
  i32 43, label %sw.bb1
  i32 44, label %sw.bb2
  i32 45, label %sw.bb3
  ]

sw.bb1: br label %return
sw.bb2: br label %return
sw.bb3: br label %return
sw.default: br label %return
return:
  %retval.0 = phi i32 [ 15, %sw.default ],  [ -1, %sw.bb3 ], [ 0, %sw.bb2 ], [ 123, %sw.bb1 ], [ 55, %entry ]
  ret i32 %retval.0
}


define i32 @bar(i32 %c) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 [[C:%.*]], 42
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[TMP0]], 4
; CHECK-NEXT:    br i1 [[TMP1]], label [[SWITCH_LOOKUP:%.*]], label [[RETURN:%.*]]
; CHECK:       switch.lookup:
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* @switch.table.bar, i32 0, i32 [[TMP0]]
; CHECK-NEXT:    [[SWITCH_LOAD:%.*]] = load i32, i32* [[SWITCH_GEP]]
; CHECK-NEXT:    ret i32 [[SWITCH_LOAD]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 15
;
entry:
  switch i32 %c, label %sw.default [
  i32 42, label %return
  i32 43, label %sw.bb1
  i32 44, label %sw.bb2
  i32 45, label %sw.bb3
  ]

sw.bb1: br label %return
sw.bb2: br label %return
sw.bb3: br label %return
sw.default: br label %return
return:
  %retval.0 = phi i32 [ 15, %sw.default ],  [ -1, %sw.bb3 ], [ 0, %sw.bb2 ], [ 123, %sw.bb1 ], [ 55, %entry ]
  ret i32 %retval.0
}

