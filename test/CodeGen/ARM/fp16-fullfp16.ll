; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple armv8a-none-none-eabihf -mattr=fullfp16 -asm-verbose=false < %s | FileCheck %s

define void @test_fadd(half* %p, half* %q) {
; CHECK-LABEL: test_fadd:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vadd.f16 s0, s2, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = fadd half %a, %b
  store half %r, half* %p
  ret void
}

define void @test_fsub(half* %p, half* %q) {
; CHECK-LABEL: test_fsub:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vsub.f16 s0, s2, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = fsub half %a, %b
  store half %r, half* %p
  ret void
}

define void @test_fmul(half* %p, half* %q) {
; CHECK-LABEL: test_fmul:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vmul.f16 s0, s2, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = fmul half %a, %b
  store half %r, half* %p
  ret void
}

define void @test_fdiv(half* %p, half* %q) {
; CHECK-LABEL: test_fdiv:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vdiv.f16 s0, s2, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = fdiv half %a, %b
  store half %r, half* %p
  ret void
}

define arm_aapcs_vfpcc void @test_frem(half* %p, half* %q) {
; CHECK-LABEL: test_frem:
; CHECK:         .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    vldr.16 s2, [r1]
; CHECK-NEXT:    vldr.16 s0, [r0]
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    vcvtb.f32.f16 s0, s0
; CHECK-NEXT:    vcvtb.f32.f16 s1, s2
; CHECK-NEXT:    bl fmodf
; CHECK-NEXT:    vcvtb.f16.f32 s0, s0
; CHECK-NEXT:    vstr.16 s0, [r4]
; CHECK-NEXT:    pop {r4, pc}
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = frem half %a, %b
  store half %r, half* %p
  ret void
}

define void @test_load_store(half* %p, half* %q) {
; CHECK-LABEL: test_load_store:
; CHECK:         vldr.16 s0, [r0]
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  store half %a, half* %q
  ret void
}

define i32 @test_fptosi_i32(half* %p) {
; CHECK-LABEL: test_fptosi_i32:
; CHECK:         vldr.16 s0, [r0]
; CHECK-NEXT:    vcvt.s32.f16 s0, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %r = fptosi half %a to i32
  ret i32 %r
}

; FIXME
;define i64 @test_fptosi_i64(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = fptosi half %a to i64
;  ret i64 %r
;}

define i32 @test_fptoui_i32(half* %p) {
; CHECK-LABEL: test_fptoui_i32:
; CHECK:         vldr.16 s0, [r0]
; CHECK-NEXT:    vcvt.u32.f16 s0, s0
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %r = fptoui half %a to i32
  ret i32 %r
}

; FIXME
;define i64 @test_fptoui_i64(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = fptoui half %a to i64
;  ret i64 %r
;}

define void @test_sitofp_i32(i32 %a, half* %p) {
; CHECK-LABEL: test_sitofp_i32:
; CHECK:         vmov s0, r0
; CHECK-NEXT:    vcvt.f16.s32 s0, s0
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    bx lr
  %r = sitofp i32 %a to half
  store half %r, half* %p
  ret void
}

define void @test_uitofp_i32(i32 %a, half* %p) {
; CHECK-LABEL: test_uitofp_i32:
; CHECK:         vmov s0, r0
; CHECK-NEXT:    vcvt.f16.u32 s0, s0
; CHECK-NEXT:    vstr.16 s0, [r1]
; CHECK-NEXT:    bx lr
  %r = uitofp i32 %a to half
  store half %r, half* %p
  ret void
}

; FIXME
;define void @test_sitofp_i64(i64 %a, half* %p) {
;  %r = sitofp i64 %a to half
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_uitofp_i64(i64 %a, half* %p) {
;  %r = uitofp i64 %a to half
;  store half %r, half* %p
;  ret void
;}

define void @test_fptrunc_float(float %f, half* %p) {
; CHECK-LABEL: test_fptrunc_float:
; CHECK:         vcvtb.f16.f32 s0, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = fptrunc float %f to half
  store half %a, half* %p
  ret void
}

define void @test_fptrunc_double(double %d, half* %p) {
; CHECK-LABEL: test_fptrunc_double:
; CHECK:         vcvtb.f16.f64 s0, d0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = fptrunc double %d to half
  store half %a, half* %p
  ret void
}

define float @test_fpextend_float(half* %p) {
; CHECK-LABEL: test_fpextend_float:
; CHECK:         vldr.16 s0, [r0]
; CHECK-NEXT:    vcvtb.f32.f16 s0, s0
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %r = fpext half %a to float
  ret float %r
}

define double @test_fpextend_double(half* %p) {
; CHECK-LABEL: test_fpextend_double:
; CHECK:         vldr.16 s0, [r0]
; CHECK-NEXT:    vcvtb.f64.f16 d0, s0
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %r = fpext half %a to double
  ret double %r
}

define i16 @test_bitcast_halftoi16(half* %p) {
; CHECK-LABEL: test_bitcast_halftoi16:
; CHECK:         ldrh r0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %r = bitcast half %a to i16
  ret i16 %r
}

define void @test_bitcast_i16tohalf(i16 %a, half* %p) {
; CHECK-LABEL: test_bitcast_i16tohalf:
; CHECK:         strh r0, [r1]
; CHECK-NEXT:    bx lr
  %r = bitcast i16 %a to half
  store half %r, half* %p
  ret void
}

; FIXME
;define void @test_sqrt(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.sqrt.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_fpowi(half* %p, i32 %b) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.powi.f16(half %a, i32 %b)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_sin(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.sin.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_cos(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.cos.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_pow(half* %p, half* %q) {
;  %a = load half, half* %p, align 2
;  %b = load half, half* %q, align 2
;  %r = call half @llvm.pow.f16(half %a, half %b)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_exp(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.exp.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_exp2(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.exp2.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_log(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.log.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_log10(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.log10.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_log2(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.log2.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_fma(half* %p, half* %q, half* %r) {
;  %a = load half, half* %p, align 2
;  %b = load half, half* %q, align 2
;  %c = load half, half* %r, align 2
;  %v = call half @llvm.fma.f16(half %a, half %b, half %c)
;  store half %v, half* %p
;  ret void
;}

; FIXME
;define void @test_fabs(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.fabs.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

define void @test_minnum(half* %p, half* %q) {
; CHECK-LABEL: test_minnum:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vminnm.f16 s0, s2, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = call half @llvm.minnum.f16(half %a, half %b)
  store half %r, half* %p
  ret void
}

define void @test_maxnum(half* %p, half* %q) {
; CHECK-LABEL: test_maxnum:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vmaxnm.f16 s0, s2, s0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %r = call half @llvm.maxnum.f16(half %a, half %b)
  store half %r, half* %p
  ret void
}

define void @test_minimum(half* %p) {
; CHECK-LABEL: test_minimum:
; CHECK:         vldr.16 s2, [r0]
; CHECK-NEXT:    vmov.f16 s0, #1.000000e+00
; CHECK-NEXT:    vmin.f16 d0, d1, d0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %c = fcmp ult half %a, 1.0
  %r = select i1 %c, half %a, half 1.0
  store half %r, half* %p
  ret void
}

define void @test_maximum(half* %p) {
; CHECK-LABEL: test_maximum:
; CHECK:         vldr.16 s2, [r0]
; CHECK-NEXT:    vmov.f16 s0, #1.000000e+00
; CHECK-NEXT:    vmax.f16 d0, d1, d0
; CHECK-NEXT:    vstr.16 s0, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %c = fcmp ugt half %a, 1.0
  %r = select i1 %c, half %a, half 1.0
  store half %r, half* %p
  ret void
}

; FIXME
;define void @test_copysign(half* %p, half* %q) {
;  %a = load half, half* %p, align 2
;  %b = load half, half* %q, align 2
;  %r = call half @llvm.copysign.f16(half %a, half %b)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_floor(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.floor.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_ceil(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.ceil.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_trunc(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.trunc.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_rint(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.rint.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_nearbyint(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.nearbyint.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

; FIXME
;define void @test_round(half* %p) {
;  %a = load half, half* %p, align 2
;  %r = call half @llvm.round.f16(half %a)
;  store half %r, half* %p
;  ret void
;}

define void @test_fmuladd(half* %p, half* %q, half* %r) {
; CHECK-LABEL: test_fmuladd:
; CHECK:         vldr.16 s0, [r1]
; CHECK-NEXT:    vldr.16 s2, [r0]
; CHECK-NEXT:    vldr.16 s4, [r2]
; CHECK-NEXT:    vmla.f16 s4, s2, s0
; CHECK-NEXT:    vstr.16 s4, [r0]
; CHECK-NEXT:    bx lr
  %a = load half, half* %p, align 2
  %b = load half, half* %q, align 2
  %c = load half, half* %r, align 2
  %v = call half @llvm.fmuladd.f16(half %a, half %b, half %c)
  store half %v, half* %p
  ret void
}

declare half @llvm.sqrt.f16(half %a)
declare half @llvm.powi.f16(half %a, i32 %b)
declare half @llvm.sin.f16(half %a)
declare half @llvm.cos.f16(half %a)
declare half @llvm.pow.f16(half %a, half %b)
declare half @llvm.exp.f16(half %a)
declare half @llvm.exp2.f16(half %a)
declare half @llvm.log.f16(half %a)
declare half @llvm.log10.f16(half %a)
declare half @llvm.log2.f16(half %a)
declare half @llvm.fma.f16(half %a, half %b, half %c)
declare half @llvm.fabs.f16(half %a)
declare half @llvm.minnum.f16(half %a, half %b)
declare half @llvm.maxnum.f16(half %a, half %b)
declare half @llvm.copysign.f16(half %a, half %b)
declare half @llvm.floor.f16(half %a)
declare half @llvm.ceil.f16(half %a)
declare half @llvm.trunc.f16(half %a)
declare half @llvm.rint.f16(half %a)
declare half @llvm.nearbyint.f16(half %a)
declare half @llvm.round.f16(half %a)
declare half @llvm.fmuladd.f16(half %a, half %b, half %c)
