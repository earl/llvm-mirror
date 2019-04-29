; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv8a -mattr=+armv8.2-a,+fullfp16,+neon -target-abi=aapcs-gnu -float-abi=soft -o - %s | FileCheck %s --check-prefix=SOFT
; RUN: llc -mtriple=armv8a -mattr=+armv8.2-a,+fullfp16,+neon -target-abi=aapcs-gnu -float-abi=hard -o - %s | FileCheck %s --check-prefix=HARD
; RUN: llc -mtriple=armeb-eabi -mattr=+armv8.2-a,+fullfp16,+neon -target-abi=aapcs-gnu -float-abi=soft -o - %s | FileCheck %s --check-prefix=SOFTEB
; RUN: llc -mtriple=armeb-eabi -mattr=+armv8.2-a,+fullfp16,+neon -target-abi=aapcs-gnu -float-abi=hard -o - %s | FileCheck %s --check-prefix=HARDEB

declare <4 x half> @llvm.fabs.v4f16(<4 x half>)
declare <8 x half> @llvm.fabs.v8f16(<8 x half>)
declare void @use(double, float, <4 x half>, i16, <8 x half>)
define <4 x half> @test_vabs_f16(<4 x half> %a) {
; SOFT-LABEL: test_vabs_f16:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    vmov d16, r0, r1
; SOFT-NEXT:    vabs.f16 d16, d16
; SOFT-NEXT:    vmov r0, r1, d16
; SOFT-NEXT:    bx lr
;
; HARD-LABEL: test_vabs_f16:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    vabs.f16 d0, d0
; HARD-NEXT:    bx lr
;
; SOFTEB-LABEL: test_vabs_f16:
; SOFTEB:       @ %bb.0: @ %entry
; SOFTEB-NEXT:    vmov d16, r1, r0
; SOFTEB-NEXT:    vrev64.16 d16, d16
; SOFTEB-NEXT:    vabs.f16 d16, d16
; SOFTEB-NEXT:    vrev64.16 d16, d16
; SOFTEB-NEXT:    vmov r1, r0, d16
; SOFTEB-NEXT:    bx lr
;
; HARDEB-LABEL: test_vabs_f16:
; HARDEB:       @ %bb.0: @ %entry
; HARDEB-NEXT:    vrev64.16 d16, d0
; HARDEB-NEXT:    vabs.f16 d16, d16
; HARDEB-NEXT:    vrev64.16 d0, d16
; HARDEB-NEXT:    bx lr
entry:
  %vabs1.i = tail call <4 x half> @llvm.fabs.v4f16(<4 x half> %a)
  ret <4 x half> %vabs1.i
}


define <8 x half> @test2_vabs_f16(<8 x half> %a) {
; SOFT-LABEL: test2_vabs_f16:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    vmov d17, r2, r3
; SOFT-NEXT:    vmov d16, r0, r1
; SOFT-NEXT:    vabs.f16 q8, q8
; SOFT-NEXT:    vmov r0, r1, d16
; SOFT-NEXT:    vmov r2, r3, d17
; SOFT-NEXT:    bx lr
;
; HARD-LABEL: test2_vabs_f16:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    vabs.f16 q0, q0
; HARD-NEXT:    bx lr
;
; SOFTEB-LABEL: test2_vabs_f16:
; SOFTEB:       @ %bb.0: @ %entry
; SOFTEB-NEXT:    vmov d17, r3, r2
; SOFTEB-NEXT:    vmov d16, r1, r0
; SOFTEB-NEXT:    vrev64.16 q8, q8
; SOFTEB-NEXT:    vabs.f16 q8, q8
; SOFTEB-NEXT:    vrev64.16 q8, q8
; SOFTEB-NEXT:    vmov r1, r0, d16
; SOFTEB-NEXT:    vmov r3, r2, d17
; SOFTEB-NEXT:    bx lr
;
; HARDEB-LABEL: test2_vabs_f16:
; HARDEB:       @ %bb.0: @ %entry
; HARDEB-NEXT:    vrev64.16 q8, q0
; HARDEB-NEXT:    vabs.f16 q8, q8
; HARDEB-NEXT:    vrev64.16 q0, q8
; HARDEB-NEXT:    bx lr
entry:
  %vabs1.i = tail call <8 x half> @llvm.fabs.v8f16(<8 x half> %a)
  ret <8 x half> %vabs1.i
}

define void @test(double, float, i16, <4 x half>, <8 x half>) {
; SOFT-LABEL: test:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    push {r11, lr}
; SOFT-NEXT:    sub sp, sp, #32
; SOFT-NEXT:    vldr d16, [sp, #40]
; SOFT-NEXT:    mov r12, #16
; SOFT-NEXT:    vabs.f16 d16, d16
; SOFT-NEXT:    mov lr, sp
; SOFT-NEXT:    vst1.16 {d16}, [lr:64], r12
; SOFT-NEXT:    add r12, sp, #48
; SOFT-NEXT:    vld1.64 {d16, d17}, [r12]
; SOFT-NEXT:    vabs.f16 q8, q8
; SOFT-NEXT:    str r3, [sp, #8]
; SOFT-NEXT:    vst1.64 {d16, d17}, [lr]
; SOFT-NEXT:    bl use
; SOFT-NEXT:    add sp, sp, #32
; SOFT-NEXT:    pop {r11, pc}
;
; HARD-LABEL: test:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    vabs.f16 q2, q2
; HARD-NEXT:    vabs.f16 d2, d2
; HARD-NEXT:    b use
;
; SOFTEB-LABEL: test:
; SOFTEB:       @ %bb.0: @ %entry
; SOFTEB-NEXT:    .save {r11, lr}
; SOFTEB-NEXT:    push {r11, lr}
; SOFTEB-NEXT:    .pad #32
; SOFTEB-NEXT:    sub sp, sp, #32
; SOFTEB-NEXT:    vldr d16, [sp, #40]
; SOFTEB-NEXT:    mov r12, #16
; SOFTEB-NEXT:    mov lr, sp
; SOFTEB-NEXT:    str r3, [sp, #8]
; SOFTEB-NEXT:    vrev64.16 d16, d16
; SOFTEB-NEXT:    vabs.f16 d16, d16
; SOFTEB-NEXT:    vst1.16 {d16}, [lr:64], r12
; SOFTEB-NEXT:    add r12, sp, #48
; SOFTEB-NEXT:    vld1.64 {d16, d17}, [r12]
; SOFTEB-NEXT:    vrev64.16 q8, q8
; SOFTEB-NEXT:    vabs.f16 q8, q8
; SOFTEB-NEXT:    vrev64.16 q8, q8
; SOFTEB-NEXT:    vst1.64 {d16, d17}, [lr]
; SOFTEB-NEXT:    bl use
; SOFTEB-NEXT:    add sp, sp, #32
; SOFTEB-NEXT:    pop {r11, pc}
;
; HARDEB-LABEL: test:
; HARDEB:       @ %bb.0: @ %entry
; HARDEB-NEXT:    vrev64.16 d16, d2
; HARDEB-NEXT:    vabs.f16 d16, d16
; HARDEB-NEXT:    vrev64.16 d2, d16
; HARDEB-NEXT:    vrev64.16 q8, q2
; HARDEB-NEXT:    vabs.f16 q8, q8
; HARDEB-NEXT:    vrev64.16 q2, q8
; HARDEB-NEXT:    b use
entry:
  %5 = tail call <4 x half> @llvm.fabs.v4f16(<4 x half> %3)
  %6 = tail call <8 x half> @llvm.fabs.v8f16(<8 x half> %4)
  tail call void @use(double %0, float %1, <4 x half> %5, i16 %2, <8 x half> %6)
  ret void
}

define void @many_args_test(double, float, i16, <4 x half>, <8 x half>, <8 x half>, <8 x half>) {
; SOFT-LABEL: many_args_test:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    push {r11, lr}
; SOFT-NEXT:    sub sp, sp, #32
; SOFT-NEXT:    add r12, sp, #80
; SOFT-NEXT:    mov lr, sp
; SOFT-NEXT:    vld1.64 {d16, d17}, [r12]
; SOFT-NEXT:    add r12, sp, #48
; SOFT-NEXT:    vabs.f16 q8, q8
; SOFT-NEXT:    vld1.64 {d18, d19}, [r12]
; SOFT-NEXT:    add r12, sp, #64
; SOFT-NEXT:    str r3, [sp, #8]
; SOFT-NEXT:    vadd.f16 q8, q8, q9
; SOFT-NEXT:    vld1.64 {d18, d19}, [r12]
; SOFT-NEXT:    mov r12, #16
; SOFT-NEXT:    vmul.f16 q8, q9, q8
; SOFT-NEXT:    vldr d18, [sp, #40]
; SOFT-NEXT:    vst1.16 {d18}, [lr:64], r12
; SOFT-NEXT:    vst1.64 {d16, d17}, [lr]
; SOFT-NEXT:    bl use
; SOFT-NEXT:    add sp, sp, #32
; SOFT-NEXT:    pop {r11, pc}
;
; HARD-LABEL: many_args_test:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    mov r1, sp
; HARD-NEXT:    vld1.64 {d16, d17}, [r1]
; HARD-NEXT:    vabs.f16 q8, q8
; HARD-NEXT:    vadd.f16 q8, q8, q2
; HARD-NEXT:    vmul.f16 q2, q3, q8
; HARD-NEXT:    b use
;
; SOFTEB-LABEL: many_args_test:
; SOFTEB:       @ %bb.0: @ %entry
; SOFTEB-NEXT:    .save {r11, lr}
; SOFTEB-NEXT:    push {r11, lr}
; SOFTEB-NEXT:    .pad #32
; SOFTEB-NEXT:    sub sp, sp, #32
; SOFTEB-NEXT:    vldr d16, [sp, #40]
; SOFTEB-NEXT:    mov r12, #16
; SOFTEB-NEXT:    mov lr, sp
; SOFTEB-NEXT:    str r3, [sp, #8]
; SOFTEB-NEXT:    vrev64.16 d16, d16
; SOFTEB-NEXT:    vst1.16 {d16}, [lr:64], r12
; SOFTEB-NEXT:    add r12, sp, #80
; SOFTEB-NEXT:    vld1.64 {d16, d17}, [r12]
; SOFTEB-NEXT:    add r12, sp, #48
; SOFTEB-NEXT:    vrev64.16 q8, q8
; SOFTEB-NEXT:    vabs.f16 q8, q8
; SOFTEB-NEXT:    vld1.64 {d18, d19}, [r12]
; SOFTEB-NEXT:    add r12, sp, #64
; SOFTEB-NEXT:    vrev64.16 q9, q9
; SOFTEB-NEXT:    vadd.f16 q8, q8, q9
; SOFTEB-NEXT:    vld1.64 {d18, d19}, [r12]
; SOFTEB-NEXT:    vrev64.16 q9, q9
; SOFTEB-NEXT:    vmul.f16 q8, q9, q8
; SOFTEB-NEXT:    vrev64.16 q8, q8
; SOFTEB-NEXT:    vst1.64 {d16, d17}, [lr]
; SOFTEB-NEXT:    bl use
; SOFTEB-NEXT:    add sp, sp, #32
; SOFTEB-NEXT:    pop {r11, pc}
;
; HARDEB-LABEL: many_args_test:
; HARDEB:       @ %bb.0: @ %entry
; HARDEB-NEXT:    mov r1, sp
; HARDEB-NEXT:    vld1.64 {d16, d17}, [r1]
; HARDEB-NEXT:    vrev64.16 q8, q8
; HARDEB-NEXT:    vabs.f16 q8, q8
; HARDEB-NEXT:    vrev64.16 q9, q2
; HARDEB-NEXT:    vadd.f16 q8, q8, q9
; HARDEB-NEXT:    vrev64.16 q9, q3
; HARDEB-NEXT:    vmul.f16 q8, q9, q8
; HARDEB-NEXT:    vrev64.16 q2, q8
; HARDEB-NEXT:    b use
entry:
  %7 = tail call <8 x half> @llvm.fabs.v8f16(<8 x half> %6)
  %8 = fadd <8 x half> %7, %4
  %9 = fmul <8 x half> %5, %8
  tail call void @use(double %0, float %1, <4 x half> %3, i16 %2, <8 x half> %9)
  ret void
}
