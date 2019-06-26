; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

define <4 x float> @good1(float %arg) {
; CHECK-LABEL: @good1(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T6:%.*]] = shufflevector <4 x float> [[T]], <4 x float> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 0
  %t4 = insertelement <4 x float> %t, float %arg, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <4 x float> @good2(float %arg) {
; CHECK-LABEL: @good2(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T6:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 1
  %t4 = insertelement <4 x float> %t, float %arg, i32 2
  %t5 = insertelement <4 x float> %t4, float %arg, i32 0
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <4 x float> @good3(float %arg) {
; CHECK-LABEL: @good3(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T6:%.*]] = shufflevector <4 x float> [[T]], <4 x float> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> zeroinitializer, float %arg, i32 0
  %t4 = insertelement <4 x float> %t, float %arg, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <4 x float> @good4(float %arg) {
; CHECK-LABEL: @good4(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = fadd <4 x float> [[T]], [[T]]
; CHECK-NEXT:    [[T7:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x float> [[T7]]
;
  %t = insertelement <4 x float> zeroinitializer, float %arg, i32 0
  %t4 = insertelement <4 x float> %t, float %arg, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  %t7 = fadd <4 x float> %t6, %t6
  ret <4 x float> %t7
}

define <4 x float> @good5(float %v) {
; CHECK-LABEL: @good5(
; CHECK-NEXT:    [[INS1:%.*]] = insertelement <4 x float> undef, float [[V:%.*]], i32 0
; CHECK-NEXT:    [[A1:%.*]] = fadd <4 x float> [[INS1]], [[INS1]]
; CHECK-NEXT:    [[INS4:%.*]] = shufflevector <4 x float> [[INS1]], <4 x float> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[RES:%.*]] = fadd <4 x float> [[A1]], [[INS4]]
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %ins1 = insertelement <4 x float> undef, float %v, i32 0
  %a1 = fadd <4 x float> %ins1, %ins1
  %ins2 = insertelement<4 x float> %ins1, float %v, i32 1
  %ins3 = insertelement<4 x float> %ins2, float %v, i32 2
  %ins4 = insertelement<4 x float> %ins3, float %v, i32 3
  %res = fadd <4 x float> %a1, %ins4
  ret <4 x float> %res
}

define <4 x float> @bad1(float %arg) {
; CHECK-LABEL: @bad1(
; CHECK-NEXT:    [[T4:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 1
; CHECK-NEXT:    [[T5:%.*]] = insertelement <4 x float> [[T4]], float [[ARG]], i32 2
; CHECK-NEXT:    [[T6:%.*]] = insertelement <4 x float> [[T5]], float [[ARG]], i32 3
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 1
  %t4 = insertelement <4 x float> %t, float %arg, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <4 x float> @bad2(float %arg) {
; CHECK-LABEL: @bad2(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T5:%.*]] = insertelement <4 x float> [[T]], float [[ARG]], i32 2
; CHECK-NEXT:    [[T6:%.*]] = insertelement <4 x float> [[T5]], float [[ARG]], i32 3
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 0
  %t5 = insertelement <4 x float> %t, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <4 x float> @bad3(float %arg, float %arg2) {
; CHECK-LABEL: @bad3(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T4:%.*]] = insertelement <4 x float> [[T]], float [[ARG2:%.*]], i32 1
; CHECK-NEXT:    [[T5:%.*]] = insertelement <4 x float> [[T4]], float [[ARG]], i32 2
; CHECK-NEXT:    [[T6:%.*]] = insertelement <4 x float> [[T5]], float [[ARG]], i32 3
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 0
  %t4 = insertelement <4 x float> %t, float %arg2, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <1 x float> @bad4(float %arg) {
; CHECK-LABEL: @bad4(
; CHECK-NEXT:    [[T:%.*]] = insertelement <1 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    ret <1 x float> [[T]]
;
  %t = insertelement <1 x float> undef, float %arg, i32 0
  ret <1 x float> %t
}

define <4 x float> @bad5(float %arg) {
; CHECK-LABEL: @bad5(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T4:%.*]] = insertelement <4 x float> [[T]], float [[ARG]], i32 1
; CHECK-NEXT:    [[T5:%.*]] = insertelement <4 x float> [[T4]], float [[ARG]], i32 2
; CHECK-NEXT:    [[T6:%.*]] = insertelement <4 x float> [[T5]], float [[ARG]], i32 3
; CHECK-NEXT:    [[T7:%.*]] = fadd <4 x float> [[T6]], [[T4]]
; CHECK-NEXT:    ret <4 x float> [[T7]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 0
  %t4 = insertelement <4 x float> %t, float %arg, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 2
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  %t7 = fadd <4 x float> %t6, %t4
  ret <4 x float> %t7
}

define <4 x float> @bad6(float %arg, i32 %k) {
; CHECK-LABEL: @bad6(
; CHECK-NEXT:    [[T:%.*]] = insertelement <4 x float> undef, float [[ARG:%.*]], i32 0
; CHECK-NEXT:    [[T4:%.*]] = insertelement <4 x float> [[T]], float [[ARG]], i32 1
; CHECK-NEXT:    [[T5:%.*]] = insertelement <4 x float> [[T4]], float [[ARG]], i32 [[K:%.*]]
; CHECK-NEXT:    [[T6:%.*]] = insertelement <4 x float> [[T5]], float [[ARG]], i32 3
; CHECK-NEXT:    ret <4 x float> [[T6]]
;
  %t = insertelement <4 x float> undef, float %arg, i32 0
  %t4 = insertelement <4 x float> %t, float %arg, i32 1
  %t5 = insertelement <4 x float> %t4, float %arg, i32 %k
  %t6 = insertelement <4 x float> %t5, float %arg, i32 3
  ret <4 x float> %t6
}

define <4 x float> @bad7(float %v) {
; CHECK-LABEL: @bad7(
; CHECK-NEXT:    [[INS1:%.*]] = insertelement <4 x float> undef, float [[V:%.*]], i32 1
; CHECK-NEXT:    [[A1:%.*]] = fadd <4 x float> [[INS1]], [[INS1]]
; CHECK-NEXT:    [[INS2:%.*]] = insertelement <4 x float> [[INS1]], float [[V]], i32 2
; CHECK-NEXT:    [[INS3:%.*]] = insertelement <4 x float> [[INS2]], float [[V]], i32 3
; CHECK-NEXT:    [[INS4:%.*]] = insertelement <4 x float> [[INS3]], float [[V]], i32 0
; CHECK-NEXT:    [[RES:%.*]] = fadd <4 x float> [[A1]], [[INS4]]
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %ins1 = insertelement <4 x float> undef, float %v, i32 1
  %a1 = fadd <4 x float> %ins1, %ins1
  %ins2 = insertelement<4 x float> %ins1, float %v, i32 2
  %ins3 = insertelement<4 x float> %ins2, float %v, i32 3
  %ins4 = insertelement<4 x float> %ins3, float %v, i32 0
  %res = fadd <4 x float> %a1, %ins4
  ret <4 x float> %res
}
