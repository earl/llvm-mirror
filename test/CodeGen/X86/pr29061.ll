; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple i386-unknown-linux-gnu < %s | FileCheck %s

; Previously, a reference to SIL/DIL was being emitted
; but those aren't available unless on a 64bit mode

define void @t1(i8 signext %c) {
; CHECK-LABEL: t1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    .cfi_offset %edi, -8
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %edi
; CHECK-NEXT:    # kill: %di<def> %di<kill> %edi<kill>
; CHECK-NEXT:    #APP
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
entry:
  tail call void asm sideeffect "", "{di},~{dirflag},~{fpsr},~{flags}"(i8 %c)
  ret void
}

define void @t2(i8 signext %c) {
; CHECK-LABEL: t2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    .cfi_offset %esi, -8
; CHECK-NEXT:    movzbl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    # kill: %si<def> %si<kill> %esi<kill>
; CHECK-NEXT:    #APP
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
entry:
  tail call void asm sideeffect "", "{si},~{dirflag},~{fpsr},~{flags}"(i8 %c)
  ret void
}

