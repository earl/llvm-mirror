; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv6-unknown-linux-gnu | FileCheck %s

%umul.ty = type { i32, i1 }

define i32 @test1(i32 %a, i1 %x) nounwind {
; CHECK-LABEL: test1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    mov r5, r1
; CHECK-NEXT:    movs r2, #37
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    mov r1, r4
; CHECK-NEXT:    mov r3, r4
; CHECK-NEXT:    bl __muldi3
; CHECK-NEXT:    lsls r1, r5, #31
; CHECK-NEXT:    beq .LBB0_2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:    mvns r0, r4
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    pop {r4, r5, r7, pc}
  %tmp0 = tail call %umul.ty @llvm.umul.with.overflow.i32(i32 %a, i32 37)
  %tmp1 = extractvalue %umul.ty %tmp0, 0
  %tmp2 = select i1 %x, i32 -1, i32 %tmp1
  ret i32 %tmp2
}

declare %umul.ty @llvm.umul.with.overflow.i32(i32, i32) nounwind readnone

define i32 @test2(i32* %m_degree) ssp {
; CHECK-LABEL: test2:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    movs r2, #8
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    mov r1, r4
; CHECK-NEXT:    mov r3, r4
; CHECK-NEXT:    bl __muldi3
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    beq .LBB1_2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:    movs r1, #1
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    cmp r1, #0
; CHECK-NEXT:    beq .LBB1_4
; CHECK-NEXT:  @ %bb.3:
; CHECK-NEXT:    mvns r0, r4
; CHECK-NEXT:  .LBB1_4:
; CHECK-NEXT:    bl _Znam
; CHECK-NEXT:    mov r0, r4
; CHECK-NEXT:    pop {r4, pc}
%val = load i32, i32* %m_degree, align 4
%res = call %umul.ty @llvm.umul.with.overflow.i32(i32 %val, i32 8)
%ov = extractvalue %umul.ty %res, 1
%mul = extractvalue %umul.ty %res, 0
%sel = select i1 %ov, i32 -1, i32 %mul
%ret = call noalias i8* @_Znam(i32 %sel)
ret i32 0
}

declare noalias i8* @_Znam(i32)
