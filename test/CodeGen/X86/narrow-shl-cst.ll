; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s
; PR5039

define i32 @test1(i32 %x) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $31, %eax
; CHECK-NEXT:    shll $10, %eax
; CHECK-NEXT:    retq
  %and = shl i32 %x, 10
  %shl = and i32 %and, 31744
  ret i32 %shl
}

define i32 @test2(i32 %x) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    orl $31, %eax
; CHECK-NEXT:    shll $10, %eax
; CHECK-NEXT:    retq
  %or = shl i32 %x, 10
  %shl = or i32 %or, 31744
  ret i32 %shl
}

define i32 @test3(i32 %x) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    xorl $31, %eax
; CHECK-NEXT:    shll $10, %eax
; CHECK-NEXT:    retq
  %xor = shl i32 %x, 10
  %shl = xor i32 %xor, 31744
  ret i32 %shl
}

define i64 @test4(i64 %x) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    andl $241, %eax
; CHECK-NEXT:    shlq $40, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 40
  %shl = and i64 %and, 264982302294016
  ret i64 %shl
}

define i64 @test5(i64 %x) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    andl $31, %eax
; CHECK-NEXT:    shlq $40, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 40
  %shl = and i64 %and, 34084860461056
  ret i64 %shl
}

define i64 @test6(i64 %x) nounwind {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    andl $-65536, %eax # imm = 0xFFFF0000
; CHECK-NEXT:    shlq $32, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 32
  %shl = and i64 %and, -281474976710656
  ret i64 %shl
}

define i64 @test7(i64 %x) nounwind {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    orq $241, %rax
; CHECK-NEXT:    shlq $40, %rax
; CHECK-NEXT:    retq
  %or = shl i64 %x, 40
  %shl = or i64 %or, 264982302294016
  ret i64 %shl
}

define i64 @test8(i64 %x) nounwind {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    orq $31, %rax
; CHECK-NEXT:    shlq $40, %rax
; CHECK-NEXT:    retq
  %or = shl i64 %x, 40
  %shl = or i64 %or, 34084860461056
  ret i64 %shl
}

define i64 @test9(i64 %x) nounwind {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    xorq $241, %rax
; CHECK-NEXT:    shlq $40, %rax
; CHECK-NEXT:    retq
  %xor = shl i64 %x, 40
  %shl = xor i64 %xor, 264982302294016
  ret i64 %shl
}

define i64 @test10(i64 %x) nounwind {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    xorq $31, %rax
; CHECK-NEXT:    shlq $40, %rax
; CHECK-NEXT:    retq
  %xor = shl i64 %x, 40
  %shl = xor i64 %xor, 34084860461056
  ret i64 %shl
}

define i64 @test11(i64 %x) nounwind {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    xorq $-65536, %rax # imm = 0xFFFF0000
; CHECK-NEXT:    shlq $33, %rax
; CHECK-NEXT:    retq
  %xor = shl i64 %x, 33
  %shl = xor i64 %xor, -562949953421312
  ret i64 %shl
}

; PR23098
define i32 @test12(i32 %x, i32* %y) nounwind {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addl %edi, %edi
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    movl %eax, (%rsi)
; CHECK-NEXT:    retq
  %and = shl i32 %x, 1
  %shl = and i32 %and, 255
  store i32 %shl, i32* %y
  ret i32 %shl
}

define i64 @test13(i64 %x, i64* %y) nounwind {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addl %edi, %edi
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    movq %rax, (%rsi)
; CHECK-NEXT:    retq
  %and = shl i64 %x, 1
  %shl = and i64 %and, 255
  store i64 %shl, i64* %y
  ret i64 %shl
}

define i64 @test14(i64 %x, i64* %y) nounwind {
; CHECK-LABEL: test14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    andl $-16777216, %eax # imm = 0xFF000000
; CHECK-NEXT:    shlq $8, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 8
  %shl = and i64 %and, 1095216660480
  ret i64 %shl
}

define i64 @test15(i64 %x, i64* %y) nounwind {
; CHECK-LABEL: test15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $4278190080, %eax # imm = 0xFF000000
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    shlq $8, %rax
; CHECK-NEXT:    retq
  %or = shl i64 %x, 8
  %shl = or i64 %or, 1095216660480
  ret i64 %shl
}

define i64 @test16(i64 %x, i64* %y) nounwind {
; CHECK-LABEL: test16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $4278190080, %eax # imm = 0xFF000000
; CHECK-NEXT:    xorq %rdi, %rax
; CHECK-NEXT:    shlq $8, %rax
; CHECK-NEXT:    retq
  %xor = shl i64 %x, 8
  %shl = xor i64 %xor, 1095216660480
  ret i64 %shl
}

define i32 @test17(i32 %x) nounwind {
; CHECK-LABEL: test17:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    shll $10, %eax
; CHECK-NEXT:    retq
  %and = shl i32 %x, 10
  %shl = and i32 %and, 261120
  ret i32 %shl
}

define i64 @test18(i64 %x) nounwind {
; CHECK-LABEL: test18:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    shlq $10, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 10
  %shl = and i64 %and, 261120
  ret i64 %shl
}

define i32 @test19(i32 %x) nounwind {
; CHECK-LABEL: test19:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl %di, %eax
; CHECK-NEXT:    shll $10, %eax
; CHECK-NEXT:    retq
  %and = shl i32 %x, 10
  %shl = and i32 %and, 67107840
  ret i32 %shl
}

define i64 @test20(i64 %x) nounwind {
; CHECK-LABEL: test20:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl %di, %eax
; CHECK-NEXT:    shlq $10, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 10
  %shl = and i64 %and, 67107840
  ret i64 %shl
}

define i64 @test21(i64 %x) nounwind {
; CHECK-LABEL: test21:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shlq $10, %rax
; CHECK-NEXT:    retq
  %and = shl i64 %x, 10
  %shl = and i64 %and, 4398046510080
  ret i64 %shl
}
