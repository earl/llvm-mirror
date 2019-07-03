; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -jump-threading -simplifycfg -S < %s | FileCheck %s
declare void @ham()

define void @hoge() {
; CHECK-LABEL: @hoge(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = and i32 undef, 1073741823
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[TMP]], 5
; CHECK-NEXT:    br i1 [[COND]], label [[BB10:%.*]], label [[BB13:%.*]]
; CHECK:       bb10:
; CHECK-NEXT:    tail call void @ham()
; CHECK-NEXT:    br label [[BB13]]
; CHECK:       bb13:
; CHECK-NEXT:    ret void
;
bb:
  %tmp = and i32 undef, 1073741823
  %tmp1 = icmp eq i32 %tmp, 2
  br i1 %tmp1, label %bb12, label %bb2

bb2:
  %tmp3 = icmp eq i32 %tmp, 3
  br i1 %tmp3, label %bb13, label %bb4

bb4:
  %tmp5 = icmp eq i32 %tmp, 5
  br i1 %tmp5, label %bb6, label %bb7

bb6:
  tail call void @ham()
  br label %bb7

bb7:
  br i1 %tmp3, label %bb13, label %bb8

bb8:
  %tmp9 = icmp eq i32 %tmp, 4
  br i1 %tmp9, label %bb13, label %bb10

bb10:
  br i1 %tmp9, label %bb11, label %bb13

bb11:
  br label %bb13

bb12:
  br label %bb2

bb13:
  ret void
}
