; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -fast-isel-sink-local-values < %s -fast-isel -mtriple=i686-unknown-unknown -O0 -mcpu=skx | FileCheck %s

define i32 @_Z3foov() {
; CHECK-LABEL: _Z3foov:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subl $16, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 20
; CHECK-NEXT:    movw $10959, {{[0-9]+}}(%esp) # imm = 0x2ACF
; CHECK-NEXT:    movw $-15498, {{[0-9]+}}(%esp) # imm = 0xC376
; CHECK-NEXT:    movw $19417, {{[0-9]+}}(%esp) # imm = 0x4BD9
; CHECK-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmpw $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movb $1, %cl
; CHECK-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; CHECK-NEXT:    movb %cl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.1: # %lor.rhs
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    movb %al, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; CHECK-NEXT:    jmp .LBB0_2
; CHECK-NEXT:  .LBB0_2: # %lor.end
; CHECK-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; CHECK-NEXT:    cmpl %ecx, %edx
; CHECK-NEXT:    setl %al
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    xorl $-1, %ecx
; CHECK-NEXT:    cmpl $0, %ecx
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    movb %al, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; CHECK-NEXT:    jne .LBB0_4
; CHECK-NEXT:  # %bb.3: # %lor.rhs4
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    movb %al, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; CHECK-NEXT:    jmp .LBB0_4
; CHECK-NEXT:  .LBB0_4: # %lor.end5
; CHECK-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    # kill: def $cx killed $cx killed $ecx
; CHECK-NEXT:    movw %cx, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    addl $16, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
  %aa = alloca i16, align 2
  %bb = alloca i16, align 2
  %cc = alloca i16, align 2
  store i16 10959, i16* %aa, align 2
  store i16 -15498, i16* %bb, align 2
  store i16 19417, i16* %cc, align 2
  %0 = load i16, i16* %aa, align 2
  %conv = zext i16 %0 to i32
  %1 = load i16, i16* %cc, align 2
  %tobool = icmp ne i16 %1, 0
  br i1 %tobool, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %entry
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %entry
  %2 = phi i1 [ true, %entry ], [ false, %lor.rhs ]
  %conv1 = zext i1 %2 to i32
  %cmp = icmp slt i32 %conv, %conv1
  %conv2 = zext i1 %cmp to i32
  %neg = xor i32 %conv2, -1
  %tobool3 = icmp ne i32 %neg, 0
  br i1 %tobool3, label %lor.end5, label %lor.rhs4

lor.rhs4:                                         ; preds = %lor.end
  br label %lor.end5

lor.end5:                                         ; preds = %lor.rhs4, %lor.end
  %3 = phi i1 [ true, %lor.end ], [ false, %lor.rhs4 ]
  %conv6 = zext i1 %3 to i16
  store i16 %conv6, i16* %bb, align 2
  %4 = load i16, i16* %bb, align 2
  %conv7 = zext i16 %4 to i32
  ret i32 %conv7
}
