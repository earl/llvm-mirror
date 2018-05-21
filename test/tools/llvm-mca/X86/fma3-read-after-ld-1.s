# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown  -mcpu=haswell -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=HASWELL

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=broadwell -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=BDWELL

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=SKYLAKE

# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -iterations=1 -resource-pressure=false -instruction-info=false -timeline < %s | FileCheck %s -check-prefix=ALL -check-prefix=ZNVER1

vaddps %xmm0, %xmm0, %xmm1
vfmadd213ps (%rdi), %xmm1, %xmm2

# BDWELL:      Iterations:     1
# BDWELL-NEXT: Instructions:   2
# BDWELL-NEXT: Total Cycles:   13
# BDWELL-NEXT: Dispatch Width: 4
# BDWELL-NEXT: IPC:            0.15

# SKYLAKE:      Iterations:     1
# SKYLAKE-NEXT: Instructions:   2
# SKYLAKE-NEXT: Total Cycles:   13
# SKYLAKE-NEXT: Dispatch Width: 6
# SKYLAKE-NEXT: IPC:            0.15

# HASWELL:      Iterations:     1
# HASWELL-NEXT: Instructions:   2
# HASWELL-NEXT: Total Cycles:   14
# HASWELL-NEXT: Dispatch Width: 4
# HASWELL-NEXT: IPC:            0.14

# ZNVER1:      Iterations:     1
# ZNVER1-NEXT: Instructions:   2
# ZNVER1-NEXT: Total Cycles:   15
# ZNVER1-NEXT: Dispatch Width: 4
# ZNVER1-NEXT: IPC:            0.13

# BDWELL:      Timeline view:
# BDWELL-NEXT:                     012
# BDWELL-NEXT: Index     0123456789

# SKYLAKE:      Timeline view:
# SKYLAKE-NEXT:                     012
# SKYLAKE-NEXT: Index     0123456789

# HASWELL:      Timeline view:
# HASWELL-NEXT:                     0123
# HASWELL-NEXT: Index     0123456789

# ZNVER1:      Timeline view:
# ZNVER1-NEXT:                     01234
# ZNVER1-NEXT: Index     0123456789

# ZNVER1:      [0,0]     DeeeER    .   .   vaddps	%xmm0, %xmm0, %xmm1
# ZNVER1-NEXT: [0,1]     DeeeeeeeeeeeeER   vfmadd213ps	(%rdi), %xmm1, %xmm2

# HASWELL:      [0,0]     DeeeER    .  .   vaddps	%xmm0, %xmm0, %xmm1
# HASWELL-NEXT: [0,1]     DeeeeeeeeeeeER   vfmadd213ps	(%rdi), %xmm1, %xmm2

# BDWELL:      [0,0]     DeeeER    . .   vaddps	%xmm0, %xmm0, %xmm1
# BDWELL-NEXT: [0,1]     DeeeeeeeeeeER   vfmadd213ps	(%rdi), %xmm1, %xmm2

# SKYLAKE:      [0,0]     DeeeeER   . .   vaddps	%xmm0, %xmm0, %xmm1
# SKYLAKE-NEXT: [0,1]     DeeeeeeeeeeER   vfmadd213ps	(%rdi), %xmm1, %xmm2

# ALL:      Average Wait times (based on the timeline view):
# ALL-NEXT: [0]: Executions
# ALL-NEXT: [1]: Average time spent waiting in a scheduler's queue
# ALL-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# ALL-NEXT: [3]: Average time elapsed from WB until retire stage

# ALL:            [0]    [1]    [2]    [3]
# ALL-NEXT: 0.     1     1.0    1.0    0.0       vaddps	%xmm0, %xmm0, %xmm1
# ALL-NEXT: 1.     1     1.0    0.0    0.0       vfmadd213ps	(%rdi), %xmm1, %xmm2

