; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define i8 @shl_and(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: shl_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    leal (,%rdi,8), %eax
; CHECK-NEXT:    andb %sil, %al
; CHECK-NEXT:    shlb $2, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %sh0 = shl i8 %x, 3
  %r = and i8 %sh0, %y
  %sh1 = shl i8 %r, 2
  ret i8 %sh1
}

define i16 @shl_or(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: shl_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shll $5, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    shll $7, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %sh0 = shl i16 %x, 5
  %r = or i16 %y, %sh0
  %sh1 = shl i16 %r, 7
  ret i16 %sh1
}

define i32 @shl_xor(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: shl_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shll $5, %eax
; CHECK-NEXT:    xorl %esi, %eax
; CHECK-NEXT:    shll $7, %eax
; CHECK-NEXT:    retq
  %sh0 = shl i32 %x, 5
  %r = xor i32 %sh0, %y
  %sh1 = shl i32 %r, 7
  ret i32 %sh1
}

define i64 @lshr_and(i64 %x, i64 %y) nounwind {
; CHECK-LABEL: lshr_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    shrq $5, %rax
; CHECK-NEXT:    andq %rsi, %rax
; CHECK-NEXT:    shrq $7, %rax
; CHECK-NEXT:    retq
  %sh0 = lshr i64 %x, 5
  %r = and i64 %y, %sh0
  %sh1 = lshr i64 %r, 7
  ret i64 %sh1
}

define <4 x i32> @lshr_or(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: lshr_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psrld $5, %xmm0
; CHECK-NEXT:    por %xmm1, %xmm0
; CHECK-NEXT:    psrld $7, %xmm0
; CHECK-NEXT:    retq
  %sh0 = lshr <4 x i32> %x, <i32 5, i32 5, i32 5, i32 5>
  %r = or <4 x i32> %sh0, %y
  %sh1 = lshr <4 x i32> %r, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %sh1
}

define <8 x i16> @lshr_xor(<8 x i16> %x, <8 x i16> %y) nounwind {
; CHECK-LABEL: lshr_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psrlw $5, %xmm0
; CHECK-NEXT:    pxor %xmm1, %xmm0
; CHECK-NEXT:    psrlw $7, %xmm0
; CHECK-NEXT:    retq
  %sh0 = lshr <8 x i16> %x, <i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5>
  %r = xor <8 x i16> %y, %sh0
  %sh1 = lshr <8 x i16> %r, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %sh1
}


define <16 x i8> @ashr_and(<16 x i8> %x, <16 x i8> %y) nounwind {
; CHECK-LABEL: ashr_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psrlw $3, %xmm0
; CHECK-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-NEXT:    movdqa {{.*#+}} xmm2 = [16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]
; CHECK-NEXT:    pxor %xmm2, %xmm0
; CHECK-NEXT:    psubb %xmm2, %xmm0
; CHECK-NEXT:    pand %xmm1, %xmm0
; CHECK-NEXT:    psrlw $2, %xmm0
; CHECK-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-NEXT:    movdqa {{.*#+}} xmm1 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; CHECK-NEXT:    pxor %xmm1, %xmm0
; CHECK-NEXT:    psubb %xmm1, %xmm0
; CHECK-NEXT:    retq
  %sh0 = ashr <16 x i8> %x, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %r = and <16 x i8> %y, %sh0
  %sh1 = ashr <16 x i8> %r, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <16 x i8> %sh1
}

define <2 x i64> @ashr_or(<2 x i64> %x, <2 x i64> %y) nounwind {
; CHECK-LABEL: ashr_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa %xmm0, %xmm2
; CHECK-NEXT:    psrad $5, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; CHECK-NEXT:    psrlq $5, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; CHECK-NEXT:    por %xmm1, %xmm0
; CHECK-NEXT:    movdqa %xmm0, %xmm1
; CHECK-NEXT:    psrad $7, %xmm1
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; CHECK-NEXT:    psrlq $7, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-NEXT:    retq
  %sh0 = ashr <2 x i64> %x, <i64 5, i64 5>
  %r = or <2 x i64> %sh0, %y
  %sh1 = ashr <2 x i64> %r, <i64 7, i64 7>
  ret <2 x i64> %sh1
}

define i32 @ashr_xor(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: ashr_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    sarl $5, %eax
; CHECK-NEXT:    xorl %esi, %eax
; CHECK-NEXT:    sarl $7, %eax
; CHECK-NEXT:    retq
  %sh0 = ashr i32 %x, 5
  %r = xor i32 %y, %sh0
  %sh1 = ashr i32 %r, 7
  ret i32 %sh1
}

define i32 @shr_mismatch_xor(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: shr_mismatch_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    sarl $5, %eax
; CHECK-NEXT:    xorl %esi, %eax
; CHECK-NEXT:    shrl $7, %eax
; CHECK-NEXT:    retq
  %sh0 = ashr i32 %x, 5
  %r = xor i32 %y, %sh0
  %sh1 = lshr i32 %r, 7
  ret i32 %sh1
}

define i32 @ashr_overshift_xor(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: ashr_overshift_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    sarl $15, %eax
; CHECK-NEXT:    xorl %esi, %eax
; CHECK-NEXT:    sarl $17, %eax
; CHECK-NEXT:    retq
  %sh0 = ashr i32 %x, 15
  %r = xor i32 %y, %sh0
  %sh1 = ashr i32 %r, 17
  ret i32 %sh1
}

define i32 @lshr_or_extra_use(i32 %x, i32 %y, i32* %p) nounwind {
; CHECK-LABEL: lshr_or_extra_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shrl $5, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    movl %eax, (%rdx)
; CHECK-NEXT:    shrl $7, %eax
; CHECK-NEXT:    retq
  %sh0 = lshr i32 %x, 5
  %r = or i32 %sh0, %y
  store i32 %r, i32* %p
  %sh1 = lshr i32 %r, 7
  ret i32 %sh1
}
