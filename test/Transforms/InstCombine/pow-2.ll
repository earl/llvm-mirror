; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the pow library call simplifier works correctly.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

declare float @pow(double, double)

; Check that pow functions with the wrong prototype aren't simplified.

define float @test_no_simplify1(double %x) {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[RETVAL:%.*]] = call float @pow(double 1.000000e+00, double [[X:%.*]])
; CHECK-NEXT:    ret float [[RETVAL]]
;
  %retval = call float @pow(double 1.0, double %x)
  ret float %retval
}

