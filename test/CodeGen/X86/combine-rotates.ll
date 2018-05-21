; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+xop | FileCheck %s --check-prefix=XOP
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=AVX512

; fold (rot (rot x, c1), c2) -> rot x, c1+c2
define <4 x i32> @combine_vec_rot_rot(<4 x i32> %x) {
; XOP-LABEL: combine_vec_rot_rot:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd {{.*}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: combine_vec_rot_rot:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprolvd {{.*}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 2, i32 3, i32 4>
  %2 = shl <4 x i32> %x, <i32 31, i32 30, i32 29, i32 28>
  %3 = or <4 x i32> %1, %2
  %4 = lshr <4 x i32> %3, <i32 12, i32 13, i32 14, i32 15>
  %5 = shl <4 x i32> %3, <i32 20, i32 19, i32 18, i32 17>
  %6 = or <4 x i32> %4, %5
  ret <4 x i32> %6
}

define <4 x i32> @combine_vec_rot_rot_splat(<4 x i32> %x) {
; XOP-LABEL: combine_vec_rot_rot_splat:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd $7, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: combine_vec_rot_rot_splat:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprold $7, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 3, i32 3, i32 3, i32 3>
  %2 = shl <4 x i32> %x, <i32 29, i32 29, i32 29, i32 29>
  %3 = or <4 x i32> %1, %2
  %4 = lshr <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  %5 = shl <4 x i32> %3, <i32 10, i32 10, i32 10, i32 10>
  %6 = or <4 x i32> %4, %5
  ret <4 x i32> %6
}

define <4 x i32> @combine_vec_rot_rot_splat_zero(<4 x i32> %x) {
; XOP-LABEL: combine_vec_rot_rot_splat_zero:
; XOP:       # %bb.0:
; XOP-NEXT:    retq
;
; AVX512-LABEL: combine_vec_rot_rot_splat_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  %2 = shl <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %3 = or <4 x i32> %1, %2
  %4 = lshr <4 x i32> %3, <i32 31, i32 31, i32 31, i32 31>
  %5 = shl <4 x i32> %3, <i32 1, i32 1, i32 1, i32 1>
  %6 = or <4 x i32> %4, %5
  ret <4 x i32> %6
}

define <4 x i32> @rotate_demanded_bits(<4 x i32>, <4 x i32>) {
; XOP-LABEL: rotate_demanded_bits:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqa {{.*#+}} xmm2 = [30,30,30,30]
; XOP-NEXT:    vpand %xmm2, %xmm1, %xmm1
; XOP-NEXT:    vpshld %xmm1, %xmm0, %xmm3
; XOP-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; XOP-NEXT:    vpsubd %xmm1, %xmm4, %xmm1
; XOP-NEXT:    vpand %xmm2, %xmm1, %xmm1
; XOP-NEXT:    vpsubd %xmm1, %xmm4, %xmm1
; XOP-NEXT:    vpshld %xmm1, %xmm0, %xmm0
; XOP-NEXT:    vpor %xmm3, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rotate_demanded_bits:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [30,30,30,30]
; AVX512-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vpsllvd %xmm1, %xmm0, %xmm3
; AVX512-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; AVX512-NEXT:    vpsubd %xmm1, %xmm4, %xmm1
; AVX512-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vpor %xmm3, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %3 = and <4 x i32> %1, <i32 30, i32 30, i32 30, i32 30>
  %4 = shl <4 x i32> %0, %3
  %5 = sub nsw <4 x i32> zeroinitializer, %3
  %6 = and <4 x i32> %5, <i32 30, i32 30, i32 30, i32 30>
  %7 = lshr <4 x i32> %0, %6
  %8 = or <4 x i32> %7, %4
  ret <4 x i32> %8
}

define <4 x i32> @rotate_demanded_bits_2(<4 x i32>, <4 x i32>) {
; XOP-LABEL: rotate_demanded_bits_2:
; XOP:       # %bb.0:
; XOP-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; XOP-NEXT:    vprotd %xmm1, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rotate_demanded_bits_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpandd {{.*}}(%rip){1to4}, %xmm1, %xmm1
; AVX512-NEXT:    vprolvd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %3 = and <4 x i32> %1, <i32 23, i32 23, i32 23, i32 23>
  %4 = shl <4 x i32> %0, %3
  %5 = sub nsw <4 x i32> zeroinitializer, %3
  %6 = and <4 x i32> %5, <i32 31, i32 31, i32 31, i32 31>
  %7 = lshr <4 x i32> %0, %6
  %8 = or <4 x i32> %7, %4
  ret <4 x i32> %8
}

define <4 x i32> @rotate_demanded_bits_3(<4 x i32>, <4 x i32>) {
; XOP-LABEL: rotate_demanded_bits_3:
; XOP:       # %bb.0:
; XOP-NEXT:    vpaddd %xmm1, %xmm1, %xmm1
; XOP-NEXT:    vmovdqa {{.*#+}} xmm2 = [30,30,30,30]
; XOP-NEXT:    vpand %xmm2, %xmm1, %xmm3
; XOP-NEXT:    vpshld %xmm3, %xmm0, %xmm3
; XOP-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; XOP-NEXT:    vpsubd %xmm1, %xmm4, %xmm1
; XOP-NEXT:    vpand %xmm2, %xmm1, %xmm1
; XOP-NEXT:    vpsubd %xmm1, %xmm4, %xmm1
; XOP-NEXT:    vpshld %xmm1, %xmm0, %xmm0
; XOP-NEXT:    vpor %xmm0, %xmm3, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rotate_demanded_bits_3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpaddd %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [30,30,30,30]
; AVX512-NEXT:    vpand %xmm2, %xmm1, %xmm3
; AVX512-NEXT:    vpsllvd %xmm3, %xmm0, %xmm3
; AVX512-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; AVX512-NEXT:    vpsubd %xmm1, %xmm4, %xmm1
; AVX512-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vpor %xmm0, %xmm3, %xmm0
; AVX512-NEXT:    retq
  %3 = shl <4 x i32> %1, <i32 1, i32 1, i32 1, i32 1>
  %4 = and <4 x i32> %3, <i32 30, i32 30, i32 30, i32 30>
  %5 = shl <4 x i32> %0, %4
  %6 = sub <4 x i32> zeroinitializer, %3
  %7 = and <4 x i32> %6, <i32 30, i32 30, i32 30, i32 30>
  %8 = lshr <4 x i32> %0, %7
  %9 = or <4 x i32> %5, %8
  ret <4 x i32> %9
}
