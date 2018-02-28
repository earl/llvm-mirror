; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=core-avx2 | FileCheck %s

define i1 @try_cmpxchg(i128* %addr, i128 %desired, i128 %new) {
; CHECK-LABEL: try_cmpxchg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rcx, %r9
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    movq %r9, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %pair = cmpxchg i128* %addr, i128 %desired, i128 %new seq_cst seq_cst
  %success = extractvalue { i128, i1 } %pair, 1
  ret i1 %success
}

define void @cmpxchg_flow(i128* %addr, i128 %desired, i128 %new) {
; CHECK-LABEL: cmpxchg_flow:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rcx, %r9
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    movq %r9, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne .LBB1_2
; CHECK-NEXT:  # %bb.1: # %true
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB1_2: # %false
; CHECK-NEXT:    callq bar
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %pair = cmpxchg i128* %addr, i128 %desired, i128 %new seq_cst seq_cst
  %success = extractvalue { i128, i1 } %pair, 1
  br i1 %success, label %true, label %false

true:
  call void @foo()
  ret void

false:
  call void @bar()
  ret void
}

; Can't use the flags here because cmpxchg16b only sets ZF.
define i1 @cmpxchg_arithcmp(i128* %addr, i128 %desired, i128 %new) {
; CHECK-LABEL: cmpxchg_arithcmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rcx, %r9
; CHECK-NEXT:    movq %rdx, %r10
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    movq %r9, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    cmpq %rsi, %rax
; CHECK-NEXT:    sbbq %r10, %rdx
; CHECK-NEXT:    setge %al
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %pair = cmpxchg i128* %addr, i128 %desired, i128 %new seq_cst seq_cst
  %oldval = extractvalue { i128, i1 } %pair, 0
  %success = icmp sge i128 %oldval, %desired
  ret i1 %success
}

define i128 @cmpxchg_zext(i128* %addr, i128 %desired, i128 %new) {
; CHECK-LABEL: cmpxchg_zext:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rcx, %r9
; CHECK-NEXT:    xorl %r10d, %r10d
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    movq %r9, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    sete %r10b
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    movq %r10, %rax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %pair = cmpxchg i128* %addr, i128 %desired, i128 %new seq_cst seq_cst
  %success = extractvalue { i128, i1 } %pair, 1
  %mask = zext i1 %success to i128
  ret i128 %mask
}


define i128 @cmpxchg_use_eflags_and_val(i128* %addr, i128 %offset) {
; CHECK-LABEL: cmpxchg_use_eflags_and_val:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB4_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rdx, %r9
; CHECK-NEXT:    movq %rax, %r10
; CHECK-NEXT:    movq %rax, %rbx
; CHECK-NEXT:    addq %rsi, %rbx
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    adcq %r8, %rcx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne .LBB4_1
; CHECK-NEXT:  # %bb.2: # %done
; CHECK-NEXT:    movq %r10, %rax
; CHECK-NEXT:    movq %r9, %rdx
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  %init = load atomic i128, i128* %addr seq_cst, align 16
  br label %loop

loop:
  %old = phi i128 [%init, %entry], [%oldval, %loop]
  %new = add i128 %old, %offset

  %pair = cmpxchg i128* %addr, i128 %old, i128 %new seq_cst seq_cst
  %oldval = extractvalue { i128, i1 } %pair, 0
  %success = extractvalue { i128, i1 } %pair, 1

  br i1 %success, label %done, label %loop

done:
  ret i128 %old
}

declare void @foo()
declare void @bar()
