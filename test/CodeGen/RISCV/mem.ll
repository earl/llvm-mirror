; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I

; Check indexed and unindexed, sext, zext and anyext loads

define i32 @lb(i8 *%a) nounwind {
; RV32I-LABEL: lb:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lb a1, 1(a0)
; RV32I-NEXT:    lb a0, 0(a0)
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    ret
  %1 = getelementptr i8, i8* %a, i32 1
  %2 = load i8, i8* %1
  %3 = sext i8 %2 to i32
  ; the unused load will produce an anyext for selection
  %4 = load volatile i8, i8* %a
  ret i32 %3
}

define i32 @lh(i16 *%a) nounwind {
; RV32I-LABEL: lh:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lh a1, 4(a0)
; RV32I-NEXT:    lh a0, 0(a0)
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    ret
  %1 = getelementptr i16, i16* %a, i32 2
  %2 = load i16, i16* %1
  %3 = sext i16 %2 to i32
  ; the unused load will produce an anyext for selection
  %4 = load volatile i16, i16* %a
  ret i32 %3
}

define i32 @lw(i32 *%a) nounwind {
; RV32I-LABEL: lw:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a1, 12(a0)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    ret
  %1 = getelementptr i32, i32* %a, i32 3
  %2 = load i32, i32* %1
  %3 = load volatile i32, i32* %a
  ret i32 %2
}

define i32 @lbu(i8 *%a) nounwind {
; RV32I-LABEL: lbu:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lbu a1, 4(a0)
; RV32I-NEXT:    lbu a0, 0(a0)
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    ret
  %1 = getelementptr i8, i8* %a, i32 4
  %2 = load i8, i8* %1
  %3 = zext i8 %2 to i32
  %4 = load volatile i8, i8* %a
  %5 = zext i8 %4 to i32
  %6 = add i32 %3, %5
  ret i32 %6
}

define i32 @lhu(i16 *%a) nounwind {
; RV32I-LABEL: lhu:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lhu a1, 10(a0)
; RV32I-NEXT:    lhu a0, 0(a0)
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    ret
  %1 = getelementptr i16, i16* %a, i32 5
  %2 = load i16, i16* %1
  %3 = zext i16 %2 to i32
  %4 = load volatile i16, i16* %a
  %5 = zext i16 %4 to i32
  %6 = add i32 %3, %5
  ret i32 %6
}

; Check indexed and unindexed stores

define void @sb(i8 *%a, i8 %b) nounwind {
; RV32I-LABEL: sb:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sb a1, 0(a0)
; RV32I-NEXT:    sb a1, 6(a0)
; RV32I-NEXT:    ret
  store i8 %b, i8* %a
  %1 = getelementptr i8, i8* %a, i32 6
  store i8 %b, i8* %1
  ret void
}

define void @sh(i16 *%a, i16 %b) nounwind {
; RV32I-LABEL: sh:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sh a1, 0(a0)
; RV32I-NEXT:    sh a1, 14(a0)
; RV32I-NEXT:    ret
  store i16 %b, i16* %a
  %1 = getelementptr i16, i16* %a, i32 7
  store i16 %b, i16* %1
  ret void
}

define void @sw(i32 *%a, i32 %b) nounwind {
; RV32I-LABEL: sw:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sw a1, 0(a0)
; RV32I-NEXT:    sw a1, 32(a0)
; RV32I-NEXT:    ret
  store i32 %b, i32* %a
  %1 = getelementptr i32, i32* %a, i32 8
  store i32 %b, i32* %1
  ret void
}

; Check load and store to an i1 location
define i32 @load_sext_zext_anyext_i1(i1 *%a) nounwind {
; RV32I-LABEL: load_sext_zext_anyext_i1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lbu a1, 1(a0)
; RV32I-NEXT:    lbu a2, 2(a0)
; RV32I-NEXT:    lb a0, 0(a0)
; RV32I-NEXT:    sub a0, a2, a1
; RV32I-NEXT:    ret
  ; sextload i1
  %1 = getelementptr i1, i1* %a, i32 1
  %2 = load i1, i1* %1
  %3 = sext i1 %2 to i32
  ; zextload i1
  %4 = getelementptr i1, i1* %a, i32 2
  %5 = load i1, i1* %4
  %6 = zext i1 %5 to i32
  %7 = add i32 %3, %6
  ; extload i1 (anyext). Produced as the load is unused.
  %8 = load volatile i1, i1* %a
  ret i32 %7
}

define i16 @load_sext_zext_anyext_i1_i16(i1 *%a) nounwind {
; RV32I-LABEL: load_sext_zext_anyext_i1_i16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lbu a1, 1(a0)
; RV32I-NEXT:    lbu a2, 2(a0)
; RV32I-NEXT:    lb a0, 0(a0)
; RV32I-NEXT:    sub a0, a2, a1
; RV32I-NEXT:    ret
  ; sextload i1
  %1 = getelementptr i1, i1* %a, i32 1
  %2 = load i1, i1* %1
  %3 = sext i1 %2 to i16
  ; zextload i1
  %4 = getelementptr i1, i1* %a, i32 2
  %5 = load i1, i1* %4
  %6 = zext i1 %5 to i16
  %7 = add i16 %3, %6
  ; extload i1 (anyext). Produced as the load is unused.
  %8 = load volatile i1, i1* %a
  ret i16 %7
}

; Check load and store to a global
@G = global i32 0

define i32 @lw_sw_global(i32 %a) nounwind {
; RV32I-LABEL: lw_sw_global:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a2, %hi(G)
; RV32I-NEXT:    lw a1, %lo(G)(a2)
; RV32I-NEXT:    sw a0, %lo(G)(a2)
; RV32I-NEXT:    addi a2, a2, %lo(G)
; RV32I-NEXT:    lw a3, 36(a2)
; RV32I-NEXT:    sw a0, 36(a2)
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    ret
  %1 = load volatile i32, i32* @G
  store i32 %a, i32* @G
  %2 = getelementptr i32, i32* @G, i32 9
  %3 = load volatile i32, i32* %2
  store i32 %a, i32* %2
  ret i32 %1
}

; Ensure that 1 is added to the high 20 bits if bit 11 of the low part is 1
define i32 @lw_sw_constant(i32 %a) nounwind {
; RV32I-LABEL: lw_sw_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a2, 912092
; RV32I-NEXT:    lw a1, -273(a2)
; RV32I-NEXT:    sw a0, -273(a2)
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    ret
  %1 = inttoptr i32 3735928559 to i32*
  %2 = load volatile i32, i32* %1
  store i32 %a, i32* %1
  ret i32 %2
}
