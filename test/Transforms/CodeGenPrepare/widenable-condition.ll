; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -codegenprepare -S < %s | FileCheck %s

; Check the idiomatic guard pattern to ensure it's lowered correctly.
define void @test_guard(i1 %cond_0) {
; CHECK-LABEL: @test_guard(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND_0:%.*]], label [[GUARDED:%.*]], label [[DEOPT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    ret void
; CHECK:       guarded:
; CHECK-NEXT:    ret void
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt

deopt:                                            ; preds = %entry
  call void @foo()
  ret void

guarded:
  ret void
}

;; Test a non-guard fastpath/slowpath case
define void @test_triangle(i1 %cond_0) {
; CHECK-LABEL: @test_triangle(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND_0:%.*]], label [[FASTPATH:%.*]], label [[SLOWPATH:%.*]]
; CHECK:       fastpath:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       slowpath:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret void
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %fastpath, label %slowpath

fastpath:
  call void @bar()
  br label %merge

slowpath:
  call void @foo()
  br label %merge

merge:
  ret void
}


; Demonstrate that resulting CFG simplifications are made
define void @test_cfg_simplify() {
; CHECK-LABEL: @test_cfg_simplify(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  %widenable_cond3 = call i1 @llvm.experimental.widenable.condition()
  br i1 %widenable_cond3, label %guarded2, label %deopt3

deopt3:
  call void @foo()
  ret void

guarded2:
  %widenable_cond4 = call i1 @llvm.experimental.widenable.condition()
  br i1 %widenable_cond4, label %merge1, label %slowpath1

slowpath1:
  call void @foo()
  br label %merge1

merge1:
  ret void
}


declare void @foo()
declare void @bar()

; Function Attrs: inaccessiblememonly nounwind
declare i1 @llvm.experimental.widenable.condition() #0

attributes #0 = { inaccessiblememonly nounwind }
