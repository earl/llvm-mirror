; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

; This file contains tests that should have identical output for the lp64 and
; lp64f ABIs. It doesn't check codegen when frame pointer elimination is
; disabled, as there is sufficient coverage for this case in other files.

define i64 @callee_double_in_regs(i64 %a, double %b) nounwind {
; RV64I-LABEL: callee_double_in_regs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    sd s0, 0(sp)
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    call __fixdfdi
; RV64I-NEXT:    add a0, s0, a0
; RV64I-NEXT:    ld s0, 0(sp)
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %b_fptosi = fptosi double %b to i64
  %1 = add i64 %a, %b_fptosi
  ret i64 %1
}

define i64 @caller_double_in_regs() nounwind {
; RV64I-LABEL: caller_double_in_regs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    addi a0, zero, 1
; RV64I-NEXT:    slli a1, a0, 62
; RV64I-NEXT:    addi a0, zero, 1
; RV64I-NEXT:    call callee_double_in_regs
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call i64 @callee_double_in_regs(i64 1, double 2.0)
  ret i64 %1
}

define double @callee_double_ret() nounwind {
; RV64I-LABEL: callee_double_ret:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, zero, 1023
; RV64I-NEXT:    slli a0, a0, 52
; RV64I-NEXT:    ret
  ret double 1.0
}

define i64 @caller_double_ret() nounwind {
; RV64I-LABEL: caller_double_ret:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    call callee_double_ret
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call double @callee_double_ret()
  %2 = bitcast double %1 to i64
  ret i64 %2
}
