# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=sandybridge -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=SANDY
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=haswell -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=HASWELL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=broadwell -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=BDWELL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=SKYLAKE
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=BDVER2
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=BTVER2
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=ZNVER1

vdivps  %xmm0, %xmm1, %xmm1
vaddps  (%rax), %xmm1, %xmm1

# ALL:          Iterations:        1
# ALL-NEXT:     Instructions:      2

# BDVER2-NEXT:  Total Cycles:      17
# BDVER2-NEXT:  Total uOps:        2

# BDWELL-NEXT:  Total Cycles:      17
# BDWELL-NEXT:  Total uOps:        3

# BTVER2-NEXT:  Total Cycles:      25
# BTVER2-NEXT:  Total uOps:        2

# HASWELL-NEXT: Total Cycles:      19
# HASWELL-NEXT: Total uOps:        3

# SANDY-NEXT:   Total Cycles:      20
# SANDY-NEXT:   Total uOps:        3

# SKYLAKE-NEXT: Total Cycles:      18
# SKYLAKE-NEXT: Total uOps:        3

# ZNVER1-NEXT:  Total Cycles:      20
# ZNVER1-NEXT:  Total uOps:        2

# BDVER2:       Dispatch Width:    4
# BDVER2-NEXT:  uOps Per Cycle:    0.12
# BDVER2-NEXT:  IPC:               0.12
# BDVER2-NEXT:  Block RThroughput: 5.0

# BDWELL:       Dispatch Width:    4
# BDWELL-NEXT:  uOps Per Cycle:    0.18
# BDWELL-NEXT:  IPC:               0.12
# BDWELL-NEXT:  Block RThroughput: 5.0

# BTVER2:       Dispatch Width:    2
# BTVER2-NEXT:  uOps Per Cycle:    0.08
# BTVER2-NEXT:  IPC:               0.08
# BTVER2-NEXT:  Block RThroughput: 19.0

# HASWELL:      Dispatch Width:    4
# HASWELL-NEXT: uOps Per Cycle:    0.16
# HASWELL-NEXT: IPC:               0.11
# HASWELL-NEXT: Block RThroughput: 7.0

# SANDY:        Dispatch Width:    4
# SANDY-NEXT:   uOps Per Cycle:    0.15
# SANDY-NEXT:   IPC:               0.10
# SANDY-NEXT:   Block RThroughput: 14.0

# SKYLAKE:      Dispatch Width:    6
# SKYLAKE-NEXT: uOps Per Cycle:    0.17
# SKYLAKE-NEXT: IPC:               0.11
# SKYLAKE-NEXT: Block RThroughput: 3.0

# ZNVER1:       Dispatch Width:    4
# ZNVER1-NEXT:  uOps Per Cycle:    0.10
# ZNVER1-NEXT:  IPC:               0.10
# ZNVER1-NEXT:  Block RThroughput: 1.0

# ALL:          Timeline view:

# BDVER2-NEXT:                      0123456
# BDVER2-NEXT:  Index     0123456789

# BDWELL-NEXT:                      0123456
# BDWELL-NEXT:  Index     0123456789

# BTVER2-NEXT:                      0123456789
# BTVER2-NEXT:  Index     0123456789          01234

# HASWELL-NEXT:                     012345678
# HASWELL-NEXT: Index     0123456789

# SANDY-NEXT:                       0123456789
# SANDY-NEXT:   Index     0123456789

# SKYLAKE-NEXT:                     01234567
# SKYLAKE-NEXT: Index     0123456789

# ZNVER1-NEXT:                      0123456789
# ZNVER1-NEXT:  Index     0123456789

# BDVER2:       [0,0]     DeeeeeeeeeER   ..   vdivps	%xmm0, %xmm1, %xmm1
# BDVER2-NEXT:  [0,1]     D====eeeeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# BDWELL:       [0,0]     DeeeeeeeeeeeER ..   vdivps	%xmm0, %xmm1, %xmm1
# BDWELL-NEXT:  [0,1]     D======eeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# BTVER2:       [0,0]     DeeeeeeeeeeeeeeeeeeeER  .   vdivps	%xmm0, %xmm1, %xmm1
# BTVER2-NEXT:  [0,1]     D==============eeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# HASWELL:      [0,0]     DeeeeeeeeeeeeeER  .   vdivps	%xmm0, %xmm1, %xmm1
# HASWELL-NEXT: [0,1]     D=======eeeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# SANDY:        [0,0]     DeeeeeeeeeeeeeeER  .   vdivps	%xmm0, %xmm1, %xmm1
# SANDY-NEXT:   [0,1]     D========eeeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# SKYLAKE:      [0,0]     DeeeeeeeeeeeER . .   vdivps	%xmm0, %xmm1, %xmm1
# SKYLAKE-NEXT: [0,1]     D=====eeeeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# ZNVER1:       [0,0]     DeeeeeeeeeeeeeeeER .   vdivps	%xmm0, %xmm1, %xmm1
# ZNVER1-NEXT:  [0,1]     D=======eeeeeeeeeeER   vaddps	(%rax), %xmm1, %xmm1

# ALL:          Average Wait times (based on the timeline view):
# ALL-NEXT:     [0]: Executions
# ALL-NEXT:     [1]: Average time spent waiting in a scheduler's queue
# ALL-NEXT:     [2]: Average time spent waiting in a scheduler's queue while ready
# ALL-NEXT:     [3]: Average time elapsed from WB until retire stage

# ALL:                [0]    [1]    [2]    [3]
# ALL-NEXT:     0.     1     1.0    1.0    0.0       vdivps	%xmm0, %xmm1, %xmm1

# BDVER2-NEXT:  1.     1     5.0    0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
# BDWELL-NEXT:  1.     1     7.0    0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
# BTVER2-NEXT:  1.     1     15.0   0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
# HASWELL-NEXT: 1.     1     8.0    0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
# SANDY-NEXT:   1.     1     9.0    0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
# SKYLAKE-NEXT: 1.     1     6.0    0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
# ZNVER1-NEXT:  1.     1     8.0    0.0    0.0       vaddps	(%rax), %xmm1, %xmm1
