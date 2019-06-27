; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; Tests BuildUREMEqFold for 4 x i32 splat vectors with odd divisor.
; See urem-seteq.ll for justification behind constants emitted.
define <4 x i32> @test_urem_odd_vec_i32(<4 x i32> %X) nounwind readnone {
; CHECK-LABEL: test_urem_odd_vec_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    movk w8, #52428, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    umull2 v3.2d, v0.4s, v2.4s
; CHECK-NEXT:    umull v2.2d, v0.2s, v2.2s
; CHECK-NEXT:    uzp2 v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    movi v1.4s, #5
; CHECK-NEXT:    ushr v2.4s, v2.4s, #2
; CHECK-NEXT:    mls v0.4s, v2.4s, v1.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 5, i32 5, i32 5, i32 5>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Like test_urem_odd_vec_i32, but with 8 x i16 vectors.
define <8 x i16> @test_urem_odd_vec_i16(<8 x i16> %X) nounwind readnone {
; CHECK-LABEL: test_urem_odd_vec_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    dup v2.8h, w8
; CHECK-NEXT:    umull2 v3.4s, v0.8h, v2.8h
; CHECK-NEXT:    umull v2.4s, v0.4h, v2.4h
; CHECK-NEXT:    uzp2 v2.8h, v2.8h, v3.8h
; CHECK-NEXT:    movi v1.8h, #5
; CHECK-NEXT:    ushr v2.8h, v2.8h, #2
; CHECK-NEXT:    mls v0.8h, v2.8h, v1.8h
; CHECK-NEXT:    cmeq v0.8h, v0.8h, #0
; CHECK-NEXT:    movi v1.8h, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <8 x i16> %X, <i16 5, i16 5, i16 5, i16 5,
                              i16 5, i16 5, i16 5, i16 5>
  %cmp = icmp eq <8 x i16> %urem, <i16 0, i16 0, i16 0, i16 0,
                                   i16 0, i16 0, i16 0, i16 0>
  %ret = zext <8 x i1> %cmp to <8 x i16>
  ret <8 x i16> %ret
}

; Tests BuildUREMEqFold for 4 x i32 splat vectors with even divisor.
; The expected behavior is that the fold is _not_ applied
; because it requires a ROTR in the even case, which has to be expanded.
define <4 x i32> @test_urem_even_vec_i32(<4 x i32> %X) nounwind readnone {
; CHECK-LABEL: test_urem_even_vec_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #9363
; CHECK-NEXT:    movk w8, #37449, lsl #16
; CHECK-NEXT:    ushr v1.4s, v0.4s, #1
; CHECK-NEXT:    dup v3.4s, w8
; CHECK-NEXT:    umull2 v4.2d, v1.4s, v3.4s
; CHECK-NEXT:    umull v1.2d, v1.2s, v3.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    movi v2.4s, #14
; CHECK-NEXT:    ushr v1.4s, v1.4s, #2
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 14, i32 14, i32 14, i32 14>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Like test_urem_even_vec_i32, but with 8 x i16 vectors.
; i16 is not legal for ROTR on AArch64, but ROTR also cannot be promoted to i32,
; so this would crash if BuildUREMEqFold was applied.
define <8 x i16> @test_urem_even_vec_i16(<8 x i16> %X) nounwind readnone {
; CHECK-LABEL: test_urem_even_vec_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #18725
; CHECK-NEXT:    ushr v1.8h, v0.8h, #1
; CHECK-NEXT:    dup v3.8h, w8
; CHECK-NEXT:    umull2 v4.4s, v1.8h, v3.8h
; CHECK-NEXT:    umull v1.4s, v1.4h, v3.4h
; CHECK-NEXT:    uzp2 v1.8h, v1.8h, v4.8h
; CHECK-NEXT:    movi v2.8h, #14
; CHECK-NEXT:    ushr v1.8h, v1.8h, #1
; CHECK-NEXT:    mls v0.8h, v1.8h, v2.8h
; CHECK-NEXT:    cmeq v0.8h, v0.8h, #0
; CHECK-NEXT:    movi v1.8h, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <8 x i16> %X, <i16 14, i16 14, i16 14, i16 14,
                              i16 14, i16 14, i16 14, i16 14>
  %cmp = icmp eq <8 x i16> %urem, <i16 0, i16 0, i16 0, i16 0,
                                   i16 0, i16 0, i16 0, i16 0>
  %ret = zext <8 x i1> %cmp to <8 x i16>
  ret <8 x i16> %ret
}

; We should not proceed with this fold if the divisor is 1 or -1
define <4 x i32> @test_urem_one_vec(<4 x i32> %X) nounwind readnone {
; CHECK-LABEL: test_urem_one_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.4s, #1
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 1, i32 1, i32 1, i32 1>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; BuildUREMEqFold does not work when the only odd factor of the divisor is 1.
; This ensures we don't touch powers of two.
define <4 x i32> @test_urem_pow2_vec(<4 x i32> %X) nounwind readnone {
; CHECK-LABEL: test_urem_pow2_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #15
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 16, i32 16, i32 16, i32 16>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
