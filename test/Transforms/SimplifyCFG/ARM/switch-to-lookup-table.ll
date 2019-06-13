; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=static    < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=pic       < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=ropi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=rwpi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -simplifycfg -switch-to-lookup -mtriple=arm -relocation-model=ropi-rwpi < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE

; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=static    < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=pic       < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ENABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=ropi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=rwpi      < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' -mtriple=arm -relocation-model=ropi-rwpi < %s | FileCheck %s --check-prefix=CHECK --check-prefix=DISABLE

; CHECK:       @{{.*}} = private unnamed_addr constant [3 x i32] [i32 1234, i32 5678, i32 15532]
; ENABLE:      @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @c1, i32* @c2, i32* @c3]
; DISABLE-NOT: @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @c1, i32* @c2, i32* @c3]
; ENABLE:      @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @g1, i32* @g2, i32* @g3]
; DISABLE-NOT: @{{.*}} = private unnamed_addr constant [3 x i32*] [i32* @g1, i32* @g2, i32* @g3]
; ENABLE:      @{{.*}} = private unnamed_addr constant [3 x i32 (i32, i32)*] [i32 (i32, i32)* @f1, i32 (i32, i32)* @f2, i32 (i32, i32)* @f3]
; DISABLE-NOT: @{{.*}} = private unnamed_addr constant [3 x i32 (i32, i32)*] [i32 (i32, i32)* @f1, i32 (i32, i32)* @f2, i32 (i32, i32)* @f3]

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7a--none-eabi"

define i32 @test1(i32 %n) {
entry:
  switch i32 %n, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  ]

sw.bb:
  br label %return

sw.bb1:
  br label %return

sw.bb2:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32 [ 15498, %sw.default ], [ 15532, %sw.bb2 ], [ 5678, %sw.bb1 ], [ 1234, %sw.bb ]
  ret i32 %retval.0
}

@c1 = external constant i32, align 4
@c2 = external constant i32, align 4
@c3 = external constant i32, align 4
@c4 = external constant i32, align 4


define i32* @test2(i32 %n) {
entry:
  switch i32 %n, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  ]

sw.bb:
  br label %return

sw.bb1:
  br label %return

sw.bb2:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32* [ @c4, %sw.default ], [ @c3, %sw.bb2 ], [ @c2, %sw.bb1 ], [ @c1, %sw.bb ]
  ret i32* %retval.0
}

@g1 = external global i32, align 4
@g2 = external global i32, align 4
@g3 = external global i32, align 4
@g4 = external global i32, align 4

define i32* @test3(i32 %n) {
entry:
  switch i32 %n, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  ]

sw.bb:
  br label %return

sw.bb1:
  br label %return

sw.bb2:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32* [ @g4, %sw.default ], [ @g3, %sw.bb2 ], [ @g2, %sw.bb1 ], [ @g1, %sw.bb ]
  ret i32* %retval.0
}

declare i32 @f1(i32, i32)
declare i32 @f2(i32, i32)
declare i32 @f3(i32, i32)
declare i32 @f4(i32, i32)
declare i32 @f5(i32, i32)

define i32 @test4(i32 %a, i32 %b, i32 %c) {
entry:
  %cmp = icmp eq i32 %a, 1
  br i1 %cmp, label %cond.end11, label %cond.false

cond.false:
  %cmp1 = icmp eq i32 %a, 2
  br i1 %cmp1, label %cond.end11, label %cond.false3

cond.false3:
  %cmp4 = icmp eq i32 %a, 3
  br i1 %cmp4, label %cond.end11, label %cond.false6

cond.false6:
  %cmp7 = icmp eq i32 %a, 4
  %cond = select i1 %cmp7, i32 (i32, i32)* @f4, i32 (i32, i32)* @f5
  br label %cond.end11

cond.end11:
  %cond12 = phi i32 (i32, i32)* [ @f1, %entry ], [ @f2, %cond.false ], [ %cond, %cond.false6 ], [ @f3, %cond.false3 ]
  %call = call i32 %cond12(i32 %b, i32 %c) #2
  ret i32 %call
}
