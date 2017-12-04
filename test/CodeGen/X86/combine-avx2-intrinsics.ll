; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s

; Verify that the backend correctly combines AVX2 builtin intrinsics.


define <16 x i16> @test_x86_avx2_pblendw(<16 x i16> %a0) {
; CHECK-LABEL: test_x86_avx2_pblendw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx2.pblendw(<16 x i16> %a0, <16 x i16> %a0, i32 7)
  ret <16 x i16> %res
}

define <4 x i32> @test_x86_avx2_pblendd_128(<4 x i32> %a0) {
; CHECK-LABEL: test_x86_avx2_pblendd_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx2.pblendd.128(<4 x i32> %a0, <4 x i32> %a0, i32 7)
  ret <4 x i32> %res
}

define <8 x i32> @test_x86_avx2_pblendd_256(<8 x i32> %a0) {
; CHECK-LABEL: test_x86_avx2_pblendd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx2.pblendd.256(<8 x i32> %a0, <8 x i32> %a0, i32 7)
  ret <8 x i32> %res
}

define <16 x i16> @test2_x86_avx2_pblendw(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: test2_x86_avx2_pblendw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx2.pblendw(<16 x i16> %a0, <16 x i16> %a1, i32 0)
  ret <16 x i16> %res
}

define <4 x i32> @test2_x86_avx2_pblendd_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test2_x86_avx2_pblendd_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx2.pblendd.128(<4 x i32> %a0, <4 x i32> %a1, i32 0)
  ret <4 x i32> %res
}

define <8 x i32> @test2_x86_avx2_pblendd_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: test2_x86_avx2_pblendd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx2.pblendd.256(<8 x i32> %a0, <8 x i32> %a1, i32 0)
  ret <8 x i32> %res
}

define <16 x i16> @test3_x86_avx2_pblendw(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: test3_x86_avx2_pblendw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx2.pblendw(<16 x i16> %a0, <16 x i16> %a1, i32 -1)
  ret <16 x i16> %res
}

define <4 x i32> @test3_x86_avx2_pblendd_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: test3_x86_avx2_pblendd_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx2.pblendd.128(<4 x i32> %a0, <4 x i32> %a1, i32 -1)
  ret <4 x i32> %res
}

define <8 x i32> @test3_x86_avx2_pblendd_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: test3_x86_avx2_pblendd_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx2.pblendd.256(<8 x i32> %a0, <8 x i32> %a1, i32 -1)
  ret <8 x i32> %res
}

declare <16 x i16> @llvm.x86.avx2.pblendw(<16 x i16>, <16 x i16>, i32)
declare <4 x i32> @llvm.x86.avx2.pblendd.128(<4 x i32>, <4 x i32>, i32)
declare <8 x i32> @llvm.x86.avx2.pblendd.256(<8 x i32>, <8 x i32>, i32)

