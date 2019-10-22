; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -mcpu=mips32r5 -mattr=+msa,+fp64,+nan2008 -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=P5600

define void @add_v16i8(<16 x i8>* %a, <16 x i8>* %b, <16 x i8>* %c) {
; P5600-LABEL: add_v16i8:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.b $w0, 0($4)
; P5600-NEXT:    ld.b $w1, 0($5)
; P5600-NEXT:    addv.b $w0, $w1, $w0
; P5600-NEXT:    st.b $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <16 x i8>, <16 x i8>* %a, align 16
  %1 = load <16 x i8>, <16 x i8>* %b, align 16
  %add = add <16 x i8> %1, %0
  store <16 x i8> %add, <16 x i8>* %c, align 16
  ret void
}

define void @add_v8i16(<8 x i16>* %a, <8 x i16>* %b, <8 x i16>* %c) {
; P5600-LABEL: add_v8i16:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.h $w0, 0($4)
; P5600-NEXT:    ld.h $w1, 0($5)
; P5600-NEXT:    addv.h $w0, $w1, $w0
; P5600-NEXT:    st.h $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <8 x i16>, <8 x i16>* %a, align 16
  %1 = load <8 x i16>, <8 x i16>* %b, align 16
  %add = add <8 x i16> %1, %0
  store <8 x i16> %add, <8 x i16>* %c, align 16
  ret void
}

define void @add_v4i32(<4 x i32>* %a, <4 x i32>* %b, <4 x i32>* %c) {
; P5600-LABEL: add_v4i32:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    addv.w $w0, $w1, $w0
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x i32>, <4 x i32>* %a, align 16
  %1 = load <4 x i32>, <4 x i32>* %b, align 16
  %add = add <4 x i32> %1, %0
  store <4 x i32> %add, <4 x i32>* %c, align 16
  ret void
}

define void @add_v2i64(<2 x i64>* %a, <2 x i64>* %b, <2 x i64>* %c) {
; P5600-LABEL: add_v2i64:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    addv.d $w0, $w1, $w0
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x i64>, <2 x i64>* %a, align 16
  %1 = load <2 x i64>, <2 x i64>* %b, align 16
  %add = add <2 x i64> %1, %0
  store <2 x i64> %add, <2 x i64>* %c, align 16
  ret void
}
