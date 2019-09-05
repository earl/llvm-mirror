; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx  | FileCheck %s

; Eliminating a shuffle means we have to replace an undef operand of a horizontal op.

define void @PR43225(<4 x double>* %p0, <4 x double>* %p1, <4 x double> %x, <4 x double> %y, <4 x double> %z) nounwind {
; CHECK-LABEL: PR43225:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm0
; CHECK-NEXT:    vmovaps (%rsi), %ymm0
; CHECK-NEXT:    vhsubpd %ymm2, %ymm2, %ymm0
; CHECK-NEXT:    vmovapd %ymm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t39 = load volatile <4 x double>, <4 x double>* %p0, align 32
  %shuffle11 = shufflevector <4 x double> %t39, <4 x double> %x, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  %t40 = load volatile <4 x double>, <4 x double>* %p1, align 32
  %t41 = tail call <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double> %shuffle11, <4 x double> %t40)
  %t42 = tail call <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double> %z, <4 x double> %t41)
  %shuffle12 = shufflevector <4 x double> %t42, <4 x double> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  store volatile <4 x double> %shuffle12, <4 x double>* %p0, align 32
  ret void
}

declare <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double>, <4 x double>)
declare <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double>, <4 x double>)
