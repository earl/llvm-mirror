; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+sse2 < %s | FileCheck %s --check-prefixes=CHECK,SSE2
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 < %s | FileCheck %s --check-prefixes=CHECK,SSE41

define i32 @test_eq_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_eq_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_eq_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp eq <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ne_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_ne_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_ne_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp ne <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_le_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_le_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sle <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ge_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_ge_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_ge_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sge <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_lt_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_lt_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_lt_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp slt <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_gt_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_gt_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sgt <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_eq_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_eq_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_eq_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp eq <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ne_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_ne_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_ne_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp ne <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_le_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_le_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_le_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sle <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ge_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_ge_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sge <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_lt_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_lt_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_lt_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp slt <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_gt_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_gt_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_gt_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sgt <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

; (and (setne X, 0), (setne X, -1)) --> (setuge (add X, 1), 2)
; Don't combine with i1 - out of range constant
define void @test_i1_uge(i1 *%A2) {
; CHECK-LABEL: test_i1_uge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb (%rdi), %al
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    xorb $1, %cl
; CHECK-NEXT:    andb %cl, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    negq %rax
; CHECK-NEXT:    andb $1, %cl
; CHECK-NEXT:    movb %cl, (%rdi,%rax)
; CHECK-NEXT:    retq
  %L5 = load i1, i1* %A2
  %C3 = icmp ne i1 %L5, true
  %C8 = icmp eq i1 %L5, false
  %C9 = icmp ugt i1 %C3, %C8
  %G3 = getelementptr i1, i1* %A2, i1 %C9
  store i1 %C3, i1* %G3
  ret void
}

