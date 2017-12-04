; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=skylake-avx512 < %s | FileCheck %s --check-prefix=ALL --check-prefix=SKX
; RUN: llc -mcpu=knl < %s | FileCheck %s --check-prefix=ALL --check-prefix=KNL

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"



define <16 x float> @test1(float* %base) {
; SKX-LABEL: test1:
; SKX:       # %bb.0:
; SKX-NEXT:    movw $-2049, %ax # imm = 0xF7FF
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps (%rdi), %zmm0 {%k1} {z}
; SKX-NEXT:    retq
;
; KNL-LABEL: test1:
; KNL:       # %bb.0:
; KNL-NEXT:    movw $-2049, %ax # imm = 0xF7FF
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vexpandps (%rdi), %zmm0 {%k1} {z}
; KNL-NEXT:    retq
  %res = call <16 x float> @llvm.masked.expandload.v16f32(float* %base, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 true>, <16 x float> undef)
  ret <16 x float>%res
}

define <16 x float> @test2(float* %base, <16 x float> %src0) {
; SKX-LABEL: test2:
; SKX:       # %bb.0:
; SKX-NEXT:    movw $30719, %ax # imm = 0x77FF
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps (%rdi), %zmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test2:
; KNL:       # %bb.0:
; KNL-NEXT:    movw $30719, %ax # imm = 0x77FF
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vexpandps (%rdi), %zmm0 {%k1}
; KNL-NEXT:    retq
  %res = call <16 x float> @llvm.masked.expandload.v16f32(float* %base, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 false>, <16 x float> %src0)
  ret <16 x float>%res
}

define <8 x double> @test3(double* %base, <8 x double> %src0, <8 x i1> %mask) {
; SKX-LABEL: test3:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsllw $15, %xmm1, %xmm1
; SKX-NEXT:    vpmovw2m %xmm1, %k1
; SKX-NEXT:    vexpandpd (%rdi), %zmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test3:
; KNL:       # %bb.0:
; KNL-NEXT:    vpmovsxwq %xmm1, %zmm1
; KNL-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL-NEXT:    vexpandpd (%rdi), %zmm0 {%k1}
; KNL-NEXT:    retq
  %res = call <8 x double> @llvm.masked.expandload.v8f64(double* %base, <8 x i1> %mask, <8 x double> %src0)
  ret <8 x double>%res
}

define <4 x float> @test4(float* %base, <4 x float> %src0) {
; SKX-LABEL: test4:
; SKX:       # %bb.0:
; SKX-NEXT:    movb $7, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps (%rdi), %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test4:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<def>
; KNL-NEXT:    movw $7, %ax
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vexpandps (%rdi), %zmm0 {%k1}
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<kill>
; KNL-NEXT:    retq
  %res = call <4 x float> @llvm.masked.expandload.v4f32(float* %base, <4 x i1> <i1 true, i1 true, i1 true, i1 false>, <4 x float> %src0)
  ret <4 x float>%res
}

define <2 x i64> @test5(i64* %base, <2 x i64> %src0) {
; SKX-LABEL: test5:
; SKX:       # %bb.0:
; SKX-NEXT:    movb $2, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandq (%rdi), %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test5:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<def>
; KNL-NEXT:    movb $2, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandq (%rdi), %zmm0 {%k1}
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<kill>
; KNL-NEXT:    retq
  %res = call <2 x i64> @llvm.masked.expandload.v2i64(i64* %base, <2 x i1> <i1 false, i1 true>, <2 x i64> %src0)
  ret <2 x i64>%res
}

declare <16 x float> @llvm.masked.expandload.v16f32(float*, <16 x i1>, <16 x float>)
declare <8 x double> @llvm.masked.expandload.v8f64(double*, <8 x i1>, <8 x double>)
declare <4 x float>  @llvm.masked.expandload.v4f32(float*, <4 x i1>, <4 x float>)
declare <2 x i64>    @llvm.masked.expandload.v2i64(i64*, <2 x i1>, <2 x i64>)

define void @test6(float* %base, <16 x float> %V) {
; SKX-LABEL: test6:
; SKX:       # %bb.0:
; SKX-NEXT:    movw $-2049, %ax # imm = 0xF7FF
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vcompressps %zmm0, (%rdi) {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test6:
; KNL:       # %bb.0:
; KNL-NEXT:    movw $-2049, %ax # imm = 0xF7FF
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vcompressps %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
  call void @llvm.masked.compressstore.v16f32(<16 x float> %V, float* %base, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 true, i1 true, i1 true, i1 true>)
  ret void
}

define void @test7(float* %base, <8 x float> %V, <8 x i1> %mask) {
; SKX-LABEL: test7:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsllw $15, %xmm1, %xmm1
; SKX-NEXT:    vpmovw2m %xmm1, %k1
; SKX-NEXT:    vcompressps %ymm0, (%rdi) {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test7:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %ymm0<def> %ymm0<kill> %zmm0<def>
; KNL-NEXT:    vpmovsxwq %xmm1, %zmm1
; KNL-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL-NEXT:    vcompressps %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
  call void @llvm.masked.compressstore.v8f32(<8 x float> %V, float* %base, <8 x i1> %mask)
  ret void
}

define void @test8(double* %base, <8 x double> %V, <8 x i1> %mask) {
; SKX-LABEL: test8:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsllw $15, %xmm1, %xmm1
; SKX-NEXT:    vpmovw2m %xmm1, %k1
; SKX-NEXT:    vcompresspd %zmm0, (%rdi) {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test8:
; KNL:       # %bb.0:
; KNL-NEXT:    vpmovsxwq %xmm1, %zmm1
; KNL-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL-NEXT:    vcompresspd %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
  call void @llvm.masked.compressstore.v8f64(<8 x double> %V, double* %base, <8 x i1> %mask)
  ret void
}

define void @test9(i64* %base, <8 x i64> %V, <8 x i1> %mask) {
; SKX-LABEL: test9:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsllw $15, %xmm1, %xmm1
; SKX-NEXT:    vpmovw2m %xmm1, %k1
; SKX-NEXT:    vpcompressq %zmm0, (%rdi) {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test9:
; KNL:       # %bb.0:
; KNL-NEXT:    vpmovsxwq %xmm1, %zmm1
; KNL-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL-NEXT:    vpcompressq %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
    call void @llvm.masked.compressstore.v8i64(<8 x i64> %V, i64* %base, <8 x i1> %mask)
  ret void
}

define void @test10(i64* %base, <4 x i64> %V, <4 x i1> %mask) {
; SKX-LABEL: test10:
; SKX:       # %bb.0:
; SKX-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX-NEXT:    vpcompressq %ymm0, (%rdi) {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test10:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %ymm0<def> %ymm0<kill> %zmm0<def>
; KNL-NEXT:    vpslld $31, %xmm1, %xmm1
; KNL-NEXT:    vpsrad $31, %xmm1, %xmm1
; KNL-NEXT:    vpmovsxdq %xmm1, %ymm1
; KNL-NEXT:    vmovdqa %ymm1, %ymm1
; KNL-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL-NEXT:    vpcompressq %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
    call void @llvm.masked.compressstore.v4i64(<4 x i64> %V, i64* %base, <4 x i1> %mask)
  ret void
}

define void @test11(i64* %base, <2 x i64> %V, <2 x i1> %mask) {
; SKX-LABEL: test11:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX-NEXT:    vpcompressq %xmm0, (%rdi) {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test11:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<def>
; KNL-NEXT:    vpsllq $63, %xmm1, %xmm1
; KNL-NEXT:    vpsraq $63, %zmm1, %zmm1
; KNL-NEXT:    vmovdqa %xmm1, %xmm1
; KNL-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL-NEXT:    vpcompressq %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
    call void @llvm.masked.compressstore.v2i64(<2 x i64> %V, i64* %base, <2 x i1> %mask)
  ret void
}

define void @test12(float* %base, <4 x float> %V, <4 x i1> %mask) {
; SKX-LABEL: test12:
; SKX:       # %bb.0:
; SKX-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX-NEXT:    vcompressps %xmm0, (%rdi) {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test12:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<def>
; KNL-NEXT:    vpslld $31, %xmm1, %xmm1
; KNL-NEXT:    vpsrad $31, %xmm1, %xmm1
; KNL-NEXT:    vmovdqa %xmm1, %xmm1
; KNL-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vcompressps %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
    call void @llvm.masked.compressstore.v4f32(<4 x float> %V, float* %base, <4 x i1> %mask)
  ret void
}

define <2 x float> @test13(float* %base, <2 x float> %src0, <2 x i32> %trigger) {
; SKX-LABEL: test13:
; SKX:       # %bb.0:
; SKX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; SKX-NEXT:    vpcmpeqq %xmm2, %xmm1, %k1
; SKX-NEXT:    vexpandps (%rdi), %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test13:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<def>
; KNL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; KNL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; KNL-NEXT:    vpcmpeqq %xmm2, %xmm1, %xmm1
; KNL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,2],zero,zero
; KNL-NEXT:    vmovaps %xmm1, %xmm1
; KNL-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vexpandps (%rdi), %zmm0 {%k1}
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<kill>
; KNL-NEXT:    retq
  %mask = icmp eq <2 x i32> %trigger, zeroinitializer
  %res = call <2 x float> @llvm.masked.expandload.v2f32(float* %base, <2 x i1> %mask, <2 x float> %src0)
  ret <2 x float> %res
}

define void @test14(float* %base, <2 x float> %V, <2 x i32> %trigger) {
; SKX-LABEL: test14:
; SKX:       # %bb.0:
; SKX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; SKX-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; SKX-NEXT:    vpcmpeqq %xmm2, %xmm1, %k1
; SKX-NEXT:    vcompressps %xmm0, (%rdi) {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test14:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: %xmm0<def> %xmm0<kill> %zmm0<def>
; KNL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; KNL-NEXT:    vpblendd {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2],xmm2[3]
; KNL-NEXT:    vpcmpeqq %xmm2, %xmm1, %xmm1
; KNL-NEXT:    vinsertps {{.*#+}} xmm1 = xmm1[0,2],zero,zero
; KNL-NEXT:    vmovaps %xmm1, %xmm1
; KNL-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL-NEXT:    vcompressps %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
  %mask = icmp eq <2 x i32> %trigger, zeroinitializer
  call void @llvm.masked.compressstore.v2f32(<2 x float> %V, float* %base, <2 x i1> %mask)
  ret void
}

define <32 x float> @test15(float* %base, <32 x float> %src0, <32 x i32> %trigger) {
; ALL-LABEL: test15:
; ALL:       # %bb.0:
; ALL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; ALL-NEXT:    vpcmpeqd %zmm4, %zmm3, %k1
; ALL-NEXT:    vpcmpeqd %zmm4, %zmm2, %k2
; ALL-NEXT:    kmovw %k2, %eax
; ALL-NEXT:    popcntl %eax, %eax
; ALL-NEXT:    vexpandps (%rdi,%rax,4), %zmm1 {%k1}
; ALL-NEXT:    vexpandps (%rdi), %zmm0 {%k2}
; ALL-NEXT:    retq
  %mask = icmp eq <32 x i32> %trigger, zeroinitializer
  %res = call <32 x float> @llvm.masked.expandload.v32f32(float* %base, <32 x i1> %mask, <32 x float> %src0)
  ret <32 x float> %res
}

define <16 x double> @test16(double* %base, <16 x double> %src0, <16 x i32> %trigger) {
; SKX-LABEL: test16:
; SKX:       # %bb.0:
; SKX-NEXT:    vextracti64x4 $1, %zmm2, %ymm3
; SKX-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; SKX-NEXT:    vpcmpeqd %ymm4, %ymm3, %k1
; SKX-NEXT:    vpcmpeqd %ymm4, %ymm2, %k2
; SKX-NEXT:    kmovb %k2, %eax
; SKX-NEXT:    popcntl %eax, %eax
; SKX-NEXT:    vexpandpd (%rdi,%rax,8), %zmm1 {%k1}
; SKX-NEXT:    vexpandpd (%rdi), %zmm0 {%k2}
; SKX-NEXT:    retq
;
; KNL-LABEL: test16:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; KNL-NEXT:    vextracti64x4 $1, %zmm2, %ymm4
; KNL-NEXT:    vpcmpeqd %zmm3, %zmm4, %k1
; KNL-NEXT:    vpcmpeqd %zmm3, %zmm2, %k2
; KNL-NEXT:    vexpandpd (%rdi), %zmm0 {%k2}
; KNL-NEXT:    kmovw %k2, %eax
; KNL-NEXT:    movzbl %al, %eax
; KNL-NEXT:    popcntl %eax, %eax
; KNL-NEXT:    vexpandpd (%rdi,%rax,8), %zmm1 {%k1}
; KNL-NEXT:    retq
  %mask = icmp eq <16 x i32> %trigger, zeroinitializer
  %res = call <16 x double> @llvm.masked.expandload.v16f64(double* %base, <16 x i1> %mask, <16 x double> %src0)
  ret <16 x double> %res
}

define void @test17(float* %base, <32 x float> %V, <32 x i32> %trigger) {
; SKX-LABEL: test17:
; SKX:       # %bb.0:
; SKX-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; SKX-NEXT:    vpcmpeqd %zmm4, %zmm3, %k1
; SKX-NEXT:    vpcmpeqd %zmm4, %zmm2, %k2
; SKX-NEXT:    kmovw %k2, %eax
; SKX-NEXT:    popcntl %eax, %eax
; SKX-NEXT:    vcompressps %zmm1, (%rdi,%rax,4) {%k1}
; SKX-NEXT:    vcompressps %zmm0, (%rdi) {%k2}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test17:
; KNL:       # %bb.0:
; KNL-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; KNL-NEXT:    vpcmpeqd %zmm4, %zmm3, %k1
; KNL-NEXT:    vpcmpeqd %zmm4, %zmm2, %k2
; KNL-NEXT:    kmovw %k2, %eax
; KNL-NEXT:    popcntl %eax, %eax
; KNL-NEXT:    vcompressps %zmm1, (%rdi,%rax,4) {%k1}
; KNL-NEXT:    vcompressps %zmm0, (%rdi) {%k2}
; KNL-NEXT:    retq
  %mask = icmp eq <32 x i32> %trigger, zeroinitializer
  call void @llvm.masked.compressstore.v32f32(<32 x float> %V, float* %base, <32 x i1> %mask)
  ret void
}

define void @test18(double* %base, <16 x double> %V, <16 x i1> %mask) {
; SKX-LABEL: test18:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsllw $7, %xmm2, %xmm2
; SKX-NEXT:    vpmovb2m %xmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    kmovb %k1, %eax
; SKX-NEXT:    popcntl %eax, %eax
; SKX-NEXT:    vcompresspd %zmm1, (%rdi,%rax,8) {%k2}
; SKX-NEXT:    vcompresspd %zmm0, (%rdi) {%k1}
; SKX-NEXT:    vzeroupper
; SKX-NEXT:    retq
;
; KNL-LABEL: test18:
; KNL:       # %bb.0:
; KNL-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL-NEXT:    kshiftrw $8, %k1, %k2
; KNL-NEXT:    kmovw %k1, %eax
; KNL-NEXT:    movzbl %al, %eax
; KNL-NEXT:    popcntl %eax, %eax
; KNL-NEXT:    vcompresspd %zmm1, (%rdi,%rax,8) {%k2}
; KNL-NEXT:    vcompresspd %zmm0, (%rdi) {%k1}
; KNL-NEXT:    retq
  call void @llvm.masked.compressstore.v16f64(<16 x double> %V, double* %base, <16 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v16f32(<16 x float>, float* , <16 x i1>)
declare void @llvm.masked.compressstore.v8f32(<8 x float>, float* , <8 x i1>)
declare void @llvm.masked.compressstore.v8f64(<8 x double>, double* , <8 x i1>)
declare void @llvm.masked.compressstore.v16i32(<16 x i32>, i32* , <16 x i1>)
declare void @llvm.masked.compressstore.v8i32(<8 x i32>, i32* , <8 x i1>)
declare void @llvm.masked.compressstore.v8i64(<8 x i64>, i64* , <8 x i1>)
declare void @llvm.masked.compressstore.v4i32(<4 x i32>, i32* , <4 x i1>)
declare void @llvm.masked.compressstore.v4f32(<4 x float>, float* , <4 x i1>)
declare void @llvm.masked.compressstore.v4i64(<4 x i64>, i64* , <4 x i1>)
declare void @llvm.masked.compressstore.v2i64(<2 x i64>, i64* , <2 x i1>)
declare void @llvm.masked.compressstore.v2f32(<2 x float>, float* , <2 x i1>)
declare void @llvm.masked.compressstore.v32f32(<32 x float>, float* , <32 x i1>)
declare void @llvm.masked.compressstore.v16f64(<16 x double>, double* , <16 x i1>)
declare void @llvm.masked.compressstore.v32f64(<32 x double>, double* , <32 x i1>)

declare <2 x float> @llvm.masked.expandload.v2f32(float* , <2 x i1> , <2 x float> )
declare <32 x float> @llvm.masked.expandload.v32f32(float* , <32 x i1> , <32 x float> )
declare <16 x double> @llvm.masked.expandload.v16f64(double* , <16 x i1> , <16 x double> )
