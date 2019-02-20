; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s --check-prefix=CHECK

declare {<1 x i32>, <1 x i1>} @llvm.umul.with.overflow.v1i32(<1 x i32>, <1 x i32>)
declare {<2 x i32>, <2 x i1>} @llvm.umul.with.overflow.v2i32(<2 x i32>, <2 x i32>)
declare {<3 x i32>, <3 x i1>} @llvm.umul.with.overflow.v3i32(<3 x i32>, <3 x i32>)
declare {<4 x i32>, <4 x i1>} @llvm.umul.with.overflow.v4i32(<4 x i32>, <4 x i32>)
declare {<6 x i32>, <6 x i1>} @llvm.umul.with.overflow.v6i32(<6 x i32>, <6 x i32>)
declare {<8 x i32>, <8 x i1>} @llvm.umul.with.overflow.v8i32(<8 x i32>, <8 x i32>)

declare {<16 x i8>, <16 x i1>} @llvm.umul.with.overflow.v16i8(<16 x i8>, <16 x i8>)
declare {<8 x i16>, <8 x i1>} @llvm.umul.with.overflow.v8i16(<8 x i16>, <8 x i16>)
declare {<2 x i64>, <2 x i1>} @llvm.umul.with.overflow.v2i64(<2 x i64>, <2 x i64>)

declare {<4 x i24>, <4 x i1>} @llvm.umul.with.overflow.v4i24(<4 x i24>, <4 x i24>)
declare {<4 x i1>, <4 x i1>} @llvm.umul.with.overflow.v4i1(<4 x i1>, <4 x i1>)
declare {<2 x i128>, <2 x i1>} @llvm.umul.with.overflow.v2i128(<2 x i128>, <2 x i128>)

define <1 x i32> @umulo_v1i32(<1 x i32> %a0, <1 x i32> %a1, <1 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v1i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    shrn v0.2s, v1.2d, #32
; CHECK-NEXT:    cmeq v0.2s, v0.2s, #0
; CHECK-NEXT:    mvn v0.8b, v0.8b
; CHECK-NEXT:    xtn v1.2s, v1.2d
; CHECK-NEXT:    str s1, [x0]
; CHECK-NEXT:    ret
  %t = call {<1 x i32>, <1 x i1>} @llvm.umul.with.overflow.v1i32(<1 x i32> %a0, <1 x i32> %a1)
  %val = extractvalue {<1 x i32>, <1 x i1>} %t, 0
  %obit = extractvalue {<1 x i32>, <1 x i1>} %t, 1
  %res = sext <1 x i1> %obit to <1 x i32>
  store <1 x i32> %val, <1 x i32>* %p2
  ret <1 x i32> %res
}

define <2 x i32> @umulo_v2i32(<2 x i32> %a0, <2 x i32> %a1, <2 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    shrn v0.2s, v1.2d, #32
; CHECK-NEXT:    cmeq v0.2s, v0.2s, #0
; CHECK-NEXT:    mvn v0.8b, v0.8b
; CHECK-NEXT:    xtn v1.2s, v1.2d
; CHECK-NEXT:    str d1, [x0]
; CHECK-NEXT:    ret
  %t = call {<2 x i32>, <2 x i1>} @llvm.umul.with.overflow.v2i32(<2 x i32> %a0, <2 x i32> %a1)
  %val = extractvalue {<2 x i32>, <2 x i1>} %t, 0
  %obit = extractvalue {<2 x i32>, <2 x i1>} %t, 1
  %res = sext <2 x i1> %obit to <2 x i32>
  store <2 x i32> %val, <2 x i32>* %p2
  ret <2 x i32> %res
}

define <3 x i32> @umulo_v3i32(<3 x i32> %a0, <3 x i32> %a1, <3 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v3i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.2d, v0.4s, v1.4s
; CHECK-NEXT:    umull v3.2d, v0.2s, v1.2s
; CHECK-NEXT:    mul v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    uzp2 v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    add x8, x0, #8 // =8
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    st1 { v1.s }[2], [x8]
; CHECK-NEXT:    str d1, [x0]
; CHECK-NEXT:    ret
  %t = call {<3 x i32>, <3 x i1>} @llvm.umul.with.overflow.v3i32(<3 x i32> %a0, <3 x i32> %a1)
  %val = extractvalue {<3 x i32>, <3 x i1>} %t, 0
  %obit = extractvalue {<3 x i32>, <3 x i1>} %t, 1
  %res = sext <3 x i1> %obit to <3 x i32>
  store <3 x i32> %val, <3 x i32>* %p2
  ret <3 x i32> %res
}

define <4 x i32> @umulo_v4i32(<4 x i32> %a0, <4 x i32> %a1, <4 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.2d, v0.4s, v1.4s
; CHECK-NEXT:    umull v3.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v2.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v2.4s, v2.4s, #0
; CHECK-NEXT:    mvn v2.16b, v2.16b
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
  %t = call {<4 x i32>, <4 x i1>} @llvm.umul.with.overflow.v4i32(<4 x i32> %a0, <4 x i32> %a1)
  %val = extractvalue {<4 x i32>, <4 x i1>} %t, 0
  %obit = extractvalue {<4 x i32>, <4 x i1>} %t, 1
  %res = sext <4 x i1> %obit to <4 x i32>
  store <4 x i32> %val, <4 x i32>* %p2
  ret <4 x i32> %res
}

define <6 x i32> @umulo_v6i32(<6 x i32> %a0, <6 x i32> %a1, <6 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v6i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s2, w6
; CHECK-NEXT:    ldr s0, [sp, #16]
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    mov v2.s[1], w7
; CHECK-NEXT:    ld1 { v2.s }[2], [x9]
; CHECK-NEXT:    add x8, sp, #24 // =24
; CHECK-NEXT:    add x10, sp, #8 // =8
; CHECK-NEXT:    ld1 { v0.s }[1], [x8]
; CHECK-NEXT:    fmov s3, w0
; CHECK-NEXT:    ldr x11, [sp, #32]
; CHECK-NEXT:    ld1 { v2.s }[3], [x10]
; CHECK-NEXT:    fmov s1, w4
; CHECK-NEXT:    mov v3.s[1], w1
; CHECK-NEXT:    mov v1.s[1], w5
; CHECK-NEXT:    mov v3.s[2], w2
; CHECK-NEXT:    mov v3.s[3], w3
; CHECK-NEXT:    umull2 v4.2d, v1.4s, v0.4s
; CHECK-NEXT:    umull v5.2d, v1.2s, v0.2s
; CHECK-NEXT:    mul v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    uzp2 v1.4s, v5.4s, v4.4s
; CHECK-NEXT:    str d0, [x11, #16]
; CHECK-NEXT:    umull2 v0.2d, v3.4s, v2.4s
; CHECK-NEXT:    umull v4.2d, v3.2s, v2.2s
; CHECK-NEXT:    uzp2 v0.4s, v4.4s, v0.4s
; CHECK-NEXT:    cmeq v1.4s, v1.4s, #0
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    mvn v1.16b, v1.16b
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    mul v2.4s, v3.4s, v2.4s
; CHECK-NEXT:    mov w5, v1.s[1]
; CHECK-NEXT:    mov w1, v0.s[1]
; CHECK-NEXT:    mov w2, v0.s[2]
; CHECK-NEXT:    mov w3, v0.s[3]
; CHECK-NEXT:    fmov w4, s1
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    str q2, [x11]
; CHECK-NEXT:    ret
  %t = call {<6 x i32>, <6 x i1>} @llvm.umul.with.overflow.v6i32(<6 x i32> %a0, <6 x i32> %a1)
  %val = extractvalue {<6 x i32>, <6 x i1>} %t, 0
  %obit = extractvalue {<6 x i32>, <6 x i1>} %t, 1
  %res = sext <6 x i1> %obit to <6 x i32>
  store <6 x i32> %val, <6 x i32>* %p2
  ret <6 x i32> %res
}

define <8 x i32> @umulo_v8i32(<8 x i32> %a0, <8 x i32> %a1, <8 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v4.2d, v0.4s, v2.4s
; CHECK-NEXT:    umull v5.2d, v0.2s, v2.2s
; CHECK-NEXT:    umull2 v6.2d, v1.4s, v3.4s
; CHECK-NEXT:    mul v2.4s, v0.4s, v2.4s
; CHECK-NEXT:    umull v0.2d, v1.2s, v3.2s
; CHECK-NEXT:    mul v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    uzp2 v1.4s, v5.4s, v4.4s
; CHECK-NEXT:    uzp2 v0.4s, v0.4s, v6.4s
; CHECK-NEXT:    cmeq v1.4s, v1.4s, #0
; CHECK-NEXT:    cmeq v4.4s, v0.4s, #0
; CHECK-NEXT:    mvn v0.16b, v1.16b
; CHECK-NEXT:    mvn v1.16b, v4.16b
; CHECK-NEXT:    stp q2, q3, [x0]
; CHECK-NEXT:    ret
  %t = call {<8 x i32>, <8 x i1>} @llvm.umul.with.overflow.v8i32(<8 x i32> %a0, <8 x i32> %a1)
  %val = extractvalue {<8 x i32>, <8 x i1>} %t, 0
  %obit = extractvalue {<8 x i32>, <8 x i1>} %t, 1
  %res = sext <8 x i1> %obit to <8 x i32>
  store <8 x i32> %val, <8 x i32>* %p2
  ret <8 x i32> %res
}

define <16 x i32> @umulo_v16i8(<16 x i8> %a0, <16 x i8> %a1, <16 x i8>* %p2) nounwind {
; CHECK-LABEL: umulo_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.8h, v0.16b, v1.16b
; CHECK-NEXT:    umull v3.8h, v0.8b, v1.8b
; CHECK-NEXT:    mul v4.16b, v0.16b, v1.16b
; CHECK-NEXT:    uzp2 v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    cmeq v0.16b, v0.16b, #0
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    zip1 v1.8b, v0.8b, v0.8b
; CHECK-NEXT:    zip2 v2.8b, v0.8b, v0.8b
; CHECK-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    ushll v1.4s, v1.4h, #0
; CHECK-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-NEXT:    zip1 v3.8b, v0.8b, v0.8b
; CHECK-NEXT:    zip2 v0.8b, v0.8b, v0.8b
; CHECK-NEXT:    shl v1.4s, v1.4s, #31
; CHECK-NEXT:    shl v2.4s, v2.4s, #31
; CHECK-NEXT:    ushll v3.4s, v3.4h, #0
; CHECK-NEXT:    ushll v5.4s, v0.4h, #0
; CHECK-NEXT:    sshr v0.4s, v1.4s, #31
; CHECK-NEXT:    sshr v1.4s, v2.4s, #31
; CHECK-NEXT:    shl v2.4s, v3.4s, #31
; CHECK-NEXT:    shl v3.4s, v5.4s, #31
; CHECK-NEXT:    sshr v2.4s, v2.4s, #31
; CHECK-NEXT:    sshr v3.4s, v3.4s, #31
; CHECK-NEXT:    str q4, [x0]
; CHECK-NEXT:    ret
  %t = call {<16 x i8>, <16 x i1>} @llvm.umul.with.overflow.v16i8(<16 x i8> %a0, <16 x i8> %a1)
  %val = extractvalue {<16 x i8>, <16 x i1>} %t, 0
  %obit = extractvalue {<16 x i8>, <16 x i1>} %t, 1
  %res = sext <16 x i1> %obit to <16 x i32>
  store <16 x i8> %val, <16 x i8>* %p2
  ret <16 x i32> %res
}

define <8 x i32> @umulo_v8i16(<8 x i16> %a0, <8 x i16> %a1, <8 x i16>* %p2) nounwind {
; CHECK-LABEL: umulo_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.4s, v0.8h, v1.8h
; CHECK-NEXT:    umull v3.4s, v0.4h, v1.4h
; CHECK-NEXT:    mul v4.8h, v0.8h, v1.8h
; CHECK-NEXT:    uzp2 v0.8h, v3.8h, v2.8h
; CHECK-NEXT:    cmeq v0.8h, v0.8h, #0
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    zip1 v1.8b, v0.8b, v0.8b
; CHECK-NEXT:    zip2 v0.8b, v0.8b, v0.8b
; CHECK-NEXT:    ushll v1.4s, v1.4h, #0
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    shl v1.4s, v1.4s, #31
; CHECK-NEXT:    shl v2.4s, v0.4s, #31
; CHECK-NEXT:    sshr v0.4s, v1.4s, #31
; CHECK-NEXT:    sshr v1.4s, v2.4s, #31
; CHECK-NEXT:    str q4, [x0]
; CHECK-NEXT:    ret
  %t = call {<8 x i16>, <8 x i1>} @llvm.umul.with.overflow.v8i16(<8 x i16> %a0, <8 x i16> %a1)
  %val = extractvalue {<8 x i16>, <8 x i1>} %t, 0
  %obit = extractvalue {<8 x i16>, <8 x i1>} %t, 1
  %res = sext <8 x i1> %obit to <8 x i32>
  store <8 x i16> %val, <8 x i16>* %p2
  ret <8 x i32> %res
}

define <2 x i32> @umulo_v2i64(<2 x i64> %a0, <2 x i64> %a1, <2 x i64>* %p2) nounwind {
; CHECK-LABEL: umulo_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov x10, d1
; CHECK-NEXT:    fmov x11, d0
; CHECK-NEXT:    mov x8, v1.d[1]
; CHECK-NEXT:    mov x9, v0.d[1]
; CHECK-NEXT:    umulh x12, x11, x10
; CHECK-NEXT:    mul x10, x11, x10
; CHECK-NEXT:    cmp xzr, x12
; CHECK-NEXT:    umulh x11, x9, x8
; CHECK-NEXT:    mul x8, x9, x8
; CHECK-NEXT:    cset w9, ne
; CHECK-NEXT:    cmp xzr, x11
; CHECK-NEXT:    fmov d1, x10
; CHECK-NEXT:    fmov s0, w9
; CHECK-NEXT:    cset w9, ne
; CHECK-NEXT:    mov v0.s[1], w9
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    str q1, [x0]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
  %t = call {<2 x i64>, <2 x i1>} @llvm.umul.with.overflow.v2i64(<2 x i64> %a0, <2 x i64> %a1)
  %val = extractvalue {<2 x i64>, <2 x i1>} %t, 0
  %obit = extractvalue {<2 x i64>, <2 x i1>} %t, 1
  %res = sext <2 x i1> %obit to <2 x i32>
  store <2 x i64> %val, <2 x i64>* %p2
  ret <2 x i32> %res
}

define <4 x i32> @umulo_v4i24(<4 x i24> %a0, <4 x i24> %a1, <4 x i24>* %p2) nounwind {
; CHECK-LABEL: umulo_v4i24:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic v1.4s, #255, lsl #24
; CHECK-NEXT:    bic v0.4s, #255, lsl #24
; CHECK-NEXT:    umull2 v2.2d, v0.4s, v1.4s
; CHECK-NEXT:    umull v3.2d, v0.2s, v1.2s
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    uzp2 v1.4s, v3.4s, v2.4s
; CHECK-NEXT:    ushr v2.4s, v0.4s, #24
; CHECK-NEXT:    mov w8, v0.s[3]
; CHECK-NEXT:    mov w9, v0.s[2]
; CHECK-NEXT:    mov w10, v0.s[1]
; CHECK-NEXT:    fmov w11, s0
; CHECK-NEXT:    cmeq v0.4s, v1.4s, #0
; CHECK-NEXT:    cmeq v1.4s, v2.4s, #0
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    mvn v1.16b, v1.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    xtn v1.4h, v1.4s
; CHECK-NEXT:    sturh w8, [x0, #9]
; CHECK-NEXT:    lsr w8, w8, #16
; CHECK-NEXT:    orr v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    strh w9, [x0, #6]
; CHECK-NEXT:    sturh w10, [x0, #3]
; CHECK-NEXT:    lsr w9, w9, #16
; CHECK-NEXT:    lsr w10, w10, #16
; CHECK-NEXT:    strb w8, [x0, #11]
; CHECK-NEXT:    sshll v0.4s, v0.4h, #0
; CHECK-NEXT:    lsr w8, w11, #16
; CHECK-NEXT:    strh w11, [x0]
; CHECK-NEXT:    strb w9, [x0, #8]
; CHECK-NEXT:    strb w10, [x0, #5]
; CHECK-NEXT:    strb w8, [x0, #2]
; CHECK-NEXT:    ret
  %t = call {<4 x i24>, <4 x i1>} @llvm.umul.with.overflow.v4i24(<4 x i24> %a0, <4 x i24> %a1)
  %val = extractvalue {<4 x i24>, <4 x i1>} %t, 0
  %obit = extractvalue {<4 x i24>, <4 x i1>} %t, 1
  %res = sext <4 x i1> %obit to <4 x i32>
  store <4 x i24> %val, <4 x i24>* %p2
  ret <4 x i32> %res
}

define <4 x i32> @umulo_v4i1(<4 x i1> %a0, <4 x i1> %a1, <4 x i1>* %p2) nounwind {
; CHECK-LABEL: umulo_v4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4h, #1
; CHECK-NEXT:    and v1.8b, v1.8b, v2.8b
; CHECK-NEXT:    and v0.8b, v0.8b, v2.8b
; CHECK-NEXT:    umull v0.4s, v0.4h, v1.4h
; CHECK-NEXT:    xtn v1.4h, v0.4s
; CHECK-NEXT:    umov w9, v1.h[1]
; CHECK-NEXT:    umov w8, v1.h[0]
; CHECK-NEXT:    and w9, w9, #0x1
; CHECK-NEXT:    bfi w8, w9, #1, #1
; CHECK-NEXT:    umov w9, v1.h[2]
; CHECK-NEXT:    ushr v0.4h, v1.4h, #1
; CHECK-NEXT:    and w9, w9, #0x1
; CHECK-NEXT:    cmeq v0.4h, v0.4h, #0
; CHECK-NEXT:    bfi w8, w9, #2, #1
; CHECK-NEXT:    umov w9, v1.h[3]
; CHECK-NEXT:    mvn v0.8b, v0.8b
; CHECK-NEXT:    bfi w8, w9, #3, #29
; CHECK-NEXT:    sshll v0.4s, v0.4h, #0
; CHECK-NEXT:    and w8, w8, #0xf
; CHECK-NEXT:    strb w8, [x0]
; CHECK-NEXT:    ret
  %t = call {<4 x i1>, <4 x i1>} @llvm.umul.with.overflow.v4i1(<4 x i1> %a0, <4 x i1> %a1)
  %val = extractvalue {<4 x i1>, <4 x i1>} %t, 0
  %obit = extractvalue {<4 x i1>, <4 x i1>} %t, 1
  %res = sext <4 x i1> %obit to <4 x i32>
  store <4 x i1> %val, <4 x i1>* %p2
  ret <4 x i32> %res
}

define <2 x i32> @umulo_v2i128(<2 x i128> %a0, <2 x i128> %a1, <2 x i128>* %p2) nounwind {
; CHECK-LABEL: umulo_v2i128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mul x9, x7, x2
; CHECK-NEXT:    umulh x10, x2, x6
; CHECK-NEXT:    madd x9, x3, x6, x9
; CHECK-NEXT:    add x15, x10, x9
; CHECK-NEXT:    cmp x15, x10
; CHECK-NEXT:    cset w10, lo
; CHECK-NEXT:    cmp x9, #0 // =0
; CHECK-NEXT:    csel w10, wzr, w10, eq
; CHECK-NEXT:    cmp x7, #0 // =0
; CHECK-NEXT:    umulh x11, x3, x6
; CHECK-NEXT:    mul x13, x5, x0
; CHECK-NEXT:    cset w17, ne
; CHECK-NEXT:    cmp x3, #0 // =0
; CHECK-NEXT:    umulh x12, x7, x2
; CHECK-NEXT:    umulh x9, x0, x4
; CHECK-NEXT:    madd x13, x1, x4, x13
; CHECK-NEXT:    cset w18, ne
; CHECK-NEXT:    cmp xzr, x11
; CHECK-NEXT:    ldr x8, [sp]
; CHECK-NEXT:    add x11, x9, x13
; CHECK-NEXT:    and w17, w18, w17
; CHECK-NEXT:    cset w18, ne
; CHECK-NEXT:    cmp xzr, x12
; CHECK-NEXT:    orr w12, w17, w18
; CHECK-NEXT:    cset w17, ne
; CHECK-NEXT:    cmp x11, x9
; CHECK-NEXT:    orr w9, w12, w17
; CHECK-NEXT:    cset w12, lo
; CHECK-NEXT:    cmp x13, #0 // =0
; CHECK-NEXT:    mul x14, x2, x6
; CHECK-NEXT:    csel w12, wzr, w12, eq
; CHECK-NEXT:    cmp x5, #0 // =0
; CHECK-NEXT:    stp x14, x15, [x8, #16]
; CHECK-NEXT:    umulh x14, x1, x4
; CHECK-NEXT:    cset w13, ne
; CHECK-NEXT:    cmp x1, #0 // =0
; CHECK-NEXT:    umulh x16, x5, x0
; CHECK-NEXT:    cset w17, ne
; CHECK-NEXT:    cmp xzr, x14
; CHECK-NEXT:    and w13, w17, w13
; CHECK-NEXT:    cset w14, ne
; CHECK-NEXT:    cmp xzr, x16
; CHECK-NEXT:    orr w13, w13, w14
; CHECK-NEXT:    cset w14, ne
; CHECK-NEXT:    orr w13, w13, w14
; CHECK-NEXT:    orr w12, w13, w12
; CHECK-NEXT:    orr w9, w9, w10
; CHECK-NEXT:    fmov s0, w12
; CHECK-NEXT:    mov v0.s[1], w9
; CHECK-NEXT:    shl v0.2s, v0.2s, #31
; CHECK-NEXT:    mul x15, x0, x4
; CHECK-NEXT:    sshr v0.2s, v0.2s, #31
; CHECK-NEXT:    stp x15, x11, [x8]
; CHECK-NEXT:    ret
  %t = call {<2 x i128>, <2 x i1>} @llvm.umul.with.overflow.v2i128(<2 x i128> %a0, <2 x i128> %a1)
  %val = extractvalue {<2 x i128>, <2 x i1>} %t, 0
  %obit = extractvalue {<2 x i128>, <2 x i1>} %t, 1
  %res = sext <2 x i1> %obit to <2 x i32>
  store <2 x i128> %val, <2 x i128>* %p2
  ret <2 x i32> %res
}
