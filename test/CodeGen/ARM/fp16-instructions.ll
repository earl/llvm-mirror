; SOFT:
; RUN: llc < %s -mtriple=arm-none-eabi -float-abi=soft     | FileCheck %s --check-prefixes=CHECK,CHECK-SOFT
; RUN: llc < %s -mtriple=thumb-none-eabi -float-abi=soft   | FileCheck %s --check-prefixes=CHECK,CHECK-SOFT

; SOFTFP:
; RUN: llc < %s -mtriple=arm-none-eabi -mattr=+vfp3        | FileCheck %s --check-prefixes=CHECK,CHECK-SOFTFP-VFP3
; RUN: llc < %s -mtriple=arm-none-eabi -mattr=+vfp4        | FileCheck %s --check-prefixes=CHECK,CHECK-SOFTFP-FP16
; RUN: llc < %s -mtriple=arm-none-eabi -mattr=+fullfp16    | FileCheck %s --check-prefixes=CHECK,CHECK-SOFTFP-FULLFP16

; RUN: llc < %s -mtriple=thumbv7-none-eabi -mattr=+vfp3        | FileCheck %s --check-prefixes=CHECK,CHECK-SOFTFP-VFP3
; RUN: llc < %s -mtriple=thumbv7-none-eabi -mattr=+vfp4        | FileCheck %s --check-prefixes=CHECK,CHECK-SOFTFP-FP16
; RUN: llc < %s -mtriple=thumbv7-none-eabi -mattr=+fullfp16    | FileCheck %s --check-prefixes=CHECK,CHECK-SOFTFP-FULLFP16

; HARD:
; RUN: llc < %s -mtriple=arm-none-eabihf -mattr=+vfp3      | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-VFP3
; RUN: llc < %s -mtriple=arm-none-eabihf -mattr=+vfp4      | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-FP16
; RUN: llc < %s -mtriple=arm-none-eabihf -mattr=+fullfp16  | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-FULLFP16

; RUN: llc < %s -mtriple=thumbv7-none-eabihf -mattr=+vfp3      | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-VFP3
; RUN: llc < %s -mtriple=thumbv7-none-eabihf -mattr=+vfp4      | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-FP16
; RUN: llc < %s -mtriple=thumbv7-none-eabihf -mattr=+fullfp16  | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-FULLFP16

; FP-CONTRACT=FAST
; RUN: llc < %s -mtriple=arm-none-eabihf -mattr=+fullfp16 -fp-contract=fast | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-FULLFP16-FAST
; RUN: llc < %s -mtriple=thumbv7-none-eabihf -mattr=+fullfp16 -fp-contract=fast | FileCheck %s --check-prefixes=CHECK,CHECK-HARDFP-FULLFP16-FAST


define float @RetValBug(float %A.coerce) {
entry:
  ret float undef
; Check thatLowerReturn can handle undef nodes (i.e. nodes which do not have
; any operands) when FullFP16 is enabled.
;
; CHECK-LABEL:            RetValBug:
; CHECK-HARDFP-FULLFP16:  {{.*}} lr
}

; 1. VABS: TODO

; 2. VADD
define float @Add(float %a.coerce, float %b.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %add = fadd half %1, %3
  %4 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %4 to i32
  %5 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %5

; CHECK-LABEL: Add:

; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_fadd
; CHECK-SOFT:  bl  __aeabi_f2h

; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  vadd.f32
; CHECK-SOFTFP-VFP3:  bl  __aeabi_f2h

; CHECK-SOFTFP-FP16:  vmov          [[S2:s[0-9]]], r1
; CHECK-SOFTFP-FP16:  vmov          [[S0:s[0-9]]], r0
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S2]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vadd.f32      [[S0]], [[S0]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vmov  r0, s0

; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S0:s[0-9]]], r1
; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S2:s[0-9]]], r0
; CHECK-SOFTFP-FULLFP16:       vadd.f16  [[S0]], [[S2]], [[S0]]
; CHECK-SOFTFP-FULLFP16-NEXT:  vmov.f16  r0, s0

; CHECK-HARDFP-VFP3:  vmov r{{.}}, s0
; CHECK-HARDFP-VFP3:  vmov{{.*}}, s1
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  vadd.f32
; CHECK-HARDFP-VFP3:  bl  __aeabi_f2h
; CHECK-HARDFP-VFP3:  vmov  s0, r0

; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S2:s[0-9]]], s1
; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S0:s[0-9]]], s0
; CHECK-HARDFP-FP16:  vadd.f32  [[S0]], [[S0]], [[S2]]
; CHECK-HARDFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]

; CHECK-HARDFP-FULLFP16:       vadd.f16  s0, s0, s1
}

; 3. VCMP
define zeroext i1 @VCMP(float %F.coerce, float %G.coerce) {
entry:
  %0 = bitcast float %F.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %G.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %cmp = fcmp ogt half %1, %3
  ret i1 %cmp

; CHECK-LABEL:            VCMP:

; CHECK-SOFT:             bl  __aeabi_fcmpgt

; CHECK-SOFTFP-VFP3:      bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:      bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:      vcmpe.f32 s{{.}}, s{{.}}

; CHECK-SOFTFP-FP16:      vcvtb.f32.f16 s{{.}}, s{{.}}
; CHECK-SOFTFP-FP16:      vcvtb.f32.f16 s{{.}}, s{{.}}
; CHECK-SOFTFP-FP16:      vcmpe.f32 s{{.}}, s{{.}}

; CHECK-SOFTFP-FULLFP16:  vmov.f16  [[S2:s[0-9]]], r0
; CHECK-SOFTFP-FULLFP16:  vmov.f16 [[S0:s[0-9]]], r1
; CHECK-SOFTFP-FULLFP16:  vcmpe.f16 [[S2]], [[S0]]

; CHECK-SOFTFP-FULLFP16-NOT:  vmov.f16  s{{.}}, r0
; CHECK-SOFTFP-FULLFP16-NOT:  vmov.f16  s{{.}}, r1
; CHECK-HARDFP-FULLFP16:      vcmpe.f16  s0, s1
}

; 4. VCMPE

; FIXME: enable when constant pool is fixed
;
;define i32 @VCMPE_IMM(float %F.coerce) {
;entry:
;  %0 = bitcast float %F.coerce to i32
;  %tmp.0.extract.trunc = trunc i32 %0 to i16
;  %1 = bitcast i16 %tmp.0.extract.trunc to half
;  %tmp = fcmp olt half %1, 1.000000e+00
;  %tmp1 = zext i1 %tmp to i32
;  ret i32 %tmp1
;}

define i32 @VCMPE(float %F.coerce, float %G.coerce) {
entry:
  %0 = bitcast float %F.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %G.coerce to i32
  %tmp.1.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp.1.extract.trunc to half
  %tmp = fcmp olt half %1, %3
  %tmp1 = zext i1 %tmp to i32
  ret i32 %tmp1

; CHECK-LABEL:  VCMPE:
}

; 5. VCVT (between floating-point and fixed-point)
; Only assembly/disassembly support

; 6. VCVT (between floating-point and integer, both directions)
define i32 @fptosi(i32 %A.coerce) {
entry:
  %tmp.0.extract.trunc = trunc i32 %A.coerce to i16
  %0 = bitcast i16 %tmp.0.extract.trunc to half
  %conv = fptosi half %0 to i32
  ret i32 %conv

; CHECK-LABEL:                 fptosi:

; CHECK-HARDFP-FULLFP16:       vmov.f16  s0, r0
; CHECK-HARDFP-FULLFP16-NEXT:  vcvt.s32.f16  s0, s0
; CHECK-HARDFP-FULLFP16-NEXT:  vmov  r0, s0
}

define i32 @fptoui(i32 %A.coerce) {
entry:
  %tmp.0.extract.trunc = trunc i32 %A.coerce to i16
  %0 = bitcast i16 %tmp.0.extract.trunc to half
  %conv = fptoui half %0 to i32
  ret i32 %conv

; CHECK-HARDFP-FULLFP16:       vcvt.u32.f16  s0, s0
; CHECK-HARDFP-FULLFP16-NEXT:  vmov  r0, s0
}

define float @UintToH(i32 %a, i32 %b) {
entry:
  %0 = uitofp i32 %a to half
  %1 = bitcast half %0 to i16
  %tmp0.insert.ext = zext i16 %1 to i32
  %2 = bitcast i32 %tmp0.insert.ext to float
  ret float %2

; CHECK-LABEL:                 UintToH:

; CHECK-HARDFP-FULLFP16:       vmov  s0, r0
; CHECK-HARDFP-FULLFP16-NEXT:  vcvt.f16.u32  s0, s0
}

define float @SintToH(i32 %a, i32 %b) {
entry:
  %0 = sitofp i32 %a to half
  %1 = bitcast half %0 to i16
  %tmp0.insert.ext = zext i16 %1 to i32
  %2 = bitcast i32 %tmp0.insert.ext to float
  ret float %2

; CHECK-LABEL:                 SintToH:

; CHECK-HARDFP-FULLFP16:       vmov  s0, r0
; CHECK-HARDFP-FULLFP16-NEXT:  vcvt.f16.s32  s0, s0
}

; TODO:
; 7.  VCVTA
; 8.  VCVTM
; 9.  VCVTN
; 10. VCVTP
; 11. VCVTR

; 12. VDIV
define float @Div(float %a.coerce, float %b.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %add = fdiv half %1, %3
  %4 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %4 to i32
  %5 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %5

; CHECK-LABEL:  Div:

; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_fdiv
; CHECK-SOFT:  bl  __aeabi_f2h

; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  vdiv.f32
; CHECK-SOFTFP-VFP3:  bl  __aeabi_f2h

; CHECK-SOFTFP-FP16:  vmov          [[S2:s[0-9]]], r1
; CHECK-SOFTFP-FP16:  vmov          [[S0:s[0-9]]], r0
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S2]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vdiv.f32      [[S0]], [[S0]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vmov  r0, s0

; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S0:s[0-9]]], r1
; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S2:s[0-9]]], r0
; CHECK-SOFTFP-FULLFP16:       vdiv.f16  [[S0]], [[S2]], [[S0]]
; CHECK-SOFTFP-FULLFP16-NEXT:  vmov.f16  r0, s0

; CHECK-HARDFP-VFP3:  vmov r{{.}}, s0
; CHECK-HARDFP-VFP3:  vmov{{.*}}, s1
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  vdiv.f32
; CHECK-HARDFP-VFP3:  bl  __aeabi_f2h
; CHECK-HARDFP-VFP3:  vmov  s0, r0

; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S2:s[0-9]]], s1
; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S0:s[0-9]]], s0
; CHECK-HARDFP-FP16:  vdiv.f32  [[S0]], [[S0]], [[S2]]
; CHECK-HARDFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]

; CHECK-HARDFP-FULLFP16:       vdiv.f16  s0, s0, s1
}

; 13. VFMA
define float @VFMA(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %mul = fmul half %1, %3
  %add = fadd half %mul, %5
  %6 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:                      VFMA:
; CHECK-HARDFP-FULLFP16-FAST:       vfma.f16  s2, s0, s1
; CHECK-HARDFP-FULLFP16-FAST-NEXT:  vmov.f32  s0, s2
}

; 14. VFMS
define float @VFMS(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %mul = fmul half %1, %3
  %sub = fsub half %5, %mul
  %6 = bitcast half %sub to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:                      VFMS:
; CHECK-HARDFP-FULLFP16-FAST:       vfms.f16  s2, s0, s1
; CHECK-HARDFP-FULLFP16-FAST-NEXT:  vmov.f32  s0, s2
}

; 15. VFNMA
define float @VFNMA(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %mul = fmul half %1, %3
  %sub = fsub half -0.0, %mul
  %sub2 = fsub half %sub, %5
  %6 = bitcast half %sub2 to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:                      VFNMA:
; CHECK-HARDFP-FULLFP16-FAST:       vfnma.f16  s2, s0, s1
; CHECK-HARDFP-FULLFP16-FAST-NEXT:  vmov.f32  s0, s2
}

; 16. VFNMS
define float @VFNMS(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %mul = fmul half %1, %3
  %sub2 = fsub half %mul, %5
  %6 = bitcast half %sub2 to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:                      VFNMS:
; CHECK-HARDFP-FULLFP16-FAST:       vfnms.f16  s2, s0, s1
; CHECK-HARDFP-FULLFP16-FAST-NEXT:  vmov.f32  s0, s2
}

; TODO:
; 17. VMAXNM
; 18. VMINNM

; 19. VMLA
define float @VMLA(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %mul = fmul half %1, %3
  %add = fadd half %5, %mul
  %6 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:                 VMLA:
; CHECK-HARDFP-FULLFP16:       vmla.f16  s2, s0, s1
; CHECK-HARDFP-FULLFP16-NEXT:  vmov.f32  s0, s2
}

; 20. VMLS
define float @VMLS(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %mul = fmul half %1, %3
  %add = fsub half %5, %mul
  %6 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:                 VMLS:
; CHECK-HARDFP-FULLFP16:       vmls.f16  s2, s0, s1
; CHECK-HARDFP-FULLFP16-NEXT:  vmov.f32  s0, s2
}

; TODO: fix immediates.
; 21. VMOV (between general-purpose register and half-precision register)
; 22. VMOV (immediate)

; 23. VMUL
define float @Mul(float %a.coerce, float %b.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %add = fmul half %1, %3
  %4 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %4 to i32
  %5 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %5

; CHECK-LABEL:  Mul:

; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_fmul
; CHECK-SOFT:  bl  __aeabi_f2h

; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  vmul.f32
; CHECK-SOFTFP-VFP3:  bl  __aeabi_f2h

; CHECK-SOFTFP-FP16:  vmov          [[S2:s[0-9]]], r1
; CHECK-SOFTFP-FP16:  vmov          [[S0:s[0-9]]], r0
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S2]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vmul.f32      [[S0]], [[S0]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vmov  r0, s0

; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S0:s[0-9]]], r1
; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S2:s[0-9]]], r0
; CHECK-SOFTFP-FULLFP16:       vmul.f16  [[S0]], [[S2]], [[S0]]
; CHECK-SOFTFP-FULLFP16-NEXT:  vmov.f16  r0, s0

; CHECK-HARDFP-VFP3:  vmov r{{.}}, s0
; CHECK-HARDFP-VFP3:  vmov{{.*}}, s1
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  vmul.f32
; CHECK-HARDFP-VFP3:  bl  __aeabi_f2h
; CHECK-HARDFP-VFP3:  vmov  s0, r0

; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S2:s[0-9]]], s1
; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S0:s[0-9]]], s0
; CHECK-HARDFP-FP16:  vmul.f32  [[S0]], [[S0]], [[S2]]
; CHECK-HARDFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]

; CHECK-HARDFP-FULLFP16:       vmul.f16  s0, s0, s1
}

; 24. VNEG
define float @Neg(float %a.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = fsub half -0.000000e+00, %1
  %3 = bitcast half %2 to i16
  %tmp4.0.insert.ext = zext i16 %3 to i32
  %4 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %4

; CHECK-LABEL:                 Neg:
; CHECK-HARDFP-FULLFP16:       vneg.f16  s0, s0
}

; 25. VNMLA
define float @VNMLA(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %add = fmul half %1, %3
  %add2 = fsub half -0.000000e+00, %add
  %add3 = fsub half %add2, %5
  %6 = bitcast half %add3 to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:            VNMLA:
; CHECK-HARDFP-FULLFP16:  vnmla.f16 s2, s0, s1
; CHECK-HARDFP-FULLFP16:  vmov.f32  s0, s2
}

; 26. VNMLS
define float @VNMLS(float %a.coerce, float %b.coerce, float %c.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %4 = bitcast float %c.coerce to i32
  %tmp2.0.extract.trunc = trunc i32 %4 to i16
  %5 = bitcast i16 %tmp2.0.extract.trunc to half
  %add = fmul half %1, %3
  %add2 = fsub half %add, %5
  %6 = bitcast half %add2 to i16
  %tmp4.0.insert.ext = zext i16 %6 to i32
  %7 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %7

; CHECK-LABEL:            VNMLS:
; CHECK-HARDFP-FULLFP16:  vnmls.f16 s2, s0, s1
; CHECK-HARDFP-FULLFP16:  vmov.f32  s0, s2
}

; 27. VNMUL
define float @NMul(float %a.coerce, float %b.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %add = fmul half %1, %3
  %add2 = fsub half -0.0, %add
  %4 = bitcast half %add2 to i16
  %tmp4.0.insert.ext = zext i16 %4 to i32
  %5 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %5

; CHECK-LABEL:                 NMul:
; CHECK-HARDFP-FULLFP16:       vnmul.f16  s0, s0, s1
}

; 28. VRINTA
; 29. VRINTM
; 30. VRINTN
; 31. VRINTP
; 32. VRINTR
; 33. VRINTX
; 34. VRINTZ
; 35. VSELEQ
; 36. VSELGE
; 37. VSELGT
; 38. VSELVS
; 39. VSQRT

; 40. VSUB
define float @Sub(float %a.coerce, float %b.coerce) {
entry:
  %0 = bitcast float %a.coerce to i32
  %tmp.0.extract.trunc = trunc i32 %0 to i16
  %1 = bitcast i16 %tmp.0.extract.trunc to half
  %2 = bitcast float %b.coerce to i32
  %tmp1.0.extract.trunc = trunc i32 %2 to i16
  %3 = bitcast i16 %tmp1.0.extract.trunc to half
  %add = fsub half %1, %3
  %4 = bitcast half %add to i16
  %tmp4.0.insert.ext = zext i16 %4 to i32
  %5 = bitcast i32 %tmp4.0.insert.ext to float
  ret float %5

; CHECK-LABEL:  Sub:

; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_h2f
; CHECK-SOFT:  bl  __aeabi_fsub
; CHECK-SOFT:  bl  __aeabi_f2h

; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  bl  __aeabi_h2f
; CHECK-SOFTFP-VFP3:  vsub.f32
; CHECK-SOFTFP-VFP3:  bl  __aeabi_f2h

; CHECK-SOFTFP-FP16:  vmov          [[S2:s[0-9]]], r1
; CHECK-SOFTFP-FP16:  vmov          [[S0:s[0-9]]], r0
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S2]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f32.f16 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vsub.f32      [[S0]], [[S0]], [[S2]]
; CHECK-SOFTFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]
; CHECK-SOFTFP-FP16:  vmov  r0, s0

; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S0:s[0-9]]], r1
; CHECK-SOFTFP-FULLFP16:       vmov.f16  [[S2:s[0-9]]], r0
; CHECK-SOFTFP-FULLFP16:       vsub.f16  [[S0]], [[S2]], [[S0]]
; CHECK-SOFTFP-FULLFP16-NEXT:  vmov.f16  r0, s0

; CHECK-HARDFP-VFP3:  vmov r{{.}}, s0
; CHECK-HARDFP-VFP3:  vmov{{.*}}, s1
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  bl  __aeabi_h2f
; CHECK-HARDFP-VFP3:  vsub.f32
; CHECK-HARDFP-VFP3:  bl  __aeabi_f2h
; CHECK-HARDFP-VFP3:  vmov  s0, r0

; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S2:s[0-9]]], s1
; CHECK-HARDFP-FP16:  vcvtb.f32.f16 [[S0:s[0-9]]], s0
; CHECK-HARDFP-FP16:  vsub.f32  [[S0]], [[S0]], [[S2]]
; CHECK-HARDFP-FP16:  vcvtb.f16.f32 [[S0]], [[S0]]

; CHECK-HARDFP-FULLFP16:       vsub.f16  s0, s0, s1
}
