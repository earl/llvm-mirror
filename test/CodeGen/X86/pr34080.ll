; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse2 -mcpu=x86-64 | FileCheck %s --check-prefix=SSE2-SCHEDULE
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse3 | FileCheck %s --check-prefix=SSE3
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse3 -mcpu=nocona | FileCheck %s --check-prefix=SSE3
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx -mcpu=sandybridge | FileCheck %s --check-prefix=AVX

define void @_Z1fe(x86_fp80 %z) local_unnamed_addr #0 {
; SSE2-LABEL: _Z1fe:
; SSE2:       ## %bb.0: ## %entry
; SSE2-NEXT:    pushq %rbp
; SSE2-NEXT:    .cfi_def_cfa_offset 16
; SSE2-NEXT:    .cfi_offset %rbp, -16
; SSE2-NEXT:    movq %rsp, %rbp
; SSE2-NEXT:    .cfi_def_cfa_register %rbp
; SSE2-NEXT:    fldt 16(%rbp)
; SSE2-NEXT:    fnstcw -4(%rbp)
; SSE2-NEXT:    movzwl -4(%rbp), %eax
; SSE2-NEXT:    movw $3199, -4(%rbp) ## imm = 0xC7F
; SSE2-NEXT:    fldcw -4(%rbp)
; SSE2-NEXT:    movw %ax, -4(%rbp)
; SSE2-NEXT:    fistl -8(%rbp)
; SSE2-NEXT:    fldcw -4(%rbp)
; SSE2-NEXT:    cvtsi2sdl -8(%rbp), %xmm0
; SSE2-NEXT:    movsd %xmm0, -64(%rbp)
; SSE2-NEXT:    movsd %xmm0, -32(%rbp)
; SSE2-NEXT:    fsubl -32(%rbp)
; SSE2-NEXT:    flds {{.*}}(%rip)
; SSE2-NEXT:    fmul %st(0), %st(1)
; SSE2-NEXT:    fnstcw -2(%rbp)
; SSE2-NEXT:    movzwl -2(%rbp), %eax
; SSE2-NEXT:    movw $3199, -2(%rbp) ## imm = 0xC7F
; SSE2-NEXT:    fldcw -2(%rbp)
; SSE2-NEXT:    movw %ax, -2(%rbp)
; SSE2-NEXT:    fxch %st(1)
; SSE2-NEXT:    fistl -12(%rbp)
; SSE2-NEXT:    fldcw -2(%rbp)
; SSE2-NEXT:    xorps %xmm0, %xmm0
; SSE2-NEXT:    cvtsi2sdl -12(%rbp), %xmm0
; SSE2-NEXT:    movsd %xmm0, -56(%rbp)
; SSE2-NEXT:    movsd %xmm0, -24(%rbp)
; SSE2-NEXT:    fsubl -24(%rbp)
; SSE2-NEXT:    fmulp %st(1)
; SSE2-NEXT:    fstpl -48(%rbp)
; SSE2-NEXT:    popq %rbp
; SSE2-NEXT:    retq
;
; SSE2-SCHEDULE-LABEL: _Z1fe:
; SSE2-SCHEDULE:       ## %bb.0: ## %entry
; SSE2-SCHEDULE-NEXT:    pushq %rbp
; SSE2-SCHEDULE-NEXT:    .cfi_def_cfa_offset 16
; SSE2-SCHEDULE-NEXT:    .cfi_offset %rbp, -16
; SSE2-SCHEDULE-NEXT:    movq %rsp, %rbp
; SSE2-SCHEDULE-NEXT:    .cfi_def_cfa_register %rbp
; SSE2-SCHEDULE-NEXT:    fnstcw -4(%rbp)
; SSE2-SCHEDULE-NEXT:    movzwl -4(%rbp), %eax
; SSE2-SCHEDULE-NEXT:    movw $3199, -4(%rbp) ## imm = 0xC7F
; SSE2-SCHEDULE-NEXT:    fldcw -4(%rbp)
; SSE2-SCHEDULE-NEXT:    fldt 16(%rbp)
; SSE2-SCHEDULE-NEXT:    movw %ax, -4(%rbp)
; SSE2-SCHEDULE-NEXT:    fistl -8(%rbp)
; SSE2-SCHEDULE-NEXT:    fldcw -4(%rbp)
; SSE2-SCHEDULE-NEXT:    cvtsi2sdl -8(%rbp), %xmm0
; SSE2-SCHEDULE-NEXT:    movsd %xmm0, -64(%rbp)
; SSE2-SCHEDULE-NEXT:    movsd %xmm0, -32(%rbp)
; SSE2-SCHEDULE-NEXT:    fsubl -32(%rbp)
; SSE2-SCHEDULE-NEXT:    fnstcw -2(%rbp)
; SSE2-SCHEDULE-NEXT:    flds {{.*}}(%rip)
; SSE2-SCHEDULE-NEXT:    movzwl -2(%rbp), %eax
; SSE2-SCHEDULE-NEXT:    movw $3199, -2(%rbp) ## imm = 0xC7F
; SSE2-SCHEDULE-NEXT:    fldcw -2(%rbp)
; SSE2-SCHEDULE-NEXT:    fmul %st(0), %st(1)
; SSE2-SCHEDULE-NEXT:    movw %ax, -2(%rbp)
; SSE2-SCHEDULE-NEXT:    fxch %st(1)
; SSE2-SCHEDULE-NEXT:    fistl -12(%rbp)
; SSE2-SCHEDULE-NEXT:    fldcw -2(%rbp)
; SSE2-SCHEDULE-NEXT:    xorps %xmm0, %xmm0
; SSE2-SCHEDULE-NEXT:    cvtsi2sdl -12(%rbp), %xmm0
; SSE2-SCHEDULE-NEXT:    movsd %xmm0, -56(%rbp)
; SSE2-SCHEDULE-NEXT:    movsd %xmm0, -24(%rbp)
; SSE2-SCHEDULE-NEXT:    fsubl -24(%rbp)
; SSE2-SCHEDULE-NEXT:    fmulp %st(1)
; SSE2-SCHEDULE-NEXT:    fstpl -48(%rbp)
; SSE2-SCHEDULE-NEXT:    popq %rbp
; SSE2-SCHEDULE-NEXT:    retq
;
; SSE3-LABEL: _Z1fe:
; SSE3:       ## %bb.0: ## %entry
; SSE3-NEXT:    pushq %rbp
; SSE3-NEXT:    .cfi_def_cfa_offset 16
; SSE3-NEXT:    .cfi_offset %rbp, -16
; SSE3-NEXT:    movq %rsp, %rbp
; SSE3-NEXT:    .cfi_def_cfa_register %rbp
; SSE3-NEXT:    fldt 16(%rbp)
; SSE3-NEXT:    fld %st(0)
; SSE3-NEXT:    fisttpl -4(%rbp)
; SSE3-NEXT:    cvtsi2sdl -4(%rbp), %xmm0
; SSE3-NEXT:    movsd %xmm0, -48(%rbp)
; SSE3-NEXT:    movsd %xmm0, -24(%rbp)
; SSE3-NEXT:    fsubl -24(%rbp)
; SSE3-NEXT:    flds {{.*}}(%rip)
; SSE3-NEXT:    fmul %st(0), %st(1)
; SSE3-NEXT:    fld %st(1)
; SSE3-NEXT:    fisttpl -8(%rbp)
; SSE3-NEXT:    xorps %xmm0, %xmm0
; SSE3-NEXT:    cvtsi2sdl -8(%rbp), %xmm0
; SSE3-NEXT:    movsd %xmm0, -40(%rbp)
; SSE3-NEXT:    movsd %xmm0, -16(%rbp)
; SSE3-NEXT:    fxch %st(1)
; SSE3-NEXT:    fsubl -16(%rbp)
; SSE3-NEXT:    fmulp %st(1)
; SSE3-NEXT:    fstpl -32(%rbp)
; SSE3-NEXT:    popq %rbp
; SSE3-NEXT:    retq
;
; AVX-LABEL: _Z1fe:
; AVX:       ## %bb.0: ## %entry
; AVX-NEXT:    pushq %rbp
; AVX-NEXT:    .cfi_def_cfa_offset 16
; AVX-NEXT:    .cfi_offset %rbp, -16
; AVX-NEXT:    movq %rsp, %rbp
; AVX-NEXT:    .cfi_def_cfa_register %rbp
; AVX-NEXT:    fldt 16(%rbp)
; AVX-NEXT:    fld %st(0)
; AVX-NEXT:    fisttpl -4(%rbp)
; AVX-NEXT:    vcvtsi2sdl -4(%rbp), %xmm0, %xmm0
; AVX-NEXT:    vmovsd %xmm0, -48(%rbp)
; AVX-NEXT:    vmovsd %xmm0, -24(%rbp)
; AVX-NEXT:    fsubl -24(%rbp)
; AVX-NEXT:    flds {{.*}}(%rip)
; AVX-NEXT:    fmul %st(0), %st(1)
; AVX-NEXT:    fld %st(1)
; AVX-NEXT:    fisttpl -8(%rbp)
; AVX-NEXT:    vcvtsi2sdl -8(%rbp), %xmm1, %xmm0
; AVX-NEXT:    vmovsd %xmm0, -40(%rbp)
; AVX-NEXT:    vmovsd %xmm0, -16(%rbp)
; AVX-NEXT:    fxch %st(1)
; AVX-NEXT:    fsubl -16(%rbp)
; AVX-NEXT:    fmulp %st(1)
; AVX-NEXT:    fstpl -32(%rbp)
; AVX-NEXT:    popq %rbp
; AVX-NEXT:    retq
entry:
  %tx = alloca [3 x double], align 16
  %0 = bitcast [3 x double]* %tx to i8*
  %conv = fptosi x86_fp80 %z to i32
  %conv1 = sitofp i32 %conv to double
  %arrayidx = getelementptr inbounds [3 x double], [3 x double]* %tx, i64 0, i64 0
  store double %conv1, double* %arrayidx, align 16
  %conv4 = fpext double %conv1 to x86_fp80
  %sub = fsub x86_fp80 %z, %conv4
  %mul = fmul x86_fp80 %sub, 0xK40178000000000000000
  %conv.1 = fptosi x86_fp80 %mul to i32
  %conv1.1 = sitofp i32 %conv.1 to double
  %arrayidx.1 = getelementptr inbounds [3 x double], [3 x double]* %tx, i64 0, i64 1
  store double %conv1.1, double* %arrayidx.1, align 8
  %conv4.1 = fpext double %conv1.1 to x86_fp80
  %sub.1 = fsub x86_fp80 %mul, %conv4.1
  %mul.1 = fmul x86_fp80 %sub.1, 0xK40178000000000000000
  %conv5 = fptrunc x86_fp80 %mul.1 to double
  %arrayidx6 = getelementptr inbounds [3 x double], [3 x double]* %tx, i64 0, i64 2
  store double %conv5, double* %arrayidx6, align 16
  ret void
}

attributes #0 = { noinline uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
