; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2

; PR37428 - https://bugs.llvm.org/show_bug.cgi?id=37428
; This is a larger-than-usual regression test to verify that several backend
; transforms are working together. We want to hoist the expansion of non-uniform
; vector shifts out of a loop if we do not have real vector shift instructions.
; See test/Transforms/CodeGenPrepare/X86/vec-shift.ll for the 1st step in that
; sequence.

define void @vector_variable_shift_left_loop(i32* nocapture %arr, i8* nocapture readonly %control, i32 %count, i32 %amt0, i32 %amt1) nounwind {
; SSE-LABEL: vector_variable_shift_left_loop:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    testl %edx, %edx
; SSE-NEXT:    jle .LBB0_9
; SSE-NEXT:  # %bb.1: # %for.body.preheader
; SSE-NEXT:    movl %ecx, %r9d
; SSE-NEXT:    movl %edx, %eax
; SSE-NEXT:    cmpl $31, %edx
; SSE-NEXT:    ja .LBB0_3
; SSE-NEXT:  # %bb.2:
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    jmp .LBB0_6
; SSE-NEXT:  .LBB0_3: # %vector.ph
; SSE-NEXT:    movl %eax, %edx
; SSE-NEXT:    andl $-32, %edx
; SSE-NEXT:    movd %r9d, %xmm0
; SSE-NEXT:    movd %r8d, %xmm1
; SSE-NEXT:    xorl %ecx, %ecx
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm14 = xmm1[0],zero,xmm1[1],zero
; SSE-NEXT:    pmovzxdq {{.*#+}} xmm15 = xmm0[0],zero,xmm0[1],zero
; SSE-NEXT:    .p2align 4, 0x90
; SSE-NEXT:  .LBB0_4: # %vector.body
; SSE-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm3 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm4 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm5 = mem[0],zero
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    pcmpeqb %xmm1, %xmm0
; SSE-NEXT:    pmovsxbd %xmm0, %xmm7
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE-NEXT:    pmovsxbd %xmm0, %xmm0
; SSE-NEXT:    pcmpeqb %xmm1, %xmm3
; SSE-NEXT:    pmovsxbd %xmm3, %xmm13
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[1,1,2,3]
; SSE-NEXT:    pmovsxbd %xmm3, %xmm6
; SSE-NEXT:    pcmpeqb %xmm1, %xmm4
; SSE-NEXT:    pmovsxbd %xmm4, %xmm11
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm4[1,1,2,3]
; SSE-NEXT:    pmovsxbd %xmm3, %xmm2
; SSE-NEXT:    pcmpeqb %xmm1, %xmm5
; SSE-NEXT:    pmovsxbd %xmm5, %xmm8
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm5[1,1,2,3]
; SSE-NEXT:    pmovsxbd %xmm3, %xmm9
; SSE-NEXT:    movdqu 16(%rdi,%rcx,4), %xmm3
; SSE-NEXT:    movdqa %xmm3, %xmm4
; SSE-NEXT:    pslld %xmm15, %xmm4
; SSE-NEXT:    pslld %xmm14, %xmm3
; SSE-NEXT:    blendvps %xmm0, %xmm4, %xmm3
; SSE-NEXT:    movdqu (%rdi,%rcx,4), %xmm10
; SSE-NEXT:    movdqa %xmm10, %xmm5
; SSE-NEXT:    pslld %xmm15, %xmm5
; SSE-NEXT:    pslld %xmm14, %xmm10
; SSE-NEXT:    movdqa %xmm7, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm5, %xmm10
; SSE-NEXT:    movdqu 48(%rdi,%rcx,4), %xmm12
; SSE-NEXT:    movdqa %xmm12, %xmm5
; SSE-NEXT:    pslld %xmm15, %xmm5
; SSE-NEXT:    pslld %xmm14, %xmm12
; SSE-NEXT:    movdqa %xmm6, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm5, %xmm12
; SSE-NEXT:    movdqu 32(%rdi,%rcx,4), %xmm6
; SSE-NEXT:    movdqa %xmm6, %xmm5
; SSE-NEXT:    pslld %xmm15, %xmm5
; SSE-NEXT:    pslld %xmm14, %xmm6
; SSE-NEXT:    movdqa %xmm13, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm5, %xmm6
; SSE-NEXT:    movdqu 80(%rdi,%rcx,4), %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm5
; SSE-NEXT:    pslld %xmm15, %xmm5
; SSE-NEXT:    pslld %xmm14, %xmm1
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm5, %xmm1
; SSE-NEXT:    movdqu 64(%rdi,%rcx,4), %xmm5
; SSE-NEXT:    movdqa %xmm5, %xmm2
; SSE-NEXT:    pslld %xmm15, %xmm2
; SSE-NEXT:    pslld %xmm14, %xmm5
; SSE-NEXT:    movdqa %xmm11, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm2, %xmm5
; SSE-NEXT:    movdqu 112(%rdi,%rcx,4), %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm4
; SSE-NEXT:    pslld %xmm15, %xmm4
; SSE-NEXT:    pslld %xmm14, %xmm2
; SSE-NEXT:    movdqa %xmm9, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm4, %xmm2
; SSE-NEXT:    movdqu 96(%rdi,%rcx,4), %xmm4
; SSE-NEXT:    movdqa %xmm4, %xmm7
; SSE-NEXT:    pslld %xmm15, %xmm7
; SSE-NEXT:    pslld %xmm14, %xmm4
; SSE-NEXT:    movdqa %xmm8, %xmm0
; SSE-NEXT:    blendvps %xmm0, %xmm7, %xmm4
; SSE-NEXT:    movups %xmm10, (%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm3, 16(%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm6, 32(%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm12, 48(%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm5, 64(%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm1, 80(%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm4, 96(%rdi,%rcx,4)
; SSE-NEXT:    movups %xmm2, 112(%rdi,%rcx,4)
; SSE-NEXT:    addq $32, %rcx
; SSE-NEXT:    cmpq %rcx, %rdx
; SSE-NEXT:    jne .LBB0_4
; SSE-NEXT:  # %bb.5: # %middle.block
; SSE-NEXT:    cmpq %rax, %rdx
; SSE-NEXT:    jne .LBB0_6
; SSE-NEXT:  .LBB0_9: # %for.cond.cleanup
; SSE-NEXT:    retq
; SSE-NEXT:    .p2align 4, 0x90
; SSE-NEXT:  .LBB0_8: # %for.body
; SSE-NEXT:    # in Loop: Header=BB0_6 Depth=1
; SSE-NEXT:    # kill: def $cl killed $cl killed $ecx
; SSE-NEXT:    shll %cl, (%rdi,%rdx,4)
; SSE-NEXT:    incq %rdx
; SSE-NEXT:    cmpq %rdx, %rax
; SSE-NEXT:    je .LBB0_9
; SSE-NEXT:  .LBB0_6: # %for.body
; SSE-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE-NEXT:    cmpb $0, (%rsi,%rdx)
; SSE-NEXT:    movl %r9d, %ecx
; SSE-NEXT:    je .LBB0_8
; SSE-NEXT:  # %bb.7: # %for.body
; SSE-NEXT:    # in Loop: Header=BB0_6 Depth=1
; SSE-NEXT:    movl %r8d, %ecx
; SSE-NEXT:    jmp .LBB0_8
;
; AVX1-LABEL: vector_variable_shift_left_loop:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    subq $24, %rsp
; AVX1-NEXT:    testl %edx, %edx
; AVX1-NEXT:    jle .LBB0_9
; AVX1-NEXT:  # %bb.1: # %for.body.preheader
; AVX1-NEXT:    movl %ecx, %r9d
; AVX1-NEXT:    movl %edx, %eax
; AVX1-NEXT:    cmpl $31, %edx
; AVX1-NEXT:    ja .LBB0_3
; AVX1-NEXT:  # %bb.2:
; AVX1-NEXT:    xorl %edx, %edx
; AVX1-NEXT:    jmp .LBB0_6
; AVX1-NEXT:  .LBB0_3: # %vector.ph
; AVX1-NEXT:    movl %eax, %edx
; AVX1-NEXT:    andl $-32, %edx
; AVX1-NEXT:    vmovd %r9d, %xmm0
; AVX1-NEXT:    vmovd %r8d, %xmm1
; AVX1-NEXT:    xorl %ecx, %ecx
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vmovdqa %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm2 = xmm0[0],zero,xmm0[1],zero
; AVX1-NEXT:    vmovdqa %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vmovdqa %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm13 = xmm0[0],zero,xmm0[1],zero
; AVX1-NEXT:    vmovdqu %ymm1, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm14 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vmovdqu %ymm0, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm15 = xmm0[0],zero,xmm0[1],zero
; AVX1-NEXT:    vpxor %xmm11, %xmm11, %xmm11
; AVX1-NEXT:    vmovdqa {{[-0-9]+}}(%r{{[sb]}}p), %xmm12 # 16-byte Reload
; AVX1-NEXT:    .p2align 4, 0x90
; AVX1-NEXT:  .LBB0_4: # %vector.body
; AVX1-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX1-NEXT:    vpmovzxdq {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Folded Reload
; AVX1-NEXT:    # xmm1 = mem[0],zero,mem[1],zero
; AVX1-NEXT:    vpmovzxdq {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Folded Reload
; AVX1-NEXT:    # xmm2 = mem[0],zero,mem[1],zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm3 = mem[0],zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm4 = mem[0],zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm5 = mem[0],zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm6 = mem[0],zero
; AVX1-NEXT:    vpcmpeqb %xmm11, %xmm3, %xmm3
; AVX1-NEXT:    vpmovsxbd %xmm3, %xmm7
; AVX1-NEXT:    vpshufd {{.*#+}} xmm3 = xmm3[1,1,2,3]
; AVX1-NEXT:    vpmovsxbd %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqb %xmm11, %xmm4, %xmm4
; AVX1-NEXT:    vpmovsxbd %xmm4, %xmm8
; AVX1-NEXT:    vpshufd {{.*#+}} xmm4 = xmm4[1,1,2,3]
; AVX1-NEXT:    vpmovsxbd %xmm4, %xmm4
; AVX1-NEXT:    vpcmpeqb %xmm11, %xmm5, %xmm5
; AVX1-NEXT:    vmovdqu (%rdi,%rcx,4), %xmm9
; AVX1-NEXT:    vpslld %xmm2, %xmm9, %xmm10
; AVX1-NEXT:    vpslld %xmm1, %xmm9, %xmm0
; AVX1-NEXT:    vblendvps %xmm7, %xmm10, %xmm0, %xmm9
; AVX1-NEXT:    vpmovsxbd %xmm5, %xmm7
; AVX1-NEXT:    vpshufd {{.*#+}} xmm5 = xmm5[1,1,2,3]
; AVX1-NEXT:    vpmovsxbd %xmm5, %xmm5
; AVX1-NEXT:    vpcmpeqb %xmm11, %xmm6, %xmm6
; AVX1-NEXT:    vmovdqu 16(%rdi,%rcx,4), %xmm0
; AVX1-NEXT:    vpslld %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpslld %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpmovsxbd %xmm6, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm6 = xmm6[1,1,2,3]
; AVX1-NEXT:    vpmovsxbd %xmm6, %xmm6
; AVX1-NEXT:    vblendvps %xmm3, %xmm2, %xmm0, %xmm10
; AVX1-NEXT:    vmovdqu 32(%rdi,%rcx,4), %xmm2
; AVX1-NEXT:    vpslld %xmm15, %xmm2, %xmm3
; AVX1-NEXT:    vpslld %xmm14, %xmm2, %xmm2
; AVX1-NEXT:    vblendvps %xmm8, %xmm3, %xmm2, %xmm8
; AVX1-NEXT:    vmovdqu 48(%rdi,%rcx,4), %xmm3
; AVX1-NEXT:    vpslld %xmm15, %xmm3, %xmm0
; AVX1-NEXT:    vpslld %xmm14, %xmm3, %xmm3
; AVX1-NEXT:    vblendvps %xmm4, %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vmovdqu 64(%rdi,%rcx,4), %xmm3
; AVX1-NEXT:    vpslld %xmm13, %xmm3, %xmm4
; AVX1-NEXT:    vmovdqa {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; AVX1-NEXT:    vpslld %xmm2, %xmm3, %xmm3
; AVX1-NEXT:    vblendvps %xmm7, %xmm4, %xmm3, %xmm3
; AVX1-NEXT:    vmovdqu 80(%rdi,%rcx,4), %xmm4
; AVX1-NEXT:    vpslld %xmm13, %xmm4, %xmm7
; AVX1-NEXT:    vpslld %xmm2, %xmm4, %xmm4
; AVX1-NEXT:    vblendvps %xmm5, %xmm7, %xmm4, %xmm4
; AVX1-NEXT:    vmovdqu 96(%rdi,%rcx,4), %xmm5
; AVX1-NEXT:    vpslld %xmm12, %xmm5, %xmm7
; AVX1-NEXT:    vmovdqa {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; AVX1-NEXT:    vpslld %xmm2, %xmm5, %xmm5
; AVX1-NEXT:    vblendvps %xmm1, %xmm7, %xmm5, %xmm1
; AVX1-NEXT:    vmovdqu 112(%rdi,%rcx,4), %xmm5
; AVX1-NEXT:    vpslld %xmm12, %xmm5, %xmm7
; AVX1-NEXT:    vpslld %xmm2, %xmm5, %xmm5
; AVX1-NEXT:    vblendvps %xmm6, %xmm7, %xmm5, %xmm5
; AVX1-NEXT:    vmovups %xmm9, (%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm10, 16(%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm8, 32(%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm0, 48(%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm3, 64(%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm4, 80(%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm1, 96(%rdi,%rcx,4)
; AVX1-NEXT:    vmovups %xmm5, 112(%rdi,%rcx,4)
; AVX1-NEXT:    addq $32, %rcx
; AVX1-NEXT:    cmpq %rcx, %rdx
; AVX1-NEXT:    jne .LBB0_4
; AVX1-NEXT:  # %bb.5: # %middle.block
; AVX1-NEXT:    cmpq %rax, %rdx
; AVX1-NEXT:    jne .LBB0_6
; AVX1-NEXT:  .LBB0_9: # %for.cond.cleanup
; AVX1-NEXT:    addq $24, %rsp
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
; AVX1-NEXT:    .p2align 4, 0x90
; AVX1-NEXT:  .LBB0_8: # %for.body
; AVX1-NEXT:    # in Loop: Header=BB0_6 Depth=1
; AVX1-NEXT:    # kill: def $cl killed $cl killed $ecx
; AVX1-NEXT:    shll %cl, (%rdi,%rdx,4)
; AVX1-NEXT:    incq %rdx
; AVX1-NEXT:    cmpq %rdx, %rax
; AVX1-NEXT:    je .LBB0_9
; AVX1-NEXT:  .LBB0_6: # %for.body
; AVX1-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX1-NEXT:    cmpb $0, (%rsi,%rdx)
; AVX1-NEXT:    movl %r9d, %ecx
; AVX1-NEXT:    je .LBB0_8
; AVX1-NEXT:  # %bb.7: # %for.body
; AVX1-NEXT:    # in Loop: Header=BB0_6 Depth=1
; AVX1-NEXT:    movl %r8d, %ecx
; AVX1-NEXT:    jmp .LBB0_8
;
; AVX2-LABEL: vector_variable_shift_left_loop:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    testl %edx, %edx
; AVX2-NEXT:    jle .LBB0_9
; AVX2-NEXT:  # %bb.1: # %for.body.preheader
; AVX2-NEXT:    movl %ecx, %r9d
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    cmpl $31, %edx
; AVX2-NEXT:    ja .LBB0_3
; AVX2-NEXT:  # %bb.2:
; AVX2-NEXT:    xorl %edx, %edx
; AVX2-NEXT:    jmp .LBB0_6
; AVX2-NEXT:  .LBB0_3: # %vector.ph
; AVX2-NEXT:    movl %eax, %edx
; AVX2-NEXT:    andl $-32, %edx
; AVX2-NEXT:    vmovd %r9d, %xmm0
; AVX2-NEXT:    vpbroadcastd %xmm0, %ymm0
; AVX2-NEXT:    vmovd %r8d, %xmm1
; AVX2-NEXT:    vpbroadcastd %xmm1, %ymm1
; AVX2-NEXT:    xorl %ecx, %ecx
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB0_4: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovzxbd {{.*#+}} ymm3 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero,mem[4],zero,zero,zero,mem[5],zero,zero,zero,mem[6],zero,zero,zero,mem[7],zero,zero,zero
; AVX2-NEXT:    vpmovzxbd {{.*#+}} ymm4 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero,mem[4],zero,zero,zero,mem[5],zero,zero,zero,mem[6],zero,zero,zero,mem[7],zero,zero,zero
; AVX2-NEXT:    vpmovzxbd {{.*#+}} ymm5 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero,mem[4],zero,zero,zero,mem[5],zero,zero,zero,mem[6],zero,zero,zero,mem[7],zero,zero,zero
; AVX2-NEXT:    vpmovzxbd {{.*#+}} ymm6 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero,mem[4],zero,zero,zero,mem[5],zero,zero,zero,mem[6],zero,zero,zero,mem[7],zero,zero,zero
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm3, %ymm3
; AVX2-NEXT:    vblendvps %ymm3, %ymm0, %ymm1, %ymm3
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm4, %ymm4
; AVX2-NEXT:    vblendvps %ymm4, %ymm0, %ymm1, %ymm4
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm5, %ymm5
; AVX2-NEXT:    vblendvps %ymm5, %ymm0, %ymm1, %ymm5
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm6, %ymm6
; AVX2-NEXT:    vblendvps %ymm6, %ymm0, %ymm1, %ymm6
; AVX2-NEXT:    vmovdqu (%rdi,%rcx,4), %ymm7
; AVX2-NEXT:    vpsllvd %ymm3, %ymm7, %ymm3
; AVX2-NEXT:    vmovdqu 32(%rdi,%rcx,4), %ymm7
; AVX2-NEXT:    vpsllvd %ymm4, %ymm7, %ymm4
; AVX2-NEXT:    vmovdqu 64(%rdi,%rcx,4), %ymm7
; AVX2-NEXT:    vpsllvd %ymm5, %ymm7, %ymm5
; AVX2-NEXT:    vmovdqu 96(%rdi,%rcx,4), %ymm7
; AVX2-NEXT:    vpsllvd %ymm6, %ymm7, %ymm6
; AVX2-NEXT:    vmovdqu %ymm3, (%rdi,%rcx,4)
; AVX2-NEXT:    vmovdqu %ymm4, 32(%rdi,%rcx,4)
; AVX2-NEXT:    vmovdqu %ymm5, 64(%rdi,%rcx,4)
; AVX2-NEXT:    vmovdqu %ymm6, 96(%rdi,%rcx,4)
; AVX2-NEXT:    addq $32, %rcx
; AVX2-NEXT:    cmpq %rcx, %rdx
; AVX2-NEXT:    jne .LBB0_4
; AVX2-NEXT:  # %bb.5: # %middle.block
; AVX2-NEXT:    cmpq %rax, %rdx
; AVX2-NEXT:    jne .LBB0_6
; AVX2-NEXT:  .LBB0_9: # %for.cond.cleanup
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB0_8: # %for.body
; AVX2-NEXT:    # in Loop: Header=BB0_6 Depth=1
; AVX2-NEXT:    # kill: def $cl killed $cl killed $ecx
; AVX2-NEXT:    shll %cl, (%rdi,%rdx,4)
; AVX2-NEXT:    incq %rdx
; AVX2-NEXT:    cmpq %rdx, %rax
; AVX2-NEXT:    je .LBB0_9
; AVX2-NEXT:  .LBB0_6: # %for.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    cmpb $0, (%rsi,%rdx)
; AVX2-NEXT:    movl %r9d, %ecx
; AVX2-NEXT:    je .LBB0_8
; AVX2-NEXT:  # %bb.7: # %for.body
; AVX2-NEXT:    # in Loop: Header=BB0_6 Depth=1
; AVX2-NEXT:    movl %r8d, %ecx
; AVX2-NEXT:    jmp .LBB0_8
entry:
  %cmp12 = icmp sgt i32 %count, 0
  br i1 %cmp12, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  %wide.trip.count = zext i32 %count to i64
  %min.iters.check = icmp ult i32 %count, 32
  br i1 %min.iters.check, label %for.body.preheader40, label %vector.ph

for.body.preheader40:
  %indvars.iv.ph = phi i64 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

vector.ph:
  %n.vec = and i64 %wide.trip.count, 4294967264
  %broadcast.splatinsert20 = insertelement <8 x i32> undef, i32 %amt0, i32 0
  %broadcast.splat21 = shufflevector <8 x i32> %broadcast.splatinsert20, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert22 = insertelement <8 x i32> undef, i32 %amt1, i32 0
  %broadcast.splat23 = shufflevector <8 x i32> %broadcast.splatinsert22, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert24 = insertelement <8 x i32> undef, i32 %amt0, i32 0
  %broadcast.splat25 = shufflevector <8 x i32> %broadcast.splatinsert24, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert26 = insertelement <8 x i32> undef, i32 %amt1, i32 0
  %broadcast.splat27 = shufflevector <8 x i32> %broadcast.splatinsert26, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert28 = insertelement <8 x i32> undef, i32 %amt0, i32 0
  %broadcast.splat29 = shufflevector <8 x i32> %broadcast.splatinsert28, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert30 = insertelement <8 x i32> undef, i32 %amt1, i32 0
  %broadcast.splat31 = shufflevector <8 x i32> %broadcast.splatinsert30, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert32 = insertelement <8 x i32> undef, i32 %amt0, i32 0
  %broadcast.splat33 = shufflevector <8 x i32> %broadcast.splatinsert32, <8 x i32> undef, <8 x i32> zeroinitializer
  %broadcast.splatinsert34 = insertelement <8 x i32> undef, i32 %amt1, i32 0
  %broadcast.splat35 = shufflevector <8 x i32> %broadcast.splatinsert34, <8 x i32> undef, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %control, i64 %index
  %1 = bitcast i8* %0 to <8 x i8>*
  %wide.load = load <8 x i8>, <8 x i8>* %1, align 1
  %2 = getelementptr inbounds i8, i8* %0, i64 8
  %3 = bitcast i8* %2 to <8 x i8>*
  %wide.load17 = load <8 x i8>, <8 x i8>* %3, align 1
  %4 = getelementptr inbounds i8, i8* %0, i64 16
  %5 = bitcast i8* %4 to <8 x i8>*
  %wide.load18 = load <8 x i8>, <8 x i8>* %5, align 1
  %6 = getelementptr inbounds i8, i8* %0, i64 24
  %7 = bitcast i8* %6 to <8 x i8>*
  %wide.load19 = load <8 x i8>, <8 x i8>* %7, align 1
  %8 = icmp eq <8 x i8> %wide.load, zeroinitializer
  %9 = icmp eq <8 x i8> %wide.load17, zeroinitializer
  %10 = icmp eq <8 x i8> %wide.load18, zeroinitializer
  %11 = icmp eq <8 x i8> %wide.load19, zeroinitializer
  %12 = select <8 x i1> %8, <8 x i32> %broadcast.splat21, <8 x i32> %broadcast.splat23
  %13 = select <8 x i1> %9, <8 x i32> %broadcast.splat25, <8 x i32> %broadcast.splat27
  %14 = select <8 x i1> %10, <8 x i32> %broadcast.splat29, <8 x i32> %broadcast.splat31
  %15 = select <8 x i1> %11, <8 x i32> %broadcast.splat33, <8 x i32> %broadcast.splat35
  %16 = getelementptr inbounds i32, i32* %arr, i64 %index
  %17 = bitcast i32* %16 to <8 x i32>*
  %wide.load36 = load <8 x i32>, <8 x i32>* %17, align 4
  %18 = getelementptr inbounds i32, i32* %16, i64 8
  %19 = bitcast i32* %18 to <8 x i32>*
  %wide.load37 = load <8 x i32>, <8 x i32>* %19, align 4
  %20 = getelementptr inbounds i32, i32* %16, i64 16
  %21 = bitcast i32* %20 to <8 x i32>*
  %wide.load38 = load <8 x i32>, <8 x i32>* %21, align 4
  %22 = getelementptr inbounds i32, i32* %16, i64 24
  %23 = bitcast i32* %22 to <8 x i32>*
  %wide.load39 = load <8 x i32>, <8 x i32>* %23, align 4
  %24 = shl <8 x i32> %wide.load36, %12
  %25 = shl <8 x i32> %wide.load37, %13
  %26 = shl <8 x i32> %wide.load38, %14
  %27 = shl <8 x i32> %wide.load39, %15
  %28 = bitcast i32* %16 to <8 x i32>*
  store <8 x i32> %24, <8 x i32>* %28, align 4
  %29 = bitcast i32* %18 to <8 x i32>*
  store <8 x i32> %25, <8 x i32>* %29, align 4
  %30 = bitcast i32* %20 to <8 x i32>*
  store <8 x i32> %26, <8 x i32>* %30, align 4
  %31 = bitcast i32* %22 to <8 x i32>*
  store <8 x i32> %27, <8 x i32>* %31, align 4
  %index.next = add i64 %index, 32
  %32 = icmp eq i64 %index.next, %n.vec
  br i1 %32, label %middle.block, label %vector.body

middle.block:
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader40

for.cond.cleanup:
  ret void

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader40 ]
  %arrayidx = getelementptr inbounds i8, i8* %control, i64 %indvars.iv
  %33 = load i8, i8* %arrayidx, align 1
  %tobool = icmp eq i8 %33, 0
  %cond = select i1 %tobool, i32 %amt0, i32 %amt1
  %arrayidx2 = getelementptr inbounds i32, i32* %arr, i64 %indvars.iv
  %34 = load i32, i32* %arrayidx2, align 4
  %shl = shl i32 %34, %cond
  store i32 %shl, i32* %arrayidx2, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

define void @vector_variable_shift_left_loop_simpler(i32* nocapture %arr, i8* nocapture readonly %control, i32 %count, i32 %amt0, i32 %amt1, i32 %x) nounwind {
; SSE-LABEL: vector_variable_shift_left_loop_simpler:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    testl %edx, %edx
; SSE-NEXT:    jle .LBB1_3
; SSE-NEXT:  # %bb.1: # %vector.ph
; SSE-NEXT:    movl %edx, %eax
; SSE-NEXT:    andl $-4, %eax
; SSE-NEXT:    movd %ecx, %xmm0
; SSE-NEXT:    movd %r8d, %xmm2
; SSE-NEXT:    movd %r9d, %xmm3
; SSE-NEXT:    xorl %ecx, %ecx
; SSE-NEXT:    pslld $23, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm4 = [1065353216,1065353216,1065353216,1065353216]
; SSE-NEXT:    paddd %xmm4, %xmm0
; SSE-NEXT:    cvttps2dq %xmm0, %xmm0
; SSE-NEXT:    pmulld %xmm3, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[0,0,0,0]
; SSE-NEXT:    pslld $23, %xmm2
; SSE-NEXT:    paddd %xmm4, %xmm2
; SSE-NEXT:    cvttps2dq %xmm2, %xmm0
; SSE-NEXT:    pmulld %xmm3, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[0,0,0,0]
; SSE-NEXT:    pxor %xmm3, %xmm3
; SSE-NEXT:    .p2align 4, 0x90
; SSE-NEXT:  .LBB1_2: # %vector.body
; SSE-NEXT:    # =>This Inner Loop Header: Depth=1
; SSE-NEXT:    pmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; SSE-NEXT:    pcmpeqd %xmm3, %xmm0
; SSE-NEXT:    movdqa %xmm2, %xmm4
; SSE-NEXT:    blendvps %xmm0, %xmm1, %xmm4
; SSE-NEXT:    movups %xmm4, (%rdi,%rcx,4)
; SSE-NEXT:    addq $4, %rcx
; SSE-NEXT:    cmpq %rcx, %rax
; SSE-NEXT:    jne .LBB1_2
; SSE-NEXT:  .LBB1_3: # %exit
; SSE-NEXT:    retq
;
; AVX1-LABEL: vector_variable_shift_left_loop_simpler:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    testl %edx, %edx
; AVX1-NEXT:    jle .LBB1_3
; AVX1-NEXT:  # %bb.1: # %vector.ph
; AVX1-NEXT:    movl %edx, %eax
; AVX1-NEXT:    andl $-4, %eax
; AVX1-NEXT:    vmovd %ecx, %xmm0
; AVX1-NEXT:    vmovd %r8d, %xmm1
; AVX1-NEXT:    vmovd %r9d, %xmm2
; AVX1-NEXT:    xorl %ecx, %ecx
; AVX1-NEXT:    vpslld $23, %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [1065353216,1065353216,1065353216,1065353216]
; AVX1-NEXT:    vpaddd %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vcvttps2dq %xmm0, %xmm0
; AVX1-NEXT:    vpmulld %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX1-NEXT:    vpslld $23, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vcvttps2dq %xmm1, %xmm1
; AVX1-NEXT:    vpmulld %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    .p2align 4, 0x90
; AVX1-NEXT:  .LBB1_2: # %vector.body
; AVX1-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX1-NEXT:    vpmovzxbd {{.*#+}} xmm3 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm3, %xmm3
; AVX1-NEXT:    vblendvps %xmm3, %xmm0, %xmm1, %xmm3
; AVX1-NEXT:    vmovups %xmm3, (%rdi,%rcx,4)
; AVX1-NEXT:    addq $4, %rcx
; AVX1-NEXT:    cmpq %rcx, %rax
; AVX1-NEXT:    jne .LBB1_2
; AVX1-NEXT:  .LBB1_3: # %exit
; AVX1-NEXT:    retq
;
; AVX2-LABEL: vector_variable_shift_left_loop_simpler:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    testl %edx, %edx
; AVX2-NEXT:    jle .LBB1_3
; AVX2-NEXT:  # %bb.1: # %vector.ph
; AVX2-NEXT:    movl %edx, %eax
; AVX2-NEXT:    andl $-4, %eax
; AVX2-NEXT:    vmovd %ecx, %xmm0
; AVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; AVX2-NEXT:    vmovd %r8d, %xmm1
; AVX2-NEXT:    vpbroadcastd %xmm1, %xmm1
; AVX2-NEXT:    vmovd %r9d, %xmm2
; AVX2-NEXT:    vpbroadcastd %xmm2, %xmm2
; AVX2-NEXT:    xorl %ecx, %ecx
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB1_2: # %vector.body
; AVX2-NEXT:    # =>This Inner Loop Header: Depth=1
; AVX2-NEXT:    vpmovzxbd {{.*#+}} xmm4 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; AVX2-NEXT:    vpcmpeqd %xmm3, %xmm4, %xmm4
; AVX2-NEXT:    vblendvps %xmm4, %xmm0, %xmm1, %xmm4
; AVX2-NEXT:    vpsllvd %xmm4, %xmm2, %xmm4
; AVX2-NEXT:    vmovdqu %xmm4, (%rdi,%rcx,4)
; AVX2-NEXT:    addq $4, %rcx
; AVX2-NEXT:    cmpq %rcx, %rax
; AVX2-NEXT:    jne .LBB1_2
; AVX2-NEXT:  .LBB1_3: # %exit
; AVX2-NEXT:    retq
entry:
  %cmp16 = icmp sgt i32 %count, 0
  %wide.trip.count = zext i32 %count to i64
  br i1 %cmp16, label %vector.ph, label %exit

vector.ph:
  %n.vec = and i64 %wide.trip.count, 4294967292
  %splatinsert18 = insertelement <4 x i32> undef, i32 %amt0, i32 0
  %splat1 = shufflevector <4 x i32> %splatinsert18, <4 x i32> undef, <4 x i32> zeroinitializer
  %splatinsert20 = insertelement <4 x i32> undef, i32 %amt1, i32 0
  %splat2 = shufflevector <4 x i32> %splatinsert20, <4 x i32> undef, <4 x i32> zeroinitializer
  %splatinsert22 = insertelement <4 x i32> undef, i32 %x, i32 0
  %splat3 = shufflevector <4 x i32> %splatinsert22, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %control, i64 %index
  %1 = bitcast i8* %0 to <4 x i8>*
  %wide.load = load <4 x i8>, <4 x i8>* %1, align 1
  %2 = icmp eq <4 x i8> %wide.load, zeroinitializer
  %3 = select <4 x i1> %2, <4 x i32> %splat1, <4 x i32> %splat2
  %4 = shl <4 x i32> %splat3, %3
  %5 = getelementptr inbounds i32, i32* %arr, i64 %index
  %6 = bitcast i32* %5 to <4 x i32>*
  store <4 x i32> %4, <4 x i32>* %6, align 4
  %index.next = add i64 %index, 4
  %7 = icmp eq i64 %index.next, %n.vec
  br i1 %7, label %exit, label %vector.body

exit:
  ret void
}
