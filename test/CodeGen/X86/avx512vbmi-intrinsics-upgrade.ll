; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512vbmi | FileCheck %s
declare <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_permvar_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_permvar_qi_512:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpermb %zmm0, %zmm1, %zmm3
; CHECK-NEXT:    kmovq %rdi, %k1
; CHECK-NEXT:    vpermb %zmm0, %zmm1, %zmm2 {%k1}
; CHECK-NEXT:    vpermb %zmm0, %zmm1, %zmm0 {%k1} {z}
; CHECK-NEXT:    vpaddb %zmm3, %zmm0, %zmm0
; CHECK-NEXT:    vpaddb %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    retq
 %res = call <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
 %res1 = call <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> zeroinitializer, i64 %x3)
 %res2 = call <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
 %res3 = add <64 x i8> %res, %res1
 %res4 = add <64 x i8> %res3, %res2
 ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_vpermi2var_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpermi2var_qi_512:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovdqa64 %zmm0, %zmm3
; CHECK-NEXT:    vpermt2b %zmm2, %zmm1, %zmm3
; CHECK-NEXT:    kmovq %rdi, %k1
; CHECK-NEXT:    vpermi2b %zmm2, %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpermi2b %zmm2, %zmm0, %zmm4 {%k1} {z}
; CHECK-NEXT:    vpaddb %zmm3, %zmm4, %zmm0
; CHECK-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %x0, <64 x i8> zeroinitializer, <64 x i8> %x2, i64 %x3)
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
  %res3 = add <64 x i8> %res, %res1
  %res4 = add <64 x i8> %res3, %res2
  ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_vpermt2var_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpermt2var_qi_512:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovdqa64 %zmm1, %zmm3
; CHECK-NEXT:    vpermt2b %zmm2, %zmm0, %zmm3
; CHECK-NEXT:    kmovq %rdi, %k1
; CHECK-NEXT:    vpermt2b %zmm2, %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpermt2b %zmm2, %zmm0, %zmm4 {%k1} {z}
; CHECK-NEXT:    vpaddb %zmm3, %zmm4, %zmm0
; CHECK-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %res = call <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> zeroinitializer, <64 x i8> %x2, i64 %x3)
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
  %res3 = add <64 x i8> %res, %res1
  %res4 = add <64 x i8> %res3, %res2
  ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_maskz_vpermt2var_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; CHECK-LABEL: test_int_x86_avx512_maskz_vpermt2var_qi_512:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    kmovq %rdi, %k1
; CHECK-NEXT:    vpermi2b %zmm2, %zmm1, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <64 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  ret <64 x i8> %res
}
