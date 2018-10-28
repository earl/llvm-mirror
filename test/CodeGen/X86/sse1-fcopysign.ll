; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=-sse2,+sse | FileCheck %s --check-prefix=ALL --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=-sse2,+sse | FileCheck %s --check-prefix=ALL --check-prefix=X64

define float @f32_pos(float %a, float %b) nounwind {
; X86-LABEL: f32_pos:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    andps {{\.LCPI.*}}, %xmm0
; X86-NEXT:    movss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: f32_pos:
; X64:       # %bb.0:
; X64-NEXT:    andps {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %tmp = tail call float @llvm.copysign.f32(float %a, float 1.0)
  ret float %tmp
}

define float @f32_neg(float %a, float %b) nounwind {
; X86-LABEL: f32_neg:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    orps {{\.LCPI.*}}, %xmm0
; X86-NEXT:    movss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: f32_neg:
; X64:       # %bb.0:
; X64-NEXT:    orps {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %tmp = tail call float @llvm.copysign.f32(float %a, float -1.0)
  ret float %tmp
}

define <4 x float> @v4f32_pos(<4 x float> %a, <4 x float> %b) nounwind {
; X86-LABEL: v4f32_pos:
; X86:       # %bb.0:
; X86-NEXT:    andps {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: v4f32_pos:
; X64:       # %bb.0:
; X64-NEXT:    andps {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %tmp = tail call <4 x float> @llvm.copysign.v4f32(<4 x float> %a, <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>)
  ret <4 x float> %tmp
}

define <4 x float> @v4f32_neg(<4 x float> %a, <4 x float> %b) nounwind {
; X86-LABEL: v4f32_neg:
; X86:       # %bb.0:
; X86-NEXT:    orps {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: v4f32_neg:
; X64:       # %bb.0:
; X64-NEXT:    orps {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %tmp = tail call <4 x float> @llvm.copysign.v4f32(<4 x float> %a, <4 x float> <float -1.0, float -1.0, float -1.0, float -1.0>)
  ret <4 x float> %tmp
}

define <4 x float> @v4f32_const_mag(<4 x float> %a, <4 x float> %b) nounwind {
; X86-LABEL: v4f32_const_mag:
; X86:       # %bb.0:
; X86-NEXT:    andps {{\.LCPI.*}}, %xmm1
; X86-NEXT:    movaps {{.*#+}} xmm0 = [1,1,1,1]
; X86-NEXT:    andps {{\.LCPI.*}}, %xmm0
; X86-NEXT:    orps %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: v4f32_const_mag:
; X64:       # %bb.0:
; X64-NEXT:    andps {{.*}}(%rip), %xmm1
; X64-NEXT:    movaps {{.*#+}} xmm0 = [1,1,1,1]
; X64-NEXT:    andps {{.*}}(%rip), %xmm0
; X64-NEXT:    orps %xmm1, %xmm0
; X64-NEXT:    retq
  %tmp = tail call <4 x float> @llvm.copysign.v4f32(<4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, <4 x float> %b )
  ret <4 x float> %tmp
}

declare float @llvm.copysign.f32(float, float)
declare <4 x float> @llvm.copysign.v4f32(<4 x float>, <4 x float>)
