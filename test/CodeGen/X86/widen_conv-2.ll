; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X64

; sign extension v2i16 to v2i32

define void @convert_v2i16_v2i32(<2 x i32>* %dst.addr, <2 x i16> %src) nounwind {
; X86-LABEL: convert_v2i16_v2i32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    psllq $48, %xmm0
; X86-NEXT:    psrad $16, %xmm0
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; X86-NEXT:    movq %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: convert_v2i16_v2i32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    psllq $48, %xmm0
; X64-NEXT:    psrad $16, %xmm0
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; X64-NEXT:    movq %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
	%signext = sext <2 x i16> %src to <2 x i32>		; <<12 x i8>> [#uses=1]
	store <2 x i32> %signext, <2 x i32>* %dst.addr
	ret void
}
