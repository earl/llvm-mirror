; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc <4 x i32> @bitcast_to_v4i1(i4 %b, <4 x i32> %a) {
; CHECK-LABEL: bitcast_to_v4i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    and r0, r0, #15
; CHECK-NEXT:    strb.w r0, [sp]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vldr p0, [r0]
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %c = bitcast i4 %b to <4 x i1>
  %s = select <4 x i1> %c, <4 x i32> %a, <4 x i32> zeroinitializer
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_to_v8i1(i8 %b, <8 x i16> %a) {
; CHECK-LABEL: bitcast_to_v8i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    strb.w r0, [sp]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldr p0, [r0]
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %c = bitcast i8 %b to <8 x i1>
  %s = select <8 x i1> %c, <8 x i16> %a, <8 x i16> zeroinitializer
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_to_v16i1(i16 %b, <16 x i8> %a) {
; CHECK-LABEL: bitcast_to_v16i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r6, r7, lr}
; CHECK-NEXT:    push {r4, r6, r7, lr}
; CHECK-NEXT:    .setfp r7, sp, #8
; CHECK-NEXT:    add r7, sp, #8
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    mov r4, sp
; CHECK-NEXT:    bfc r4, #0, #4
; CHECK-NEXT:    mov sp, r4
; CHECK-NEXT:    strh.w r0, [sp]
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    sub.w r4, r7, #8
; CHECK-NEXT:    vldr p0, [r0]
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    mov sp, r4
; CHECK-NEXT:    pop {r4, r6, r7, pc}
entry:
  %c = bitcast i16 %b to <16 x i1>
  %s = select <16 x i1> %c, <16 x i8> %a, <16 x i8> zeroinitializer
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_to_v2i1(i2 %b, <2 x i64> %a) {
; CHECK-LABEL: bitcast_to_v2i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    and r0, r0, #3
; CHECK-NEXT:    sbfx r1, r0, #0, #1
; CHECK-NEXT:    sbfx r0, r0, #1, #1
; CHECK-NEXT:    vmov.32 q1[0], r1
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    vmov.32 q1[2], r0
; CHECK-NEXT:    vmov.32 q1[3], r0
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %c = bitcast i2 %b to <2 x i1>
  %s = select <2 x i1> %c, <2 x i64> %a, <2 x i64> zeroinitializer
  ret <2 x i64> %s
}


define arm_aapcs_vfpcc i4 @bitcast_from_v4i1(<4 x i32> %a) {
; CHECK-LABEL: bitcast_from_v4i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstr p0, [r0]
; CHECK-NEXT:    ldrb.w r0, [sp]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <4 x i32> %a, zeroinitializer
  %b = bitcast <4 x i1> %c to i4
  ret i4 %b
}

define arm_aapcs_vfpcc i8 @bitcast_from_v8i1(<8 x i16> %a) {
; CHECK-LABEL: bitcast_from_v8i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstr p0, [r0]
; CHECK-NEXT:    ldrb.w r0, [sp]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <8 x i16> %a, zeroinitializer
  %b = bitcast <8 x i1> %c to i8
  ret i8 %b
}

define arm_aapcs_vfpcc i16 @bitcast_from_v16i1(<16 x i8> %a) {
; CHECK-LABEL: bitcast_from_v16i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r6, r7, lr}
; CHECK-NEXT:    push {r4, r6, r7, lr}
; CHECK-NEXT:    .setfp r7, sp, #8
; CHECK-NEXT:    add r7, sp, #8
; CHECK-NEXT:    .pad #16
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    mov r4, sp
; CHECK-NEXT:    bfc r4, #0, #4
; CHECK-NEXT:    mov sp, r4
; CHECK-NEXT:    sub.w r4, r7, #8
; CHECK-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vstr p0, [r0]
; CHECK-NEXT:    ldrh.w r0, [sp]
; CHECK-NEXT:    mov sp, r4
; CHECK-NEXT:    pop {r4, r6, r7, pc}
entry:
  %c = icmp eq <16 x i8> %a, zeroinitializer
  %b = bitcast <16 x i1> %c to i16
  ret i16 %b
}

define arm_aapcs_vfpcc i2 @bitcast_from_v2i1(<2 x i64> %a) {
; CHECK-LABEL: bitcast_from_v2i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vmov r0, s1
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    vmov r1, s3
; CHECK-NEXT:    cset r0, eq
; CHECK-NEXT:    orrs r1, r2
; CHECK-NEXT:    cset r1, eq
; CHECK-NEXT:    ands r1, r1, #1
; CHECK-NEXT:    it ne
; CHECK-NEXT:    mvnne r1, #1
; CHECK-NEXT:    bfi r1, r0, #0, #1
; CHECK-NEXT:    and r0, r1, #3
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %c = icmp eq <2 x i64> %a, zeroinitializer
  %b = bitcast <2 x i1> %c to i2
  ret i2 %b
}
