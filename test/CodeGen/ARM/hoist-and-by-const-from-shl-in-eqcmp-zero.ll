; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv6 < %s | FileCheck %s --check-prefixes=CHECK,ARM,ARM6
; RUN: llc -mtriple=armv7 < %s | FileCheck %s --check-prefixes=CHECK,ARM,ARM78,ARM7
; RUN: llc -mtriple=armv8a < %s | FileCheck %s --check-prefixes=CHECK,ARM,ARM78,ARM8
; RUN: llc -mtriple=thumbv6 < %s | FileCheck %s --check-prefixes=CHECK,THUMB,THUMB6
; RUN: llc -mtriple=thumbv7 < %s | FileCheck %s --check-prefixes=CHECK,THUMB,THUMB78,THUMB7
; RUN: llc -mtriple=thumbv8-eabi < %s | FileCheck %s --check-prefixes=CHECK,THUMB,THUMB78,THUMB8

; We are looking for the following pattern here:
;   (X & (C << Y)) ==/!= 0
; It may be optimal to hoist the constant:
;   ((X l>> Y) & C) ==/!= 0

;------------------------------------------------------------------------------;
; A few scalar test
;------------------------------------------------------------------------------;

; i8 scalar

define i1 @scalar_i8_signbit_eq(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_signbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mvn r2, #127
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    uxtb r0, r0
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #127
; THUMB6-NEXT:    mvns r2, r2
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxtb r1, r2
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    mvn r2, #127
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxtb r0, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_lowestbit_eq(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_lowestbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mov r2, #1
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    uxtb r0, r0
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxtb r1, r2
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    movs r2, #1
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxtb r0, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i8 1, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_bitsinmiddle_eq(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_bitsinmiddle_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mov r2, #24
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    uxtb r0, r0
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #24
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxtb r1, r2
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    movs r2, #24
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxtb r0, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i8 24, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

; i16 scalar

define i1 @scalar_i16_signbit_eq(i16 %x, i16 %y) nounwind {
; ARM6-LABEL: scalar_i16_signbit_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldr r2, .LCPI3_0
; ARM6-NEXT:    uxth r1, r1
; ARM6-NEXT:    and r0, r0, r2, lsl r1
; ARM6-NEXT:    uxth r0, r0
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    bx lr
; ARM6-NEXT:    .p2align 2
; ARM6-NEXT:  @ %bb.1:
; ARM6-NEXT:  .LCPI3_0:
; ARM6-NEXT:    .long 4294934528 @ 0xffff8000
;
; ARM78-LABEL: scalar_i16_signbit_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    movw r2, #32768
; ARM78-NEXT:    uxth r1, r1
; ARM78-NEXT:    movt r2, #65535
; ARM78-NEXT:    and r0, r0, r2, lsl r1
; ARM78-NEXT:    uxth r0, r0
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxth r1, r1
; THUMB6-NEXT:    ldr r2, .LCPI3_0
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxth r1, r2
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI3_0:
; THUMB6-NEXT:    .long 4294934528 @ 0xffff8000
;
; THUMB78-LABEL: scalar_i16_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    movw r2, #32768
; THUMB78-NEXT:    uxth r1, r1
; THUMB78-NEXT:    movt r2, #65535
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxth r0, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i16 32768, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

define i1 @scalar_i16_lowestbit_eq(i16 %x, i16 %y) nounwind {
; ARM-LABEL: scalar_i16_lowestbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxth r1, r1
; ARM-NEXT:    mov r2, #1
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    uxth r0, r0
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxth r1, r1
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxth r1, r2
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i16_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxth r1, r1
; THUMB78-NEXT:    movs r2, #1
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxth r0, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i16 1, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

define i1 @scalar_i16_bitsinmiddle_eq(i16 %x, i16 %y) nounwind {
; ARM-LABEL: scalar_i16_bitsinmiddle_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxth r1, r1
; ARM-NEXT:    mov r2, #4080
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    uxth r0, r0
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxth r1, r1
; THUMB6-NEXT:    movs r2, #255
; THUMB6-NEXT:    lsls r2, r2, #4
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxth r1, r2
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i16_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxth r1, r1
; THUMB78-NEXT:    mov.w r2, #4080
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxth r0, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i16 4080, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

; i32 scalar

define i1 @scalar_i32_signbit_eq(i32 %x, i32 %y) nounwind {
; ARM-LABEL: scalar_i32_signbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    mov r2, #-2147483648
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    lsls r2, r2, #31
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    rsbs r0, r2, #0
; THUMB6-NEXT:    adcs r0, r2
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i32_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    mov.w r2, #-2147483648
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i32 2147483648, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i32_lowestbit_eq(i32 %x, i32 %y) nounwind {
; ARM-LABEL: scalar_i32_lowestbit_eq:
; ARM:       @ %bb.0:
; ARM-NEXT:    mov r2, #1
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    rsbs r0, r2, #0
; THUMB6-NEXT:    adcs r0, r2
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i32_lowestbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    movs r2, #1
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i32 1, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i32_bitsinmiddle_eq(i32 %x, i32 %y) nounwind {
; ARM6-LABEL: scalar_i32_bitsinmiddle_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    mov r2, #65280
; ARM6-NEXT:    orr r2, r2, #16711680
; ARM6-NEXT:    and r0, r0, r2, lsl r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: scalar_i32_bitsinmiddle_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    movw r2, #65280
; ARM78-NEXT:    movt r2, #255
; ARM78-NEXT:    and r0, r0, r2, lsl r1
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    ldr r2, .LCPI8_0
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    rsbs r0, r2, #0
; THUMB6-NEXT:    adcs r0, r2
; THUMB6-NEXT:    bx lr
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI8_0:
; THUMB6-NEXT:    .long 16776960 @ 0xffff00
;
; THUMB78-LABEL: scalar_i32_bitsinmiddle_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    movw r2, #65280
; THUMB78-NEXT:    movt r2, #255
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i32 16776960, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

; i64 scalar

define i1 @scalar_i64_signbit_eq(i64 %x, i64 %y) nounwind {
; ARM6-LABEL: scalar_i64_signbit_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    mov r0, #-2147483648
; ARM6-NEXT:    lsl r0, r0, r2
; ARM6-NEXT:    sub r2, r2, #32
; ARM6-NEXT:    cmp r2, #0
; ARM6-NEXT:    movge r0, #0
; ARM6-NEXT:    and r0, r0, r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: scalar_i64_signbit_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    mov r0, #-2147483648
; ARM78-NEXT:    lsl r0, r0, r2
; ARM78-NEXT:    sub r2, r2, #32
; ARM78-NEXT:    cmp r2, #0
; ARM78-NEXT:    movwge r0, #0
; ARM78-NEXT:    and r0, r0, r1
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i64_signbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    mov r4, r1
; THUMB6-NEXT:    mov r5, r0
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    lsls r1, r0, #31
; THUMB6-NEXT:    movs r0, #0
; THUMB6-NEXT:    bl __ashldi3
; THUMB6-NEXT:    ands r1, r4
; THUMB6-NEXT:    ands r0, r5
; THUMB6-NEXT:    orrs r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB78-LABEL: scalar_i64_signbit_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    mov.w r0, #-2147483648
; THUMB78-NEXT:    lsls r0, r2
; THUMB78-NEXT:    subs r2, #32
; THUMB78-NEXT:    cmp r2, #0
; THUMB78-NEXT:    it ge
; THUMB78-NEXT:    movge r0, #0
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i64 9223372036854775808, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

define i1 @scalar_i64_lowestbit_eq(i64 %x, i64 %y) nounwind {
; ARM6-LABEL: scalar_i64_lowestbit_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    mov r12, #1
; ARM6-NEXT:    sub lr, r2, #32
; ARM6-NEXT:    lsl r3, r12, r2
; ARM6-NEXT:    rsb r2, r2, #32
; ARM6-NEXT:    cmp lr, #0
; ARM6-NEXT:    lsr r2, r12, r2
; ARM6-NEXT:    movge r3, #0
; ARM6-NEXT:    lslge r2, r12, lr
; ARM6-NEXT:    and r0, r3, r0
; ARM6-NEXT:    and r1, r2, r1
; ARM6-NEXT:    orr r0, r0, r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: scalar_i64_lowestbit_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    push {r11, lr}
; ARM78-NEXT:    mov r12, #1
; ARM78-NEXT:    sub lr, r2, #32
; ARM78-NEXT:    lsl r3, r12, r2
; ARM78-NEXT:    rsb r2, r2, #32
; ARM78-NEXT:    cmp lr, #0
; ARM78-NEXT:    lsr r2, r12, r2
; ARM78-NEXT:    movwge r3, #0
; ARM78-NEXT:    lslge r2, r12, lr
; ARM78-NEXT:    and r0, r3, r0
; ARM78-NEXT:    and r1, r2, r1
; ARM78-NEXT:    orr r0, r0, r1
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    pop {r11, pc}
;
; THUMB6-LABEL: scalar_i64_lowestbit_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    mov r4, r1
; THUMB6-NEXT:    mov r5, r0
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    movs r1, #0
; THUMB6-NEXT:    bl __ashldi3
; THUMB6-NEXT:    ands r1, r4
; THUMB6-NEXT:    ands r0, r5
; THUMB6-NEXT:    orrs r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB7-LABEL: scalar_i64_lowestbit_eq:
; THUMB7:       @ %bb.0:
; THUMB7-NEXT:    push {r7, lr}
; THUMB7-NEXT:    rsb.w r3, r2, #32
; THUMB7-NEXT:    mov.w r12, #1
; THUMB7-NEXT:    sub.w lr, r2, #32
; THUMB7-NEXT:    lsl.w r2, r12, r2
; THUMB7-NEXT:    lsr.w r3, r12, r3
; THUMB7-NEXT:    cmp.w lr, #0
; THUMB7-NEXT:    it ge
; THUMB7-NEXT:    lslge.w r3, r12, lr
; THUMB7-NEXT:    it ge
; THUMB7-NEXT:    movge r2, #0
; THUMB7-NEXT:    ands r1, r3
; THUMB7-NEXT:    ands r0, r2
; THUMB7-NEXT:    orrs r0, r1
; THUMB7-NEXT:    clz r0, r0
; THUMB7-NEXT:    lsrs r0, r0, #5
; THUMB7-NEXT:    pop {r7, pc}
;
; THUMB8-LABEL: scalar_i64_lowestbit_eq:
; THUMB8:       @ %bb.0:
; THUMB8-NEXT:    .save {r7, lr}
; THUMB8-NEXT:    push {r7, lr}
; THUMB8-NEXT:    rsb.w r3, r2, #32
; THUMB8-NEXT:    sub.w lr, r2, #32
; THUMB8-NEXT:    mov.w r12, #1
; THUMB8-NEXT:    cmp.w lr, #0
; THUMB8-NEXT:    lsr.w r3, r12, r3
; THUMB8-NEXT:    lsl.w r2, r12, r2
; THUMB8-NEXT:    it ge
; THUMB8-NEXT:    lslge.w r3, r12, lr
; THUMB8-NEXT:    it ge
; THUMB8-NEXT:    movge r2, #0
; THUMB8-NEXT:    ands r1, r3
; THUMB8-NEXT:    ands r0, r2
; THUMB8-NEXT:    orrs r0, r1
; THUMB8-NEXT:    clz r0, r0
; THUMB8-NEXT:    lsrs r0, r0, #5
; THUMB8-NEXT:    pop {r7, pc}
  %t0 = shl i64 1, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

define i1 @scalar_i64_bitsinmiddle_eq(i64 %x, i64 %y) nounwind {
; ARM6-LABEL: scalar_i64_bitsinmiddle_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r4, lr}
; ARM6-NEXT:    mov r12, #16711680
; ARM6-NEXT:    sub lr, r2, #32
; ARM6-NEXT:    orr r12, r12, #-16777216
; ARM6-NEXT:    cmp lr, #0
; ARM6-NEXT:    mov r4, #255
; ARM6-NEXT:    lsl r3, r12, r2
; ARM6-NEXT:    orr r4, r4, #65280
; ARM6-NEXT:    movge r3, #0
; ARM6-NEXT:    and r0, r3, r0
; ARM6-NEXT:    rsb r3, r2, #32
; ARM6-NEXT:    cmp lr, #0
; ARM6-NEXT:    lsr r3, r12, r3
; ARM6-NEXT:    orr r2, r3, r4, lsl r2
; ARM6-NEXT:    lslge r2, r12, lr
; ARM6-NEXT:    and r1, r2, r1
; ARM6-NEXT:    orr r0, r0, r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    pop {r4, pc}
;
; ARM78-LABEL: scalar_i64_bitsinmiddle_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    push {r4, lr}
; ARM78-NEXT:    movw r12, #0
; ARM78-NEXT:    sub lr, r2, #32
; ARM78-NEXT:    movt r12, #65535
; ARM78-NEXT:    cmp lr, #0
; ARM78-NEXT:    lsl r3, r12, r2
; ARM78-NEXT:    movw r4, #65535
; ARM78-NEXT:    movwge r3, #0
; ARM78-NEXT:    and r0, r3, r0
; ARM78-NEXT:    rsb r3, r2, #32
; ARM78-NEXT:    cmp lr, #0
; ARM78-NEXT:    lsr r3, r12, r3
; ARM78-NEXT:    orr r2, r3, r4, lsl r2
; ARM78-NEXT:    lslge r2, r12, lr
; ARM78-NEXT:    and r1, r2, r1
; ARM78-NEXT:    orr r0, r0, r1
; ARM78-NEXT:    clz r0, r0
; ARM78-NEXT:    lsr r0, r0, #5
; ARM78-NEXT:    pop {r4, pc}
;
; THUMB6-LABEL: scalar_i64_bitsinmiddle_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    mov r4, r1
; THUMB6-NEXT:    mov r5, r0
; THUMB6-NEXT:    ldr r0, .LCPI11_0
; THUMB6-NEXT:    ldr r1, .LCPI11_1
; THUMB6-NEXT:    bl __ashldi3
; THUMB6-NEXT:    ands r1, r4
; THUMB6-NEXT:    ands r0, r5
; THUMB6-NEXT:    orrs r0, r1
; THUMB6-NEXT:    rsbs r1, r0, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI11_0:
; THUMB6-NEXT:    .long 4294901760 @ 0xffff0000
; THUMB6-NEXT:  .LCPI11_1:
; THUMB6-NEXT:    .long 65535 @ 0xffff
;
; THUMB7-LABEL: scalar_i64_bitsinmiddle_eq:
; THUMB7:       @ %bb.0:
; THUMB7-NEXT:    push {r7, lr}
; THUMB7-NEXT:    movw r3, #65535
; THUMB7-NEXT:    movw lr, #0
; THUMB7-NEXT:    lsl.w r12, r3, r2
; THUMB7-NEXT:    rsb.w r3, r2, #32
; THUMB7-NEXT:    movt lr, #65535
; THUMB7-NEXT:    lsr.w r3, lr, r3
; THUMB7-NEXT:    orr.w r3, r3, r12
; THUMB7-NEXT:    sub.w r12, r2, #32
; THUMB7-NEXT:    lsl.w r2, lr, r2
; THUMB7-NEXT:    cmp.w r12, #0
; THUMB7-NEXT:    it ge
; THUMB7-NEXT:    lslge.w r3, lr, r12
; THUMB7-NEXT:    it ge
; THUMB7-NEXT:    movge r2, #0
; THUMB7-NEXT:    ands r1, r3
; THUMB7-NEXT:    ands r0, r2
; THUMB7-NEXT:    orrs r0, r1
; THUMB7-NEXT:    clz r0, r0
; THUMB7-NEXT:    lsrs r0, r0, #5
; THUMB7-NEXT:    pop {r7, pc}
;
; THUMB8-LABEL: scalar_i64_bitsinmiddle_eq:
; THUMB8:       @ %bb.0:
; THUMB8-NEXT:    .save {r7, lr}
; THUMB8-NEXT:    push {r7, lr}
; THUMB8-NEXT:    movw r3, #65535
; THUMB8-NEXT:    movw lr, #0
; THUMB8-NEXT:    lsl.w r12, r3, r2
; THUMB8-NEXT:    rsb.w r3, r2, #32
; THUMB8-NEXT:    movt lr, #65535
; THUMB8-NEXT:    lsr.w r3, lr, r3
; THUMB8-NEXT:    orr.w r3, r3, r12
; THUMB8-NEXT:    sub.w r12, r2, #32
; THUMB8-NEXT:    cmp.w r12, #0
; THUMB8-NEXT:    lsl.w r2, lr, r2
; THUMB8-NEXT:    it ge
; THUMB8-NEXT:    lslge.w r3, lr, r12
; THUMB8-NEXT:    it ge
; THUMB8-NEXT:    movge r2, #0
; THUMB8-NEXT:    ands r1, r3
; THUMB8-NEXT:    ands r0, r2
; THUMB8-NEXT:    orrs r0, r1
; THUMB8-NEXT:    clz r0, r0
; THUMB8-NEXT:    lsrs r0, r0, #5
; THUMB8-NEXT:    pop {r7, pc}
  %t0 = shl i64 281474976645120, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

;------------------------------------------------------------------------------;
; A few trivial vector tests
;------------------------------------------------------------------------------;

define <4 x i1> @vec_4xi32_splat_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_splat_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    and r0, r0, lr, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #12]
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    and r1, r1, lr, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #16]
; ARM6-NEXT:    clz r1, r1
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    and r2, r2, lr, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #20]
; ARM6-NEXT:    clz r2, r2
; ARM6-NEXT:    lsr r1, r1, #5
; ARM6-NEXT:    and r3, r3, lr, lsl r12
; ARM6-NEXT:    lsr r2, r2, #5
; ARM6-NEXT:    clz r3, r3
; ARM6-NEXT:    lsr r3, r3, #5
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_splat_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov.i32 q8, #0x1
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12]
; ARM78-NEXT:    vshl.u32 q8, q8, q9
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_splat_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r6, lr}
; THUMB6-NEXT:    ldr r5, [sp, #16]
; THUMB6-NEXT:    movs r4, #1
; THUMB6-NEXT:    mov r6, r4
; THUMB6-NEXT:    lsls r6, r5
; THUMB6-NEXT:    ands r6, r0
; THUMB6-NEXT:    rsbs r0, r6, #0
; THUMB6-NEXT:    adcs r0, r6
; THUMB6-NEXT:    ldr r5, [sp, #20]
; THUMB6-NEXT:    mov r6, r4
; THUMB6-NEXT:    lsls r6, r5
; THUMB6-NEXT:    ands r6, r1
; THUMB6-NEXT:    rsbs r1, r6, #0
; THUMB6-NEXT:    adcs r1, r6
; THUMB6-NEXT:    ldr r5, [sp, #24]
; THUMB6-NEXT:    mov r6, r4
; THUMB6-NEXT:    lsls r6, r5
; THUMB6-NEXT:    ands r6, r2
; THUMB6-NEXT:    rsbs r2, r6, #0
; THUMB6-NEXT:    adcs r2, r6
; THUMB6-NEXT:    ldr r5, [sp, #28]
; THUMB6-NEXT:    lsls r4, r5
; THUMB6-NEXT:    ands r4, r3
; THUMB6-NEXT:    rsbs r3, r4, #0
; THUMB6-NEXT:    adcs r3, r4
; THUMB6-NEXT:    pop {r4, r5, r6, pc}
;
; THUMB78-LABEL: vec_4xi32_splat_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov.i32 q8, #0x1
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12]
; THUMB78-NEXT:    vshl.u32 q8, q8, q9
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = shl <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}

define <4 x i1> @vec_4xi32_nonsplat_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldr r12, [sp, #4]
; ARM6-NEXT:    mov r0, #1
; ARM6-NEXT:    and r0, r1, r0, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r1, r0, #5
; ARM6-NEXT:    mov r0, #65280
; ARM6-NEXT:    orr r0, r0, #16711680
; ARM6-NEXT:    and r0, r2, r0, lsl r12
; ARM6-NEXT:    ldr r12, [sp, #12]
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r2, r0, #5
; ARM6-NEXT:    mov r0, #-2147483648
; ARM6-NEXT:    and r0, r3, r0, lsl r12
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    lsr r3, r0, #5
; ARM6-NEXT:    mov r0, #1
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: vec_4xi32_nonsplat_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d16, d17}, [r12]
; ARM78-NEXT:    adr r12, .LCPI13_0
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12:128]
; ARM78-NEXT:    vshl.u32 q8, q9, q8
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
; ARM78-NEXT:    .p2align 4
; ARM78-NEXT:  @ %bb.1:
; ARM78-NEXT:  .LCPI13_0:
; ARM78-NEXT:    .long 0 @ 0x0
; ARM78-NEXT:    .long 1 @ 0x1
; ARM78-NEXT:    .long 16776960 @ 0xffff00
; ARM78-NEXT:    .long 2147483648 @ 0x80000000
;
; THUMB6-LABEL: vec_4xi32_nonsplat_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    mov r5, r0
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r1
; THUMB6-NEXT:    rsbs r1, r5, #0
; THUMB6-NEXT:    adcs r1, r5
; THUMB6-NEXT:    ldr r4, [sp, #24]
; THUMB6-NEXT:    ldr r5, .LCPI13_0
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r2
; THUMB6-NEXT:    rsbs r2, r5, #0
; THUMB6-NEXT:    adcs r2, r5
; THUMB6-NEXT:    lsls r4, r0, #31
; THUMB6-NEXT:    ldr r5, [sp, #28]
; THUMB6-NEXT:    lsls r4, r5
; THUMB6-NEXT:    ands r4, r3
; THUMB6-NEXT:    rsbs r3, r4, #0
; THUMB6-NEXT:    adcs r3, r4
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
; THUMB6-NEXT:    .p2align 2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:  .LCPI13_0:
; THUMB6-NEXT:    .long 16776960 @ 0xffff00
;
; THUMB78-LABEL: vec_4xi32_nonsplat_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d16, d17}, [r12]
; THUMB78-NEXT:    adr.w r12, .LCPI13_0
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12:128]
; THUMB78-NEXT:    vshl.u32 q8, q9, q8
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
; THUMB78-NEXT:    .p2align 4
; THUMB78-NEXT:  @ %bb.1:
; THUMB78-NEXT:  .LCPI13_0:
; THUMB78-NEXT:    .long 0 @ 0x0
; THUMB78-NEXT:    .long 1 @ 0x1
; THUMB78-NEXT:    .long 16776960 @ 0xffff00
; THUMB78-NEXT:    .long 2147483648 @ 0x80000000
  %t0 = shl <4 x i32> <i32 0, i32 1, i32 16776960, i32 2147483648>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}

define <4 x i1> @vec_4xi32_nonsplat_undef0_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_undef0_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r2, [sp, #12]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    and r1, r1, lr, lsl r2
; ARM6-NEXT:    ldr r2, [sp, #20]
; ARM6-NEXT:    and r0, r0, lr, lsl r12
; ARM6-NEXT:    clz r1, r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    and r2, r3, lr, lsl r2
; ARM6-NEXT:    lsr r1, r1, #5
; ARM6-NEXT:    clz r2, r2
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    lsr r3, r2, #5
; ARM6-NEXT:    mov r2, #1
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_nonsplat_undef0_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov.i32 q8, #0x1
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12]
; ARM78-NEXT:    vshl.u32 q8, q8, q9
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_nonsplat_undef0_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    ldr r4, [sp, #16]
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r0
; THUMB6-NEXT:    rsbs r0, r5, #0
; THUMB6-NEXT:    adcs r0, r5
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r1
; THUMB6-NEXT:    rsbs r1, r5, #0
; THUMB6-NEXT:    adcs r1, r5
; THUMB6-NEXT:    ldr r4, [sp, #28]
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r3
; THUMB6-NEXT:    rsbs r3, r5, #0
; THUMB6-NEXT:    adcs r3, r5
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB78-LABEL: vec_4xi32_nonsplat_undef0_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov.i32 q8, #0x1
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12]
; THUMB78-NEXT:    vshl.u32 q8, q8, q9
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = shl <4 x i32> <i32 1, i32 1, i32 undef, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}
define <4 x i1> @vec_4xi32_nonsplat_undef1_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_undef1_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r2, [sp, #12]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    and r1, r1, lr, lsl r2
; ARM6-NEXT:    ldr r2, [sp, #20]
; ARM6-NEXT:    and r0, r0, lr, lsl r12
; ARM6-NEXT:    clz r1, r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    and r2, r3, lr, lsl r2
; ARM6-NEXT:    lsr r1, r1, #5
; ARM6-NEXT:    clz r2, r2
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    lsr r3, r2, #5
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_nonsplat_undef1_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov.i32 q8, #0x1
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12]
; ARM78-NEXT:    vshl.u32 q8, q8, q9
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_nonsplat_undef1_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    ldr r4, [sp, #16]
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r0
; THUMB6-NEXT:    rsbs r0, r5, #0
; THUMB6-NEXT:    adcs r0, r5
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r1
; THUMB6-NEXT:    rsbs r1, r5, #0
; THUMB6-NEXT:    adcs r1, r5
; THUMB6-NEXT:    ldr r4, [sp, #28]
; THUMB6-NEXT:    lsls r2, r4
; THUMB6-NEXT:    ands r2, r3
; THUMB6-NEXT:    rsbs r3, r2, #0
; THUMB6-NEXT:    adcs r3, r2
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB78-LABEL: vec_4xi32_nonsplat_undef1_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov.i32 q8, #0x1
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12]
; THUMB78-NEXT:    vshl.u32 q8, q8, q9
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = shl <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %res
}
define <4 x i1> @vec_4xi32_nonsplat_undef2_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vec_4xi32_nonsplat_undef2_eq:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr r2, [sp, #12]
; ARM6-NEXT:    mov lr, #1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    and r1, r1, lr, lsl r2
; ARM6-NEXT:    ldr r2, [sp, #20]
; ARM6-NEXT:    and r0, r0, lr, lsl r12
; ARM6-NEXT:    clz r1, r1
; ARM6-NEXT:    clz r0, r0
; ARM6-NEXT:    and r2, r3, lr, lsl r2
; ARM6-NEXT:    lsr r1, r1, #5
; ARM6-NEXT:    clz r2, r2
; ARM6-NEXT:    lsr r0, r0, #5
; ARM6-NEXT:    lsr r3, r2, #5
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vec_4xi32_nonsplat_undef2_eq:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov.i32 q8, #0x1
; ARM78-NEXT:    mov r12, sp
; ARM78-NEXT:    vld1.64 {d18, d19}, [r12]
; ARM78-NEXT:    vshl.u32 q8, q8, q9
; ARM78-NEXT:    vmov d19, r2, r3
; ARM78-NEXT:    vmov d18, r0, r1
; ARM78-NEXT:    vtst.32 q8, q8, q9
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vmovn.i32 d16, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vec_4xi32_nonsplat_undef2_eq:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    ldr r4, [sp, #16]
; THUMB6-NEXT:    movs r2, #1
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r0
; THUMB6-NEXT:    rsbs r0, r5, #0
; THUMB6-NEXT:    adcs r0, r5
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    mov r5, r2
; THUMB6-NEXT:    lsls r5, r4
; THUMB6-NEXT:    ands r5, r1
; THUMB6-NEXT:    rsbs r1, r5, #0
; THUMB6-NEXT:    adcs r1, r5
; THUMB6-NEXT:    ldr r4, [sp, #28]
; THUMB6-NEXT:    lsls r2, r4
; THUMB6-NEXT:    ands r2, r3
; THUMB6-NEXT:    rsbs r3, r2, #0
; THUMB6-NEXT:    adcs r3, r2
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB78-LABEL: vec_4xi32_nonsplat_undef2_eq:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov.i32 q8, #0x1
; THUMB78-NEXT:    mov r12, sp
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r12]
; THUMB78-NEXT:    vshl.u32 q8, q8, q9
; THUMB78-NEXT:    vmov d19, r2, r3
; THUMB78-NEXT:    vmov d18, r0, r1
; THUMB78-NEXT:    vtst.32 q8, q8, q9
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vmovn.i32 d16, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    bx lr
  %t0 = shl <4 x i32> <i32 1, i32 1, i32 undef, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %res
}

;------------------------------------------------------------------------------;
; A special tests
;------------------------------------------------------------------------------;

define i1 @scalar_i8_signbit_ne(i8 %x, i8 %y) nounwind {
; ARM6-LABEL: scalar_i8_signbit_ne:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    uxtb r1, r1
; ARM6-NEXT:    mvn r2, #127
; ARM6-NEXT:    and r0, r0, r2, lsl r1
; ARM6-NEXT:    uxtb r0, r0
; ARM6-NEXT:    cmp r0, #0
; ARM6-NEXT:    movne r0, #1
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: scalar_i8_signbit_ne:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    uxtb r1, r1
; ARM78-NEXT:    mvn r2, #127
; ARM78-NEXT:    and r0, r0, r2, lsl r1
; ARM78-NEXT:    uxtb r0, r0
; ARM78-NEXT:    cmp r0, #0
; ARM78-NEXT:    movwne r0, #1
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_signbit_ne:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #127
; THUMB6-NEXT:    mvns r2, r2
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxtb r0, r2
; THUMB6-NEXT:    subs r1, r0, #1
; THUMB6-NEXT:    sbcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_signbit_ne:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    mvn r2, #127
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    uxtb r0, r0
; THUMB78-NEXT:    cmp r0, #0
; THUMB78-NEXT:    it ne
; THUMB78-NEXT:    movne r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = shl i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp ne i8 %t1, 0 ;  we are perfectly happy with 'ne' predicate
  ret i1 %res
}

;------------------------------------------------------------------------------;
; A few negative tests
;------------------------------------------------------------------------------;

define i1 @negative_scalar_i8_bitsinmiddle_slt(i8 %x, i8 %y) nounwind {
; ARM6-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    uxtb r1, r1
; ARM6-NEXT:    mov r2, #24
; ARM6-NEXT:    and r0, r0, r2, lsl r1
; ARM6-NEXT:    sxtb r1, r0
; ARM6-NEXT:    mov r0, #0
; ARM6-NEXT:    cmp r1, #0
; ARM6-NEXT:    movlt r0, #1
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    uxtb r1, r1
; ARM78-NEXT:    mov r2, #24
; ARM78-NEXT:    and r0, r0, r2, lsl r1
; ARM78-NEXT:    sxtb r1, r0
; ARM78-NEXT:    mov r0, #0
; ARM78-NEXT:    cmp r1, #0
; ARM78-NEXT:    movwlt r0, #1
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #24
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    sxtb r0, r2
; THUMB6-NEXT:    cmp r0, #0
; THUMB6-NEXT:    blt .LBB18_2
; THUMB6-NEXT:  @ %bb.1:
; THUMB6-NEXT:    movs r0, #0
; THUMB6-NEXT:    bx lr
; THUMB6-NEXT:  .LBB18_2:
; THUMB6-NEXT:    movs r0, #1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: negative_scalar_i8_bitsinmiddle_slt:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    movs r2, #24
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    sxtb r1, r0
; THUMB78-NEXT:    movs r0, #0
; THUMB78-NEXT:    cmp r1, #0
; THUMB78-NEXT:    it lt
; THUMB78-NEXT:    movlt r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = shl i8 24, %y
  %t1 = and i8 %t0, %x
  %res = icmp slt i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_signbit_eq_with_nonzero(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8_signbit_eq_with_nonzero:
; ARM:       @ %bb.0:
; ARM-NEXT:    uxtb r1, r1
; ARM-NEXT:    mvn r2, #127
; ARM-NEXT:    and r0, r0, r2, lsl r1
; ARM-NEXT:    mvn r1, #0
; ARM-NEXT:    uxtab r0, r1, r0
; ARM-NEXT:    clz r0, r0
; ARM-NEXT:    lsr r0, r0, #5
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8_signbit_eq_with_nonzero:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    uxtb r1, r1
; THUMB6-NEXT:    movs r2, #127
; THUMB6-NEXT:    mvns r2, r2
; THUMB6-NEXT:    lsls r2, r1
; THUMB6-NEXT:    ands r2, r0
; THUMB6-NEXT:    uxtb r0, r2
; THUMB6-NEXT:    subs r1, r0, #1
; THUMB6-NEXT:    rsbs r0, r1, #0
; THUMB6-NEXT:    adcs r0, r1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8_signbit_eq_with_nonzero:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    uxtb r1, r1
; THUMB78-NEXT:    mvn r2, #127
; THUMB78-NEXT:    lsl.w r1, r2, r1
; THUMB78-NEXT:    ands r0, r1
; THUMB78-NEXT:    mov.w r1, #-1
; THUMB78-NEXT:    uxtab r0, r1, r0
; THUMB78-NEXT:    clz r0, r0
; THUMB78-NEXT:    lsrs r0, r0, #5
; THUMB78-NEXT:    bx lr
  %t0 = shl i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 1 ; should be comparing with 0
  ret i1 %res
}
