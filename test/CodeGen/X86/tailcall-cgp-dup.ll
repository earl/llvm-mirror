; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin | FileCheck %s
; RUN: opt -S -codegenprepare %s -mtriple=x86_64-apple-darwin -o - | FileCheck %s --check-prefix OPT

; Teach CGP to dup returns to enable tail call optimization.
; rdar://9147433

define i32 @foo(i32 %x) nounwind ssp {
; CHECK-LABEL: foo:
entry:
  switch i32 %x, label %return [
    i32 1, label %sw.bb
    i32 2, label %sw.bb1
    i32 3, label %sw.bb3
    i32 4, label %sw.bb5
    i32 5, label %sw.bb7
    i32 6, label %sw.bb9
  ]

sw.bb:                                            ; preds = %entry
; CHECK: jmp _f1
  %call = tail call i32 @f1() nounwind
  br label %return

sw.bb1:                                           ; preds = %entry
; CHECK: jmp _f2
  %call2 = tail call i32 @f2() nounwind
  br label %return

sw.bb3:                                           ; preds = %entry
; CHECK: jmp _f3
  %call4 = tail call i32 @f3() nounwind
  br label %return

sw.bb5:                                           ; preds = %entry
; CHECK: jmp _f4
  %call6 = tail call i32 @f4() nounwind
  br label %return

sw.bb7:                                           ; preds = %entry
; CHECK: jmp _f5
  %call8 = tail call i32 @f5() nounwind
  br label %return

sw.bb9:                                           ; preds = %entry
; CHECK: jmp _f6
  %call10 = tail call i32 @f6() nounwind
  br label %return

return:                                           ; preds = %entry, %sw.bb9, %sw.bb7, %sw.bb5, %sw.bb3, %sw.bb1, %sw.bb
  %retval.0 = phi i32 [ %call10, %sw.bb9 ], [ %call8, %sw.bb7 ], [ %call6, %sw.bb5 ], [ %call4, %sw.bb3 ], [ %call2, %sw.bb1 ], [ %call, %sw.bb ], [ 0, %entry ]
  ret i32 %retval.0
}

declare i32 @f1()

declare i32 @f2()

declare i32 @f3()

declare i32 @f4()

declare i32 @f5()

declare i32 @f6()

; rdar://11958338
%0 = type opaque

declare i8* @bar(i8*) uwtable optsize noinline ssp

define hidden %0* @thingWithValue(i8* %self) uwtable ssp {
entry:
; CHECK-LABEL: thingWithValue:
; CHECK: jmp _bar
  br i1 undef, label %if.then.i, label %if.else.i

if.then.i:                                        ; preds = %entry
  br label %someThingWithValue.exit

if.else.i:                                        ; preds = %entry
  %call4.i = tail call i8* @bar(i8* undef) optsize
  br label %someThingWithValue.exit

someThingWithValue.exit:                          ; preds = %if.else.i, %if.then.i
  %retval.0.in.i = phi i8* [ undef, %if.then.i ], [ %call4.i, %if.else.i ]
  %retval.0.i = bitcast i8* %retval.0.in.i to %0*
  ret %0* %retval.0.i
}


; Correctly handle zext returns.
declare zeroext i1 @foo_i1()

; CHECK-LABEL: zext_i1
; CHECK: jmp _foo_i1
define zeroext i1 @zext_i1(i1 %k) {
entry:
  br i1 %k, label %land.end, label %land.rhs

land.rhs:                                         ; preds = %entry
  %call1 = tail call zeroext i1 @foo_i1()
  br label %land.end

land.end:                                         ; preds = %entry, %land.rhs
  %0 = phi i1 [ false, %entry ], [ %call1, %land.rhs ]
  ret i1 %0
}

; We need to look through bitcasts when looking for tail calls in phi incoming
; values.
declare i32* @g_ret32()
define i8* @f_ret8(i8* %obj) nounwind {
; OPT-LABEL: @f_ret8(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[CMP:%.*]] = icmp eq i8* [[OBJ:%.*]], null
; OPT-NEXT:    br i1 [[CMP]], label [[RETURN:%.*]], label [[IF_THEN:%.*]]
; OPT:       if.then:
; OPT-NEXT:    [[PTR:%.*]] = tail call i32* @g_ret32()
; OPT-NEXT:    [[CASTED:%.*]] = bitcast i32* [[PTR]] to i8*
; OPT-NEXT:    ret i8* [[CASTED]]
; OPT:       return:
; OPT-NEXT:    ret i8* [[OBJ]]
;
; CHECK-LABEL: f_ret8:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    je LBB3_1
; CHECK-NEXT:  ## %bb.2: ## %if.then
; CHECK-NEXT:    jmp _g_ret32 ## TAILCALL
; CHECK-NEXT:  LBB3_1: ## %return
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
entry:
  %cmp = icmp eq i8* %obj, null
  br i1 %cmp, label %return, label %if.then

if.then:
  %ptr = tail call i32* @g_ret32()
  %casted = bitcast i32* %ptr to i8*
  br label %return

return:
  %retval = phi i8* [ %casted, %if.then ], [ %obj, %entry ]
  ret i8* %retval
}
