; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8-arm-none-eabi"

; Turning a vld1 intrinsic into an llvm load is beneficial
; when the underlying object being addressed comes from a
; constant, since we get constant-folding for free.

; Bail the optimization if the alignment is not a constant.
define <2 x i64> @vld1_align(i8* %ptr, i32 %align) {
; CHECK-LABEL: @vld1_align(
; CHECK-NEXT:    [[VLD1:%.*]] = call <2 x i64> @llvm.arm.neon.vld1.v2i64.p0i8(i8* [[PTR:%.*]], i32 [[ALIGN:%.*]])
; CHECK-NEXT:    ret <2 x i64> [[VLD1]]
;
  %vld1 = call <2 x i64> @llvm.arm.neon.vld1.v2i64.p0i8(i8* %ptr, i32 %align)
  ret <2 x i64> %vld1
}

; Bail the optimization if the alignment is not power of 2.
define <2 x i64> @vld1_align_pow2(i8* %ptr) {
; CHECK-LABEL: @vld1_align_pow2(
; CHECK-NEXT:    [[VLD1:%.*]] = call <2 x i64> @llvm.arm.neon.vld1.v2i64.p0i8(i8* [[PTR:%.*]], i32 3)
; CHECK-NEXT:    ret <2 x i64> [[VLD1]]
;
  %vld1 = call <2 x i64> @llvm.arm.neon.vld1.v2i64.p0i8(i8* %ptr, i32 3)
  ret <2 x i64> %vld1
}

define <8 x i8> @vld1_8x8(i8* %ptr) {
; CHECK-LABEL: @vld1_8x8(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <8 x i8>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i8>, <8 x i8>* [[TMP1]], align 1
; CHECK-NEXT:    ret <8 x i8> [[TMP2]]
;
  %vld1 = call <8 x i8> @llvm.arm.neon.vld1.v8i8.p0i8(i8* %ptr, i32 1)
  ret <8 x i8> %vld1
}

define <4 x i16> @vld1_4x16(i8* %ptr) {
; CHECK-LABEL: @vld1_4x16(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <4 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    ret <4 x i16> [[TMP2]]
;
  %vld1 = call <4 x i16> @llvm.arm.neon.vld1.v4i16.p0i8(i8* %ptr, i32 2)
  ret <4 x i16> %vld1
}

define <2 x i32> @vld1_2x32(i8* %ptr) {
; CHECK-LABEL: @vld1_2x32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <2 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i32>, <2 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %vld1 = call <2 x i32> @llvm.arm.neon.vld1.v2i32.p0i8(i8* %ptr, i32 4)
  ret <2 x i32> %vld1
}

define <1 x i64> @vld1_1x64(i8* %ptr) {
; CHECK-LABEL: @vld1_1x64(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <1 x i64>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <1 x i64>, <1 x i64>* [[TMP1]], align 8
; CHECK-NEXT:    ret <1 x i64> [[TMP2]]
;
  %vld1 = call <1 x i64> @llvm.arm.neon.vld1.v1i64.p0i8(i8* %ptr, i32 8)
  ret <1 x i64> %vld1
}

define <8 x i16> @vld1_8x16(i8* %ptr) {
; CHECK-LABEL: @vld1_8x16(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <8 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i16>, <8 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    ret <8 x i16> [[TMP2]]
;
  %vld1 = call <8 x i16> @llvm.arm.neon.vld1.v8i16.p0i8(i8* %ptr, i32 2)
  ret <8 x i16> %vld1
}

define <16 x i8> @vld1_16x8(i8* %ptr) {
; CHECK-LABEL: @vld1_16x8(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <16 x i8>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <16 x i8>, <16 x i8>* [[TMP1]], align 1
; CHECK-NEXT:    ret <16 x i8> [[TMP2]]
;
  %vld1 = call <16 x i8> @llvm.arm.neon.vld1.v16i8.p0i8(i8* %ptr, i32 1)
  ret <16 x i8> %vld1
}

define <4 x i32> @vld1_4x32(i8* %ptr) {
; CHECK-LABEL: @vld1_4x32(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %vld1 = call <4 x i32> @llvm.arm.neon.vld1.v4i32.p0i8(i8* %ptr, i32 4)
  ret <4 x i32> %vld1
}

define <2 x i64> @vld1_2x64(i8* %ptr) {
; CHECK-LABEL: @vld1_2x64(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[PTR:%.*]] to <2 x i64>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i64>, <2 x i64>* [[TMP1]], align 8
; CHECK-NEXT:    ret <2 x i64> [[TMP2]]
;
  %vld1 = call <2 x i64> @llvm.arm.neon.vld1.v2i64.p0i8(i8* %ptr, i32 8)
  ret <2 x i64> %vld1
}

declare <8 x i8> @llvm.arm.neon.vld1.v8i8.p0i8(i8*, i32)
declare <4 x i16> @llvm.arm.neon.vld1.v4i16.p0i8(i8*, i32)
declare <2 x i32> @llvm.arm.neon.vld1.v2i32.p0i8(i8*, i32)
declare <1 x i64> @llvm.arm.neon.vld1.v1i64.p0i8(i8*, i32)
declare <8 x i16> @llvm.arm.neon.vld1.v8i16.p0i8(i8*, i32)
declare <16 x i8> @llvm.arm.neon.vld1.v16i8.p0i8(i8*, i32)
declare <4 x i32> @llvm.arm.neon.vld1.v4i32.p0i8(i8*, i32)
declare <2 x i64> @llvm.arm.neon.vld1.v2i64.p0i8(i8*, i32)
