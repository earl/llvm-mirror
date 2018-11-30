; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=ALL,SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=ALL,AVX

define <4 x float> @fadd_op1_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fadd_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fadd <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @load_fadd_op1_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fadd_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fadd_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fadd <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @fsub_op0_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fsub_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    subps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vsubps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fsub <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x float> @load_fsub_op0_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fsub_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    subps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fsub_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vsubps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fsub <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x float> @fmul_op1_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fmul_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fmul <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @load_fmul_op1_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fmul_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fmul_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fmul <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @fdiv_op1_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fdiv_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @load_fdiv_op1_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fdiv_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @fdiv_op0_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fdiv_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    divps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x float> @load_fdiv_op0_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fdiv_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x double> @fadd_op1_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fadd_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fadd <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @load_fadd_op1_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fadd_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fadd_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fadd <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fsub_op0_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fsub_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; SSE-NEXT:    subpd %xmm0, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    movapd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <4 x double> @load_fsub_op0_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fsub_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    subpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fsub_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <4 x double> @fmul_op1_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fmul_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    mulpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vmulpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fmul <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @load_fmul_op1_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fmul_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    mulpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fmul_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vmulpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fmul <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fdiv_op1_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fdiv_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    divpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @load_fdiv_op1_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fdiv_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    divpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fdiv_op0_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fdiv_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; SSE-NEXT:    divpd %xmm0, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    movapd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <4 x double> @load_fdiv_op0_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fdiv_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    divpd %xmm1, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [NaN,NaN]
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %ymm0, %ymm1, %ymm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

