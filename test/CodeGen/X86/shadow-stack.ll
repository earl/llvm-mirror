; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple x86_64-apple-macosx10.13.0 < %s | FileCheck %s --check-prefix=X86_64
; RUN: llc -mtriple i386-apple-macosx10.13.0 < %s | FileCheck %s --check-prefix=X86

; The MacOS tripples are used to get trapping behavior on the "unreachable" IR
; instruction, so that the placement of the ud2 instruction could be verified.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The IR was created using the following C code:
;; typedef void *jmp_buf;
;; jmp_buf buf;
;;
;; __attribute__((noinline)) int bar(int i) {
;;   int j = i - 111;
;;   __builtin_longjmp(&buf, 1);
;;   return j;
;; }
;;
;; int foo(int i) {
;;   int j = i * 11;
;;   if (!__builtin_setjmp(&buf)) {
;;     j += 33 + bar(j);
;;   }
;;   return j + i;
;; }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

@buf = common local_unnamed_addr global i8* null, align 8

; Functions that use LongJmp should fix the Shadow Stack using previosuly saved
; ShadowStackPointer in the input buffer.
; The fix requires unwinding the shadow stack to the last SSP.
define i32 @bar(i32 %i) local_unnamed_addr {
; X86_64-LABEL: bar:
; X86_64:       ## %bb.0: ## %entry
; X86_64-NEXT:    pushq %rbp
; X86_64-NEXT:    .cfi_def_cfa_offset 16
; X86_64-NEXT:    .cfi_offset %rbp, -16
; X86_64-NEXT:    movq _buf@{{.*}}(%rip), %rax
; X86_64-NEXT:    movq (%rax), %rax
; X86_64-NEXT:    xorq %rdx, %rdx
; X86_64-NEXT:    rdsspq %rdx
; X86_64-NEXT:    testq %rdx, %rdx
; X86_64-NEXT:    je LBB0_5
; X86_64-NEXT:  ## %bb.1: ## %entry
; X86_64-NEXT:    movq 24(%rax), %rcx
; X86_64-NEXT:    subq %rdx, %rcx
; X86_64-NEXT:    jbe LBB0_5
; X86_64-NEXT:  ## %bb.2: ## %entry
; X86_64-NEXT:    shrq $3, %rcx
; X86_64-NEXT:    incsspq %rcx
; X86_64-NEXT:    shrq $8, %rcx
; X86_64-NEXT:    je LBB0_5
; X86_64-NEXT:  ## %bb.3: ## %entry
; X86_64-NEXT:    shlq %rcx
; X86_64-NEXT:    movq $128, %rdx
; X86_64-NEXT:  LBB0_4: ## %entry
; X86_64-NEXT:    ## =>This Inner Loop Header: Depth=1
; X86_64-NEXT:    incsspq %rdx
; X86_64-NEXT:    decq %rcx
; X86_64-NEXT:    jne LBB0_4
; X86_64-NEXT:  LBB0_5: ## %entry
; X86_64-NEXT:    movq (%rax), %rbp
; X86_64-NEXT:    movq 8(%rax), %rcx
; X86_64-NEXT:    movq 16(%rax), %rsp
; X86_64-NEXT:    jmpq *%rcx
; X86_64-NEXT:    ud2
;
; X86-LABEL: bar:
; X86:       ## %bb.0: ## %entry
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl L_buf$non_lazy_ptr, %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    rdsspd %edx
; X86-NEXT:    testl %edx, %edx
; X86-NEXT:    je LBB0_5
; X86-NEXT:  ## %bb.1: ## %entry
; X86-NEXT:    movl 12(%eax), %ecx
; X86-NEXT:    subl %edx, %ecx
; X86-NEXT:    jbe LBB0_5
; X86-NEXT:  ## %bb.2: ## %entry
; X86-NEXT:    shrl $2, %ecx
; X86-NEXT:    incsspd %ecx
; X86-NEXT:    shrl $8, %ecx
; X86-NEXT:    je LBB0_5
; X86-NEXT:  ## %bb.3: ## %entry
; X86-NEXT:    shll %ecx
; X86-NEXT:    movl $128, %edx
; X86-NEXT:  LBB0_4: ## %entry
; X86-NEXT:    ## =>This Inner Loop Header: Depth=1
; X86-NEXT:    incsspd %edx
; X86-NEXT:    decl %ecx
; X86-NEXT:    jne LBB0_4
; X86-NEXT:  LBB0_5: ## %entry
; X86-NEXT:    movl (%eax), %ebp
; X86-NEXT:    movl 4(%eax), %ecx
; X86-NEXT:    movl 8(%eax), %esp
; X86-NEXT:    jmpl *%ecx
; X86-NEXT:    ud2
entry:
  %0 = load i8*, i8** @buf, align 8
  tail call void @llvm.eh.sjlj.longjmp(i8* %0)
  unreachable
}

declare void @llvm.eh.sjlj.longjmp(i8*)

; Functions that call SetJmp should save the current ShadowStackPointer for
; future fixing of the Shadow Stack.
define i32 @foo(i32 %i) local_unnamed_addr {
; X86_64-LABEL: foo:
; X86_64:       ## %bb.0: ## %entry
; X86_64-NEXT:    pushq %rbp
; X86_64-NEXT:    .cfi_def_cfa_offset 16
; X86_64-NEXT:    .cfi_offset %rbp, -16
; X86_64-NEXT:    movq %rsp, %rbp
; X86_64-NEXT:    .cfi_def_cfa_register %rbp
; X86_64-NEXT:    pushq %r15
; X86_64-NEXT:    pushq %r14
; X86_64-NEXT:    pushq %r13
; X86_64-NEXT:    pushq %r12
; X86_64-NEXT:    pushq %rbx
; X86_64-NEXT:    pushq %rax
; X86_64-NEXT:    .cfi_offset %rbx, -56
; X86_64-NEXT:    .cfi_offset %r12, -48
; X86_64-NEXT:    .cfi_offset %r13, -40
; X86_64-NEXT:    .cfi_offset %r14, -32
; X86_64-NEXT:    .cfi_offset %r15, -24
; X86_64-NEXT:    ## kill: def $edi killed $edi def $rdi
; X86_64-NEXT:    movq %rdi, {{[-0-9]+}}(%r{{[sb]}}p) ## 8-byte Spill
; X86_64-NEXT:    movq _buf@{{.*}}(%rip), %rax
; X86_64-NEXT:    movq (%rax), %rax
; X86_64-NEXT:    movq %rbp, (%rax)
; X86_64-NEXT:    movq %rsp, 16(%rax)
; X86_64-NEXT:    leaq {{.*}}(%rip), %rcx
; X86_64-NEXT:    movq %rcx, 8(%rax)
; X86_64-NEXT:    xorq %rcx, %rcx
; X86_64-NEXT:    rdsspq %rcx
; X86_64-NEXT:    movq %rcx, 24(%rax)
; X86_64-NEXT:    #EH_SjLj_Setup LBB1_4
; X86_64-NEXT:  ## %bb.1: ## %entry
; X86_64-NEXT:    xorl %eax, %eax
; X86_64-NEXT:    testl %eax, %eax
; X86_64-NEXT:    jne LBB1_3
; X86_64-NEXT:    jmp LBB1_5
; X86_64-NEXT:  LBB1_4: ## Block address taken
; X86_64-NEXT:    ## %entry
; X86_64-NEXT:    movl $1, %eax
; X86_64-NEXT:    testl %eax, %eax
; X86_64-NEXT:    je LBB1_5
; X86_64-NEXT:  LBB1_3: ## %if.end
; X86_64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax ## 8-byte Reload
; X86_64-NEXT:    shll $2, %eax
; X86_64-NEXT:    leal (%rax,%rax,2), %eax
; X86_64-NEXT:    addq $8, %rsp
; X86_64-NEXT:    popq %rbx
; X86_64-NEXT:    popq %r12
; X86_64-NEXT:    popq %r13
; X86_64-NEXT:    popq %r14
; X86_64-NEXT:    popq %r15
; X86_64-NEXT:    popq %rbp
; X86_64-NEXT:    retq
; X86_64-NEXT:  LBB1_5: ## %if.then
; X86_64-NEXT:    callq _bar
; X86_64-NEXT:    ud2
;
; X86-LABEL: foo:
; X86:       ## %bb.0: ## %entry
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    .cfi_offset %esi, -20
; X86-NEXT:    .cfi_offset %edi, -16
; X86-NEXT:    .cfi_offset %ebx, -12
; X86-NEXT:    movl L_buf$non_lazy_ptr, %eax
; X86-NEXT:    movl (%eax), %eax
; X86-NEXT:    movl %ebp, (%eax)
; X86-NEXT:    movl %esp, 16(%eax)
; X86-NEXT:    movl $LBB1_4, 4(%eax)
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    rdsspd %ecx
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    #EH_SjLj_Setup LBB1_4
; X86-NEXT:  ## %bb.1: ## %entry
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    jne LBB1_3
; X86-NEXT:    jmp LBB1_5
; X86-NEXT:  LBB1_4: ## Block address taken
; X86-NEXT:    ## %entry
; X86-NEXT:    movl $1, %eax
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    je LBB1_5
; X86-NEXT:  LBB1_3: ## %if.end
; X86-NEXT:    movl 8(%ebp), %eax
; X86-NEXT:    shll $2, %eax
; X86-NEXT:    leal (%eax,%eax,2), %eax
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
; X86-NEXT:  LBB1_5: ## %if.then
; X86-NEXT:    calll _bar
; X86-NEXT:    ud2
entry:
  %0 = load i8*, i8** @buf, align 8
  %1 = bitcast i8* %0 to i8**
  %2 = tail call i8* @llvm.frameaddress(i32 0)
  store i8* %2, i8** %1, align 8
  %3 = tail call i8* @llvm.stacksave()
  %4 = getelementptr inbounds i8, i8* %0, i64 16
  %5 = bitcast i8* %4 to i8**
  store i8* %3, i8** %5, align 8
  %6 = tail call i32 @llvm.eh.sjlj.setjmp(i8* %0)
  %tobool = icmp eq i32 %6, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = tail call i32 @bar(i32 undef)
  unreachable

if.end:                                           ; preds = %entry
  %add2 = mul nsw i32 %i, 12
  ret i32 %add2
}

declare i8* @llvm.frameaddress(i32)
declare i8* @llvm.stacksave()
declare i32 @llvm.eh.sjlj.setjmp(i8*)

!llvm.module.flags = !{!0}

!0 = !{i32 4, !"cf-protection-return", i32 1}
