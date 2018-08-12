; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; =========================================================================
;
;   Test FP factorization with patterns:
;   X * Z + Y * Z --> (X + Y) * Z (including all 4 commuted variants)
;   X * Z - Y * Z --> (X - Y) * Z (including all 4 commuted variants)
;   X / Z + Y / Z --> (X + Y) / Z
;   X / Z - Y / Z --> (X - Y) / Z
;
; =========================================================================

; Minimum FMF - the final result requires/propagates FMF.

define float @fmul_fadd(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fadd(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %x, %z
  %t2 = fmul float %y, %z
  %r = fadd reassoc nsz float %t1, %t2
  ret float %r
}

; FIXME:
; Verify vector types and commuted operands.

define <2 x float> @fmul_fadd_commute1_vec(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fmul_fadd_commute1_vec(
; CHECK-NEXT:    [[T1:%.*]] = fmul <2 x float> [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul <2 x float> [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd reassoc nsz <2 x float> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %t1 = fmul <2 x float> %z, %x
  %t2 = fmul <2 x float> %z, %y
  %r = fadd reassoc nsz <2 x float> %t1, %t2
  ret <2 x float> %r
}

; FIXME:
; Verify vector types, commuted operands, FMF propagation.

define <2 x float> @fmul_fadd_commute2_vec(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fmul_fadd_commute2_vec(
; CHECK-NEXT:    [[T1:%.*]] = fmul fast <2 x float> [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul nnan <2 x float> [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd reassoc ninf nsz <2 x float> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %t1 = fmul fast <2 x float> %x, %z
  %t2 = fmul nnan <2 x float> %z, %y
  %r = fadd reassoc nsz ninf <2 x float> %t1, %t2
  ret <2 x float> %r
}

; Verify different scalar type, commuted operands, FMF propagation.

define double @fmul_fadd_commute3(double %x, double %y, double %z) {
; CHECK-LABEL: @fmul_fadd_commute3(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nnan nsz double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nnan nsz double [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret double [[TMP2]]
;
  %t1 = fmul double %z, %x
  %t2 = fmul fast double %y, %z
  %r = fadd reassoc nsz nnan double %t1, %t2
  ret double %r
}

; Negative test - verify the fold is not done with only 'reassoc' ('nsz' is required).

define float @fmul_fadd_not_enough_FMF(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fadd_not_enough_FMF(
; CHECK-NEXT:    [[T1:%.*]] = fmul fast float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul fast float [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = fadd reassoc float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[R]]
;
  %t1 = fmul fast float %x, %z
  %t2 = fmul fast float %y, %z
  %r = fadd reassoc float %t1, %t2
  ret float %r
}

declare void @use(float)

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fmul_fadd_uses1(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fadd_uses1(
; CHECK-NEXT:    [[T1:%.*]] = fmul float [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %z, %x
  %t2 = fmul float %y, %z
  %r = fadd reassoc nsz float %t1, %t2
  call void @use(float %t1)
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fmul_fadd_uses2(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fadd_uses2(
; CHECK-NEXT:    [[T2:%.*]] = fmul float [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %z, %x
  %t2 = fmul float %z, %y
  %r = fadd reassoc nsz float %t1, %t2
  call void @use(float %t2)
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fmul_fadd_uses3(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fadd_uses3(
; CHECK-NEXT:    [[T1:%.*]] = fmul float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul float [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[X]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %x, %z
  %t2 = fmul float %z, %y
  %r = fadd reassoc nsz float %t1, %t2
  call void @use(float %t1)
  call void @use(float %t2)
  ret float %r
}

; Minimum FMF - the final result requires/propagates FMF.

define half @fmul_fsub(half %x, half %y, half %z) {
; CHECK-LABEL: @fmul_fsub(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nsz half [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz half [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret half [[TMP2]]
;
  %t1 = fmul half %x, %z
  %t2 = fmul half %y, %z
  %r = fsub reassoc nsz half %t1, %t2
  ret half %r
}

; FIXME:
; Verify vector types and commuted operands.

define <2 x float> @fmul_fsub_commute1_vec(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fmul_fsub_commute1_vec(
; CHECK-NEXT:    [[T1:%.*]] = fmul <2 x float> [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul <2 x float> [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = fsub reassoc nsz <2 x float> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %t1 = fmul <2 x float> %z, %x
  %t2 = fmul <2 x float> %y, %z
  %r = fsub reassoc nsz <2 x float> %t1, %t2
  ret <2 x float> %r
}

; FIXME:
; Verify vector types, commuted operands, FMF propagation.

define <2 x float> @fmul_fsub_commute2_vec(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fmul_fsub_commute2_vec(
; CHECK-NEXT:    [[T1:%.*]] = fmul fast <2 x float> [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul nnan <2 x float> [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub reassoc ninf nsz <2 x float> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %t1 = fmul fast <2 x float> %x, %z
  %t2 = fmul nnan <2 x float> %z, %y
  %r = fsub reassoc nsz ninf <2 x float> %t1, %t2
  ret <2 x float> %r
}

; Verify different scalar type, commuted operands, FMF propagation.

define double @fmul_fsub_commute3(double %x, double %y, double %z) {
; CHECK-LABEL: @fmul_fsub_commute3(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nnan nsz double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nnan nsz double [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret double [[TMP2]]
;
  %t1 = fmul double %z, %x
  %t2 = fmul fast double %z, %y
  %r = fsub reassoc nsz nnan double %t1, %t2
  ret double %r
}

; Negative test - verify the fold is not done with only 'nsz' ('reassoc' is required).

define float @fmul_fsub_not_enough_FMF(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fsub_not_enough_FMF(
; CHECK-NEXT:    [[T1:%.*]] = fmul fast float [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul fast float [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = fsub nsz float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[R]]
;
  %t1 = fmul fast float %z, %x
  %t2 = fmul fast float %y, %z
  %r = fsub nsz float %t1, %t2
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fmul_fsub_uses1(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fsub_uses1(
; CHECK-NEXT:    [[T1:%.*]] = fmul float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nsz float [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %x, %z
  %t2 = fmul float %y, %z
  %r = fsub reassoc nsz float %t1, %t2
  call void @use(float %t1)
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fmul_fsub_uses2(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fsub_uses2(
; CHECK-NEXT:    [[T2:%.*]] = fmul float [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nsz float [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %z, %x
  %t2 = fmul float %z, %y
  %r = fsub reassoc nsz float %t1, %t2
  call void @use(float %t2)
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fmul_fsub_uses3(float %x, float %y, float %z) {
; CHECK-LABEL: @fmul_fsub_uses3(
; CHECK-NEXT:    [[T1:%.*]] = fmul float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fmul float [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nsz float [[X]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc nsz float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fmul float %x, %z
  %t2 = fmul float %y, %z
  %r = fsub reassoc nsz float %t1, %t2
  call void @use(float %t1)
  call void @use(float %t2)
  ret float %r
}

; Common divisor

define double @fdiv_fadd(double %x, double %y, double %z) {
; CHECK-LABEL: @fdiv_fadd(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fdiv reassoc nsz double [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret double [[TMP2]]
;
  %t1 = fdiv double %x, %z
  %t2 = fdiv double %y, %z
  %r = fadd reassoc nsz double %t1, %t2
  ret double %r
}

define float @fdiv_fsub(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fsub(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub reassoc nsz float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fdiv reassoc nsz float [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fdiv fast float %x, %z
  %t2 = fdiv nnan float %y, %z
  %r = fsub reassoc nsz float %t1, %t2
  ret float %r
}

; FIXME:
; Verify vector types.

define <2 x double> @fdiv_fadd_vec(<2 x double> %x, <2 x double> %y, <2 x double> %z) {
; CHECK-LABEL: @fdiv_fadd_vec(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast <2 x double> [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv <2 x double> [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = fadd reassoc nsz <2 x double> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %t1 = fdiv fast <2 x double> %x, %z
  %t2 = fdiv <2 x double> %y, %z
  %r = fadd reassoc nsz <2 x double> %t1, %t2
  ret <2 x double> %r
}

; FIXME:
; Verify vector types.

define <2 x float> @fdiv_fsub_vec(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fdiv_fsub_vec(
; CHECK-NEXT:    [[T1:%.*]] = fdiv <2 x float> [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv nnan <2 x float> [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = fsub reassoc nsz <2 x float> [[T1]], [[T2]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %t1 = fdiv <2 x float> %x, %z
  %t2 = fdiv nnan <2 x float> %y, %z
  %r = fsub reassoc nsz <2 x float> %t1, %t2
  ret <2 x float> %r
}

; Negative test - common operand is not divisor.

define float @fdiv_fadd_commute1(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fadd_commute1(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float [[Z]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd fast float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[R]]
;
  %t1 = fdiv fast float %z, %y
  %t2 = fdiv fast float %z, %x
  %r = fadd fast float %t1, %t2
  ret float %r
}

; Negative test - common operand is not divisor.

define float @fdiv_fsub_commute2(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fsub_commute2(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float [[X:%.*]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = fsub fast float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[R]]
;
  %t1 = fdiv fast float %z, %y
  %t2 = fdiv fast float %x, %z
  %r = fsub fast float %t1, %t2
  ret float %r
}

; Negative test - verify the fold is not done with only 'nsz' ('reassoc' is required).

define float @fdiv_fadd_not_enough_FMF(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fadd_not_enough_FMF(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[T3:%.*]] = fadd nsz float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fdiv fast float %y, %x
  %t2 = fdiv fast float %z, %x
  %t3 = fadd nsz float %t1, %t2
  ret float %t3
}

; Negative test - verify the fold is not done with only 'reassoc' ('nsz' is required).

define float @fdiv_fsub_not_enough_FMF(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fsub_not_enough_FMF(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[T3:%.*]] = fsub reassoc float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fdiv fast float %y, %x
  %t2 = fdiv fast float %z, %x
  %t3 = fsub reassoc float %t1, %t2
  ret float %t3
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fdiv_fadd_uses1(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fadd_uses1(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd fast float [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fdiv fast float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fdiv fast float %x, %z
  %t2 = fdiv fast float %y, %z
  %r = fadd fast float %t1, %t2
  call void @use(float %t1)
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fdiv_fsub_uses2(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fsub_uses2(
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub fast float [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = fdiv fast float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fdiv fast float %x, %z
  %t2 = fdiv fast float %y, %z
  %r = fsub fast float %t1, %t2
  call void @use(float %t2)
  ret float %r
}

; FIXME:
; Negative test - extra uses should disable the fold.

define float @fdiv_fsub_uses3(float %x, float %y, float %z) {
; CHECK-LABEL: @fdiv_fsub_uses3(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub fast float [[X]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = fdiv fast float [[TMP1]], [[Z]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[TMP2]]
;
  %t1 = fdiv fast float %x, %z
  %t2 = fdiv fast float %y, %z
  %r = fsub fast float %t1, %t2
  call void @use(float %t1)
  call void @use(float %t2)
  ret float %r
}

; Constants are fine to combine if they are not denorms.

define float @fdiv_fadd_not_denorm(float %x) {
; CHECK-LABEL: @fdiv_fadd_not_denorm(
; CHECK-NEXT:    [[TMP1:%.*]] = fdiv fast float 0x3818000000000000, [[X:%.*]]
; CHECK-NEXT:    ret float [[TMP1]]
;
  %t1 = fdiv fast float 0x3810000000000000, %x
  %t2 = fdiv fast float 0x3800000000000000, %x
  %r = fadd fast float %t1, %t2
  ret float %r
}

; Negative test - disabled if x+y is denormal.

define float @fdiv_fadd_denorm(float %x) {
; CHECK-LABEL: @fdiv_fadd_denorm(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float 0xB810000000000000, [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float 0x3800000000000000, [[X]]
; CHECK-NEXT:    [[R:%.*]] = fadd fast float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[R]]
;
  %t1 = fdiv fast float 0xB810000000000000, %x
  %t2 = fdiv fast float 0x3800000000000000, %x
  %r = fadd fast float %t1, %t2
  ret float %r
}

; Negative test - disabled if x-y is denormal.

define float @fdiv_fsub_denorm(float %x) {
; CHECK-LABEL: @fdiv_fsub_denorm(
; CHECK-NEXT:    [[T1:%.*]] = fdiv fast float 0x3810000000000000, [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fdiv fast float 0x3800000000000000, [[X]]
; CHECK-NEXT:    [[R:%.*]] = fsub fast float [[T1]], [[T2]]
; CHECK-NEXT:    ret float [[R]]
;
  %t1 = fdiv fast float 0x3810000000000000, %x
  %t2 = fdiv fast float 0x3800000000000000, %x
  %r = fsub fast float %t1, %t2
  ret float %r
}

