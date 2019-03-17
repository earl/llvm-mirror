; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

; There are at least 3 potential patterns corresponding to an unsigned saturated add: min, cmp with sum, cmp with not.
; Test each of those patterns with i8/i16/i32/i64.
; Test each of those with a constant operand and a variable operand.
; Test each of those with a 128-bit vector type.

define i8 @unsigned_sat_constant_i8_using_min(i8 %x) {
; CHECK-LABEL: unsigned_sat_constant_i8_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xff
; CHECK-NEXT:    cmp w8, #213 // =213
; CHECK-NEXT:    mov w8, #-43
; CHECK-NEXT:    csel w8, w0, w8, lo
; CHECK-NEXT:    add w0, w8, #42 // =42
; CHECK-NEXT:    ret
  %c = icmp ult i8 %x, -43
  %s = select i1 %c, i8 %x, i8 -43
  %r = add i8 %s, 42
  ret i8 %r
}

define i8 @unsigned_sat_constant_i8_using_cmp_sum(i8 %x) {
; CHECK-LABEL: unsigned_sat_constant_i8_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xff
; CHECK-NEXT:    add w8, w8, #42 // =42
; CHECK-NEXT:    tst w8, #0x100
; CHECK-NEXT:    csinv w0, w8, wzr, eq
; CHECK-NEXT:    ret
  %a = add i8 %x, 42
  %c = icmp ugt i8 %x, %a
  %r = select i1 %c, i8 -1, i8 %a
  ret i8 %r
}

define i8 @unsigned_sat_constant_i8_using_cmp_notval(i8 %x) {
; CHECK-LABEL: unsigned_sat_constant_i8_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xff
; CHECK-NEXT:    add w9, w0, #42 // =42
; CHECK-NEXT:    cmp w8, #213 // =213
; CHECK-NEXT:    csinv w0, w9, wzr, ls
; CHECK-NEXT:    ret
  %a = add i8 %x, 42
  %c = icmp ugt i8 %x, -43
  %r = select i1 %c, i8 -1, i8 %a
  ret i8 %r
}

define i16 @unsigned_sat_constant_i16_using_min(i16 %x) {
; CHECK-LABEL: unsigned_sat_constant_i16_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #65493
; CHECK-NEXT:    cmp w8, w0, uxth
; CHECK-NEXT:    mov w8, #-43
; CHECK-NEXT:    csel w8, w0, w8, hi
; CHECK-NEXT:    add w0, w8, #42 // =42
; CHECK-NEXT:    ret
  %c = icmp ult i16 %x, -43
  %s = select i1 %c, i16 %x, i16 -43
  %r = add i16 %s, 42
  ret i16 %r
}

define i16 @unsigned_sat_constant_i16_using_cmp_sum(i16 %x) {
; CHECK-LABEL: unsigned_sat_constant_i16_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xffff
; CHECK-NEXT:    add w8, w8, #42 // =42
; CHECK-NEXT:    tst w8, #0x10000
; CHECK-NEXT:    csinv w0, w8, wzr, eq
; CHECK-NEXT:    ret
  %a = add i16 %x, 42
  %c = icmp ugt i16 %x, %a
  %r = select i1 %c, i16 -1, i16 %a
  ret i16 %r
}

define i16 @unsigned_sat_constant_i16_using_cmp_notval(i16 %x) {
; CHECK-LABEL: unsigned_sat_constant_i16_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #65493
; CHECK-NEXT:    add w8, w0, #42 // =42
; CHECK-NEXT:    cmp w9, w0, uxth
; CHECK-NEXT:    csinv w0, w8, wzr, hs
; CHECK-NEXT:    ret
  %a = add i16 %x, 42
  %c = icmp ugt i16 %x, -43
  %r = select i1 %c, i16 -1, i16 %a
  ret i16 %r
}

define i32 @unsigned_sat_constant_i32_using_min(i32 %x) {
; CHECK-LABEL: unsigned_sat_constant_i32_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmn w0, #43 // =43
; CHECK-NEXT:    mov w8, #-43
; CHECK-NEXT:    csel w8, w0, w8, lo
; CHECK-NEXT:    add w0, w8, #42 // =42
; CHECK-NEXT:    ret
  %c = icmp ult i32 %x, -43
  %s = select i1 %c, i32 %x, i32 -43
  %r = add i32 %s, 42
  ret i32 %r
}

define i32 @unsigned_sat_constant_i32_using_cmp_sum(i32 %x) {
; CHECK-LABEL: unsigned_sat_constant_i32_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds w8, w0, #42 // =42
; CHECK-NEXT:    csinv w0, w8, wzr, lo
; CHECK-NEXT:    ret
  %a = add i32 %x, 42
  %c = icmp ugt i32 %x, %a
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i32 @unsigned_sat_constant_i32_using_cmp_notval(i32 %x) {
; CHECK-LABEL: unsigned_sat_constant_i32_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds w8, w0, #42 // =42
; CHECK-NEXT:    csinv w0, w8, wzr, lo
; CHECK-NEXT:    ret
  %a = add i32 %x, 42
  %c = icmp ugt i32 %x, -43
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i64 @unsigned_sat_constant_i64_using_min(i64 %x) {
; CHECK-LABEL: unsigned_sat_constant_i64_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmn x0, #43 // =43
; CHECK-NEXT:    mov x8, #-43
; CHECK-NEXT:    csel x8, x0, x8, lo
; CHECK-NEXT:    add x0, x8, #42 // =42
; CHECK-NEXT:    ret
  %c = icmp ult i64 %x, -43
  %s = select i1 %c, i64 %x, i64 -43
  %r = add i64 %s, 42
  ret i64 %r
}

define i64 @unsigned_sat_constant_i64_using_cmp_sum(i64 %x) {
; CHECK-LABEL: unsigned_sat_constant_i64_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x8, x0, #42 // =42
; CHECK-NEXT:    csinv x0, x8, xzr, lo
; CHECK-NEXT:    ret
  %a = add i64 %x, 42
  %c = icmp ugt i64 %x, %a
  %r = select i1 %c, i64 -1, i64 %a
  ret i64 %r
}

define i64 @unsigned_sat_constant_i64_using_cmp_notval(i64 %x) {
; CHECK-LABEL: unsigned_sat_constant_i64_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x8, x0, #42 // =42
; CHECK-NEXT:    csinv x0, x8, xzr, lo
; CHECK-NEXT:    ret
  %a = add i64 %x, 42
  %c = icmp ugt i64 %x, -43
  %r = select i1 %c, i64 -1, i64 %a
  ret i64 %r
}

define i8 @unsigned_sat_variable_i8_using_min(i8 %x, i8 %y) {
; CHECK-LABEL: unsigned_sat_variable_i8_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xff
; CHECK-NEXT:    mvn w9, w1
; CHECK-NEXT:    cmp w8, w9, uxtb
; CHECK-NEXT:    csinv w8, w0, w1, lo
; CHECK-NEXT:    add w0, w8, w1
; CHECK-NEXT:    ret
  %noty = xor i8 %y, -1
  %c = icmp ult i8 %x, %noty
  %s = select i1 %c, i8 %x, i8 %noty
  %r = add i8 %s, %y
  ret i8 %r
}

define i8 @unsigned_sat_variable_i8_using_cmp_sum(i8 %x, i8 %y) {
; CHECK-LABEL: unsigned_sat_variable_i8_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xff
; CHECK-NEXT:    add w8, w8, w1, uxtb
; CHECK-NEXT:    tst w8, #0x100
; CHECK-NEXT:    csinv w0, w8, wzr, eq
; CHECK-NEXT:    ret
  %a = add i8 %x, %y
  %c = icmp ugt i8 %x, %a
  %r = select i1 %c, i8 -1, i8 %a
  ret i8 %r
}

define i8 @unsigned_sat_variable_i8_using_cmp_notval(i8 %x, i8 %y) {
; CHECK-LABEL: unsigned_sat_variable_i8_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xff
; CHECK-NEXT:    mvn w9, w1
; CHECK-NEXT:    add w10, w0, w1
; CHECK-NEXT:    cmp w8, w9, uxtb
; CHECK-NEXT:    csinv w0, w10, wzr, ls
; CHECK-NEXT:    ret
  %noty = xor i8 %y, -1
  %a = add i8 %x, %y
  %c = icmp ugt i8 %x, %noty
  %r = select i1 %c, i8 -1, i8 %a
  ret i8 %r
}

define i16 @unsigned_sat_variable_i16_using_min(i16 %x, i16 %y) {
; CHECK-LABEL: unsigned_sat_variable_i16_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xffff
; CHECK-NEXT:    mvn w9, w1
; CHECK-NEXT:    cmp w8, w9, uxth
; CHECK-NEXT:    csinv w8, w0, w1, lo
; CHECK-NEXT:    add w0, w8, w1
; CHECK-NEXT:    ret
  %noty = xor i16 %y, -1
  %c = icmp ult i16 %x, %noty
  %s = select i1 %c, i16 %x, i16 %noty
  %r = add i16 %s, %y
  ret i16 %r
}

define i16 @unsigned_sat_variable_i16_using_cmp_sum(i16 %x, i16 %y) {
; CHECK-LABEL: unsigned_sat_variable_i16_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xffff
; CHECK-NEXT:    add w8, w8, w1, uxth
; CHECK-NEXT:    tst w8, #0x10000
; CHECK-NEXT:    csinv w0, w8, wzr, eq
; CHECK-NEXT:    ret
  %a = add i16 %x, %y
  %c = icmp ugt i16 %x, %a
  %r = select i1 %c, i16 -1, i16 %a
  ret i16 %r
}

define i16 @unsigned_sat_variable_i16_using_cmp_notval(i16 %x, i16 %y) {
; CHECK-LABEL: unsigned_sat_variable_i16_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, #0xffff
; CHECK-NEXT:    mvn w9, w1
; CHECK-NEXT:    add w10, w0, w1
; CHECK-NEXT:    cmp w8, w9, uxth
; CHECK-NEXT:    csinv w0, w10, wzr, ls
; CHECK-NEXT:    ret
  %noty = xor i16 %y, -1
  %a = add i16 %x, %y
  %c = icmp ugt i16 %x, %noty
  %r = select i1 %c, i16 -1, i16 %a
  ret i16 %r
}

define i32 @unsigned_sat_variable_i32_using_min(i32 %x, i32 %y) {
; CHECK-LABEL: unsigned_sat_variable_i32_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w1
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    csinv w8, w0, w1, lo
; CHECK-NEXT:    add w0, w8, w1
; CHECK-NEXT:    ret
  %noty = xor i32 %y, -1
  %c = icmp ult i32 %x, %noty
  %s = select i1 %c, i32 %x, i32 %noty
  %r = add i32 %s, %y
  ret i32 %r
}

define i32 @unsigned_sat_variable_i32_using_cmp_sum(i32 %x, i32 %y) {
; CHECK-LABEL: unsigned_sat_variable_i32_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds w8, w0, w1
; CHECK-NEXT:    csinv w0, w8, wzr, lo
; CHECK-NEXT:    ret
  %a = add i32 %x, %y
  %c = icmp ugt i32 %x, %a
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i32 @unsigned_sat_variable_i32_using_cmp_notval(i32 %x, i32 %y) {
; CHECK-LABEL: unsigned_sat_variable_i32_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w1
; CHECK-NEXT:    add w9, w0, w1
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    csinv w0, w9, wzr, ls
; CHECK-NEXT:    ret
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp ugt i32 %x, %noty
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i64 @unsigned_sat_variable_i64_using_min(i64 %x, i64 %y) {
; CHECK-LABEL: unsigned_sat_variable_i64_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn x8, x1
; CHECK-NEXT:    cmp x0, x8
; CHECK-NEXT:    csinv x8, x0, x1, lo
; CHECK-NEXT:    add x0, x8, x1
; CHECK-NEXT:    ret
  %noty = xor i64 %y, -1
  %c = icmp ult i64 %x, %noty
  %s = select i1 %c, i64 %x, i64 %noty
  %r = add i64 %s, %y
  ret i64 %r
}

define i64 @unsigned_sat_variable_i64_using_cmp_sum(i64 %x, i64 %y) {
; CHECK-LABEL: unsigned_sat_variable_i64_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x8, x0, x1
; CHECK-NEXT:    csinv x0, x8, xzr, lo
; CHECK-NEXT:    ret
  %a = add i64 %x, %y
  %c = icmp ugt i64 %x, %a
  %r = select i1 %c, i64 -1, i64 %a
  ret i64 %r
}

define i64 @unsigned_sat_variable_i64_using_cmp_notval(i64 %x, i64 %y) {
; CHECK-LABEL: unsigned_sat_variable_i64_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn x8, x1
; CHECK-NEXT:    add x9, x0, x1
; CHECK-NEXT:    cmp x0, x8
; CHECK-NEXT:    csinv x0, x9, xzr, ls
; CHECK-NEXT:    ret
  %noty = xor i64 %y, -1
  %a = add i64 %x, %y
  %c = icmp ugt i64 %x, %noty
  %r = select i1 %c, i64 -1, i64 %a
  ret i64 %r
}

define <16 x i8> @unsigned_sat_constant_v16i8_using_min(<16 x i8> %x) {
; CHECK-LABEL: unsigned_sat_constant_v16i8_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.16b, #213
; CHECK-NEXT:    umin v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    movi v1.16b, #42
; CHECK-NEXT:    add v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %c = icmp ult <16 x i8> %x, <i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43>
  %s = select <16 x i1> %c, <16 x i8> %x, <16 x i8> <i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43>
  %r = add <16 x i8> %s, <i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42>
  ret <16 x i8> %r
}

define <16 x i8> @unsigned_sat_constant_v16i8_using_cmp_sum(<16 x i8> %x) {
; CHECK-LABEL: unsigned_sat_constant_v16i8_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.16b, #42
; CHECK-NEXT:    add v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmhi v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a = add <16 x i8> %x, <i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42>
  %c = icmp ugt <16 x i8> %x, %a
  %r = select <16 x i1> %c, <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> %a
  ret <16 x i8> %r
}

define <16 x i8> @unsigned_sat_constant_v16i8_using_cmp_notval(<16 x i8> %x) {
; CHECK-LABEL: unsigned_sat_constant_v16i8_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.16b, #42
; CHECK-NEXT:    movi v2.16b, #213
; CHECK-NEXT:    add v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmhi v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a = add <16 x i8> %x, <i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42, i8 42>
  %c = icmp ugt <16 x i8> %x, <i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43, i8 -43>
  %r = select <16 x i1> %c, <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> %a
  ret <16 x i8> %r
}

define <8 x i16> @unsigned_sat_constant_v8i16_using_min(<8 x i16> %x) {
; CHECK-LABEL: unsigned_sat_constant_v8i16_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvni v1.8h, #42
; CHECK-NEXT:    umin v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    movi v1.8h, #42
; CHECK-NEXT:    add v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ret
  %c = icmp ult <8 x i16> %x, <i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43>
  %s = select <8 x i1> %c, <8 x i16> %x, <8 x i16> <i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43>
  %r = add <8 x i16> %s, <i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42>
  ret <8 x i16> %r
}

define <8 x i16> @unsigned_sat_constant_v8i16_using_cmp_sum(<8 x i16> %x) {
; CHECK-LABEL: unsigned_sat_constant_v8i16_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.8h, #42
; CHECK-NEXT:    add v1.8h, v0.8h, v1.8h
; CHECK-NEXT:    cmhi v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a = add <8 x i16> %x, <i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42>
  %c = icmp ugt <8 x i16> %x, %a
  %r = select <8 x i1> %c, <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> %a
  ret <8 x i16> %r
}

define <8 x i16> @unsigned_sat_constant_v8i16_using_cmp_notval(<8 x i16> %x) {
; CHECK-LABEL: unsigned_sat_constant_v8i16_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.8h, #42
; CHECK-NEXT:    mvni v2.8h, #42
; CHECK-NEXT:    add v1.8h, v0.8h, v1.8h
; CHECK-NEXT:    cmhi v0.8h, v0.8h, v2.8h
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a = add <8 x i16> %x, <i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42>
  %c = icmp ugt <8 x i16> %x, <i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43, i16 -43>
  %r = select <8 x i1> %c, <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> %a
  ret <8 x i16> %r
}

define <4 x i32> @unsigned_sat_constant_v4i32_using_min(<4 x i32> %x) {
; CHECK-LABEL: unsigned_sat_constant_v4i32_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvni v1.4s, #42
; CHECK-NEXT:    umin v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    movi v1.4s, #42
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %c = icmp ult <4 x i32> %x, <i32 -43, i32 -43, i32 -43, i32 -43>
  %s = select <4 x i1> %c, <4 x i32> %x, <4 x i32> <i32 -43, i32 -43, i32 -43, i32 -43>
  %r = add <4 x i32> %s, <i32 42, i32 42, i32 42, i32 42>
  ret <4 x i32> %r
}

define <4 x i32> @unsigned_sat_constant_v4i32_using_cmp_sum(<4 x i32> %x) {
; CHECK-LABEL: unsigned_sat_constant_v4i32_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #42
; CHECK-NEXT:    add v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmhi v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %a = add <4 x i32> %x, <i32 42, i32 42, i32 42, i32 42>
  %c = icmp ugt <4 x i32> %x, %a
  %r = select <4 x i1> %c, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %a
  ret <4 x i32> %r
}

define <4 x i32> @unsigned_sat_constant_v4i32_using_cmp_notval(<4 x i32> %x) {
; CHECK-LABEL: unsigned_sat_constant_v4i32_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #42
; CHECK-NEXT:    mvni v2.4s, #42
; CHECK-NEXT:    add v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmhi v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %a = add <4 x i32> %x, <i32 42, i32 42, i32 42, i32 42>
  %c = icmp ugt <4 x i32> %x, <i32 -43, i32 -43, i32 -43, i32 -43>
  %r = select <4 x i1> %c, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %a
  ret <4 x i32> %r
}

define <2 x i64> @unsigned_sat_constant_v2i64_using_min(<2 x i64> %x) {
; CHECK-LABEL: unsigned_sat_constant_v2i64_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #-43
; CHECK-NEXT:    dup v1.2d, x8
; CHECK-NEXT:    mov w9, #42
; CHECK-NEXT:    cmhi v2.2d, v1.2d, v0.2d
; CHECK-NEXT:    bsl v2.16b, v0.16b, v1.16b
; CHECK-NEXT:    dup v0.2d, x9
; CHECK-NEXT:    add v0.2d, v2.2d, v0.2d
; CHECK-NEXT:    ret
  %c = icmp ult <2 x i64> %x, <i64 -43, i64 -43>
  %s = select <2 x i1> %c, <2 x i64> %x, <2 x i64> <i64 -43, i64 -43>
  %r = add <2 x i64> %s, <i64 42, i64 42>
  ret <2 x i64> %r
}

define <2 x i64> @unsigned_sat_constant_v2i64_using_cmp_sum(<2 x i64> %x) {
; CHECK-LABEL: unsigned_sat_constant_v2i64_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    dup v1.2d, x8
; CHECK-NEXT:    add v1.2d, v0.2d, v1.2d
; CHECK-NEXT:    cmhi v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %a = add <2 x i64> %x, <i64 42, i64 42>
  %c = icmp ugt <2 x i64> %x, %a
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> %a
  ret <2 x i64> %r
}

define <2 x i64> @unsigned_sat_constant_v2i64_using_cmp_notval(<2 x i64> %x) {
; CHECK-LABEL: unsigned_sat_constant_v2i64_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    mov x9, #-43
; CHECK-NEXT:    dup v1.2d, x8
; CHECK-NEXT:    dup v2.2d, x9
; CHECK-NEXT:    add v1.2d, v0.2d, v1.2d
; CHECK-NEXT:    cmhi v0.2d, v0.2d, v2.2d
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %a = add <2 x i64> %x, <i64 42, i64 42>
  %c = icmp ugt <2 x i64> %x, <i64 -43, i64 -43>
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> %a
  ret <2 x i64> %r
}

define <16 x i8> @unsigned_sat_variable_v16i8_using_min(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: unsigned_sat_variable_v16i8_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    umin v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    add v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %noty = xor <16 x i8> %y, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %c = icmp ult <16 x i8> %x, %noty
  %s = select <16 x i1> %c, <16 x i8> %x, <16 x i8> %noty
  %r = add <16 x i8> %s, %y
  ret <16 x i8> %r
}

define <16 x i8> @unsigned_sat_variable_v16i8_using_cmp_sum(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: unsigned_sat_variable_v16i8_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmhi v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a = add <16 x i8> %x, %y
  %c = icmp ugt <16 x i8> %x, %a
  %r = select <16 x i1> %c, <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> %a
  ret <16 x i8> %r
}

define <16 x i8> @unsigned_sat_variable_v16i8_using_cmp_notval(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: unsigned_sat_variable_v16i8_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    add v1.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmhi v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %noty = xor <16 x i8> %y, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %a = add <16 x i8> %x, %y
  %c = icmp ugt <16 x i8> %x, %noty
  %r = select <16 x i1> %c, <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> %a
  ret <16 x i8> %r
}

define <8 x i16> @unsigned_sat_variable_v8i16_using_min(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: unsigned_sat_variable_v8i16_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    umin v0.8h, v0.8h, v2.8h
; CHECK-NEXT:    add v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ret
  %noty = xor <8 x i16> %y, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %c = icmp ult <8 x i16> %x, %noty
  %s = select <8 x i1> %c, <8 x i16> %x, <8 x i16> %noty
  %r = add <8 x i16> %s, %y
  ret <8 x i16> %r
}

define <8 x i16> @unsigned_sat_variable_v8i16_using_cmp_sum(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: unsigned_sat_variable_v8i16_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v1.8h, v0.8h, v1.8h
; CHECK-NEXT:    cmhi v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a = add <8 x i16> %x, %y
  %c = icmp ugt <8 x i16> %x, %a
  %r = select <8 x i1> %c, <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> %a
  ret <8 x i16> %r
}

define <8 x i16> @unsigned_sat_variable_v8i16_using_cmp_notval(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: unsigned_sat_variable_v8i16_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    add v1.8h, v0.8h, v1.8h
; CHECK-NEXT:    cmhi v0.8h, v0.8h, v2.8h
; CHECK-NEXT:    bic v1.16b, v1.16b, v0.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %noty = xor <8 x i16> %y, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %a = add <8 x i16> %x, %y
  %c = icmp ugt <8 x i16> %x, %noty
  %r = select <8 x i1> %c, <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> %a
  ret <8 x i16> %r
}

define <4 x i32> @unsigned_sat_variable_v4i32_using_min(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: unsigned_sat_variable_v4i32_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    umin v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %noty = xor <4 x i32> %y, <i32 -1, i32 -1, i32 -1, i32 -1>
  %c = icmp ult <4 x i32> %x, %noty
  %s = select <4 x i1> %c, <4 x i32> %x, <4 x i32> %noty
  %r = add <4 x i32> %s, %y
  ret <4 x i32> %r
}

define <4 x i32> @unsigned_sat_variable_v4i32_using_cmp_sum(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: unsigned_sat_variable_v4i32_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmhi v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %a = add <4 x i32> %x, %y
  %c = icmp ugt <4 x i32> %x, %a
  %r = select <4 x i1> %c, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %a
  ret <4 x i32> %r
}

define <4 x i32> @unsigned_sat_variable_v4i32_using_cmp_notval(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: unsigned_sat_variable_v4i32_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    add v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmhi v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %noty = xor <4 x i32> %y, <i32 -1, i32 -1, i32 -1, i32 -1>
  %a = add <4 x i32> %x, %y
  %c = icmp ugt <4 x i32> %x, %noty
  %r = select <4 x i1> %c, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %a
  ret <4 x i32> %r
}

define <2 x i64> @unsigned_sat_variable_v2i64_using_min(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: unsigned_sat_variable_v2i64_using_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    cmhi v3.2d, v2.2d, v0.2d
; CHECK-NEXT:    bsl v3.16b, v0.16b, v2.16b
; CHECK-NEXT:    add v0.2d, v3.2d, v1.2d
; CHECK-NEXT:    ret
  %noty = xor <2 x i64> %y, <i64 -1, i64 -1>
  %c = icmp ult <2 x i64> %x, %noty
  %s = select <2 x i1> %c, <2 x i64> %x, <2 x i64> %noty
  %r = add <2 x i64> %s, %y
  ret <2 x i64> %r
}

define <2 x i64> @unsigned_sat_variable_v2i64_using_cmp_sum(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: unsigned_sat_variable_v2i64_using_cmp_sum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add v1.2d, v0.2d, v1.2d
; CHECK-NEXT:    cmhi v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %a = add <2 x i64> %x, %y
  %c = icmp ugt <2 x i64> %x, %a
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> %a
  ret <2 x i64> %r
}

define <2 x i64> @unsigned_sat_variable_v2i64_using_cmp_notval(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: unsigned_sat_variable_v2i64_using_cmp_notval:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn v2.16b, v1.16b
; CHECK-NEXT:    add v1.2d, v0.2d, v1.2d
; CHECK-NEXT:    cmhi v0.2d, v0.2d, v2.2d
; CHECK-NEXT:    orr v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %noty = xor <2 x i64> %y, <i64 -1, i64 -1>
  %a = add <2 x i64> %x, %y
  %c = icmp ugt <2 x i64> %x, %noty
  %r = select <2 x i1> %c, <2 x i64> <i64 -1, i64 -1>, <2 x i64> %a
  ret <2 x i64> %r
}

