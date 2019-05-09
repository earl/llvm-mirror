# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -instruction-tables < %s | FileCheck %s

vfmaddpd    %xmm0, %xmm1, %xmm2, %xmm3
vfmaddpd    (%rax), %xmm1, %xmm2, %xmm3
vfmaddpd    %xmm0, (%rax), %xmm2, %xmm3

vfmaddpd    %ymm0, %ymm1, %ymm2, %ymm3
vfmaddpd    (%rax), %ymm1, %ymm2, %ymm3
vfmaddpd    %ymm0, (%rax), %ymm2, %ymm3

vfmaddps    %xmm0, %xmm1, %xmm2, %xmm3
vfmaddps    (%rax), %xmm1, %xmm2, %xmm3
vfmaddps    %xmm0, (%rax), %xmm2, %xmm3

vfmaddps    %ymm0, %ymm1, %ymm2, %ymm3
vfmaddps    (%rax), %ymm1, %ymm2, %ymm3
vfmaddps    %ymm0, (%rax), %ymm2, %ymm3

vfmaddsd    %xmm0, %xmm1, %xmm2, %xmm3
vfmaddsd    (%rax), %xmm1, %xmm2, %xmm3
vfmaddsd    %xmm0, (%rax), %xmm2, %xmm3

vfmaddss    %xmm0, %xmm1, %xmm2, %xmm3
vfmaddss    (%rax), %xmm1, %xmm2, %xmm3
vfmaddss    %xmm0, (%rax), %xmm2, %xmm3

vfmaddsubpd %xmm0, %xmm1, %xmm2, %xmm3
vfmaddsubpd (%rax), %xmm1, %xmm2, %xmm3
vfmaddsubpd %xmm0, (%rax), %xmm2, %xmm3

vfmaddsubpd %ymm0, %ymm1, %ymm2, %ymm3
vfmaddsubpd (%rax), %ymm1, %ymm2, %ymm3
vfmaddsubpd %ymm0, (%rax), %ymm2, %ymm3

vfmaddsubps %xmm0, %xmm1, %xmm2, %xmm3
vfmaddsubps (%rax), %xmm1, %xmm2, %xmm3
vfmaddsubps %xmm0, (%rax), %xmm2, %xmm3

vfmaddsubps %ymm0, %ymm1, %ymm2, %ymm3
vfmaddsubps (%rax), %ymm1, %ymm2, %ymm3
vfmaddsubps %ymm0, (%rax), %ymm2, %ymm3

vfmsubaddpd %xmm0, %xmm1, %xmm2, %xmm3
vfmsubaddpd (%rax), %xmm1, %xmm2, %xmm3
vfmsubaddpd %xmm0, (%rax), %xmm2, %xmm3

vfmsubaddpd %ymm0, %ymm1, %ymm2, %ymm3
vfmsubaddpd (%rax), %ymm1, %ymm2, %ymm3
vfmsubaddpd %ymm0, (%rax), %ymm2, %ymm3

vfmsubaddps %xmm0, %xmm1, %xmm2, %xmm3
vfmsubaddps (%rax), %xmm1, %xmm2, %xmm3
vfmsubaddps %xmm0, (%rax), %xmm2, %xmm3

vfmsubaddps %ymm0, %ymm1, %ymm2, %ymm3
vfmsubaddps (%rax), %ymm1, %ymm2, %ymm3
vfmsubaddps %ymm0, (%rax), %ymm2, %ymm3

vfmsubpd    %xmm0, %xmm1, %xmm2, %xmm3
vfmsubpd    (%rax), %xmm1, %xmm2, %xmm3
vfmsubpd    %xmm0, (%rax), %xmm2, %xmm3

vfmsubpd    %ymm0, %ymm1, %ymm2, %ymm3
vfmsubpd    (%rax), %ymm1, %ymm2, %ymm3
vfmsubpd    %ymm0, (%rax), %ymm2, %ymm3

vfmsubps    %xmm0, %xmm1, %xmm2, %xmm3
vfmsubps    (%rax), %xmm1, %xmm2, %xmm3
vfmsubps    %xmm0, (%rax), %xmm2, %xmm3

vfmsubps    %ymm0, %ymm1, %ymm2, %ymm3
vfmsubps    (%rax), %ymm1, %ymm2, %ymm3
vfmsubps    %ymm0, (%rax), %ymm2, %ymm3

vfmsubsd    %xmm0, %xmm1, %xmm2, %xmm3
vfmsubsd    (%rax), %xmm1, %xmm2, %xmm3
vfmsubsd    %xmm0, (%rax), %xmm2, %xmm3

vfmsubss    %xmm0, %xmm1, %xmm2, %xmm3
vfmsubss    (%rax), %xmm1, %xmm2, %xmm3
vfmsubss    %xmm0, (%rax), %xmm2, %xmm3

vfnmaddpd   %xmm0, %xmm1, %xmm2, %xmm3
vfnmaddpd   (%rax), %xmm1, %xmm2, %xmm3
vfnmaddpd   %xmm0, (%rax), %xmm2, %xmm3

vfnmaddpd   %ymm0, %ymm1, %ymm2, %ymm3
vfnmaddpd   (%rax), %ymm1, %ymm2, %ymm3
vfnmaddpd   %ymm0, (%rax), %ymm2, %ymm3

vfnmaddps   %xmm0, %xmm1, %xmm2, %xmm3
vfnmaddps   (%rax), %xmm1, %xmm2, %xmm3
vfnmaddps   %xmm0, (%rax), %xmm2, %xmm3

vfnmaddps   %ymm0, %ymm1, %ymm2, %ymm3
vfnmaddps   (%rax), %ymm1, %ymm2, %ymm3
vfnmaddps   %ymm0, (%rax), %ymm2, %ymm3

vfnmaddsd   %xmm0, %xmm1, %xmm2, %xmm3
vfnmaddsd   (%rax), %xmm1, %xmm2, %xmm3
vfnmaddsd   %xmm0, (%rax), %xmm2, %xmm3

vfnmaddss   %xmm0, %xmm1, %xmm2, %xmm3
vfnmaddss   (%rax), %xmm1, %xmm2, %xmm3
vfnmaddss   %xmm0, (%rax), %xmm2, %xmm3

vfnmsubpd   %xmm0, %xmm1, %xmm2, %xmm3
vfnmsubpd   (%rax), %xmm1, %xmm2, %xmm3
vfnmsubpd   %xmm0, (%rax), %xmm2, %xmm3

vfnmsubpd   %ymm0, %ymm1, %ymm2, %ymm3
vfnmsubpd   (%rax), %ymm1, %ymm2, %ymm3
vfnmsubpd   %ymm0, (%rax), %ymm2, %ymm3

vfnmsubps   %xmm0, %xmm1, %xmm2, %xmm3
vfnmsubps   (%rax), %xmm1, %xmm2, %xmm3
vfnmsubps   %xmm0, (%rax), %xmm2, %xmm3

vfnmsubps   %ymm0, %ymm1, %ymm2, %ymm3
vfnmsubps   (%rax), %ymm1, %ymm2, %ymm3
vfnmsubps   %ymm0, (%rax), %ymm2, %ymm3

vfnmsubsd   %xmm0, %xmm1, %xmm2, %xmm3
vfnmsubsd   (%rax), %xmm1, %xmm2, %xmm3
vfnmsubsd   %xmm0, (%rax), %xmm2, %xmm3

vfnmsubss   %xmm0, %xmm1, %xmm2, %xmm3
vfnmsubss   (%rax), %xmm1, %xmm2, %xmm3
vfnmsubss   %xmm0, (%rax), %xmm2, %xmm3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      5     1.50                        vfmaddpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmaddpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmaddps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmaddps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmaddsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfmaddss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddss	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfmaddsubpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddsubpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddsubpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmaddsubpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddsubpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddsubpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmaddsubps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddsubps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmaddsubps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmaddsubps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddsubps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmaddsubps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmsubaddpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubaddpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubaddpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmsubaddpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubaddpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubaddpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmsubaddps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubaddps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubaddps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmsubaddps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubaddps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubaddps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmsubpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmsubpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmsubps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfmsubps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfmsubps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfmsubsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfmsubss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfmsubss	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfnmaddpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfnmaddpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmaddpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmaddpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfnmaddps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfnmaddps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmaddps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmaddps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfnmaddsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfnmaddss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmaddss	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfnmsubpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfnmsubpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmsubpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmsubpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfnmsubps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  2      5     1.50                        vfnmsubps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmsubps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      10    1.50    *                   vfnmsubps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  1      5     1.50                        vfnmsubsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  1      5     1.50                        vfnmsubss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  1      10    1.50    *                   vfnmsubss	%xmm0, (%rax), %xmm2, %xmm3

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT: 96.00  96.00   -      -      -      -      -      -     144.00 144.00  -      -      -      -     24.00  24.00  24.00  24.00   -     96.00  96.00   -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddss	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddsubpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddsubpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddsubps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmaddsubps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmaddsubps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubaddpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubaddpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubaddps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubaddps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubaddps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfmsubss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfmsubss	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmaddpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmaddpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmaddps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmaddps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmaddsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmaddss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmaddss	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmsubpd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubpd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubpd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmsubpd	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubpd	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubpd	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmsubps	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubps	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubps	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmsubps	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubps	(%rax), %ymm1, %ymm2, %ymm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubps	%ymm0, (%rax), %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmsubsd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubsd	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubsd	%xmm0, (%rax), %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -     vfnmsubss	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubss	(%rax), %xmm1, %xmm2, %xmm3
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -     1.50   1.50    -      -      -      -     0.25   0.25   0.25   0.25    -     1.50   1.50    -      -     vfnmsubss	%xmm0, (%rax), %xmm2, %xmm3
