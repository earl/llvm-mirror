; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s

; Check that debug locations are preserved. For more info see:
;   https://llvm.org/docs/SourceLevelDebugging.html#fixing-errors
; RUN: opt < %s -enable-debugify -correlated-propagation -S 2>&1 | \
; RUN:   FileCheck %s -check-prefix=DEBUG
; DEBUG: CheckModuleDebugify: PASS

declare void @use64(i64)

define void @test1(i32 %n) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[N:%.*]], [[ENTRY:%.*]] ], [ [[EXT:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[EXT_WIDE:%.*]] = sext i32 [[A]] to i64
; CHECK-NEXT:    call void @use64(i64 [[EXT_WIDE]])
; CHECK-NEXT:    [[EXT]] = trunc i64 [[EXT_WIDE]] to i32
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %a = phi i32 [ %n, %entry ], [ %ext, %for.body ]
  %cmp = icmp sgt i32 %a, 1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %ext.wide = sext i32 %a to i64
  call void @use64(i64 %ext.wide)
  %ext = trunc i64 %ext.wide to i32
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

;; Negative test to show transform doesn't happen unless n > 0.
define void @test2(i32 %n) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[N:%.*]], [[ENTRY:%.*]] ], [ [[EXT:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A]], -2
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[EXT_WIDE:%.*]] = sext i32 [[A]] to i64
; CHECK-NEXT:    call void @use64(i64 [[EXT_WIDE]])
; CHECK-NEXT:    [[EXT]] = trunc i64 [[EXT_WIDE]] to i32
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %a = phi i32 [ %n, %entry ], [ %ext, %for.body ]
  %cmp = icmp sgt i32 %a, -2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %ext.wide = sext i32 %a to i64
  call void @use64(i64 %ext.wide)
  %ext = trunc i64 %ext.wide to i32
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

;; Non looping test case.
define void @test3(i32 %n) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[EXT_WIDE:%.*]] = sext i32 [[N]] to i64
; CHECK-NEXT:    call void @use64(i64 [[EXT_WIDE]])
; CHECK-NEXT:    [[EXT:%.*]] = trunc i64 [[EXT_WIDE]] to i32
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %bb, label %exit

bb:
  %ext.wide = sext i32 %n to i64
  call void @use64(i64 %ext.wide)
  %ext = trunc i64 %ext.wide to i32
  br label %exit

exit:
  ret void
}
