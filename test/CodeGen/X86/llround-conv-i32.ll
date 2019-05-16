; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown             | FileCheck %s
; RUN: llc < %s -mtriple=i686-unknown -mattr=sse2 | FileCheck %s --check-prefix=SSE2

define i64 @testmsxs_builtin(float %x) {
; CHECK-LABEL: testmsxs_builtin:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fstps (%esp)
; CHECK-NEXT:    calll llroundf
; CHECK-NEXT:    popl %ecx
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
;
; SSE2-LABEL: testmsxs_builtin:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    pushl %eax
; SSE2-NEXT:    .cfi_def_cfa_offset 8
; SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2-NEXT:    movss %xmm0, (%esp)
; SSE2-NEXT:    calll llroundf
; SSE2-NEXT:    popl %ecx
; SSE2-NEXT:    .cfi_def_cfa_offset 4
; SSE2-NEXT:    retl
entry:
  %0 = tail call i64 @llvm.llround.f32(float %x)
  ret i64 %0
}

define i64 @testmsxd_builtin(double %x) {
; CHECK-LABEL: testmsxd_builtin:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    fldl {{[0-9]+}}(%esp)
; CHECK-NEXT:    fstpl (%esp)
; CHECK-NEXT:    calll llround
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
;
; SSE2-LABEL: testmsxd_builtin:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    subl $8, %esp
; SSE2-NEXT:    .cfi_def_cfa_offset 12
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movsd %xmm0, (%esp)
; SSE2-NEXT:    calll llround
; SSE2-NEXT:    addl $8, %esp
; SSE2-NEXT:    .cfi_def_cfa_offset 4
; SSE2-NEXT:    retl
entry:
  %0 = tail call i64 @llvm.llround.f64(double %x)
  ret i64 %0
}

declare i64 @llvm.llround.f32(float) nounwind readnone
declare i64 @llvm.llround.f64(double) nounwind readnone
