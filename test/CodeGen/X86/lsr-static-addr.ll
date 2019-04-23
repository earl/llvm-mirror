; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=generic -mtriple=x86_64-unknown-linux-gnu -relocation-model=static < %s | FileCheck %s --check-prefix=CHECK
; RUN: llc -mcpu=atom -mtriple=x86_64-unknown-linux-gnu -relocation-model=static < %s | FileCheck %s --check-prefix=ATOM

@A = external global [0 x double]

define void @foo(i64 %n) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    jle .LBB0_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm1
; CHECK-NEXT:    movsd %xmm1, A(,%rax,8)
; CHECK-NEXT:    incq %rax
; CHECK-NEXT:    cmpq %rax, %rdi
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  .LBB0_3: # %for.end
; CHECK-NEXT:    retq
;
; ATOM-LABEL: foo:
; ATOM:       # %bb.0: # %entry
; ATOM-NEXT:    testq %rdi, %rdi
; ATOM-NEXT:    jle .LBB0_3
; ATOM-NEXT:  # %bb.1: # %for.body.preheader
; ATOM-NEXT:    xorl %eax, %eax
; ATOM-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; ATOM-NEXT:    .p2align 4, 0x90
; ATOM-NEXT:  .LBB0_2: # %for.body
; ATOM-NEXT:    # =>This Inner Loop Header: Depth=1
; ATOM-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; ATOM-NEXT:    mulsd %xmm0, %xmm1
; ATOM-NEXT:    movsd %xmm1, A(,%rax,8)
; ATOM-NEXT:    incq %rax
; ATOM-NEXT:    cmpq %rax, %rdi
; ATOM-NEXT:    jne .LBB0_2
; ATOM-NEXT:  .LBB0_3: # %for.end
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
entry:
  %cmp5 = icmp sgt i64 %n, 0
  br i1 %cmp5, label %for.body, label %for.end

for.body:
  %i.06 = phi i64 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr [0 x double], [0 x double]* @A, i64 0, i64 %i.06
  %tmp3 = load double, double* %arrayidx, align 8
  %mul = fmul double %tmp3, 2.300000e+00
  store double %mul, double* %arrayidx, align 8
  %inc = add nsw i64 %i.06, 1
  %exitcond = icmp eq i64 %inc, %n
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}
