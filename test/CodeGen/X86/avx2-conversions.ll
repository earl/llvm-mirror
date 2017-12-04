; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=X64

define <4 x i32> @trunc4(<4 x i64> %A) nounwind {
; X32-LABEL: trunc4:
; X32:       # %bb.0:
; X32-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,2,2,3,4,6,6,7]
; X32-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X32-NEXT:    # kill: %xmm0<def> %xmm0<kill> %ymm0<kill>
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: trunc4:
; X64:       # %bb.0:
; X64-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,2,2,3,4,6,6,7]
; X64-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X64-NEXT:    # kill: %xmm0<def> %xmm0<kill> %ymm0<kill>
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %B = trunc <4 x i64> %A to <4 x i32>
  ret <4 x i32>%B
}

define <8 x i16> @trunc8(<8 x i32> %A) nounwind {
; X32-LABEL: trunc8:
; X32:       # %bb.0:
; X32-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X32-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X32-NEXT:    # kill: %xmm0<def> %xmm0<kill> %ymm0<kill>
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: trunc8:
; X64:       # %bb.0:
; X64-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; X64-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; X64-NEXT:    # kill: %xmm0<def> %xmm0<kill> %ymm0<kill>
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %B = trunc <8 x i32> %A to <8 x i16>
  ret <8 x i16>%B
}

define <4 x i64> @sext4(<4 x i32> %A) nounwind {
; X32-LABEL: sext4:
; X32:       # %bb.0:
; X32-NEXT:    vpmovsxdq %xmm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: sext4:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    retq
  %B = sext <4 x i32> %A to <4 x i64>
  ret <4 x i64>%B
}

define <8 x i32> @sext8(<8 x i16> %A) nounwind {
; X32-LABEL: sext8:
; X32:       # %bb.0:
; X32-NEXT:    vpmovsxwd %xmm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: sext8:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxwd %xmm0, %ymm0
; X64-NEXT:    retq
  %B = sext <8 x i16> %A to <8 x i32>
  ret <8 x i32>%B
}

define <4 x i64> @zext4(<4 x i32> %A) nounwind {
; X32-LABEL: zext4:
; X32:       # %bb.0:
; X32-NEXT:    vpmovzxdq {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; X32-NEXT:    retl
;
; X64-LABEL: zext4:
; X64:       # %bb.0:
; X64-NEXT:    vpmovzxdq {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; X64-NEXT:    retq
  %B = zext <4 x i32> %A to <4 x i64>
  ret <4 x i64>%B
}

define <8 x i32> @zext8(<8 x i16> %A) nounwind {
; X32-LABEL: zext8:
; X32:       # %bb.0:
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X32-NEXT:    retl
;
; X64-LABEL: zext8:
; X64:       # %bb.0:
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    retq
  %B = zext <8 x i16> %A to <8 x i32>
  ret <8 x i32>%B
}

define <8 x i32> @zext_8i8_8i32(<8 x i8> %A) nounwind {
; X32-LABEL: zext_8i8_8i32:
; X32:       # %bb.0:
; X32-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X32-NEXT:    retl
;
; X64-LABEL: zext_8i8_8i32:
; X64:       # %bb.0:
; X64-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    retq
  %B = zext <8 x i8> %A to <8 x i32>
  ret <8 x i32>%B
}

define <16 x i16> @zext_16i8_16i16(<16 x i8> %z) {
; X32-LABEL: zext_16i8_16i16:
; X32:       # %bb.0:
; X32-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; X32-NEXT:    retl
;
; X64-LABEL: zext_16i8_16i16:
; X64:       # %bb.0:
; X64-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; X64-NEXT:    retq
  %t = zext <16 x i8> %z to <16 x i16>
  ret <16 x i16> %t
}

define <16 x i16> @sext_16i8_16i16(<16 x i8> %z) {
; X32-LABEL: sext_16i8_16i16:
; X32:       # %bb.0:
; X32-NEXT:    vpmovsxbw %xmm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: sext_16i8_16i16:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxbw %xmm0, %ymm0
; X64-NEXT:    retq
  %t = sext <16 x i8> %z to <16 x i16>
  ret <16 x i16> %t
}

define <16 x i8> @trunc_16i16_16i8(<16 x i16> %z) {
; X32-LABEL: trunc_16i16_16i8:
; X32:       # %bb.0:
; X32-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X32-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; X32-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; X32-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; X32-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: trunc_16i16_16i8:
; X64:       # %bb.0:
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; X64-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; X64-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; X64-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %t = trunc <16 x i16> %z to <16 x i8>
  ret <16 x i8> %t
}

define <4 x i64> @load_sext_test1(<4 x i32> *%ptr) {
; X32-LABEL: load_sext_test1:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vpmovsxdq (%eax), %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: load_sext_test1:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxdq (%rdi), %ymm0
; X64-NEXT:    retq
 %X = load <4 x i32>, <4 x i32>* %ptr
 %Y = sext <4 x i32> %X to <4 x i64>
 ret <4 x i64>%Y
}

define <4 x i64> @load_sext_test2(<4 x i8> *%ptr) {
; X32-LABEL: load_sext_test2:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vpmovsxbq (%eax), %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: load_sext_test2:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxbq (%rdi), %ymm0
; X64-NEXT:    retq
 %X = load <4 x i8>, <4 x i8>* %ptr
 %Y = sext <4 x i8> %X to <4 x i64>
 ret <4 x i64>%Y
}

define <4 x i64> @load_sext_test3(<4 x i16> *%ptr) {
; X32-LABEL: load_sext_test3:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vpmovsxwq (%eax), %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: load_sext_test3:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxwq (%rdi), %ymm0
; X64-NEXT:    retq
 %X = load <4 x i16>, <4 x i16>* %ptr
 %Y = sext <4 x i16> %X to <4 x i64>
 ret <4 x i64>%Y
}

define <8 x i32> @load_sext_test4(<8 x i16> *%ptr) {
; X32-LABEL: load_sext_test4:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vpmovsxwd (%eax), %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: load_sext_test4:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxwd (%rdi), %ymm0
; X64-NEXT:    retq
 %X = load <8 x i16>, <8 x i16>* %ptr
 %Y = sext <8 x i16> %X to <8 x i32>
 ret <8 x i32>%Y
}

define <8 x i32> @load_sext_test5(<8 x i8> *%ptr) {
; X32-LABEL: load_sext_test5:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vpmovsxbd (%eax), %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: load_sext_test5:
; X64:       # %bb.0:
; X64-NEXT:    vpmovsxbd (%rdi), %ymm0
; X64-NEXT:    retq
 %X = load <8 x i8>, <8 x i8>* %ptr
 %Y = sext <8 x i8> %X to <8 x i32>
 ret <8 x i32>%Y
}
