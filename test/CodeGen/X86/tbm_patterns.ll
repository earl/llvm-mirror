; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+tbm < %s | FileCheck %s

define i32 @test_x86_tbm_bextri_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 4
  %t1 = and i32 %t0, 4095
  ret i32 %t1
}

; Make sure we still use AH subreg trick for extracting bits 15:8
define i32 @test_x86_tbm_bextri_u32_subreg(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_subreg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 8
  %t1 = and i32 %t0, 255
  ret i32 %t1
}

define i32 @test_x86_tbm_bextri_u32_m(i32* nocapture %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_m:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl $3076, (%rdi), %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = load i32, i32* %a
  %t1 = lshr i32 %t0, 4
  %t2 = and i32 %t1, 4095
  ret i32 %t2
}

define i32 @test_x86_tbm_bextri_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 4
  %t1 = and i32 %t0, 4095
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_bextri_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    bextrl $3076, %edi, %ecx # imm = 0xC04
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 4
  %t1 = and i32 %t0, 4095
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_bextri_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 4
  %t1 = and i64 %t0, 4095
  ret i64 %t1
}

; Make sure we still use AH subreg trick for extracting bits 15:8
define i64 @test_x86_tbm_bextri_u64_subreg(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_subreg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 8
  %t1 = and i64 %t0, 255
  ret i64 %t1
}

define i64 @test_x86_tbm_bextri_u64_m(i64* nocapture %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_m:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl $3076, (%rdi), %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = load i64, i64* %a
  %t1 = lshr i64 %t0, 4
  %t2 = and i64 %t1, 4095
  ret i64 %t2
}

define i64 @test_x86_tbm_bextri_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 4
  %t1 = and i64 %t0, 4095
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_bextri_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    bextrl $3076, %edi, %ecx # imm = 0xC04
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 4
  %t1 = and i64 %t0, 4095
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blcfill_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcfilll %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = and i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blcfill_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcfilll %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = and i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blcfill_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blcfilll %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = and i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blcfill_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcfillq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = and i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blcfill_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcfillq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = and i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blcfill_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blcfillq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = and i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blci_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcil %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 1, %a
  %t1 = xor i32 %t0, -1
  %t2 = or i32 %t1, %a
  ret i32 %t2
}

define i32 @test_x86_tbm_blci_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcil %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 1, %a
  %t1 = xor i32 %t0, -1
  %t2 = or i32 %t1, %a
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_blci_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blcil %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 1, %a
  %t1 = xor i32 %t0, -1
  %t2 = or i32 %t1, %a
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_blci_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blciq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 1, %a
  %t1 = xor i64 %t0, -1
  %t2 = or i64 %t1, %a
  ret i64 %t2
}

define i64 @test_x86_tbm_blci_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blciq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 1, %a
  %t1 = xor i64 %t0, -1
  %t2 = or i64 %t1, %a
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_blci_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blciq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 1, %a
  %t1 = xor i64 %t0, -1
  %t2 = or i64 %t1, %a
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_blci_u32_b(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcil %edi, %eax
; CHECK-NEXT:    retq
  %t0 = sub i32 -2, %a
  %t1 = or i32 %t0, %a
  ret i32 %t1
}

define i64 @test_x86_tbm_blci_u64_b(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blciq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = sub i64 -2, %a
  %t1 = or i64 %t0, %a
  ret i64 %t1
}

define i32 @test_x86_tbm_blcic_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcicl %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = and i32 %t1, %t0
  ret i32 %t2
}

define i32 @test_x86_tbm_blcic_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcicl %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = and i32 %t1, %t0
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_blcic_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blcicl %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = and i32 %t1, %t0
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_blcic_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcicq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = and i64 %t1, %t0
  ret i64 %t2
}

define i64 @test_x86_tbm_blcic_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcicq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = and i64 %t1, %t0
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_blcic_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blcicq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = and i64 %t1, %t0
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_blcmsk_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcmskl %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = xor i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blcmsk_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcmskl %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = xor i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blcmsk_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blcmskl %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = xor i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blcmsk_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcmskq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = xor i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blcmsk_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcmskq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = xor i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blcmsk_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blcmskq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = xor i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blcs_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcsl %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = or i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blcs_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcsl %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blcs_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blcsl %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blcs_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcsq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = or i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blcs_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blcsq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blcs_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blcsq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blsfill_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsfilll %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, -1
  %t1 = or i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blsfill_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsfilll %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, -1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blsfill_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blsfilll %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, -1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blsfill_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsfillq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, -1
  %t1 = or i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blsfill_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsfillq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, -1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blsfill_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blsfillq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, -1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blsic_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsicl %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @test_x86_tbm_blsic_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsicl %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_blsic_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    blsicl %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_blsic_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsicq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = or i64 %t0, %t1
  ret i64 %t2
}

define i64 @test_x86_tbm_blsic_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blsicq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_blsic_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    blsicq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_t1mskc_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    t1mskcl %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @test_x86_tbm_t1mskc_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    t1mskcl %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_t1mskc_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    t1mskcl %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_t1mskc_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    t1mskcq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = or i64 %t0, %t1
  ret i64 %t2
}

define i64 @test_x86_tbm_t1mskc_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    t1mskcq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_t1mskc_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    t1mskcq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_tzmsk_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    tzmskl %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = and i32 %t0, %t1
  ret i32 %t2
}

define i32 @test_x86_tbm_tzmsk_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u32_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    tzmskl %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = and i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_tzmsk_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u32_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    tzmskl %edi, %ecx
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = and i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_tzmsk_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    tzmskq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = and i64 %t0, %t1
  ret i64 %t2
}

define i64 @test_x86_tbm_tzmsk_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u64_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    tzmskq %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = and i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_tzmsk_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u64_z2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    tzmskq %rdi, %rcx
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = and i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i64 @test_and_large_constant_mask(i64 %x) {
; CHECK-LABEL: test_and_large_constant_mask:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    bextrq $15872, %rdi, %rax # imm = 0x3E00
; CHECK-NEXT:    retq
entry:
  %and = and i64 %x, 4611686018427387903
  ret i64 %and
}

define i64 @test_and_large_constant_mask_load(i64* %x) {
; CHECK-LABEL: test_and_large_constant_mask_load:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    bextrq $15872, (%rdi), %rax # imm = 0x3E00
; CHECK-NEXT:    retq
entry:
  %x1 = load i64, i64* %x
  %and = and i64 %x1, 4611686018427387903
  ret i64 %and
}

; Make sure the mask doesn't break our matching of blcic
define  i64 @masked_blcic(i64) {
; CHECK-LABEL: masked_blcic:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl %di, %eax
; CHECK-NEXT:    blcicl %eax, %eax
; CHECK-NEXT:    retq
  %2 = and i64 %0, 65535
  %3 = xor i64 %2, -1
  %4 = add nuw nsw i64 %2, 1
  %5 = and i64 %4, %3
  ret i64 %5
}

define i32 @blcic32_branch(i32 %x) nounwind {
; CHECK-LABEL: blcic32_branch:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    incl %ebx
; CHECK-NEXT:    andl %eax, %ebx
; CHECK-NEXT:    jne .LBB69_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    callq bar
; CHECK-NEXT:  .LBB69_2:
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %tmp = xor i32 %x, -1
  %tmp2 = add i32 %x, 1
  %tmp3 = and i32 %tmp, %tmp2
  %cmp = icmp eq i32 %tmp3, 0
  br i1 %cmp, label %1, label %2

  tail call void @bar()
  br label %2
  ret i32 %tmp3
}

define i64 @blcic64_branch(i64 %x) nounwind {
; CHECK-LABEL: blcic64_branch:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    movq %rdi, %rbx
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    incq %rbx
; CHECK-NEXT:    andq %rax, %rbx
; CHECK-NEXT:    jne .LBB70_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    callq bar
; CHECK-NEXT:  .LBB70_2:
; CHECK-NEXT:    movq %rbx, %rax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %tmp = xor i64 %x, -1
  %tmp2 = add i64 %x, 1
  %tmp3 = and i64 %tmp, %tmp2
  %cmp = icmp eq i64 %tmp3, 0
  br i1 %cmp, label %1, label %2

  tail call void @bar()
  br label %2
  ret i64 %tmp3
}

define i32 @tzmsk32_branch(i32 %x) nounwind {
; CHECK-LABEL: tzmsk32_branch:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    decl %ebx
; CHECK-NEXT:    andl %eax, %ebx
; CHECK-NEXT:    jne .LBB71_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    callq bar
; CHECK-NEXT:  .LBB71_2:
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %tmp = xor i32 %x, -1
  %tmp2 = add i32 %x, -1
  %tmp3 = and i32 %tmp, %tmp2
  %cmp = icmp eq i32 %tmp3, 0
  br i1 %cmp, label %1, label %2

  tail call void @bar()
  br label %2
  ret i32 %tmp3
}

define i64 @tzmsk64_branch(i64 %x) nounwind {
; CHECK-LABEL: tzmsk64_branch:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    movq %rdi, %rbx
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    decq %rbx
; CHECK-NEXT:    andq %rax, %rbx
; CHECK-NEXT:    jne .LBB72_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    callq bar
; CHECK-NEXT:  .LBB72_2:
; CHECK-NEXT:    movq %rbx, %rax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %tmp = xor i64 %x, -1
  %tmp2 = add i64 %x, -1
  %tmp3 = and i64 %tmp, %tmp2
  %cmp = icmp eq i64 %tmp3, 0
  br i1 %cmp, label %1, label %2

  tail call void @bar()
  br label %2
  ret i64 %tmp3
}

declare void @bar()
