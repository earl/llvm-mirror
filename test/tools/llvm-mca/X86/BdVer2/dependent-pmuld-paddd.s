# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=500 -timeline < %s | FileCheck %s

vpmuld %xmm0, %xmm0, %xmm1
vpaddd %xmm1, %xmm1, %xmm0
vpaddd %xmm0, %xmm0, %xmm3

# CHECK:      Iterations:        500
# CHECK-NEXT: Instructions:      1500
# CHECK-NEXT: Total Cycles:      3004
# CHECK-NEXT: Total uOps:        1500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.50
# CHECK-NEXT: IPC:               0.50
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      5     1.00                        vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT:  1      1     0.50                        vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT:  1      1     0.50                        vpaddd	%xmm0, %xmm0, %xmm3

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vpaddd	%xmm0, %xmm0, %xmm3

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789          0123456789
# CHECK-NEXT: Index     0123456789          0123456789          0123456789          0123

# CHECK:      [0,0]     DeeeeeER  .    .    .    .    .    .    .    .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [0,1]     D=====eER .    .    .    .    .    .    .    .    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [0,2]     D======eER.    .    .    .    .    .    .    .    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [1,0]     D======eeeeeER .    .    .    .    .    .    .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [1,1]     .D==========eER.    .    .    .    .    .    .    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [1,2]     .D===========eER    .    .    .    .    .    .    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [2,0]     .D===========eeeeeER.    .    .    .    .    .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [2,1]     .D================eER    .    .    .    .    .    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [2,2]     . D================eER   .    .    .    .    .    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [3,0]     . D================eeeeeER    .    .    .    .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [3,1]     . D=====================eER   .    .    .    .    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [3,2]     . D======================eER  .    .    .    .    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [4,0]     .  D=====================eeeeeER   .    .    .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [4,1]     .  D==========================eER  .    .    .    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [4,2]     .  D===========================eER .    .    .    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [5,0]     .  D===========================eeeeeER  .    .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [5,1]     .   D===============================eER .    .    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [5,2]     .   D================================eER.    .    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [6,0]     .   D================================eeeeeER .    .    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [6,1]     .   D=====================================eER.    .    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [6,2]     .    D=====================================eER    .    .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [7,0]     .    D=====================================eeeeeER.    .    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [7,1]     .    D==========================================eER    .    .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [7,2]     .    D===========================================eER   .    .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [8,0]     .    .D==========================================eeeeeER    .  .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [8,1]     .    .D===============================================eER   .  .   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [8,2]     .    .D================================================eER  .  .   vpaddd	%xmm0, %xmm0, %xmm3
# CHECK-NEXT: [9,0]     .    .D================================================eeeeeER .   vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [9,1]     .    . D====================================================eER.   vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: [9,2]     .    . D=====================================================eER   vpaddd	%xmm0, %xmm0, %xmm3

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    25.0   0.1    0.0       vpmuldq	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: 1.     10    29.7   0.0    0.0       vpaddd	%xmm1, %xmm1, %xmm0
# CHECK-NEXT: 2.     10    30.5   0.0    0.0       vpaddd	%xmm0, %xmm0, %xmm3
