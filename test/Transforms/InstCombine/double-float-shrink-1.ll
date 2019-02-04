; RUN: opt < %s -instcombine -S -mtriple x86_64-unknown-linux-gnu | FileCheck %s --check-prefixes=CHECK,LINUX,LIN64
; RUN: opt < %s -instcombine -S -mtriple x86_64-pc-win32          | FileCheck %s --check-prefixes=CHECK,WIN64,WIN96,LIN64
; RUN: opt < %s -instcombine -S -mtriple i386-pc-win32            | FileCheck %s --check-prefixes=CHECK,WIN32,WIN96

; Check for and against shrinkage when using the
; unsafe-fp-math function attribute on a math lib
; function. This optimization may be overridden by
; the -enable-double-float-shrink option.
; PR17850: http://llvm.org/bugs/show_bug.cgi?id=17850

define float @acos_test1(float %f)   {
; CHECK-LABEL: @acos_test1(
; LIN64-NEXT:    [[ACOSF:%.*]] = call fast float @acosf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[ACOSF]]
; WIN32:         [[ACOSF:%.*]] = call fast double @acos(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @acos(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @acos_test2(float %f)   {
; CHECK-LABEL: @acos_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @acos(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @acos(double %conv)
  ret double %call
}

define float @acosh_test1(float %f)   {
; CHECK-LABEL: @acosh_test1(
; LINUX-NEXT:    [[ACOSHF:%.*]] = call fast float @acoshf(float [[F:%.*]])
; LINUX-NEXT:    ret float [[ACOSHF]]
; WIN96:         [[ACOSHF:%.*]] = call fast double @acosh(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @acosh(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @acosh_test2(float %f)   {
; CHECK-LABEL: @acosh_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @acosh(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @acosh(double %conv)
  ret double %call
}

define float @asin_test1(float %f)   {
; CHECK-LABEL: @asin_test1(
; LIN64-NEXT:    [[ASINF:%.*]] = call fast float @asinf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[ASINF]]
; WIN32:         [[ASINF:%.*]] = call fast double @asin(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @asin(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @asin_test2(float %f)   {
; CHECK-LABEL: @asin_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @asin(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @asin(double %conv)
  ret double %call
}

define float @asinh_test1(float %f)   {
; CHECK-LABEL: @asinh_test1(
; LINUX-NEXT:   [[ASINHF:%.*]] = call fast float @asinhf(float [[F:%.*]])
; LINUX-NEXT:   ret float [[ASINHF]]
; WIN96:        [[ASINHF:%.*]] = call fast double @asinh(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @asinh(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @asinh_test2(float %f)   {
; CHECK-LABEL: @asinh_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @asinh(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @asinh(double %conv)
  ret double %call
}

define float @atan_test1(float %f)   {
; CHECK-LABEL: @atan_test1(
; LIN64-NEXT:    [[ATANF:%.*]] = call fast float @atanf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[ATANF]]
; WIN32:         [[ATANF:%.*]] = call fast double @atan(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @atan(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @atan_test2(float %f)   {
; CHECK-LABEL: @atan_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @atan(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @atan(double %conv)
  ret double %call
}

define float @atanh_test1(float %f)   {
; CHECK-LABEL: @atanh_test1(
; LINUX-NEXT:    [[ATANHF:%.*]] = call fast float @atanhf(float [[F:%.*]])
; LINUX-NEXT:    ret float [[ATANHF]]
; WIN96:         [[ATANHF:%.*]] = call fast double @atanh(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @atanh(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @atanh_test2(float %f)   {
; CHECK-LABEL: @atanh_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @atanh(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @atanh(double %conv)
  ret double %call
}

define float @cbrt_test1(float %f)   {
; CHECK-LABEL: @cbrt_test1(
; LINUX-NEXT:    [[CBRTF:%.*]] = call fast float @cbrtf(float [[F:%.*]])
; LINUX-NEXT:    ret float [[CBRTF]]
; WIN96:         [[CBRTF:%.*]] = call fast double @cbrt(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @cbrt(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @cbrt_test2(float %f)   {
; CHECK-LABEL: @cbrt_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @cbrt(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast  double @cbrt(double %conv)
  ret double %call
}

define float @exp_test1(float %f)   {
; CHECK-LABEL: @exp_test1(
; LIN64-NEXT:    [[EXPF:%.*]] = call fast float @expf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[EXPF]]
; WIN32:         [[EXPF:%.*]] = call fast double @exp(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @exp(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @exp_test2(float %f)   {
; CHECK-LABEL: @exp_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @exp(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @exp(double %conv)
  ret double %call
}

define float @expm1_test1(float %f)   {
; CHECK-LABEL: @expm1_test1(
; LINUX-NEXT:    [[EXPM1F:%.*]] = call fast float @expm1f(float [[F:%.*]])
; LINUX-NEXT:    ret float [[EXPM1F]]
; WIN96:         [[EXPM1F:%.*]] = call fast double @expm1(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @expm1(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @expm1_test2(float %f)   {
; CHECK-LABEL: @expm1_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @expm1(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @expm1(double %conv)
  ret double %call
}

; exp10f() doesn't exist for this triple, so it doesn't shrink.

define float @exp10_test1(float %f)   {
; CHECK-LABEL: @exp10_test1(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @exp10(double [[CONV]])
; CHECK-NEXT:    [[CONV1:%.*]] = fptrunc double [[CALL]] to float
; CHECK-NEXT:    ret float [[CONV1]]
;
  %conv = fpext float %f to double
  %call = call fast double @exp10(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @exp10_test2(float %f)   {
; CHECK-LABEL: @exp10_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @exp10(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @exp10(double %conv)
  ret double %call
}

define float @log_test1(float %f)   {
; CHECK-LABEL: @log_test1(
; LIN64-NEXT:    [[LOGF:%.*]] = call fast float @logf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[LOGF]]
; WIN32:         [[LOGF:%.*]] = call fast double @log(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @log(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @log_test2(float %f)   {
; CHECK-LABEL: @log_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @log(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @log(double %conv)
  ret double %call
}

define float @log10_test1(float %f)   {
; CHECK-LABEL: @log10_test1(
; LIN64-NEXT:    [[LOG10F:%.*]] = call fast float @log10f(float [[F:%.*]])
; LIN64-NEXT:    ret float [[LOG10F]]
; WIN32:         [[LOG10F:%.*]] = call fast double @log10(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @log10(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @log10_test2(float %f) {
; CHECK-LABEL: @log10_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @log10(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @log10(double %conv)
  ret double %call
}

define float @log1p_test1(float %f)   {
; CHECK-LABEL: @log1p_test1(
; LINUX-NEXT:    [[LOG1PF:%.*]] = call fast float @log1pf(float [[F:%.*]])
; LINUX-NEXT:    ret float [[LOG1PF]]
; WIN96:         [[LOG1PF:%.*]] = call fast double @log1p(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @log1p(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @log1p_test2(float %f)   {
; CHECK-LABEL: @log1p_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @log1p(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @log1p(double %conv)
  ret double %call
}

define float @log2_test1(float %f)   {
; CHECK-LABEL: @log2_test1(
; LINUX-NEXT:    [[LOG2F:%.*]] = call fast float @log2f(float [[F:%.*]])
; LINUX-NEXT:     ret float [[LOG2F]]
; WIN96:         [[LOG2F:%.*]] = call fast double @log2(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @log2(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @log2_test2(float %f)   {
; CHECK-LABEL: @log2_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @log2(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @log2(double %conv)
  ret double %call
}

define float @logb_test1(float %f)   {
; CHECK-LABEL: @logb_test1(
; LIN64-NEXT:    [[LOGBF:%.*]] = call fast float @logbf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[LOGBF]]
; WIN32:         [[LOGBF:%.*]] = call fast double @logb(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @logb(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @logb_test2(float %f)   {
; CHECK-LABEL: @logb_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @logb(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @logb(double %conv)
  ret double %call
}

define float @pow_test1(float %f, float %g)   {
; CHECK-LABEL: @pow_test1(
; LIN64-NEXT:    [[POWF:%.*]] = call fast float @powf(float %f, float %g)
; LIN64-NEXT:    ret float [[POWF]]
; WIN32:         [[POWF:%.*]] = call fast double @pow(double %df, double %dg)
;
  %df = fpext float %f to double
  %dg = fpext float %g to double
  %call = call fast double @pow(double %df, double %dg)
  %fr = fptrunc double %call to float
  ret float %fr
}

define double @pow_test2(float %f, float %g) {
; CHECK-LABEL: @pow_test2(
; CHECK:         [[POW:%.*]] = call fast double @pow(double %df, double %dg)
; CHECK-NEXT:    ret double [[POW]]
;
  %df = fpext float %f to double
  %dg = fpext float %g to double
  %call = call fast double @pow(double %df, double %dg)
  ret double %call
}

define float @sin_test1(float %f)   {
; CHECK-LABEL: @sin_test1(
; LIN64-NEXT:    [[SINF:%.*]] = call fast float @sinf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[SINF]]
; WIN32:         [[SINF:%.*]] = call fast double @sin(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @sin(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @sin_test2(float %f) {
; CHECK-LABEL: @sin_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @sin(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @sin(double %conv)
  ret double %call
}

define float @sqrt_test1(float %f) {
; CHECK-LABEL: @sqrt_test1(
; LIN64-NEXT:    [[SQRTF:%.*]] = call float @sqrtf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[SQRTF]]
; WIN32:         [[SQRTF:%.*]] = call double @sqrt(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call double @sqrt(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @sqrt_test2(float %f) {
; CHECK-LABEL: @sqrt_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call double @sqrt(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call double @sqrt(double %conv)
  ret double %call
}

define float @sqrt_int_test1(float %f) {
; CHECK-LABEL: @sqrt_int_test1(
; LIN64-NEXT:    [[TMP1:%.*]] = call float @llvm.sqrt.f32(float [[F:%.*]])
; LIN64-NEXT:    ret float [[TMP1]]
; WIN32:         [[TMP1:%.*]] = call double @llvm.sqrt.f64(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call double @llvm.sqrt.f64(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @sqrt_int_test2(float %f) {
; CHECK-LABEL: @sqrt_int_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call double @llvm.sqrt.f64(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call double @llvm.sqrt.f64(double %conv)
  ret double %call
}

define float @tan_test1(float %f) {
; CHECK-LABEL: @tan_test1(
; LIN64-NEXT:    [[TANF:%.*]] = call fast float @tanf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[TANF]]
; WIN32:         [[TANF:%.*]] = call fast double @tan(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @tan(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @tan_test2(float %f) {
; CHECK-LABEL: @tan_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @tan(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @tan(double %conv)
  ret double %call
}
define float @tanh_test1(float %f) {
; CHECK-LABEL: @tanh_test1(
; LIN64-NEXT:    [[TANHF:%.*]] = call fast float @tanhf(float [[F:%.*]])
; LIN64-NEXT:    ret float [[TANHF]]
; WIN32:         [[TANHF:%.*]] = call fast double @tanh(double [[F:%.*]])
;
  %conv = fpext float %f to double
  %call = call fast double @tanh(double %conv)
  %conv1 = fptrunc double %call to float
  ret float %conv1
}

define double @tanh_test2(float %f) {
; CHECK-LABEL: @tanh_test2(
; CHECK-NEXT:    [[CONV:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @tanh(double [[CONV]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %conv = fpext float %f to double
  %call = call fast double @tanh(double %conv)
  ret double %call
}

; 'arcp' on an fmax() is meaningless. This test just proves that
; flags are propagated for shrunken *binary* double FP calls.
define float @max1(float %a, float %b) {
; CHECK-LABEL: @max1(
; LINUX-NEXT:    [[FMAXF:%.*]] = call arcp float @fmaxf(float [[A:%.*]], float [[B:%.*]])
; LINUX-NEXT:    ret float [[FMAXF]]
; WIN96:         [[FMAXF:%.*]] = call arcp double @fmax(double [[A:%.*]], double [[B:%.*]])
;
  %c = fpext float %a to double
  %d = fpext float %b to double
  %e = call arcp double @fmax(double %c, double %d)
  %f = fptrunc double %e to float
  ret float %f
}

; A function can have a name that matches a common libcall,
; but with the wrong type(s). Let it be.

define float @fake_fmin(float %a, float %b) {
; CHECK-LABEL: @fake_fmin(
; CHECK-NEXT:    [[C:%.*]] = fpext float [[A:%.*]] to fp128
; CHECK-NEXT:    [[D:%.*]] = fpext float [[B:%.*]] to fp128
; CHECK-NEXT:    [[E:%.*]] = call fp128 @fmin(fp128 [[C]], fp128 [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc fp128 [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %c = fpext float %a to fp128
  %d = fpext float %b to fp128
  %e = call fp128 @fmin(fp128 %c, fp128 %d)
  %f = fptrunc fp128 %e to float
  ret float %f
}

declare fp128 @fmin(fp128, fp128) ; This is not the 'fmin' you're looking for.

declare double @fmax(double, double)

declare double @tanh(double)
declare double @tan(double)

; sqrt is a special case: the shrinking optimization
; is valid even without unsafe-fp-math.
declare double @sqrt(double)
declare double @llvm.sqrt.f64(double)

declare double @sin(double)
declare double @pow(double, double)
declare double @log2(double)
declare double @log1p(double)
declare double @log10(double)
declare double @log(double)
declare double @logb(double)
declare double @exp10(double)
declare double @expm1(double)
declare double @exp(double)
declare double @cbrt(double)
declare double @atanh(double)
declare double @atan(double)
declare double @acos(double)
declare double @acosh(double)
declare double @asin(double)
declare double @asinh(double)

