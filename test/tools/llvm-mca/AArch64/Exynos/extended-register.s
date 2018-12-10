# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m1  -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM1
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3  -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM3

  sub	w0, w1, w2, sxtb #0
  add	w3, w4, w5, sxth #1
  subs	x6, x7, w8, uxtw #2
  adds	x9, x10, x11, uxtx #3
  sub	w12, w13, w14, uxtb #3
  add	w15, w16, w17, uxth #2
  subs	x18, x19, w20, sxtw #1
  adds	x21, x22, x23, sxtx #0

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      800

# EM1-NEXT: Total Cycles:      537
# EM3-NEXT: Total Cycles:      403

# ALL-NEXT: Total uOps:        800

# EM1:      Dispatch Width:    4
# EM1-NEXT: uOps Per Cycle:    1.49
# EM1-NEXT: IPC:               1.49
# EM1-NEXT: Block RThroughput: 5.3

# EM3:      Dispatch Width:    6
# EM3-NEXT: uOps Per Cycle:    1.99
# EM3-NEXT: IPC:               1.99
# EM3-NEXT: Block RThroughput: 4.0

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# EM1-NEXT:  1      2     0.67                        sub	w0, w1, w2, sxtb
# EM1-NEXT:  1      2     0.67                        add	w3, w4, w5, sxth #1
# EM1-NEXT:  1      2     0.67                        subs	x6, x7, w8, uxtw #2
# EM1-NEXT:  1      2     0.67                        adds	x9, x10, x11, uxtx #3
# EM1-NEXT:  1      2     0.67                        sub	w12, w13, w14, uxtb #3
# EM1-NEXT:  1      2     0.67                        add	w15, w16, w17, uxth #2
# EM1-NEXT:  1      2     0.67                        subs	x18, x19, w20, sxtw #1
# EM1-NEXT:  1      2     0.67                        adds	x21, x22, x23, sxtx

# EM3-NEXT:  1      2     0.50                        sub	w0, w1, w2, sxtb
# EM3-NEXT:  1      2     0.50                        add	w3, w4, w5, sxth #1
# EM3-NEXT:  1      2     0.50                        subs	x6, x7, w8, uxtw #2
# EM3-NEXT:  1      2     0.50                        adds	x9, x10, x11, uxtx #3
# EM3-NEXT:  1      2     0.50                        sub	w12, w13, w14, uxtb #3
# EM3-NEXT:  1      2     0.50                        add	w15, w16, w17, uxth #2
# EM3-NEXT:  1      2     0.50                        subs	x18, x19, w20, sxtw #1
# EM3-NEXT:  1      2     0.50                        adds	x21, x22, x23, sxtx
