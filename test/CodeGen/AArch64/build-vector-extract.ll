; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

; This would crash because we did not expect to create
; a shuffle for a vector where the source operand is
; not the same size as the result.
; TODO: Should we handle this pattern? Ie, is moving to/from
; registers the optimal code?

define <4 x i32> @larger_bv_than_source(<4 x i16> %t0) {
; CHECK-LABEL: larger_bv_than_source:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.h[2]
; CHECK-NEXT:    fmov s0, w8
; CHECK-NEXT:    ret
  %t1 = extractelement <4 x i16> %t0, i32 2
  %vgetq_lane = zext i16 %t1 to i32
  %t2 = insertelement <4 x i32> undef, i32 %vgetq_lane, i64 0
  ret <4 x i32> %t2
}

