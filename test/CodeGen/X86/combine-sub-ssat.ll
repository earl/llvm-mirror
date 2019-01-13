; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=CHECK,SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX,AVX512,AVX512BW

declare  i32 @llvm.ssub.sat.i32  (i32, i32)
declare  i64 @llvm.ssub.sat.i64  (i64, i64)
declare  <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16>, <8 x i16>)

; fold (ssub_sat c, 0) -> x
define i32 @combine_zero_i32(i32 %a0) {
; CHECK-LABEL: combine_zero_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    subl $0, %ecx
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    subl $0, %edi
; CHECK-NEXT:    cmovnol %edi, %eax
; CHECK-NEXT:    retq
  %1 = call i32 @llvm.ssub.sat.i32(i32 %a0, i32 0);
  ret i32 %1
}

define <8 x i16> @combine_zero_v8i16(<8 x i16> %a0) {
; SSE-LABEL: combine_zero_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_zero_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpsubsw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %a0, <8 x i16> zeroinitializer);
  ret <8 x i16> %1
}
