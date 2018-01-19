; MemCpy optimizations should take place even in presence of invariant.start
; RUN: opt < %s -basicaa -memcpyopt -dse -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

target triple = "i686-apple-darwin9"

%0 = type { x86_fp80, x86_fp80 }
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1)
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1)

declare {}* @llvm.invariant.start.p0i8(i64, i8* nocapture) nounwind readonly

; FIXME: The invariant.start does not modify %P.
; The intermediate alloca and one of the memcpy's should be eliminated, the
; other should be transformed to a memmove.
define void @test1(i8* %P, i8* %Q) nounwind  {
  %memtmp = alloca %0, align 16
  %R = bitcast %0* %memtmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %R, i8* align 16 %P, i32 32, i1 false)
  %i = call {}* @llvm.invariant.start.p0i8(i64 32, i8* %P)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %Q, i8* align 16 %R, i32 32, i1 false)
  ret void
; CHECK-LABEL: @test1(
; CHECK-NEXT: %memtmp = alloca %0, align 16
; CHECK-NEXT: %R = bitcast %0* %memtmp to i8*
; CHECK-NEXT: call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %R, i8* align 16 %P, i32 32, i1 false)
; CHECK-NEXT: %i = call {}* @llvm.invariant.start.p0i8(i64 32, i8* %P)
; CHECK-NEXT: call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %Q, i8* align 16 %R, i32 32, i1 false)
; CHECK-NEXT: ret void
}


; The invariant.start intrinsic does not inhibit tranforming the memcpy to a
; memset.
define void @test2(i8* %dst1, i8* %dst2, i8 %c) {
; CHECK-LABEL: define void @test2(
; CHECK-NEXT: call void @llvm.memset.p0i8.i64(i8* %dst1, i8 %c, i64 128, i1 false)
; CHECK-NEXT: %i = call {}* @llvm.invariant.start.p0i8(i64 32, i8* %dst1)
; CHECK-NEXT: call void @llvm.memset.p0i8.i64(i8* align 8 %dst2, i8 %c, i64 128, i1 false)
; CHECK-NEXT: ret void
  call void @llvm.memset.p0i8.i64(i8* %dst1, i8 %c, i64 128, i1 false)
  %i = call {}* @llvm.invariant.start.p0i8(i64 32, i8* %dst1)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %dst2, i8* align 8 %dst1, i64 128, i1 false)
  ret void
}
