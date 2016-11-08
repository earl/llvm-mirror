; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define float @test1(i32 %scale) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i32 %scale, 1
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 1, i32 %scale
; CHECK-NEXT:    [[TMP3:%.*]] = sitofp i32 [[TMP2]] to float
; CHECK-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[TMP2]], 0
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[TMP4]], float [[TMP3]], float 0.000000e+00
; CHECK-NEXT:    ret float [[SEL]]
;
  %tmp1 = icmp sgt i32 1, %scale
  %tmp2 = select i1 %tmp1, i32 1, i32 %scale
  %tmp3 = sitofp i32 %tmp2 to float
  %tmp4 = icmp sgt i32 %tmp2, 0
  %sel = select i1 %tmp4, float %tmp3, float 0.000000e+00
  ret float %sel
}

