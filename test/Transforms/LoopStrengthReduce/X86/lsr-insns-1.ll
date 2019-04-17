; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-reduce -mtriple=x86_64  -S | FileCheck %s -check-prefix=BOTH -check-prefix=INSN
; RUN: opt < %s -loop-reduce -mtriple=x86_64 -lsr-insns-cost=false -S | FileCheck %s -check-prefix=BOTH -check-prefix=REGS
; RUN: llc < %s -O2 -mtriple=x86_64-unknown-unknown -lsr-insns-cost | FileCheck %s

; OPT test checks that LSR optimize compare for static counter to compare with 0.

; LLC test checks that LSR optimize compare for static counter.
; That means that instead of creating the following:
;   movl %ecx, (%rdx,%rax,4)
;   incq %rax
;   cmpq $1024, %rax
; LSR should optimize out cmp:
;   movl %ecx, 4096(%rdx,%rax)
;   addq $4, %rax
; or
;   movl %ecx, 4096(%rdx,%rax,4)
;   incq %rax

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @foo(i32* nocapture readonly %x, i32* nocapture readonly %y, i32* nocapture %q) {
; INSN-LABEL: @foo(
; INSN-NEXT:  entry:
; INSN-NEXT:    [[Q1:%.*]] = bitcast i32* [[Q:%.*]] to i8*
; INSN-NEXT:    [[Y3:%.*]] = bitcast i32* [[Y:%.*]] to i8*
; INSN-NEXT:    [[X7:%.*]] = bitcast i32* [[X:%.*]] to i8*
; INSN-NEXT:    br label [[FOR_BODY:%.*]]
; INSN:       for.cond.cleanup:
; INSN-NEXT:    ret void
; INSN:       for.body:
; INSN-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[FOR_BODY]] ], [ -4096, [[ENTRY:%.*]] ]
; INSN-NEXT:    [[UGLYGEP8:%.*]] = getelementptr i8, i8* [[X7]], i64 [[LSR_IV]]
; INSN-NEXT:    [[UGLYGEP89:%.*]] = bitcast i8* [[UGLYGEP8]] to i32*
; INSN-NEXT:    [[SCEVGEP10:%.*]] = getelementptr i32, i32* [[UGLYGEP89]], i64 1024
; INSN-NEXT:    [[TMP:%.*]] = load i32, i32* [[SCEVGEP10]], align 4
; INSN-NEXT:    [[UGLYGEP4:%.*]] = getelementptr i8, i8* [[Y3]], i64 [[LSR_IV]]
; INSN-NEXT:    [[UGLYGEP45:%.*]] = bitcast i8* [[UGLYGEP4]] to i32*
; INSN-NEXT:    [[SCEVGEP6:%.*]] = getelementptr i32, i32* [[UGLYGEP45]], i64 1024
; INSN-NEXT:    [[TMP1:%.*]] = load i32, i32* [[SCEVGEP6]], align 4
; INSN-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP1]], [[TMP]]
; INSN-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8* [[Q1]], i64 [[LSR_IV]]
; INSN-NEXT:    [[UGLYGEP2:%.*]] = bitcast i8* [[UGLYGEP]] to i32*
; INSN-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[UGLYGEP2]], i64 1024
; INSN-NEXT:    store i32 [[ADD]], i32* [[SCEVGEP]], align 4
; INSN-NEXT:    [[LSR_IV_NEXT]] = add nsw i64 [[LSR_IV]], 4
; INSN-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[LSR_IV_NEXT]], 0
; INSN-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
;
; REGS-LABEL: @foo(
; REGS-NEXT:  entry:
; REGS-NEXT:    br label [[FOR_BODY:%.*]]
; REGS:       for.cond.cleanup:
; REGS-NEXT:    ret void
; REGS:       for.body:
; REGS-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; REGS-NEXT:    [[SCEVGEP2:%.*]] = getelementptr i32, i32* [[X:%.*]], i64 [[INDVARS_IV]]
; REGS-NEXT:    [[TMP:%.*]] = load i32, i32* [[SCEVGEP2]], align 4
; REGS-NEXT:    [[SCEVGEP1:%.*]] = getelementptr i32, i32* [[Y:%.*]], i64 [[INDVARS_IV]]
; REGS-NEXT:    [[TMP1:%.*]] = load i32, i32* [[SCEVGEP1]], align 4
; REGS-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP1]], [[TMP]]
; REGS-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[Q:%.*]], i64 [[INDVARS_IV]]
; REGS-NEXT:    store i32 [[ADD]], i32* [[SCEVGEP]], align 4
; REGS-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; REGS-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 1024
; REGS-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY]]
;
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-4096, %rax # imm = 0xF000
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl 4096(%rsi,%rax), %ecx
; CHECK-NEXT:    addl 4096(%rdi,%rax), %ecx
; CHECK-NEXT:    movl %ecx, 4096(%rdx,%rax)
; CHECK-NEXT:    addq $4, %rax
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    retq
entry:
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret void

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %x, i64 %indvars.iv
  %tmp = load i32, i32* %arrayidx, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %y, i64 %indvars.iv
  %tmp1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %tmp1, %tmp
  %arrayidx4 = getelementptr inbounds i32, i32* %q, i64 %indvars.iv
  store i32 %add, i32* %arrayidx4, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 1024
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

