; RUN: llc < %s -march=nvptx 2>&1 | FileCheck %s
; Allow to make libcalls that are defined in the current module

; Underlying libcall declaration
; CHECK: .visible .func  (.param .align 16 .b8 func_retval0[16]) __umodti3

define i128 @remainder(i128, i128) {
bb0:
  ; CHECK:      { // callseq 0, 0
  ; CHECK:      call.uni (retval0),
  ; CHECK-NEXT: __umodti3,
  ; CHECK-NEXT: (
  ; CHECK-NEXT: param0,
  ; CHECK-NEXT: param1
  ; CHECK-NEXT: );
  ; CHECK-NEXT: ld.param.v2.b64 {%[[REG0:rd[0-9]+]], %[[REG1:rd[0-9]+]]}, [retval0+0];
  ; CHECK-NEXT: } // callseq 0
  %a = urem i128 %0, %1
  br label %bb1

bb1:
  ; CHECK-NEXT: st.param.v2.b64 [func_retval0+0], {%[[REG0]], %[[REG1]]};
  ; CHECK-NEXT: ret;
  ret i128 %a
}

; Underlying libcall definition
; CHECK: .visible .func  (.param .align 16 .b8 func_retval0[16]) __umodti3(
define i128 @__umodti3(i128, i128) {
  ret i128 0
}
