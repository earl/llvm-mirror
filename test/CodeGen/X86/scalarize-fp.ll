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
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fadd_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fadd <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fsub_op0_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fsub_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subpd %xmm0, %xmm1
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %xmm0, %xmm1, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fsub_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %xmm0, %xmm1, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vmulpd %xmm1, %xmm0, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fmul_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vmulpd %xmm1, %xmm0, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %xmm1, %xmm0, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fdiv_op0_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fdiv_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    divpd %xmm0, %xmm1
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %xmm0, %xmm1, %xmm0
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
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <2 x double> @fadd_splat_splat_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: fadd_splat_splat_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_splat_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> zeroinitializer
  %splaty = shufflevector <2 x double> %vy, <2 x double> undef, <2 x i32> zeroinitializer
  %r = fadd <2 x double> %splatx, %splaty
  ret <2 x double> %r
}

define <4 x double> @fsub_splat_splat_v4f64(double %x, double %y) {
; SSE-LABEL: fsub_splat_splat_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    subpd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_splat_splat_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %vy = insertelement <4 x double> undef, double %y, i32 0
  %splatx = shufflevector <4 x double> %vx, <4 x double> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x double> %vy, <4 x double> undef, <4 x i32> zeroinitializer
  %r = fsub <4 x double> %splatx, %splaty
  ret <4 x double> %r
}

define <4 x float> @fmul_splat_splat_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: fmul_splat_splat_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_splat_splat_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %splatx = shufflevector <4 x float> %vx, <4 x float> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x float> %vy, <4 x float> undef, <4 x i32> zeroinitializer
  %r = fmul fast <4 x float> %splatx, %splaty
  ret <4 x float> %r
}

define <8 x float> @fdiv_splat_splat_v8f32(<8 x float> %vx, <8 x float> %vy) {
; SSE-LABEL: fdiv_splat_splat_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    rcpps %xmm2, %xmm3
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    subps %xmm2, %xmm1
; SSE-NEXT:    mulps %xmm3, %xmm1
; SSE-NEXT:    addps %xmm3, %xmm1
; SSE-NEXT:    mulps %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_splat_splat_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vrcpps %ymm1, %ymm2
; AVX-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vmovaps {{.*#+}} xmm3 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %xmm1, %xmm3, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vaddps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> %vx, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> %vy, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <2 x double> @fadd_splat_const_op1_v2f64(<2 x double> %vx) {
; SSE-LABEL: fadd_splat_const_op1_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    addpd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_const_op1_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vaddpd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> zeroinitializer
  %r = fadd <2 x double> %splatx, <double 42.0, double 42.0>
  ret <2 x double> %r
}

define <4 x double> @fsub_const_op0_splat_v4f64(double %x) {
; SSE-LABEL: fsub_const_op0_splat_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subpd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_const_op0_splat_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double 8.0, i32 0
  %vy = insertelement <4 x double> undef, double %x, i32 0
  %splatx = shufflevector <4 x double> %vx, <4 x double> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x double> %vy, <4 x double> undef, <4 x i32> zeroinitializer
  %r = fsub <4 x double> %splatx, %splaty
  ret <4 x double> %r
}

define <4 x float> @fmul_splat_const_op1_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: fmul_splat_const_op1_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_splat_const_op1_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vmulps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %splatx = shufflevector <4 x float> %vx, <4 x float> undef, <4 x i32> zeroinitializer
  %r = fmul fast <4 x float> %splatx, <float 17.0, float 17.0, float 17.0, float 17.0>
  ret <4 x float> %r
}

define <8 x float> @fdiv_splat_const_op0_v8f32(<8 x float> %vy) {
; SSE-LABEL: fdiv_splat_const_op0_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    rcpps %xmm0, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    subps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps %xmm2, %xmm1
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_splat_const_op0_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vrcpps %ymm0, %ymm1
; AVX-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vmovaps {{.*#+}} ymm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %ymm0, %ymm2, %ymm0
; AVX-NEXT:    vmulps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vmulps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> <float 4.5, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> %vy, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <8 x float> @fdiv_const_op1_splat_v8f32(<8 x float> %vx) {
; SSE-LABEL: fdiv_const_op1_splat_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    rcpps %xmm1, %xmm1
; SSE-NEXT:    addps %xmm1, %xmm1
; SSE-NEXT:    mulps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_const_op1_splat_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vrcpps %ymm1, %ymm1
; AVX-NEXT:    vaddps %ymm1, %ymm1, %ymm1
; AVX-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> %vx, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> <float 0.0, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <2 x double> @fadd_splat_const_op1_v2f64(<2 x double> %vx) {
; SSE-LABEL: fadd_splat_const_op1_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    addpd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_const_op1_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vaddpd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> zeroinitializer
  %r = fadd <2 x double> %splatx, <double 42.0, double 42.0>
  ret <2 x double> %r
}

define <4 x double> @fsub_const_op0_splat_v4f64(double %x) {
; SSE-LABEL: fsub_const_op0_splat_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subpd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_const_op0_splat_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double 8.0, i32 0
  %vy = insertelement <4 x double> undef, double %x, i32 0
  %splatx = shufflevector <4 x double> %vx, <4 x double> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x double> %vy, <4 x double> undef, <4 x i32> zeroinitializer
  %r = fsub <4 x double> %splatx, %splaty
  ret <4 x double> %r
}

define <4 x float> @fmul_splat_const_op1_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: fmul_splat_const_op1_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_splat_const_op1_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vmulps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %splatx = shufflevector <4 x float> %vx, <4 x float> undef, <4 x i32> zeroinitializer
  %r = fmul fast <4 x float> %splatx, <float 17.0, float 17.0, float 17.0, float 17.0>
  ret <4 x float> %r
}

define <8 x float> @fdiv_splat_const_op0_v8f32(<8 x float> %vy) {
; SSE-LABEL: fdiv_splat_const_op0_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    rcpps %xmm0, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    subps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps %xmm2, %xmm1
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_splat_const_op0_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vrcpps %ymm0, %ymm1
; AVX-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vmovaps {{.*#+}} ymm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %ymm0, %ymm2, %ymm0
; AVX-NEXT:    vmulps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; AVX-NEXT:    vmulps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> <float 4.5, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> %vy, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <8 x float> @fdiv_const_op1_splat_v8f32(<8 x float> %vx) {
; SSE-LABEL: fdiv_const_op1_splat_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    rcpps %xmm1, %xmm1
; SSE-NEXT:    addps %xmm1, %xmm1
; SSE-NEXT:    mulps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_const_op1_splat_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vrcpps %ymm1, %ymm1
; AVX-NEXT:    vaddps %ymm1, %ymm1, %ymm1
; AVX-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> %vx, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> <float 0.0, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <2 x double> @splat0_fadd_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: splat0_fadd_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fadd_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %b = fadd <2 x double> %vx, %vy
  %r = shufflevector <2 x double> %b, <2 x double> undef, <2 x i32> zeroinitializer
  ret <2 x double> %r
}

define <4 x double> @splat0_fsub_v4f64(double %x, double %y) {
; SSE-LABEL: splat0_fsub_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    subpd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fsub_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %vy = insertelement <4 x double> undef, double %y, i32 0
  %b = fsub <4 x double> %vx, %vy
  %r = shufflevector <4 x double> %b, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %r
}

define <4 x float> @splat0_fmul_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: splat0_fmul_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fmul_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %b = fmul fast <4 x float> %vx, %vy
  %r = shufflevector <4 x float> %b, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %r
}

define <8 x float> @splat0_fdiv_v8f32(<8 x float> %vx, <8 x float> %vy) {
; SSE-LABEL: splat0_fdiv_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    rcpps %xmm2, %xmm3
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    subps %xmm2, %xmm1
; SSE-NEXT:    mulps %xmm3, %xmm1
; SSE-NEXT:    addps %xmm3, %xmm1
; SSE-NEXT:    mulps %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vrcpps %ymm1, %ymm2
; AVX-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vmovaps {{.*#+}} xmm3 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %xmm1, %xmm3, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vaddps %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> %vx, %vy
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <2 x double> @splat0_fadd_const_op1_v2f64(<2 x double> %vx) {
; SSE-LABEL: splat0_fadd_const_op1_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    addpd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fadd_const_op1_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %b = fadd <2 x double> %vx, <double 42.0, double 12.0>
  %r = shufflevector <2 x double> %b, <2 x double> undef, <2 x i32> zeroinitializer
  ret <2 x double> %r
}

define <4 x double> @splat0_fsub_const_op0_v4f64(double %x) {
; SSE-LABEL: splat0_fsub_const_op0_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subpd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fsub_const_op0_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double -42.0, double 42.0, double 0.0, double 1.0>, %vx
  %r = shufflevector <4 x double> %b, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %r
}

define <4 x float> @splat0_fmul_const_op1_v4f32(<4 x float> %vx) {
; SSE-LABEL: splat0_fmul_const_op1_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    mulps %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fmul_const_op1_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %b = fmul fast <4 x float> %vx, <float 6.0, float -1.0, float 1.0, float 7.0>
  %r = shufflevector <4 x float> %b, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %r
}

define <8 x float> @splat0_fdiv_const_op1_v8f32(<8 x float> %vx) {
; SSE-LABEL: splat0_fdiv_const_op1_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_const_op1_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vrcpps %ymm1, %ymm1
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %xmm1, %xmm2, %xmm2
; AVX-NEXT:    vmulps %xmm2, %xmm1, %xmm2
; AVX-NEXT:    vaddps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> %vx, <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <8 x float> @splat0_fdiv_const_op0_v8f32(<8 x float> %vx) {
; SSE-LABEL: splat0_fdiv_const_op0_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    rcpps %xmm0, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    subps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps %xmm2, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_const_op0_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vrcpps %ymm0, %ymm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vmulps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>, %vx
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <2 x double> @splat0_fadd_const_op1_v2f64(<2 x double> %vx) {
; SSE-LABEL: splat0_fadd_const_op1_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    addpd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fadd_const_op1_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %b = fadd <2 x double> %vx, <double 42.0, double 12.0>
  %r = shufflevector <2 x double> %b, <2 x double> undef, <2 x i32> zeroinitializer
  ret <2 x double> %r
}

define <4 x double> @splat0_fsub_const_op0_v4f64(double %x) {
; SSE-LABEL: splat0_fsub_const_op0_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subpd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fsub_const_op0_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubpd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double -42.0, double 42.0, double 0.0, double 1.0>, %vx
  %r = shufflevector <4 x double> %b, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %r
}

define <4 x float> @splat0_fmul_const_op1_v4f32(<4 x float> %vx) {
; SSE-LABEL: splat0_fmul_const_op1_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    mulps %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fmul_const_op1_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %b = fmul fast <4 x float> %vx, <float 6.0, float -1.0, float 1.0, float 7.0>
  %r = shufflevector <4 x float> %b, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %r
}

define <8 x float> @splat0_fdiv_const_op1_v8f32(<8 x float> %vx) {
; SSE-LABEL: splat0_fdiv_const_op1_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_const_op1_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vrcpps %ymm1, %ymm1
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %xmm1, %xmm2, %xmm2
; AVX-NEXT:    vmulps %xmm2, %xmm1, %xmm2
; AVX-NEXT:    vaddps %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> %vx, <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <8 x float> @splat0_fdiv_const_op0_v8f32(<8 x float> %vx) {
; SSE-LABEL: splat0_fdiv_const_op0_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    rcpps %xmm0, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    subps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps %xmm2, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_const_op0_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vrcpps %ymm0, %ymm1
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovaps {{.*#+}} xmm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX-NEXT:    vsubps %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vmulps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>, %vx
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}
