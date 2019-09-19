; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -float2int -S | FileCheck %s
; RUN: opt < %s -passes='float2int' -S | FileCheck %s

;
; Positive tests
;

define i16 @simple1(i8 %a) {
; CHECK-LABEL: @simple1(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[T21:%.*]] = add i32 [[TMP1]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[T21]] to i16
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fadd float %t1, 1.0
  %t3 = fptoui float %t2 to i16
  ret i16 %t3
}

define i8 @simple2(i8 %a) {
; CHECK-LABEL: @simple2(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[T21:%.*]] = sub i32 [[TMP1]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[T21]] to i8
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fsub float %t1, 1.0
  %t3 = fptoui float %t2 to i8
  ret i8 %t3
}

define i32 @simple3(i8 %a) {
; CHECK-LABEL: @simple3(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[T21:%.*]] = sub i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[T21]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fsub float %t1, 1.0
  %t3 = fptoui float %t2 to i32
  ret i32 %t3
}

define i1 @cmp(i8 %a, i8 %b) {
; CHECK-LABEL: @cmp(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[T31:%.*]] = icmp slt i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i1 [[T31]]
;
  %t1 = uitofp i8 %a to float
  %t2 = uitofp i8 %b to float
  %t3 = fcmp ult float %t1, %t2
  ret i1 %t3
}

define i32 @simple4(i32 %a) {
; CHECK-LABEL: @simple4(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[A:%.*]] to i64
; CHECK-NEXT:    [[T21:%.*]] = add i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[T21]] to i32
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %t1 = uitofp i32 %a to double
  %t2 = fadd double %t1, 1.0
  %t3 = fptoui double %t2 to i32
  ret i32 %t3
}

define i32 @simple5(i8 %a, i8 %b) {
; CHECK-LABEL: @simple5(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[T31:%.*]] = add i32 [[TMP1]], 1
; CHECK-NEXT:    [[T42:%.*]] = mul i32 [[T31]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[T42]]
;
  %t1 = uitofp i8 %a to float
  %t2 = uitofp i8 %b to float
  %t3 = fadd float %t1, 1.0
  %t4 = fmul float %t3, %t2
  %t5 = fptoui float %t4 to i32
  ret i32 %t5
}

define i32 @simple6(i8 %a, i8 %b) {
; CHECK-LABEL: @simple6(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[T31:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    [[T42:%.*]] = mul i32 [[T31]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[T42]]
;
  %t1 = uitofp i8 %a to float
  %t2 = uitofp i8 %b to float
  %t3 = fneg float %t1
  %t4 = fmul float %t3, %t2
  %t5 = fptoui float %t4 to i32
  ret i32 %t5
}

; The two chains don't interact - failure of one shouldn't
; cause failure of the other.

define i32 @multi1(i8 %a, i8 %b, i8 %c, float %d) {
; CHECK-LABEL: @multi1(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[FC:%.*]] = uitofp i8 [[C:%.*]] to float
; CHECK-NEXT:    [[X1:%.*]] = add i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[FC]], [[D:%.*]]
; CHECK-NEXT:    [[W:%.*]] = fptoui float [[Z]] to i32
; CHECK-NEXT:    [[R:%.*]] = add i32 [[X1]], [[W]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %fa = uitofp i8 %a to float
  %fb = uitofp i8 %b to float
  %fc = uitofp i8 %c to float
  %x = fadd float %fa, %fb
  %y = fptoui float %x to i32
  %z = fadd float %fc, %d
  %w = fptoui float %z to i32
  %r = add i32 %y, %w
  ret i32 %r
}

define i16 @simple_negzero(i8 %a) {
; CHECK-LABEL: @simple_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[T21:%.*]] = add i32 [[TMP1]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[T21]] to i16
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fadd fast float %t1, -0.0
  %t3 = fptoui float %t2 to i16
  ret i16 %t3
}

define i32 @simple_negative(i8 %call) {
; CHECK-LABEL: @simple_negative(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i8 [[CALL:%.*]] to i32
; CHECK-NEXT:    [[MUL1:%.*]] = mul i32 [[TMP1]], -3
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[MUL1]] to i8
; CHECK-NEXT:    [[CONV3:%.*]] = sext i8 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[CONV3]]
;
  %conv1 = sitofp i8 %call to float
  %mul = fmul float %conv1, -3.000000e+00
  %conv2 = fptosi float %mul to i8
  %conv3 = sext i8 %conv2 to i32
  ret i32 %conv3
}

define i16 @simple_fneg(i8 %a) {
; CHECK-LABEL: @simple_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[T21:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i32 [[T21]] to i16
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fneg fast float %t1
  %t3 = fptoui float %t2 to i16
  ret i16 %t3
}

;
; Negative tests
;

; The two chains intersect, which means because one fails, no
; transform can occur.

define i32 @neg_multi1(i8 %a, i8 %b, i8 %c, float %d) {
; CHECK-LABEL: @neg_multi1(
; CHECK-NEXT:    [[FA:%.*]] = uitofp i8 [[A:%.*]] to float
; CHECK-NEXT:    [[FC:%.*]] = uitofp i8 [[C:%.*]] to float
; CHECK-NEXT:    [[X:%.*]] = fadd float [[FA]], [[FC]]
; CHECK-NEXT:    [[Y:%.*]] = fptoui float [[X]] to i32
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[FC]], [[D:%.*]]
; CHECK-NEXT:    [[W:%.*]] = fptoui float [[Z]] to i32
; CHECK-NEXT:    [[R:%.*]] = add i32 [[Y]], [[W]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %fa = uitofp i8 %a to float
  %fc = uitofp i8 %c to float
  %x = fadd float %fa, %fc
  %y = fptoui float %x to i32
  %z = fadd float %fc, %d
  %w = fptoui float %z to i32
  %r = add i32 %y, %w
  ret i32 %r
}

; The i32 * i32 = i64, which has 64 bits, which is greater than the 52 bits
; that can be exactly represented in a double.

define i64 @neg_muld(i32 %a, i32 %b) {
; CHECK-LABEL: @neg_muld(
; CHECK-NEXT:    [[FA:%.*]] = uitofp i32 [[A:%.*]] to double
; CHECK-NEXT:    [[FB:%.*]] = uitofp i32 [[B:%.*]] to double
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[FA]], [[FB]]
; CHECK-NEXT:    [[R:%.*]] = fptoui double [[MUL]] to i64
; CHECK-NEXT:    ret i64 [[R]]
;
  %fa = uitofp i32 %a to double
  %fb = uitofp i32 %b to double
  %mul = fmul double %fa, %fb
  %r = fptoui double %mul to i64
  ret i64 %r
}

; The i16 * i16 = i32, which can't be represented in a float, but can in a
; double. This should fail, as the written code uses floats, not doubles so
; the original result may be inaccurate.

define i32 @neg_mulf(i16 %a, i16 %b) {
; CHECK-LABEL: @neg_mulf(
; CHECK-NEXT:    [[FA:%.*]] = uitofp i16 [[A:%.*]] to float
; CHECK-NEXT:    [[FB:%.*]] = uitofp i16 [[B:%.*]] to float
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[FA]], [[FB]]
; CHECK-NEXT:    [[R:%.*]] = fptoui float [[MUL]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %fa = uitofp i16 %a to float
  %fb = uitofp i16 %b to float
  %mul = fmul float %fa, %fb
  %r = fptoui float %mul to i32
  ret i32 %r
}

; "false" doesn't have an icmp equivalent.

define i1 @neg_cmp(i8 %a, i8 %b) {
; CHECK-LABEL: @neg_cmp(
; CHECK-NEXT:    [[T1:%.*]] = uitofp i8 [[A:%.*]] to float
; CHECK-NEXT:    [[T2:%.*]] = uitofp i8 [[B:%.*]] to float
; CHECK-NEXT:    [[T3:%.*]] = fcmp false float [[T1]], [[T2]]
; CHECK-NEXT:    ret i1 [[T3]]
;
  %t1 = uitofp i8 %a to float
  %t2 = uitofp i8 %b to float
  %t3 = fcmp false float %t1, %t2
  ret i1 %t3
}

; Division isn't a supported operator.

define i16 @neg_div(i8 %a) {
; CHECK-LABEL: @neg_div(
; CHECK-NEXT:    [[T1:%.*]] = uitofp i8 [[A:%.*]] to float
; CHECK-NEXT:    [[T2:%.*]] = fdiv float [[T1]], 1.000000e+00
; CHECK-NEXT:    [[T3:%.*]] = fptoui float [[T2]] to i16
; CHECK-NEXT:    ret i16 [[T3]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fdiv float %t1, 1.0
  %t3 = fptoui float %t2 to i16
  ret i16 %t3
}

; 1.2 is not an integer.

define i16 @neg_remainder(i8 %a) {
; CHECK-LABEL: @neg_remainder(
; CHECK-NEXT:    [[T1:%.*]] = uitofp i8 [[A:%.*]] to float
; CHECK-NEXT:    [[T2:%.*]] = fadd float [[T1]], 1.250000e+00
; CHECK-NEXT:    [[T3:%.*]] = fptoui float [[T2]] to i16
; CHECK-NEXT:    ret i16 [[T3]]
;
  %t1 = uitofp i8 %a to float
  %t2 = fadd float %t1, 1.25
  %t3 = fptoui float %t2 to i16
  ret i16 %t3
}

; i80 > i64, which is the largest bitwidth handleable by default.

define i80 @neg_toolarge(i80 %a) {
; CHECK-LABEL: @neg_toolarge(
; CHECK-NEXT:    [[T1:%.*]] = uitofp i80 [[A:%.*]] to fp128
; CHECK-NEXT:    [[T2:%.*]] = fadd fp128 [[T1]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = fptoui fp128 [[T2]] to i80
; CHECK-NEXT:    ret i80 [[T3]]
;
  %t1 = uitofp i80 %a to fp128
  %t2 = fadd fp128 %t1, %t1
  %t3 = fptoui fp128 %t2 to i80
  ret i80 %t3
}

; The sequence %t1..%t3 cannot be converted because %t4 uses %t2.

define i32 @neg_calluser(i32 %value) {
; CHECK-LABEL: @neg_calluser(
; CHECK-NEXT:    [[T1:%.*]] = sitofp i32 [[VALUE:%.*]] to double
; CHECK-NEXT:    [[T2:%.*]] = fadd double [[T1]], 1.000000e+00
; CHECK-NEXT:    [[T3:%.*]] = fcmp olt double [[T2]], 0.000000e+00
; CHECK-NEXT:    [[T4:%.*]] = tail call double @g(double [[T2]])
; CHECK-NEXT:    [[T5:%.*]] = fptosi double [[T4]] to i32
; CHECK-NEXT:    [[T6:%.*]] = zext i1 [[T3]] to i32
; CHECK-NEXT:    [[T7:%.*]] = add i32 [[T6]], [[T5]]
; CHECK-NEXT:    ret i32 [[T7]]
;
  %t1 = sitofp i32 %value to double
  %t2 = fadd double %t1, 1.0
  %t3 = fcmp olt double %t2, 0.000000e+00
  %t4 = tail call double @g(double %t2)
  %t5 = fptosi double %t4 to i32
  %t6 = zext i1 %t3 to i32
  %t7 = add i32 %t6, %t5
  ret i32 %t7
}

declare double @g(double)

define <4 x i16> @neg_vector(<4 x i8> %a) {
; CHECK-LABEL: @neg_vector(
; CHECK-NEXT:    [[T1:%.*]] = uitofp <4 x i8> [[A:%.*]] to <4 x float>
; CHECK-NEXT:    [[T2:%.*]] = fptoui <4 x float> [[T1]] to <4 x i16>
; CHECK-NEXT:    ret <4 x i16> [[T2]]
;
  %t1 = uitofp <4 x i8> %a to <4 x float>
  %t2 = fptoui <4 x float> %t1 to <4 x i16>
  ret <4 x i16> %t2
}
