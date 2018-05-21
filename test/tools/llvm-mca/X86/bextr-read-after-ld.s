# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=haswell -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=HASWELL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=broadwell -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=BDWELL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=SKYLAKE
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=BTVER2
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=ZNVER1

add     %edi, %esi
bextrl	%esi, (%rdi), %eax

# BDWELL:      Iterations:     1
# BDWELL-NEXT: Instructions:   2
# BDWELL-NEXT: Total Cycles:   10
# BDWELL-NEXT: Dispatch Width: 4
# BDWELL-NEXT: IPC:            0.20

# HASWELL:      Iterations:     1
# HASWELL-NEXT: Instructions:   2
# HASWELL-NEXT: Total Cycles:   10
# HASWELL-NEXT: Dispatch Width: 4
# HASWELL-NEXT: IPC:            0.20

# SKYLAKE:      Iterations:     1
# SKYLAKE-NEXT: Instructions:   2
# SKYLAKE-NEXT: Total Cycles:   10
# SKYLAKE-NEXT: Dispatch Width: 6
# SKYLAKE-NEXT: IPC:            0.20

# BTVER2:      Iterations:     1
# BTVER2-NEXT: Instructions:   2
# BTVER2-NEXT: Total Cycles:   7
# BTVER2-NEXT: Dispatch Width: 2
# BTVER2-NEXT: IPC:            0.29

# ZNVER1:      Iterations:     1
# ZNVER1-NEXT: Instructions:   2
# ZNVER1-NEXT: Total Cycles:   8
# ZNVER1-NEXT: Dispatch Width: 4
# ZNVER1-NEXT: IPC:            0.25

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects

# ZNVER1:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# ZNVER1-NEXT:  1      1     0.25                        addl	%edi, %esi
# ZNVER1-NEXT:  2      5     0.50    *                   bextrl	%esi, (%rdi), %eax

# BDWELL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# BDWELL-NEXT:  1      1     0.25                        addl	%edi, %esi
# BDWELL-NEXT:  3      7     0.50    *                   bextrl	%esi, (%rdi), %eax

# HASWELL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# HASWELL-NEXT:  1      1     0.25                        addl	%edi, %esi
# HASWELL-NEXT:  3      7     0.50    *                   bextrl	%esi, (%rdi), %eax

# SKYLAKE:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# SKYLAKE-NEXT:  1      1     0.25                        addl	%edi, %esi
# SKYLAKE-NEXT:  3      7     0.50    *                   bextrl	%esi, (%rdi), %eax

# BTVER2:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# BTVER2-NEXT:  1      1     0.50                        addl	%edi, %esi
# BTVER2-NEXT:  1      4     1.00    *                   bextrl	%esi, (%rdi), %eax

# BTVER2:      Timeline view:
# BTVER2-NEXT: Index     0123456

# ZNVER1:      Timeline view:
# ZNVER1-NEXT: Index     01234567

# BDWELL:      Timeline view:
# BDWELL-NEXT: Index     0123456789

# HASWELL:      Timeline view:
# HASWELL-NEXT: Index     0123456789

# SKYLAKE:      Timeline view:
# SKYLAKE-NEXT: Index     0123456789

# BDWELL:      [0,0]     DeER .   .   addl	%edi, %esi
# BDWELL-NEXT: [0,1]     DeeeeeeeER   bextrl	%esi, (%rdi), %eax

# HASWELL:      [0,0]     DeER .   .   addl	%edi, %esi
# HASWELL-NEXT: [0,1]     DeeeeeeeER   bextrl	%esi, (%rdi), %eax

# SKYLAKE:      [0,0]     DeER .   .   addl	%edi, %esi
# SKYLAKE-NEXT: [0,1]     DeeeeeeeER   bextrl	%esi, (%rdi), %eax

# ZNVER1:      [0,0]     DeER . .   addl	%edi, %esi
# ZNVER1-NEXT: [0,1]     DeeeeeER   bextrl	%esi, (%rdi), %eax

# BTVER2:      [0,0]     DeER ..   addl	%edi, %esi
# BTVER2-NEXT: [0,1]     DeeeeER   bextrl	%esi, (%rdi), %eax

# ALL:      Average Wait times (based on the timeline view):
# ALL-NEXT: [0]: Executions
# ALL-NEXT: [1]: Average time spent waiting in a scheduler's queue
# ALL-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# ALL-NEXT: [3]: Average time elapsed from WB until retire stage

# ALL:            [0]    [1]    [2]    [3]
# ALL-NEXT: 0.     1     1.0    1.0    0.0       addl	%edi, %esi
# ALL-NEXT: 1.     1     1.0    0.0    0.0       bextrl	%esi, (%rdi), %eax

