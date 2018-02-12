; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
 ; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
 ; RUN: opt < %s -slp-vectorizer -S -mtriple=x86_64-unknown-linux -mattr=+sse4.2 | FileCheck %s

 target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
 target triple = "x86_64-unknown-linux-gnu"

  @a = common local_unnamed_addr global [4 x i32] zeroinitializer, align 4
   @b = common local_unnamed_addr global [4 x i32] zeroinitializer, align 4

    define i32 @fn1() {
; CHECK-LABEL: @fn1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i64 0, i32 0), align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i32>, <2 x i32>* bitcast (i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i64 0, i32 1) to <2 x i32>*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @b, i64 0, i32 3), align 4
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x i32> [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x i32> undef, i32 [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i32> [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x i32> [[TMP4]], i32 [[TMP5]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> [[TMP6]], i32 [[TMP2]], i32 2
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <4 x i32> [[TMP7]], i32 [[TMP0]], i32 3
; CHECK-NEXT:    [[TMP9:%.*]] = icmp sgt <4 x i32> [[TMP8]], zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <4 x i32> [[TMP4]], i32 ptrtoint (i32 ()* @fn1 to i32), i32 1
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x i32> [[TMP10]], i32 ptrtoint (i32 ()* @fn1 to i32), i32 2
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <4 x i32> [[TMP11]], i32 8, i32 3
; CHECK-NEXT:    [[TMP13:%.*]] = select <4 x i1> [[TMP9]], <4 x i32> [[TMP12]], <4 x i32> <i32 6, i32 0, i32 0, i32 0>
; CHECK-NEXT:    store <4 x i32> [[TMP13]], <4 x i32>* bitcast ([4 x i32]* @a to <4 x i32>*), align 4
; CHECK-NEXT:    ret i32 0
;
  entry:
  %0 = load i32, i32* getelementptr ([4 x i32], [4 x i32]* @b, i64 0, i32 0), align 4
  %cmp = icmp sgt i32 %0, 0
  %cond = select i1 %cmp, i32 8, i32 0
  store i32 %cond, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i64 0, i32 3), align 4
  %1 = load i32, i32* getelementptr ([4 x i32], [4 x i32]* @b, i64 0, i32 1), align 4
  %cmp1 = icmp sgt i32 %1, 0
  %. = select i1 %cmp1, i32 %1, i32 6
  store i32 %., i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i64 0, i32 0), align 4
  %2 = load i32, i32* getelementptr ([4 x i32], [4 x i32]* @b, i64 0, i32 2), align 4
  %cmp4 = icmp sgt i32 %2, 0
  %3 = select i1 %cmp4, i32 ptrtoint (i32 ()* @fn1 to i32), i32 0
  store i32 %3, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i64 0, i32 1), align 4
  %4 = load i32, i32* getelementptr ([4 x i32], [4 x i32]* @b, i64 0, i32 3), align 4
  %cmp6 = icmp sgt i32 %4, 0
  %5 = select i1 %cmp6, i32 ptrtoint (i32 ()* @fn1 to i32), i32 0
  store i32 %5, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @a, i64 0, i32 2), align 4
  ret i32 0
}
