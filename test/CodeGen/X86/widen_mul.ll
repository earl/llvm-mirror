; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW

; Test multiplies of various narrow types.

define <2 x i8> @mul_v2i8(<2 x i8> %x, <2 x i8> %y) {
; SSE2-LABEL: mul_v2i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    pmullw %xmm1, %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v2i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    pmullw %xmm1, %xmm0
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE41-NEXT:    retq
;
; AVX-LABEL: mul_v2i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmovzxbw {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    retq
  %res = mul <2 x i8> %x, %y
  ret <2 x i8> %res
}

define <4 x i8> @mul_v4i8(<4 x i8> %x, <4 x i8> %y) {
; SSE2-LABEL: mul_v4i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    pmullw %xmm1, %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v4i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    pmullw %xmm1, %xmm0
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE41-NEXT:    retq
;
; AVX-LABEL: mul_v4i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmovzxbw {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    retq
  %res = mul <4 x i8> %x, %y
  ret <4 x i8> %res
}

define <8 x i8> @mul_v8i8(<8 x i8> %x, <8 x i8> %y) {
; SSE2-LABEL: mul_v8i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    pmullw %xmm1, %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v8i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    pmullw %xmm1, %xmm0
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; SSE41-NEXT:    retq
;
; AVX-LABEL: mul_v8i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmovzxbw {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX-NEXT:    retq
  %res = mul <8 x i8> %x, %y
  ret <8 x i8> %res
}

define <2 x i16> @mul_v2i16(<2 x i16> %x, <2 x i16> %y) {
; SSE-LABEL: mul_v2i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmullw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mul_v2i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = mul <2 x i16> %x, %y
  ret <2 x i16> %res
}

define <4 x i16> @mul_v4i16(<4 x i16> %x, <4 x i16> %y) {
; SSE-LABEL: mul_v4i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmullw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mul_v4i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = mul <4 x i16> %x, %y
  ret <4 x i16> %res
}

define <2 x i32> @mul_v2i32(<2 x i32> %x, <2 x i32> %y) {
; SSE2-LABEL: mul_v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmulld %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: mul_v2i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = mul <2 x i32> %x, %y
  ret <2 x i32> %res
}
