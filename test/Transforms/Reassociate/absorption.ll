; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -reassociate < %s | FileCheck %s

; Check that if constants combine to an absorbing value then the expression is
; evaluated as the absorbing value.

define i8 @or_all_ones(i8 %x) {
; CHECK-LABEL: @or_all_ones(
; CHECK-NEXT:    ret i8 -1
;
  %tmp1 = or i8 %x, 127
  %tmp2 = or i8 %tmp1, 128
  ret i8 %tmp2
}

; TODO: fmul by 0.0 with nsz+nnan should have simplified to 0.0.

define double @fmul_zero(double %x) {
; CHECK-LABEL: @fmul_zero(
; CHECK-NEXT:    [[R:%.*]] = fmul fast double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    ret double [[R]]
;
  %x4 = fmul fast double %x, 4.0
  %r = fmul fast double %x4, 0.0
  ret double %r
}

