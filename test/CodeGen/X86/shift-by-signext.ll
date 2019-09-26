; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+bmi,+bmi2,+sse,+sse2,+avx,+avx2 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+bmi,+bmi2,+sse,+sse2,+avx,+avx2 | FileCheck %s --check-prefixes=CHECK,X64

; If we have a shift by sign-extended value, we can replace sign-extension
; with zero-extension.

define i32 @t0_shl(i32 %x, i8 %shamt) nounwind {
; X86-LABEL: t0_shl:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlxl %eax, {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: t0_shl:
; X64:       # %bb.0:
; X64-NEXT:    shlxl %esi, %edi, %eax
; X64-NEXT:    retq
  %shamt_wide = sext i8 %shamt to i32
  %r = shl i32 %x, %shamt_wide
  ret i32 %r
}
define i32 @t1_lshr(i32 %x, i8 %shamt) nounwind {
; X86-LABEL: t1_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shrxl %eax, {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: t1_lshr:
; X64:       # %bb.0:
; X64-NEXT:    shrxl %esi, %edi, %eax
; X64-NEXT:    retq
  %shamt_wide = sext i8 %shamt to i32
  %r = lshr i32 %x, %shamt_wide
  ret i32 %r
}
define i32 @t2_ashr(i32 %x, i8 %shamt) nounwind {
; X86-LABEL: t2_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    sarxl %eax, {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: t2_ashr:
; X64:       # %bb.0:
; X64-NEXT:    sarxl %esi, %edi, %eax
; X64-NEXT:    retq
  %shamt_wide = sext i8 %shamt to i32
  %r = ashr i32 %x, %shamt_wide
  ret i32 %r
}

define <4 x i32> @t3_vec_shl(<4 x i32> %x, <4 x i8> %shamt) nounwind {
; CHECK-LABEL: t3_vec_shl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbd %xmm1, %xmm1
; CHECK-NEXT:    vpsllvd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %shamt_wide = sext <4 x i8> %shamt to <4 x i32>
  %r = shl <4 x i32> %x, %shamt_wide
  ret <4 x i32> %r
}
define <4 x i32> @t4_vec_lshr(<4 x i32> %x, <4 x i8> %shamt) nounwind {
; CHECK-LABEL: t4_vec_lshr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbd %xmm1, %xmm1
; CHECK-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %shamt_wide = sext <4 x i8> %shamt to <4 x i32>
  %r = lshr <4 x i32> %x, %shamt_wide
  ret <4 x i32> %r
}
define <4 x i32> @t5_vec_ashr(<4 x i32> %x, <4 x i8> %shamt) nounwind {
; CHECK-LABEL: t5_vec_ashr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbd %xmm1, %xmm1
; CHECK-NEXT:    vpsravd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %shamt_wide = sext <4 x i8> %shamt to <4 x i32>
  %r = ashr <4 x i32> %x, %shamt_wide
  ret <4 x i32> %r
}

; This is not valid for funnel shifts
declare i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 %c)
declare i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 %c)
define i32 @n6_fshl(i32 %x, i32 %y, i8 %shamt) nounwind {
; X86-LABEL: n6_fshl:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n6_fshl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shldl %cl, %esi, %eax
; X64-NEXT:    retq
  %shamt_wide = sext i8 %shamt to i32
  %r = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %shamt_wide)
  ret i32 %r
}
define i32 @n7_fshr(i32 %x, i32 %y, i8 %shamt) nounwind {
; X86-LABEL: n7_fshr:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n7_fshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrdl %cl, %edi, %eax
; X64-NEXT:    retq
  %shamt_wide = sext i8 %shamt to i32
  %r = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %shamt_wide)
  ret i32 %r
}

define i32 @n8_extrause(i32 %x, i8 %shamt, i32* %shamt_wide_store) nounwind {
; X86-LABEL: n8_extrause:
; X86:       # %bb.0:
; X86-NEXT:    movsbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    shlxl %eax, {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: n8_extrause:
; X64:       # %bb.0:
; X64-NEXT:    movsbl %sil, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    shlxl %eax, %edi, %eax
; X64-NEXT:    retq
  %shamt_wide = sext i8 %shamt to i32
  store i32 %shamt_wide, i32* %shamt_wide_store, align 4
  %r = shl i32 %x, %shamt_wide
  ret i32 %r
}
