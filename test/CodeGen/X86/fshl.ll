; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=CHECK,X64

declare i8 @llvm.fshl.i8(i8, i8, i8) nounwind readnone
declare i16 @llvm.fshl.i16(i16, i16, i16) nounwind readnone
declare i32 @llvm.fshl.i32(i32, i32, i32) nounwind readnone
declare i64 @llvm.fshl.i64(i64, i64, i64) nounwind readnone

;
; Variable Funnel Shift
;

define i8 @var_shift_i8(i8 %x, i8 %y, i8 %z) nounwind {
; X86-LABEL: var_shift_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %ah
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-NEXT:    andb $7, %dl
; X86-NEXT:    movb %al, %ch
; X86-NEXT:    movb %dl, %cl
; X86-NEXT:    shlb %cl, %ch
; X86-NEXT:    movb $8, %cl
; X86-NEXT:    subb %dl, %cl
; X86-NEXT:    shrb %cl, %ah
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    orb %ah, %ch
; X86-NEXT:    movb %ch, %al
; X86-NEXT:  .LBB0_2:
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $7, %dl
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shlb %cl, %dil
; X64-NEXT:    movb $8, %cl
; X64-NEXT:    subb %dl, %cl
; X64-NEXT:    shrb %cl, %sil
; X64-NEXT:    testb %dl, %dl
; X64-NEXT:    je .LBB0_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    orb %sil, %dil
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:  .LBB0_2:
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %tmp = tail call i8 @llvm.fshl.i8(i8 %x, i8 %y, i8 %z)
  ret i8 %tmp
}

define i16 @var_shift_i16(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: var_shift_i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl $15, %ecx
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shldw %cl, %si, %dx
; X86-NEXT:    testw %cx, %cx
; X86-NEXT:    je .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    andl $15, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shldw %cl, %si, %ax
; X64-NEXT:    testw %cx, %cx
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %tmp = tail call i16 @llvm.fshl.i16(i16 %x, i16 %y, i16 %z)
  ret i16 %tmp
}

define i32 @var_shift_i32(i32 %x, i32 %y, i32 %z) nounwind {
; X86-LABEL: var_shift_i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl $31, %ecx
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shldl %cl, %esi, %edx
; X86-NEXT:    testl %ecx, %ecx
; X86-NEXT:    je .LBB2_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:  .LBB2_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    andl $31, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shldl %cl, %esi, %eax
; X64-NEXT:    testl %ecx, %ecx
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %tmp
}

define i64 @var_shift_i64(i64 %x, i64 %y, i64 %z) nounwind {
; X86-LABEL: var_shift_i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    pushl %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    andl $63, %ebx
; X86-NEXT:    movl %eax, %edi
; X86-NEXT:    movl %ebx, %ecx
; X86-NEXT:    shll %cl, %edi
; X86-NEXT:    shldl %cl, %eax, %ebp
; X86-NEXT:    testb $32, %bl
; X86-NEXT:    je .LBB3_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %edi, %ebp
; X86-NEXT:    xorl %edi, %edi
; X86-NEXT:  .LBB3_2:
; X86-NEXT:    movl $64, %ecx
; X86-NEXT:    subl %ebx, %ecx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl %cl, %esi
; X86-NEXT:    shrdl %cl, %edx, (%esp) # 4-byte Folded Spill
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    jne .LBB3_3
; X86-NEXT:  # %bb.4:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl (%esp), %ecx # 4-byte Reload
; X86-NEXT:    testl %ebx, %ebx
; X86-NEXT:    jne .LBB3_6
; X86-NEXT:    jmp .LBB3_7
; X86-NEXT:  .LBB3_3:
; X86-NEXT:    movl %esi, %ecx
; X86-NEXT:    xorl %esi, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    testl %ebx, %ebx
; X86-NEXT:    je .LBB3_7
; X86-NEXT:  .LBB3_6:
; X86-NEXT:    orl %esi, %ebp
; X86-NEXT:    orl %ecx, %edi
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    movl %ebp, %edx
; X86-NEXT:  .LBB3_7:
; X86-NEXT:    addl $4, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdx, %rcx
; X64-NEXT:    andl $63, %ecx
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shldq %cl, %rsi, %rax
; X64-NEXT:    testq %rcx, %rcx
; X64-NEXT:    cmoveq %rdi, %rax
; X64-NEXT:    retq
  %tmp = tail call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %tmp
}

;
; Const Funnel Shift
;

define i8 @const_shift_i8(i8 %x, i8 %y) nounwind {
; X86-LABEL: const_shift_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    shrb %cl
; X86-NEXT:    shlb $7, %al
; X86-NEXT:    orb %cl, %al
; X86-NEXT:    retl
;
; X64-LABEL: const_shift_i8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrb %sil
; X64-NEXT:    shlb $7, %al
; X64-NEXT:    orb %sil, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %tmp = tail call i8 @llvm.fshl.i8(i8 %x, i8 %y, i8 7)
  ret i8 %tmp
}

define i16 @const_shift_i16(i16 %x, i16 %y) nounwind {
; X86-LABEL: const_shift_i16:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldw $7, %cx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: const_shift_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shldw $7, %si, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %tmp = tail call i16 @llvm.fshl.i16(i16 %x, i16 %y, i16 7)
  ret i16 %tmp
}

define i32 @const_shift_i32(i32 %x, i32 %y) nounwind {
; X86-LABEL: const_shift_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldl $7, %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: const_shift_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shldl $7, %esi, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 7)
  ret i32 %tmp
}

define i64 @const_shift_i64(i64 %x, i64 %y) nounwind {
; X86-LABEL: const_shift_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shrdl $25, %ecx, %eax
; X86-NEXT:    shldl $7, %ecx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: const_shift_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shldq $7, %rsi, %rax
; X64-NEXT:    retq
  %tmp = tail call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 7)
  ret i64 %tmp
}
