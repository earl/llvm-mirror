; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.2 | FileCheck %s

; widen a v3f32 to vfi32 to do a vector multiple and an add

define void @update(<3 x float>* %dst, <3 x float>* %src, i32 %n) nounwind {
; CHECK-LABEL: update:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    andl $-16, %esp
; CHECK-NEXT:    subl $48, %esp
; CHECK-NEXT:    movl $1077936128, {{[0-9]+}}(%esp) # imm = 0x40400000
; CHECK-NEXT:    movl $1073741824, {{[0-9]+}}(%esp) # imm = 0x40000000
; CHECK-NEXT:    movl $1065353216, {{[0-9]+}}(%esp) # imm = 0x3F800000
; CHECK-NEXT:    movl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = <1.97604004E+3,1.97604004E+3,1.97604004E+3,u>
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %forcond
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmpl 16(%ebp), %eax
; CHECK-NEXT:    jge .LBB0_3
; CHECK-NEXT:  # %bb.2: # %forbody
; CHECK-NEXT:    # in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl 8(%ebp), %ecx
; CHECK-NEXT:    shll $4, %eax
; CHECK-NEXT:    movl 12(%ebp), %edx
; CHECK-NEXT:    movaps (%edx,%eax), %xmm1
; CHECK-NEXT:    mulps {{[0-9]+}}(%esp), %xmm1
; CHECK-NEXT:    addps %xmm0, %xmm1
; CHECK-NEXT:    extractps $2, %xmm1, 8(%ecx,%eax)
; CHECK-NEXT:    extractps $1, %xmm1, 4(%ecx,%eax)
; CHECK-NEXT:    movss %xmm1, (%ecx,%eax)
; CHECK-NEXT:    incl {{[0-9]+}}(%esp)
; CHECK-NEXT:    jmp .LBB0_1
; CHECK-NEXT:  .LBB0_3: # %afterfor
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
	%dst.addr = alloca <3 x float>*
	%src.addr = alloca <3 x float>*
	%n.addr = alloca i32
	%v = alloca <3 x float>, align 16
	%i = alloca i32, align 4
	store <3 x float>* %dst, <3 x float>** %dst.addr
	store <3 x float>* %src, <3 x float>** %src.addr
	store i32 %n, i32* %n.addr
	store <3 x float> < float 1.000000e+00, float 2.000000e+00, float 3.000000e+00 >, <3 x float>* %v
	store i32 0, i32* %i
	br label %forcond

forcond:
	%tmp = load i32, i32* %i
	%tmp1 = load i32, i32* %n.addr
	%cmp = icmp slt i32 %tmp, %tmp1
	br i1 %cmp, label %forbody, label %afterfor

forbody:
	%tmp2 = load i32, i32* %i
	%tmp3 = load <3 x float>*, <3 x float>** %dst.addr
	%arrayidx = getelementptr <3 x float>, <3 x float>* %tmp3, i32 %tmp2
	%tmp4 = load i32, i32* %i
	%tmp5 = load <3 x float>*, <3 x float>** %src.addr
	%arrayidx6 = getelementptr <3 x float>, <3 x float>* %tmp5, i32 %tmp4
	%tmp7 = load <3 x float>, <3 x float>* %arrayidx6
	%tmp8 = load <3 x float>, <3 x float>* %v
	%mul = fmul <3 x float> %tmp7, %tmp8
	%add = fadd <3 x float> %mul, < float 0x409EE02900000000, float 0x409EE02900000000, float 0x409EE02900000000 >
	store <3 x float> %add, <3 x float>* %arrayidx
	br label %forinc

forinc:
	%tmp9 = load i32, i32* %i
	%inc = add i32 %tmp9, 1
	store i32 %inc, i32* %i
	br label %forcond

afterfor:
	ret void
}
