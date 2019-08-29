; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-LE
; RUN: llc -mtriple=thumbebv8.1m.main-arm-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-BE

define void @foo_v4i32_v4i32(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i32> *%src) {
; CHECK-LABEL: foo_v4i32_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i32> @llvm.masked.load.v4i32(<4 x i32>* %src, i32 4, <4 x i1> %1, <4 x i32> undef)
  call void @llvm.masked.store.v4i32(<4 x i32> %2, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_sext_v4i32_v4i8(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i8> *%src) {
; CHECK-LABEL: foo_sext_v4i32_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrbne r3, [r2]
; CHECK-NEXT:    vmovne.32 q0[0], r3
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #1]
; CHECK-NEXT:    vmovmi.32 q0[1], r3
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #2]
; CHECK-NEXT:    vmovmi.32 q0[2], r3
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r1, [r2, #3]
; CHECK-NEXT:    vmovmi.32 q0[3], r1
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i8> @llvm.masked.load.v4i8(<4 x i8>* %src, i32 1, <4 x i1> %1, <4 x i8> undef)
  %3 = sext <4 x i8> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_sext_v4i32_v4i16(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i16> *%src) {
; CHECK-LABEL: foo_sext_v4i32_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrhne r3, [r2]
; CHECK-NEXT:    vmovne.32 q0[0], r3
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrhmi r3, [r2, #2]
; CHECK-NEXT:    vmovmi.32 q0[1], r3
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrhmi r3, [r2, #4]
; CHECK-NEXT:    vmovmi.32 q0[2], r3
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrhmi r1, [r2, #6]
; CHECK-NEXT:    vmovmi.32 q0[3], r1
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i16> @llvm.masked.load.v4i16(<4 x i16>* %src, i32 2, <4 x i1> %1, <4 x i16> undef)
  %3 = sext <4 x i16> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_zext_v4i32_v4i8(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i8> *%src) {
; CHECK-LABEL: foo_zext_v4i32_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrbne r3, [r2]
; CHECK-NEXT:    vmovne.32 q0[0], r3
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #1]
; CHECK-NEXT:    vmovmi.32 q0[1], r3
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #2]
; CHECK-NEXT:    vmovmi.32 q0[2], r3
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r1, [r2, #3]
; CHECK-NEXT:    vmovmi.32 q0[3], r1
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i8> @llvm.masked.load.v4i8(<4 x i8>* %src, i32 1, <4 x i1> %1, <4 x i8> undef)
  %3 = zext <4 x i8> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_zext_v4i32_v4i16(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i16> *%src) {
; CHECK-LABEL: foo_zext_v4i32_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrhne r3, [r2]
; CHECK-NEXT:    vmovne.32 q0[0], r3
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrhmi r3, [r2, #2]
; CHECK-NEXT:    vmovmi.32 q0[1], r3
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrhmi r3, [r2, #4]
; CHECK-NEXT:    vmovmi.32 q0[2], r3
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrhmi r1, [r2, #6]
; CHECK-NEXT:    vmovmi.32 q0[3], r1
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i16> @llvm.masked.load.v4i16(<4 x i16>* %src, i32 2, <4 x i1> %1, <4 x i16> undef)
  %3 = zext <4 x i16> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_v8i16_v8i16(<8 x i16> *%dest, <8 x i16> *%mask, <8 x i16> *%src) {
; CHECK-LABEL: foo_v8i16_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrht.u16 q0, [r2]
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i16> @llvm.masked.load.v8i16(<8 x i16>* %src, i32 2, <8 x i1> %1, <8 x i16> undef)
  call void @llvm.masked.store.v8i16(<8 x i16> %2, <8 x i16>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_sext_v8i16_v8i8(<8 x i16> *%dest, <8 x i16> *%mask, <8 x i8> *%src) {
; CHECK-LABEL: foo_sext_v8i16_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrbne r3, [r2]
; CHECK-NEXT:    vmovne.16 q0[0], r3
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #1]
; CHECK-NEXT:    vmovmi.16 q0[1], r3
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #2]
; CHECK-NEXT:    vmovmi.16 q0[2], r3
; CHECK-NEXT:    lsls r3, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #3]
; CHECK-NEXT:    vmovmi.16 q0[3], r3
; CHECK-NEXT:    lsls r3, r1, #27
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #4]
; CHECK-NEXT:    vmovmi.16 q0[4], r3
; CHECK-NEXT:    lsls r3, r1, #26
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #5]
; CHECK-NEXT:    vmovmi.16 q0[5], r3
; CHECK-NEXT:    lsls r3, r1, #25
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #6]
; CHECK-NEXT:    vmovmi.16 q0[6], r3
; CHECK-NEXT:    lsls r1, r1, #24
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r1, [r2, #7]
; CHECK-NEXT:    vmovmi.16 q0[7], r1
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i8> @llvm.masked.load.v8i8(<8 x i8>* %src, i32 1, <8 x i1> %1, <8 x i8> undef)
  %3 = sext <8 x i8> %2 to <8 x i16>
  call void @llvm.masked.store.v8i16(<8 x i16> %3, <8 x i16>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_zext_v8i16_v8i8(<8 x i16> *%dest, <8 x i16> *%mask, <8 x i8> *%src) {
; CHECK-LABEL: foo_zext_v8i16_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrbne r3, [r2]
; CHECK-NEXT:    vmovne.16 q0[0], r3
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #1]
; CHECK-NEXT:    vmovmi.16 q0[1], r3
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #2]
; CHECK-NEXT:    vmovmi.16 q0[2], r3
; CHECK-NEXT:    lsls r3, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #3]
; CHECK-NEXT:    vmovmi.16 q0[3], r3
; CHECK-NEXT:    lsls r3, r1, #27
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #4]
; CHECK-NEXT:    vmovmi.16 q0[4], r3
; CHECK-NEXT:    lsls r3, r1, #26
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #5]
; CHECK-NEXT:    vmovmi.16 q0[5], r3
; CHECK-NEXT:    lsls r3, r1, #25
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r3, [r2, #6]
; CHECK-NEXT:    vmovmi.16 q0[6], r3
; CHECK-NEXT:    lsls r1, r1, #24
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrbmi r1, [r2, #7]
; CHECK-NEXT:    vmovmi.16 q0[7], r1
; CHECK-NEXT:    vmovlb.u8 q0, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i8> @llvm.masked.load.v8i8(<8 x i8>* %src, i32 1, <8 x i1> %1, <8 x i8> undef)
  %3 = zext <8 x i8> %2 to <8 x i16>
  call void @llvm.masked.store.v8i16(<8 x i16> %3, <8 x i16>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_v16i8_v16i8(<16 x i8> *%dest, <16 x i8> *%mask, <16 x i8> *%src) {
; CHECK-LABEL: foo_v16i8_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r1]
; CHECK-NEXT:    vcmp.s8 gt, q0, zr
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrbt.u8 q0, [r2]
; CHECK-NEXT:    vstrbt.8 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <16 x i8>, <16 x i8>* %mask, align 1
  %1 = icmp sgt <16 x i8> %0, zeroinitializer
  %2 = call <16 x i8> @llvm.masked.load.v16i8(<16 x i8>* %src, i32 1, <16 x i1> %1, <16 x i8> undef)
  call void @llvm.masked.store.v16i8(<16 x i8> %2, <16 x i8>* %dest, i32 1, <16 x i1> %1)
  ret void
}

define void @foo_trunc_v8i8_v8i16(<8 x i8> *%dest, <8 x i16> *%mask, <8 x i16> *%src) {
; CHECK-LABEL: foo_trunc_v8i8_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrht.u16 q0, [r2]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r2, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    vmovne.u16 r2, q0[0]
; CHECK-NEXT:    strbne r2, [r0]
; CHECK-NEXT:    lsls r2, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r2, q0[1]
; CHECK-NEXT:    strbmi r2, [r0, #1]
; CHECK-NEXT:    lsls r2, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r2, q0[2]
; CHECK-NEXT:    strbmi r2, [r0, #2]
; CHECK-NEXT:    lsls r2, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r2, q0[3]
; CHECK-NEXT:    strbmi r2, [r0, #3]
; CHECK-NEXT:    lsls r2, r1, #27
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r2, q0[4]
; CHECK-NEXT:    strbmi r2, [r0, #4]
; CHECK-NEXT:    lsls r2, r1, #26
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r2, q0[5]
; CHECK-NEXT:    strbmi r2, [r0, #5]
; CHECK-NEXT:    lsls r2, r1, #25
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r2, q0[6]
; CHECK-NEXT:    strbmi r2, [r0, #6]
; CHECK-NEXT:    lsls r1, r1, #24
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi.u16 r1, q0[7]
; CHECK-NEXT:    strbmi r1, [r0, #7]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i16> @llvm.masked.load.v8i16(<8 x i16>* %src, i32 2, <8 x i1> %1, <8 x i16> undef)
  %3 = trunc <8 x i16> %2 to <8 x i8>
  call void @llvm.masked.store.v8i8(<8 x i8> %3, <8 x i8>* %dest, i32 1, <8 x i1> %1)
  ret void
}

define void @foo_trunc_v4i8_v4i32(<4 x i8> *%dest, <4 x i32> *%mask, <4 x i32> *%src) {
; CHECK-LABEL: foo_trunc_v4i8_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r2, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    vmovne r2, s0
; CHECK-NEXT:    strbne r2, [r0]
; CHECK-NEXT:    lsls r2, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s1
; CHECK-NEXT:    strbmi r2, [r0, #1]
; CHECK-NEXT:    lsls r2, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s2
; CHECK-NEXT:    strbmi r2, [r0, #2]
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r1, s3
; CHECK-NEXT:    strbmi r1, [r0, #3]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i32> @llvm.masked.load.v4i32(<4 x i32>* %src, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = trunc <4 x i32> %2 to <4 x i8>
  call void @llvm.masked.store.v4i8(<4 x i8> %3, <4 x i8>* %dest, i32 1, <4 x i1> %1)
  ret void
}

define void @foo_trunc_v4i16_v4i32(<4 x i16> *%dest, <4 x i32> *%mask, <4 x i32> *%src) {
; CHECK-LABEL: foo_trunc_v4i16_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r3, sp
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    vstr p0, [r3]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    ldrb.w r1, [sp]
; CHECK-NEXT:    lsls r2, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    vmovne r2, s0
; CHECK-NEXT:    strhne r2, [r0]
; CHECK-NEXT:    lsls r2, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s1
; CHECK-NEXT:    strhmi r2, [r0, #2]
; CHECK-NEXT:    lsls r2, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s2
; CHECK-NEXT:    strhmi r2, [r0, #4]
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r1, s3
; CHECK-NEXT:    strhmi r1, [r0, #6]
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i32> @llvm.masked.load.v4i32(<4 x i32>* %src, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = trunc <4 x i32> %2 to <4 x i16>
  call void @llvm.masked.store.v4i16(<4 x i16> %3, <4 x i16>* %dest, i32 2, <4 x i1> %1)
  ret void
}

define void @foo_v4f32_v4f32(<4 x float> *%dest, <4 x i32> *%mask, <4 x float> *%src) {
; CHECK-LABEL: foo_v4f32_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x float> @llvm.masked.load.v4f32(<4 x float>* %src, i32 4, <4 x i1> %1, <4 x float> undef)
  call void @llvm.masked.store.v4f32(<4 x float> %2, <4 x float>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_v8f16_v8f16(<8 x half> *%dest, <8 x i16> *%mask, <8 x half> *%src) {
; CHECK-LABEL: foo_v8f16_v8f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vcmp.s16 gt, q0, zr
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrht.u16 q0, [r2]
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x half> @llvm.masked.load.v8f16(<8 x half>* %src, i32 2, <8 x i1> %1, <8 x half> undef)
  call void @llvm.masked.store.v8f16(<8 x half> %2, <8 x half>* %dest, i32 2, <8 x i1> %1)
  ret void
}

declare void @llvm.masked.store.v4i32(<4 x i32>, <4 x i32>*, i32, <4 x i1>)
declare void @llvm.masked.store.v8i16(<8 x i16>, <8 x i16>*, i32, <8 x i1>)
declare void @llvm.masked.store.v16i8(<16 x i8>, <16 x i8>*, i32, <16 x i1>)
declare void @llvm.masked.store.v8f16(<8 x half>, <8 x half>*, i32, <8 x i1>)
declare void @llvm.masked.store.v4f32(<4 x float>, <4 x float>*, i32, <4 x i1>)
declare <16 x i8> @llvm.masked.load.v16i8(<16 x i8>*, i32, <16 x i1>, <16 x i8>)
declare <8 x i16> @llvm.masked.load.v8i16(<8 x i16>*, i32, <8 x i1>, <8 x i16>)
declare <4 x i32> @llvm.masked.load.v4i32(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
declare <4 x float> @llvm.masked.load.v4f32(<4 x float>*, i32, <4 x i1>, <4 x float>)
declare <8 x half> @llvm.masked.load.v8f16(<8 x half>*, i32, <8 x i1>, <8 x half>)

declare void @llvm.masked.store.v8i8(<8 x i8>, <8 x i8>*, i32, <8 x i1>)
declare void @llvm.masked.store.v4i8(<4 x i8>, <4 x i8>*, i32, <4 x i1>)
declare void @llvm.masked.store.v4i16(<4 x i16>, <4 x i16>*, i32, <4 x i1>)
declare <4 x i16> @llvm.masked.load.v4i16(<4 x i16>*, i32, <4 x i1>, <4 x i16>)
declare <4 x i8> @llvm.masked.load.v4i8(<4 x i8>*, i32, <4 x i1>, <4 x i8>)
declare <8 x i8> @llvm.masked.load.v8i8(<8 x i8>*, i32, <8 x i1>, <8 x i8>)
