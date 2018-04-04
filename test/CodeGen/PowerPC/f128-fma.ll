; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -enable-ppc-quad-precision -ppc-vsr-nums-as-vr < %s | FileCheck %s

define void @qpFmadd(fp128* nocapture readonly %a, fp128* nocapture %b,
                   fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %madd = tail call fp128 @llvm.fmuladd.f128(fp128 %0, fp128 %1, fp128 %2)
  store fp128 %madd, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFmadd
; CHECK-NOT: bl fmal
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsmaddqp [[REG5]], [[REG3]], [[REG4]]
; CHECK-NEXT: stxv [[REG5]], 0(6)
; CHECK-NEXT: blr
}
declare fp128 @llvm.fmuladd.f128(fp128, fp128, fp128)

; Function Attrs: norecurse nounwind
define void @qpFmadd_02(fp128* nocapture readonly %a,
                        fp128* nocapture readonly %b,
                        fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %add = fadd contract fp128 %0, %mul
  store fp128 %add, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFmadd_02
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsmaddqp [[REG3]], [[REG4]], [[REG5]]
; CHECK-NEXT: stxv [[REG3]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFmadd_03(fp128* nocapture readonly %a,
                        fp128* nocapture readonly %b,
                        fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %add = fadd contract fp128 %mul, %2
  store fp128 %add, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFmadd_03
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsmaddqp [[REG5]], [[REG3]], [[REG4]]
; CHECK-NEXT: stxv [[REG5]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFnmadd(fp128* nocapture readonly %a,
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %add = fadd contract fp128 %0, %mul
  %sub = fsub fp128 0xL00000000000000008000000000000000, %add
  store fp128 %sub, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFnmadd
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsnmaddqp [[REG3]], [[REG4]], [[REG5]]
; CHECK-NEXT: stxv [[REG3]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFnmadd_02(fp128* nocapture readonly %a,
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %add = fadd contract fp128 %mul, %2
  %sub = fsub fp128 0xL00000000000000008000000000000000, %add
  store fp128 %sub, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFnmadd_02
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsnmaddqp [[REG5]], [[REG3]], [[REG4]]
; CHECK-NEXT: stxv [[REG5]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFmsub(fp128* nocapture readonly %a,
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %sub = fsub contract fp128 %0, %mul
  store fp128 %sub, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFmsub
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsnmsubqp [[REG3]], [[REG5]], [[REG4]]
; CHECK-NEXT: stxv [[REG3]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFmsub_02(fp128* nocapture readonly %a,
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %sub = fsub contract fp128 %mul, %2
  store fp128 %sub, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFmsub_02
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsmsubqp [[REG5]], [[REG3]], [[REG4]]
; CHECK-NEXT: stxv [[REG5]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFnmsub(fp128* nocapture readonly %a,
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %sub = fsub contract fp128 %0, %mul
  %sub1 = fsub fp128 0xL00000000000000008000000000000000, %sub
  store fp128 %sub1, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFnmsub
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsnegqp [[REG4]], [[REG4]]
; CHECK: xsnmaddqp [[REG3]], [[REG4]], [[REG5]]
; CHECK-NEXT: stxv [[REG3]], 0(6)
; CHECK-NEXT: blr
}

; Function Attrs: norecurse nounwind
define void @qpFnmsub_02(fp128* nocapture readonly %a,
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %sub = fsub contract fp128 %mul, %2
  %sub1 = fsub fp128 0xL00000000000000008000000000000000, %sub
  store fp128 %sub1, fp128* %res, align 16
  ret void
; CHECK-LABEL: qpFnmsub_02
; CHECK-NOT: bl __multf3
; CHECK-DAG: lxv [[REG3:[0-9]+]], 0(3)
; CHECK-DAG: lxv [[REG4:[0-9]+]], 0(4)
; CHECK-DAG: lxv [[REG5:[0-9]+]], 0(5)
; CHECK: xsnmsubqp [[REG5]], [[REG3]], [[REG4]]
; CHECK-NEXT: stxv [[REG5]], 0(6)
; CHECK-NEXT: blr
}
