; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512vl --show-mc-encoding| FileCheck %s

define <8 x i32> @test_256_1(i8 * %addr) {
; CHECK-LABEL: test_256_1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x i32>*
  %res = load <8 x i32>, <8 x i32>* %vaddr, align 1
  ret <8 x i32>%res
}

define <8 x i32> @test_256_2(i8 * %addr) {
; CHECK-LABEL: test_256_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x i32>*
  %res = load <8 x i32>, <8 x i32>* %vaddr, align 32
  ret <8 x i32>%res
}

define void @test_256_3(i8 * %addr, <4 x i64> %data) {
; CHECK-LABEL: test_256_3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i64>*
  store <4 x i64>%data, <4 x i64>* %vaddr, align 32
  ret void
}

define void @test_256_4(i8 * %addr, <8 x i32> %data) {
; CHECK-LABEL: test_256_4:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x i32>*
  store <8 x i32>%data, <8 x i32>* %vaddr, align 1
  ret void
}

define void @test_256_5(i8 * %addr, <8 x i32> %data) {
; CHECK-LABEL: test_256_5:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x i32>*
  store <8 x i32>%data, <8 x i32>* %vaddr, align 32
  ret void
}

define  <4 x i64> @test_256_6(i8 * %addr) {
; CHECK-LABEL: test_256_6:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i64>*
  %res = load <4 x i64>, <4 x i64>* %vaddr, align 32
  ret <4 x i64>%res
}

define void @test_256_7(i8 * %addr, <4 x i64> %data) {
; CHECK-LABEL: test_256_7:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i64>*
  store <4 x i64>%data, <4 x i64>* %vaddr, align 1
  ret void
}

define <4 x i64> @test_256_8(i8 * %addr) {
; CHECK-LABEL: test_256_8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i64>*
  %res = load <4 x i64>, <4 x i64>* %vaddr, align 1
  ret <4 x i64>%res
}

define void @test_256_9(i8 * %addr, <4 x double> %data) {
; CHECK-LABEL: test_256_9:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x double>*
  store <4 x double>%data, <4 x double>* %vaddr, align 32
  ret void
}

define <4 x double> @test_256_10(i8 * %addr) {
; CHECK-LABEL: test_256_10:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x double>*
  %res = load <4 x double>, <4 x double>* %vaddr, align 32
  ret <4 x double>%res
}

define void @test_256_11(i8 * %addr, <8 x float> %data) {
; CHECK-LABEL: test_256_11:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x float>*
  store <8 x float>%data, <8 x float>* %vaddr, align 32
  ret void
}

define <8 x float> @test_256_12(i8 * %addr) {
; CHECK-LABEL: test_256_12:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x float>*
  %res = load <8 x float>, <8 x float>* %vaddr, align 32
  ret <8 x float>%res
}

define void @test_256_13(i8 * %addr, <4 x double> %data) {
; CHECK-LABEL: test_256_13:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x double>*
  store <4 x double>%data, <4 x double>* %vaddr, align 1
  ret void
}

define <4 x double> @test_256_14(i8 * %addr) {
; CHECK-LABEL: test_256_14:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x double>*
  %res = load <4 x double>, <4 x double>* %vaddr, align 1
  ret <4 x double>%res
}

define void @test_256_15(i8 * %addr, <8 x float> %data) {
; CHECK-LABEL: test_256_15:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %ymm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x float>*
  store <8 x float>%data, <8 x float>* %vaddr, align 1
  ret void
}

define <8 x float> @test_256_16(i8 * %addr) {
; CHECK-LABEL: test_256_16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %ymm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfc,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <8 x float>*
  %res = load <8 x float>, <8 x float>* %vaddr, align 1
  ret <8 x float>%res
}

define <8 x i32> @test_256_17(i8 * %addr, <8 x i32> %old, <8 x i32> %mask1) {
; CHECK-LABEL: test_256_17:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %ymm1, %ymm1, %k1 ## encoding: [0x62,0xf2,0x75,0x28,0x27,0xc9]
; CHECK-NEXT:    vmovdqa32 (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0x7d,0x29,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <8 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x i32>*
  %r = load <8 x i32>, <8 x i32>* %vaddr, align 32
  %res = select <8 x i1> %mask, <8 x i32> %r, <8 x i32> %old
  ret <8 x i32>%res
}

define <8 x i32> @test_256_18(i8 * %addr, <8 x i32> %old, <8 x i32> %mask1) {
; CHECK-LABEL: test_256_18:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %ymm1, %ymm1, %k1 ## encoding: [0x62,0xf2,0x75,0x28,0x27,0xc9]
; CHECK-NEXT:    vmovdqu32 (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0x7e,0x29,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <8 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x i32>*
  %r = load <8 x i32>, <8 x i32>* %vaddr, align 1
  %res = select <8 x i1> %mask, <8 x i32> %r, <8 x i32> %old
  ret <8 x i32>%res
}

define <8 x i32> @test_256_19(i8 * %addr, <8 x i32> %mask1) {
; CHECK-LABEL: test_256_19:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %ymm0, %ymm0, %k1 ## encoding: [0x62,0xf2,0x7d,0x28,0x27,0xc8]
; CHECK-NEXT:    vmovdqa32 (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7d,0xa9,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <8 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x i32>*
  %r = load <8 x i32>, <8 x i32>* %vaddr, align 32
  %res = select <8 x i1> %mask, <8 x i32> %r, <8 x i32> zeroinitializer
  ret <8 x i32>%res
}

define <8 x i32> @test_256_20(i8 * %addr, <8 x i32> %mask1) {
; CHECK-LABEL: test_256_20:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %ymm0, %ymm0, %k1 ## encoding: [0x62,0xf2,0x7d,0x28,0x27,0xc8]
; CHECK-NEXT:    vmovdqu32 (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7e,0xa9,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <8 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x i32>*
  %r = load <8 x i32>, <8 x i32>* %vaddr, align 1
  %res = select <8 x i1> %mask, <8 x i32> %r, <8 x i32> zeroinitializer
  ret <8 x i32>%res
}

define <4 x i64> @test_256_21(i8 * %addr, <4 x i64> %old, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_21:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm1, %ymm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x28,0x27,0xc9]
; CHECK-NEXT:    vmovdqa64 (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0xfd,0x29,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i64>*
  %r = load <4 x i64>, <4 x i64>* %vaddr, align 32
  %res = select <4 x i1> %mask, <4 x i64> %r, <4 x i64> %old
  ret <4 x i64>%res
}

define <4 x i64> @test_256_22(i8 * %addr, <4 x i64> %old, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_22:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm1, %ymm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x28,0x27,0xc9]
; CHECK-NEXT:    vmovdqu64 (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0xfe,0x29,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i64>*
  %r = load <4 x i64>, <4 x i64>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x i64> %r, <4 x i64> %old
  ret <4 x i64>%res
}

define <4 x i64> @test_256_23(i8 * %addr, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_23:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm0, %ymm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x28,0x27,0xc8]
; CHECK-NEXT:    vmovdqa64 (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfd,0xa9,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i64>*
  %r = load <4 x i64>, <4 x i64>* %vaddr, align 32
  %res = select <4 x i1> %mask, <4 x i64> %r, <4 x i64> zeroinitializer
  ret <4 x i64>%res
}

define <4 x i64> @test_256_24(i8 * %addr, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_24:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm0, %ymm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x28,0x27,0xc8]
; CHECK-NEXT:    vmovdqu64 (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfe,0xa9,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i64>*
  %r = load <4 x i64>, <4 x i64>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x i64> %r, <4 x i64> zeroinitializer
  ret <4 x i64>%res
}

define <8 x float> @test_256_25(i8 * %addr, <8 x float> %old, <8 x float> %mask1) {
; CHECK-LABEL: test_256_25:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpxor %xmm2, %xmm2, %xmm2 ## EVEX TO VEX Compression encoding: [0xc5,0xe9,0xef,0xd2]
; CHECK-NEXT:    vcmpneq_oqps %ymm2, %ymm1, %k1 ## encoding: [0x62,0xf1,0x74,0x28,0xc2,0xca,0x0c]
; CHECK-NEXT:    vmovaps (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0x7c,0x29,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = fcmp one <8 x float> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x float>*
  %r = load <8 x float>, <8 x float>* %vaddr, align 32
  %res = select <8 x i1> %mask, <8 x float> %r, <8 x float> %old
  ret <8 x float>%res
}

define <8 x float> @test_256_26(i8 * %addr, <8 x float> %old, <8 x float> %mask1) {
; CHECK-LABEL: test_256_26:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpxor %xmm2, %xmm2, %xmm2 ## EVEX TO VEX Compression encoding: [0xc5,0xe9,0xef,0xd2]
; CHECK-NEXT:    vcmpneq_oqps %ymm2, %ymm1, %k1 ## encoding: [0x62,0xf1,0x74,0x28,0xc2,0xca,0x0c]
; CHECK-NEXT:    vmovups (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0x7c,0x29,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = fcmp one <8 x float> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x float>*
  %r = load <8 x float>, <8 x float>* %vaddr, align 1
  %res = select <8 x i1> %mask, <8 x float> %r, <8 x float> %old
  ret <8 x float>%res
}

define <8 x float> @test_256_27(i8 * %addr, <8 x float> %mask1) {
; CHECK-LABEL: test_256_27:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf1,0xef,0xc9]
; CHECK-NEXT:    vcmpneq_oqps %ymm1, %ymm0, %k1 ## encoding: [0x62,0xf1,0x7c,0x28,0xc2,0xc9,0x0c]
; CHECK-NEXT:    vmovaps (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7c,0xa9,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = fcmp one <8 x float> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x float>*
  %r = load <8 x float>, <8 x float>* %vaddr, align 32
  %res = select <8 x i1> %mask, <8 x float> %r, <8 x float> zeroinitializer
  ret <8 x float>%res
}

define <8 x float> @test_256_28(i8 * %addr, <8 x float> %mask1) {
; CHECK-LABEL: test_256_28:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf1,0xef,0xc9]
; CHECK-NEXT:    vcmpneq_oqps %ymm1, %ymm0, %k1 ## encoding: [0x62,0xf1,0x7c,0x28,0xc2,0xc9,0x0c]
; CHECK-NEXT:    vmovups (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7c,0xa9,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = fcmp one <8 x float> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <8 x float>*
  %r = load <8 x float>, <8 x float>* %vaddr, align 1
  %res = select <8 x i1> %mask, <8 x float> %r, <8 x float> zeroinitializer
  ret <8 x float>%res
}

define <4 x double> @test_256_29(i8 * %addr, <4 x double> %old, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_29:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm1, %ymm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x28,0x27,0xc9]
; CHECK-NEXT:    vmovapd (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0xfd,0x29,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x double>*
  %r = load <4 x double>, <4 x double>* %vaddr, align 32
  %res = select <4 x i1> %mask, <4 x double> %r, <4 x double> %old
  ret <4 x double>%res
}

define <4 x double> @test_256_30(i8 * %addr, <4 x double> %old, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_30:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm1, %ymm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x28,0x27,0xc9]
; CHECK-NEXT:    vmovupd (%rdi), %ymm0 {%k1} ## encoding: [0x62,0xf1,0xfd,0x29,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x double>*
  %r = load <4 x double>, <4 x double>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x double> %r, <4 x double> %old
  ret <4 x double>%res
}

define <4 x double> @test_256_31(i8 * %addr, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_31:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm0, %ymm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x28,0x27,0xc8]
; CHECK-NEXT:    vmovapd (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfd,0xa9,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x double>*
  %r = load <4 x double>, <4 x double>* %vaddr, align 32
  %res = select <4 x i1> %mask, <4 x double> %r, <4 x double> zeroinitializer
  ret <4 x double>%res
}

define <4 x double> @test_256_32(i8 * %addr, <4 x i64> %mask1) {
; CHECK-LABEL: test_256_32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %ymm0, %ymm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x28,0x27,0xc8]
; CHECK-NEXT:    vmovupd (%rdi), %ymm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfd,0xa9,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x double>*
  %r = load <4 x double>, <4 x double>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x double> %r, <4 x double> zeroinitializer
  ret <4 x double>%res
}

define <4 x i32> @test_128_1(i8 * %addr) {
; CHECK-LABEL: test_128_1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i32>*
  %res = load <4 x i32>, <4 x i32>* %vaddr, align 1
  ret <4 x i32>%res
}

define <4 x i32> @test_128_2(i8 * %addr) {
; CHECK-LABEL: test_128_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i32>*
  %res = load <4 x i32>, <4 x i32>* %vaddr, align 16
  ret <4 x i32>%res
}

define void @test_128_3(i8 * %addr, <2 x i64> %data) {
; CHECK-LABEL: test_128_3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x i64>*
  store <2 x i64>%data, <2 x i64>* %vaddr, align 16
  ret void
}

define void @test_128_4(i8 * %addr, <4 x i32> %data) {
; CHECK-LABEL: test_128_4:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i32>*
  store <4 x i32>%data, <4 x i32>* %vaddr, align 1
  ret void
}

define void @test_128_5(i8 * %addr, <4 x i32> %data) {
; CHECK-LABEL: test_128_5:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x i32>*
  store <4 x i32>%data, <4 x i32>* %vaddr, align 16
  ret void
}

define  <2 x i64> @test_128_6(i8 * %addr) {
; CHECK-LABEL: test_128_6:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x i64>*
  %res = load <2 x i64>, <2 x i64>* %vaddr, align 16
  ret <2 x i64>%res
}

define void @test_128_7(i8 * %addr, <2 x i64> %data) {
; CHECK-LABEL: test_128_7:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x i64>*
  store <2 x i64>%data, <2 x i64>* %vaddr, align 1
  ret void
}

define <2 x i64> @test_128_8(i8 * %addr) {
; CHECK-LABEL: test_128_8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x i64>*
  %res = load <2 x i64>, <2 x i64>* %vaddr, align 1
  ret <2 x i64>%res
}

define void @test_128_9(i8 * %addr, <2 x double> %data) {
; CHECK-LABEL: test_128_9:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x double>*
  store <2 x double>%data, <2 x double>* %vaddr, align 16
  ret void
}

define <2 x double> @test_128_10(i8 * %addr) {
; CHECK-LABEL: test_128_10:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x double>*
  %res = load <2 x double>, <2 x double>* %vaddr, align 16
  ret <2 x double>%res
}

define void @test_128_11(i8 * %addr, <4 x float> %data) {
; CHECK-LABEL: test_128_11:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x29,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x float>*
  store <4 x float>%data, <4 x float>* %vaddr, align 16
  ret void
}

define <4 x float> @test_128_12(i8 * %addr) {
; CHECK-LABEL: test_128_12:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x float>*
  %res = load <4 x float>, <4 x float>* %vaddr, align 16
  ret <4 x float>%res
}

define void @test_128_13(i8 * %addr, <2 x double> %data) {
; CHECK-LABEL: test_128_13:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x double>*
  store <2 x double>%data, <2 x double>* %vaddr, align 1
  ret void
}

define <2 x double> @test_128_14(i8 * %addr) {
; CHECK-LABEL: test_128_14:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <2 x double>*
  %res = load <2 x double>, <2 x double>* %vaddr, align 1
  ret <2 x double>%res
}

define void @test_128_15(i8 * %addr, <4 x float> %data) {
; CHECK-LABEL: test_128_15:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups %xmm0, (%rdi) ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x11,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x float>*
  store <4 x float>%data, <4 x float>* %vaddr, align 1
  ret void
}

define <4 x float> @test_128_16(i8 * %addr) {
; CHECK-LABEL: test_128_16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovups (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf8,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %vaddr = bitcast i8* %addr to <4 x float>*
  %res = load <4 x float>, <4 x float>* %vaddr, align 1
  ret <4 x float>%res
}

define <4 x i32> @test_128_17(i8 * %addr, <4 x i32> %old, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_17:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0x75,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovdqa32 (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0x7d,0x09,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i32>*
  %r = load <4 x i32>, <4 x i32>* %vaddr, align 16
  %res = select <4 x i1> %mask, <4 x i32> %r, <4 x i32> %old
  ret <4 x i32>%res
}

define <4 x i32> @test_128_18(i8 * %addr, <4 x i32> %old, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_18:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0x75,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovdqu32 (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0x7e,0x09,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i32>*
  %r = load <4 x i32>, <4 x i32>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x i32> %r, <4 x i32> %old
  ret <4 x i32>%res
}

define <4 x i32> @test_128_19(i8 * %addr, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_19:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0x7d,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovdqa32 (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7d,0x89,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i32>*
  %r = load <4 x i32>, <4 x i32>* %vaddr, align 16
  %res = select <4 x i1> %mask, <4 x i32> %r, <4 x i32> zeroinitializer
  ret <4 x i32>%res
}

define <4 x i32> @test_128_20(i8 * %addr, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_20:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0x7d,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovdqu32 (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7e,0x89,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x i32>*
  %r = load <4 x i32>, <4 x i32>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x i32> %r, <4 x i32> zeroinitializer
  ret <4 x i32>%res
}

define <2 x i64> @test_128_21(i8 * %addr, <2 x i64> %old, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_21:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovdqa64 (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0xfd,0x09,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x i64>*
  %r = load <2 x i64>, <2 x i64>* %vaddr, align 16
  %res = select <2 x i1> %mask, <2 x i64> %r, <2 x i64> %old
  ret <2 x i64>%res
}

define <2 x i64> @test_128_22(i8 * %addr, <2 x i64> %old, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_22:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovdqu64 (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0xfe,0x09,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x i64>*
  %r = load <2 x i64>, <2 x i64>* %vaddr, align 1
  %res = select <2 x i1> %mask, <2 x i64> %r, <2 x i64> %old
  ret <2 x i64>%res
}

define <2 x i64> @test_128_23(i8 * %addr, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_23:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovdqa64 (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfd,0x89,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x i64>*
  %r = load <2 x i64>, <2 x i64>* %vaddr, align 16
  %res = select <2 x i1> %mask, <2 x i64> %r, <2 x i64> zeroinitializer
  ret <2 x i64>%res
}

define <2 x i64> @test_128_24(i8 * %addr, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_24:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovdqu64 (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfe,0x89,0x6f,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x i64>*
  %r = load <2 x i64>, <2 x i64>* %vaddr, align 1
  %res = select <2 x i1> %mask, <2 x i64> %r, <2 x i64> zeroinitializer
  ret <2 x i64>%res
}

define <4 x float> @test_128_25(i8 * %addr, <4 x float> %old, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_25:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0x75,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovaps (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0x7c,0x09,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x float>*
  %r = load <4 x float>, <4 x float>* %vaddr, align 16
  %res = select <4 x i1> %mask, <4 x float> %r, <4 x float> %old
  ret <4 x float>%res
}

define <4 x float> @test_128_26(i8 * %addr, <4 x float> %old, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_26:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0x75,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovups (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0x7c,0x09,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x float>*
  %r = load <4 x float>, <4 x float>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x float> %r, <4 x float> %old
  ret <4 x float>%res
}

define <4 x float> @test_128_27(i8 * %addr, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_27:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0x7d,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovaps (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7c,0x89,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x float>*
  %r = load <4 x float>, <4 x float>* %vaddr, align 16
  %res = select <4 x i1> %mask, <4 x float> %r, <4 x float> zeroinitializer
  ret <4 x float>%res
}

define <4 x float> @test_128_28(i8 * %addr, <4 x i32> %mask1) {
; CHECK-LABEL: test_128_28:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmd %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0x7d,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovups (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0x7c,0x89,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <4 x i32> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <4 x float>*
  %r = load <4 x float>, <4 x float>* %vaddr, align 1
  %res = select <4 x i1> %mask, <4 x float> %r, <4 x float> zeroinitializer
  ret <4 x float>%res
}

define <2 x double> @test_128_29(i8 * %addr, <2 x double> %old, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_29:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovapd (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0xfd,0x09,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x double>*
  %r = load <2 x double>, <2 x double>* %vaddr, align 16
  %res = select <2 x i1> %mask, <2 x double> %r, <2 x double> %old
  ret <2 x double>%res
}

define <2 x double> @test_128_30(i8 * %addr, <2 x double> %old, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_30:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm1, %xmm1, %k1 ## encoding: [0x62,0xf2,0xf5,0x08,0x27,0xc9]
; CHECK-NEXT:    vmovupd (%rdi), %xmm0 {%k1} ## encoding: [0x62,0xf1,0xfd,0x09,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x double>*
  %r = load <2 x double>, <2 x double>* %vaddr, align 1
  %res = select <2 x i1> %mask, <2 x double> %r, <2 x double> %old
  ret <2 x double>%res
}

define <2 x double> @test_128_31(i8 * %addr, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_31:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovapd (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfd,0x89,0x28,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x double>*
  %r = load <2 x double>, <2 x double>* %vaddr, align 16
  %res = select <2 x i1> %mask, <2 x double> %r, <2 x double> zeroinitializer
  ret <2 x double>%res
}

define <2 x double> @test_128_32(i8 * %addr, <2 x i64> %mask1) {
; CHECK-LABEL: test_128_32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %xmm0, %xmm0, %k1 ## encoding: [0x62,0xf2,0xfd,0x08,0x27,0xc8]
; CHECK-NEXT:    vmovupd (%rdi), %xmm0 {%k1} {z} ## encoding: [0x62,0xf1,0xfd,0x89,0x10,0x07]
; CHECK-NEXT:    retq ## encoding: [0xc3]
  %mask = icmp ne <2 x i64> %mask1, zeroinitializer
  %vaddr = bitcast i8* %addr to <2 x double>*
  %r = load <2 x double>, <2 x double>* %vaddr, align 1
  %res = select <2 x i1> %mask, <2 x double> %r, <2 x double> zeroinitializer
  ret <2 x double>%res
}

