; RUN: opt -mtriple=x86_64-- -O0 -debug-pass=Structure < %s -o /dev/null 2>&1 | FileCheck %s

; REQUIRES: asserts

; CHECK-LABEL: Pass Arguments:
; CHECK-NEXT: Target Transform Information
; CHECK-NEXT:   FunctionPass Manager
; CHECK-NEXT:     Module Verifier
; CHECK-NEXT:     Instrument function entry/exit with calls to e.g. mcount() (pre inlining)
; CHECK-NEXT: Pass Arguments:
; CHECK-NEXT: Target Library Information
; CHECK-NEXT: Target Transform Information
; CHECK-NEXT: Target Pass Configuration
; CHECK-NEXT: Assumption Cache Tracker
; CHECK-NEXT: Profile summary info
; CHECK-NEXT:   ModulePass Manager
; CHECK-NEXT:     Force set function attributes
; CHECK-NEXT:     CallGraph Construction
; CHECK-NEXT:     Call Graph SCC Pass Manager
; CHECK-NEXT:       Inliner for always_inline functions
; CHECK-NEXT:       FunctionPass Manager
; CHECK-NEXT:         Module Verifier
; CHECK-NEXT:     Bitcode Writer

define void @f() {
  ret void
}
