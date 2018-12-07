; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -bdce -instsimplify < %s | FileCheck %s
; RUN: opt -S -instsimplify < %s | FileCheck %s -check-prefix=CHECK-IO
; CHECK-IO lines to ensure that transformations are not performed by only instsimplify.

; BDCE applied to integer vectors.

define <2 x i32> @test_basic(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: @test_basic(
; CHECK-NEXT:    [[A2:%.*]] = add <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[A3:%.*]] = and <2 x i32> [[A2]], <i32 4, i32 4>
; CHECK-NEXT:    [[B2:%.*]] = add <2 x i32> [[B:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[B3:%.*]] = and <2 x i32> [[B2]], <i32 8, i32 8>
; CHECK-NEXT:    [[C:%.*]] = or <2 x i32> [[A3]], [[B3]]
; CHECK-NEXT:    [[D:%.*]] = ashr <2 x i32> [[C]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[D]]
;
; CHECK-IO-LABEL: @test_basic(
; CHECK-IO-NEXT:    [[A2:%.*]] = add <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-IO-NEXT:    [[A3:%.*]] = and <2 x i32> [[A2]], <i32 4, i32 4>
; CHECK-IO-NEXT:    [[B2:%.*]] = add <2 x i32> [[B:%.*]], <i32 1, i32 1>
; CHECK-IO-NEXT:    [[B3:%.*]] = and <2 x i32> [[B2]], <i32 8, i32 8>
; CHECK-IO-NEXT:    [[C:%.*]] = or <2 x i32> [[A3]], [[B3]]
; CHECK-IO-NEXT:    [[D:%.*]] = ashr <2 x i32> [[C]], <i32 3, i32 3>
; CHECK-IO-NEXT:    ret <2 x i32> [[D]]
;
  %a2 = add <2 x i32> %a, <i32 1, i32 1>
  %a3 = and <2 x i32> %a2, <i32 4, i32 4>
  %b2 = add <2 x i32> %b, <i32 1, i32 1>
  %b3 = and <2 x i32> %b2, <i32 8, i32 8>
  %c = or <2 x i32> %a3, %b3
  %d = ashr <2 x i32> %c, <i32 3, i32 3>
  ret <2 x i32> %d
}

; Going vector -> scalar
define i32 @test_extractelement(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: @test_extractelement(
; CHECK-NEXT:    [[A2:%.*]] = add <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[A3:%.*]] = and <2 x i32> [[A2]], <i32 4, i32 4>
; CHECK-NEXT:    [[B2:%.*]] = add <2 x i32> [[B:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[B3:%.*]] = and <2 x i32> [[B2]], <i32 8, i32 8>
; CHECK-NEXT:    [[C:%.*]] = or <2 x i32> [[A3]], [[B3]]
; CHECK-NEXT:    [[D:%.*]] = extractelement <2 x i32> [[C]], i32 0
; CHECK-NEXT:    [[E:%.*]] = ashr i32 [[D]], 3
; CHECK-NEXT:    ret i32 [[E]]
;
; CHECK-IO-LABEL: @test_extractelement(
; CHECK-IO-NEXT:    [[A2:%.*]] = add <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-IO-NEXT:    [[A3:%.*]] = and <2 x i32> [[A2]], <i32 4, i32 4>
; CHECK-IO-NEXT:    [[B2:%.*]] = add <2 x i32> [[B:%.*]], <i32 1, i32 1>
; CHECK-IO-NEXT:    [[B3:%.*]] = and <2 x i32> [[B2]], <i32 8, i32 8>
; CHECK-IO-NEXT:    [[C:%.*]] = or <2 x i32> [[A3]], [[B3]]
; CHECK-IO-NEXT:    [[D:%.*]] = extractelement <2 x i32> [[C]], i32 0
; CHECK-IO-NEXT:    [[E:%.*]] = ashr i32 [[D]], 3
; CHECK-IO-NEXT:    ret i32 [[E]]
;
  %a2 = add <2 x i32> %a, <i32 1, i32 1>
  %a3 = and <2 x i32> %a2, <i32 4, i32 4>
  %b2 = add <2 x i32> %b, <i32 1, i32 1>
  %b3 = and <2 x i32> %b2, <i32 8, i32 8>
  %c = or <2 x i32> %a3, %b3
  %d = extractelement <2 x i32> %c, i32 0
  %e = ashr i32 %d, 3
  ret i32 %e
}

; Going scalar -> vector
define <2 x i32> @test_insertelement(i32 %a, i32 %b) {
; CHECK-LABEL: @test_insertelement(
; CHECK-NEXT:    [[X:%.*]] = insertelement <2 x i32> undef, i32 [[A:%.*]], i32 0
; CHECK-NEXT:    [[X2:%.*]] = insertelement <2 x i32> [[X]], i32 [[B:%.*]], i32 1
; CHECK-NEXT:    [[X3:%.*]] = and <2 x i32> [[X2]], <i32 4, i32 4>
; CHECK-NEXT:    [[Y:%.*]] = insertelement <2 x i32> undef, i32 [[B]], i32 0
; CHECK-NEXT:    [[Y2:%.*]] = insertelement <2 x i32> [[Y]], i32 [[A]], i32 1
; CHECK-NEXT:    [[Y3:%.*]] = and <2 x i32> [[Y2]], <i32 8, i32 8>
; CHECK-NEXT:    [[Z:%.*]] = or <2 x i32> [[X3]], [[Y3]]
; CHECK-NEXT:    [[U:%.*]] = ashr <2 x i32> [[Z]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[U]]
;
; CHECK-IO-LABEL: @test_insertelement(
; CHECK-IO-NEXT:    [[X:%.*]] = insertelement <2 x i32> undef, i32 [[A:%.*]], i32 0
; CHECK-IO-NEXT:    [[X2:%.*]] = insertelement <2 x i32> [[X]], i32 [[B:%.*]], i32 1
; CHECK-IO-NEXT:    [[X3:%.*]] = and <2 x i32> [[X2]], <i32 4, i32 4>
; CHECK-IO-NEXT:    [[Y:%.*]] = insertelement <2 x i32> undef, i32 [[B]], i32 0
; CHECK-IO-NEXT:    [[Y2:%.*]] = insertelement <2 x i32> [[Y]], i32 [[A]], i32 1
; CHECK-IO-NEXT:    [[Y3:%.*]] = and <2 x i32> [[Y2]], <i32 8, i32 8>
; CHECK-IO-NEXT:    [[Z:%.*]] = or <2 x i32> [[X3]], [[Y3]]
; CHECK-IO-NEXT:    [[U:%.*]] = ashr <2 x i32> [[Z]], <i32 3, i32 3>
; CHECK-IO-NEXT:    ret <2 x i32> [[U]]
;
  %x = insertelement <2 x i32> undef, i32 %a, i32 0
  %x2 = insertelement <2 x i32> %x, i32 %b, i32 1
  %x3 = and <2 x i32> %x2, <i32 4, i32 4>
  %y = insertelement <2 x i32> undef, i32 %b, i32 0
  %y2 = insertelement <2 x i32> %y, i32 %a, i32 1
  %y3 = and <2 x i32> %y2, <i32 8, i32 8>
  %z = or <2 x i32> %x3, %y3
  %u = ashr <2 x i32> %z, <i32 3, i32 3>
  ret <2 x i32> %u
}

; Some non-int vectors and conversions
define <2 x i32> @test_conversion(<2 x i32> %a) {
; CHECK-LABEL: @test_conversion(
; CHECK-NEXT:    [[A2:%.*]] = add <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[A3:%.*]] = and <2 x i32> [[A2]], <i32 2, i32 2>
; CHECK-NEXT:    [[X:%.*]] = uitofp <2 x i32> [[A3]] to <2 x double>
; CHECK-NEXT:    [[Y:%.*]] = fadd <2 x double> [[X]], <double 1.000000e+00, double 1.000000e+00>
; CHECK-NEXT:    [[Z:%.*]] = fptoui <2 x double> [[Y]] to <2 x i32>
; CHECK-NEXT:    [[U:%.*]] = ashr <2 x i32> [[Z]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[U]]
;
; CHECK-IO-LABEL: @test_conversion(
; CHECK-IO-NEXT:    [[A2:%.*]] = add <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-IO-NEXT:    [[A3:%.*]] = and <2 x i32> [[A2]], <i32 2, i32 2>
; CHECK-IO-NEXT:    [[X:%.*]] = uitofp <2 x i32> [[A3]] to <2 x double>
; CHECK-IO-NEXT:    [[Y:%.*]] = fadd <2 x double> [[X]], <double 1.000000e+00, double 1.000000e+00>
; CHECK-IO-NEXT:    [[Z:%.*]] = fptoui <2 x double> [[Y]] to <2 x i32>
; CHECK-IO-NEXT:    [[U:%.*]] = ashr <2 x i32> [[Z]], <i32 3, i32 3>
; CHECK-IO-NEXT:    ret <2 x i32> [[U]]
;
  %a2 = add <2 x i32> %a, <i32 1, i32 1>
  %a3 = and <2 x i32> %a2, <i32 2, i32 2>
  %x = uitofp <2 x i32> %a3 to <2 x double>
  %y = fadd <2 x double> %x, <double 1.0, double 1.0>
  %z = fptoui <2 x double> %y to <2 x i32>
  %u = ashr <2 x i32> %z, <i32 3, i32 3>
  ret <2 x i32> %u
}

; Assumption invalidation (adapted from invalidate-assumptions.ll)
define <2 x i1> @test_assumption_invalidation(<2 x i1> %b, <2 x i8> %x) {
; CHECK-LABEL: @test_assumption_invalidation(
; CHECK-NEXT:    [[SETBIT:%.*]] = or <2 x i8> [[X:%.*]], <i8 64, i8 64>
; CHECK-NEXT:    [[LITTLE_NUMBER:%.*]] = zext <2 x i1> [[B:%.*]] to <2 x i8>
; CHECK-NEXT:    [[BIG_NUMBER:%.*]] = shl <2 x i8> [[SETBIT]], <i8 1, i8 1>
; CHECK-NEXT:    [[SUB:%.*]] = sub nuw <2 x i8> [[BIG_NUMBER]], [[LITTLE_NUMBER]]
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <2 x i8> [[SUB]] to <2 x i1>
; CHECK-NEXT:    ret <2 x i1> [[TRUNC]]
;
; CHECK-IO-LABEL: @test_assumption_invalidation(
; CHECK-IO-NEXT:    [[SETBIT:%.*]] = or <2 x i8> [[X:%.*]], <i8 64, i8 64>
; CHECK-IO-NEXT:    [[LITTLE_NUMBER:%.*]] = zext <2 x i1> [[B:%.*]] to <2 x i8>
; CHECK-IO-NEXT:    [[BIG_NUMBER:%.*]] = shl <2 x i8> [[SETBIT]], <i8 1, i8 1>
; CHECK-IO-NEXT:    [[SUB:%.*]] = sub nuw <2 x i8> [[BIG_NUMBER]], [[LITTLE_NUMBER]]
; CHECK-IO-NEXT:    [[TRUNC:%.*]] = trunc <2 x i8> [[SUB]] to <2 x i1>
; CHECK-IO-NEXT:    ret <2 x i1> [[TRUNC]]
;
  %setbit = or <2 x i8> %x, <i8 64, i8 64>
  %little_number = zext <2 x i1> %b to <2 x i8>
  %big_number = shl <2 x i8> %setbit, <i8 1, i8 1>
  %sub = sub nuw <2 x i8> %big_number, %little_number
  %trunc = trunc <2 x i8> %sub to <2 x i1>
  ret <2 x i1> %trunc
}
