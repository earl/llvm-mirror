# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -instruction-tables < %s | FileCheck %s

vaddpd            %zmm16, %zmm17, %zmm19
vaddpd            (%rax), %zmm17, %zmm19
vaddpd            %zmm16, %zmm17, %zmm19 {k1}
vaddpd            (%rax), %zmm17, %zmm19 {k1}
vaddpd            %zmm16, %zmm17, %zmm19 {z}{k1}
vaddpd            (%rax), %zmm17, %zmm19 {z}{k1}

vaddps            %zmm16, %zmm17, %zmm19
vaddps            (%rax), %zmm17, %zmm19
vaddps            %zmm16, %zmm17, %zmm19 {k1}
vaddps            (%rax), %zmm17, %zmm19 {k1}
vaddps            %zmm16, %zmm17, %zmm19 {z}{k1}
vaddps            (%rax), %zmm17, %zmm19 {z}{k1}

vdivpd            %zmm16, %zmm17, %zmm19
vdivpd            (%rax), %zmm17, %zmm19
vdivpd            %zmm16, %zmm17, %zmm19 {k1}
vdivpd            (%rax), %zmm17, %zmm19 {k1}
vdivpd            %zmm16, %zmm17, %zmm19 {z}{k1}
vdivpd            (%rax), %zmm17, %zmm19 {z}{k1}

vdivps            %zmm16, %zmm17, %zmm19
vdivps            (%rax), %zmm17, %zmm19
vdivps            %zmm16, %zmm17, %zmm19 {k1}
vdivps            (%rax), %zmm17, %zmm19 {k1}
vdivps            %zmm16, %zmm17, %zmm19 {z}{k1}
vdivps            (%rax), %zmm17, %zmm19 {z}{k1}

vmulpd            %zmm16, %zmm17, %zmm19
vmulpd            (%rax), %zmm17, %zmm19
vmulpd            %zmm16, %zmm17, %zmm19 {k1}
vmulpd            (%rax), %zmm17, %zmm19 {k1}
vmulpd            %zmm16, %zmm17, %zmm19 {z}{k1}
vmulpd            (%rax), %zmm17, %zmm19 {z}{k1}

vmulps            %zmm16, %zmm17, %zmm19
vmulps            (%rax), %zmm17, %zmm19
vmulps            %zmm16, %zmm17, %zmm19 {k1}
vmulps            (%rax), %zmm17, %zmm19 {k1}
vmulps            %zmm16, %zmm17, %zmm19 {z}{k1}
vmulps            (%rax), %zmm17, %zmm19 {z}{k1}

vpabsd            %zmm16, %zmm19
vpabsd            (%rax), %zmm19
vpabsd            %zmm16, %zmm19 {k1}
vpabsd            (%rax), %zmm19 {k1}
vpabsd            %zmm16, %zmm19 {z}{k1}
vpabsd            (%rax), %zmm19 {z}{k1}

vpabsq            %zmm16, %zmm19
vpabsq            (%rax), %zmm19
vpabsq            %zmm16, %zmm19 {k1}
vpabsq            (%rax), %zmm19 {k1}
vpabsq            %zmm16, %zmm19 {z}{k1}
vpabsq            (%rax), %zmm19 {z}{k1}

vpaddb            %zmm16, %zmm17, %zmm19
vpaddb            (%rax), %zmm17, %zmm19
vpaddb            %zmm16, %zmm17, %zmm19 {k1}
vpaddb            (%rax), %zmm17, %zmm19 {k1}
vpaddb            %zmm16, %zmm17, %zmm19 {z}{k1}
vpaddb            (%rax), %zmm17, %zmm19 {z}{k1}

vpaddd            %zmm16, %zmm17, %zmm19
vpaddd            (%rax), %zmm17, %zmm19
vpaddd            %zmm16, %zmm17, %zmm19 {k1}
vpaddd            (%rax), %zmm17, %zmm19 {k1}
vpaddd            %zmm16, %zmm17, %zmm19 {z}{k1}
vpaddd            (%rax), %zmm17, %zmm19 {z}{k1}

vpaddq            %zmm16, %zmm17, %zmm19
vpaddq            (%rax), %zmm17, %zmm19
vpaddq            %zmm16, %zmm17, %zmm19 {k1}
vpaddq            (%rax), %zmm17, %zmm19 {k1}
vpaddq            %zmm16, %zmm17, %zmm19 {z}{k1}
vpaddq            (%rax), %zmm17, %zmm19 {z}{k1}

vpaddw            %zmm16, %zmm17, %zmm19
vpaddw            (%rax), %zmm17, %zmm19
vpaddw            %zmm16, %zmm17, %zmm19 {k1}
vpaddw            (%rax), %zmm17, %zmm19 {k1}
vpaddw            %zmm16, %zmm17, %zmm19 {z}{k1}
vpaddw            (%rax), %zmm17, %zmm19 {z}{k1}

vpsubb            %zmm16, %zmm17, %zmm19
vpsubb            (%rax), %zmm17, %zmm19
vpsubb            %zmm16, %zmm17, %zmm19 {k1}
vpsubb            (%rax), %zmm17, %zmm19 {k1}
vpsubb            %zmm16, %zmm17, %zmm19 {z}{k1}
vpsubb            (%rax), %zmm17, %zmm19 {z}{k1}

vpsubd            %zmm16, %zmm17, %zmm19
vpsubd            (%rax), %zmm17, %zmm19
vpsubd            %zmm16, %zmm17, %zmm19 {k1}
vpsubd            (%rax), %zmm17, %zmm19 {k1}
vpsubd            %zmm16, %zmm17, %zmm19 {z}{k1}
vpsubd            (%rax), %zmm17, %zmm19 {z}{k1}

vpsubq            %zmm16, %zmm17, %zmm19
vpsubq            (%rax), %zmm17, %zmm19
vpsubq            %zmm16, %zmm17, %zmm19 {k1}
vpsubq            (%rax), %zmm17, %zmm19 {k1}
vpsubq            %zmm16, %zmm17, %zmm19 {z}{k1}
vpsubq            (%rax), %zmm17, %zmm19 {z}{k1}

vpsubw            %zmm16, %zmm17, %zmm19
vpsubw            (%rax), %zmm17, %zmm19
vpsubw            %zmm16, %zmm17, %zmm19 {k1}
vpsubw            (%rax), %zmm17, %zmm19 {k1}
vpsubw            %zmm16, %zmm17, %zmm19 {z}{k1}
vpsubw            (%rax), %zmm17, %zmm19 {z}{k1}

vsubpd            %zmm16, %zmm17, %zmm19
vsubpd            (%rax), %zmm17, %zmm19
vsubpd            %zmm16, %zmm17, %zmm19 {k1}
vsubpd            (%rax), %zmm17, %zmm19 {k1}
vsubpd            %zmm16, %zmm17, %zmm19 {z}{k1}
vsubpd            (%rax), %zmm17, %zmm19 {z}{k1}

vsubps            %zmm16, %zmm17, %zmm19
vsubps            (%rax), %zmm17, %zmm19
vsubps            %zmm16, %zmm17, %zmm19 {k1}
vsubps            (%rax), %zmm17, %zmm19 {k1}
vsubps            %zmm16, %zmm17, %zmm19 {z}{k1}
vsubps            (%rax), %zmm17, %zmm19 {z}{k1}

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        vaddpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      10    1.00    *                   vaddpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      3     1.00                        vaddpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      10    1.00    *                   vaddpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      3     1.00                        vaddpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      10    1.00    *                   vaddpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      3     1.00                        vaddps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      10    1.00    *                   vaddps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      3     1.00                        vaddps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      10    1.00    *                   vaddps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      3     1.00                        vaddps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      10    1.00    *                   vaddps	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  3      45    44.00                       vdivpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  4      52    44.00   *                   vdivpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  3      45    44.00                       vdivpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  4      52    44.00   *                   vdivpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  3      45    44.00                       vdivpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  4      52    44.00   *                   vdivpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  3      29    28.00                       vdivps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  4      36    28.00   *                   vdivps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  3      29    28.00                       vdivps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  4      36    28.00   *                   vdivps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  3      29    28.00                       vdivps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  4      36    28.00   *                   vdivps	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      5     1.00                        vmulpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      12    1.00    *                   vmulpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      5     1.00                        vmulpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      12    1.00    *                   vmulpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      5     1.00                        vmulpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      12    1.00    *                   vmulpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      5     1.00                        vmulps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      12    1.00    *                   vmulps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      5     1.00                        vmulps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      12    1.00    *                   vmulps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      5     1.00                        vmulps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      12    1.00    *                   vmulps	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpabsd	%zmm16, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpabsd	(%rax), %zmm19
# CHECK-NEXT:  1      1     0.50                        vpabsd	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpabsd	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpabsd	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpabsd	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpabsq	%zmm16, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpabsq	(%rax), %zmm19
# CHECK-NEXT:  1      1     0.50                        vpabsq	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpabsq	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpabsq	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpabsq	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpaddb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpaddb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpaddb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpaddb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpaddb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpaddb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpaddd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpaddd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpaddd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpaddd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpaddd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpaddd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpaddq	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpaddq	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpaddq	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpaddq	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpaddq	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpaddq	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpaddw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpaddw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpaddw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpaddw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpaddw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpaddw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpsubb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpsubb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpsubb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpsubb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpsubb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpsubb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpsubd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpsubd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpsubd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpsubd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpsubd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpsubd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpsubq	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpsubq	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpsubq	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpsubq	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpsubq	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpsubq	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.50                        vpsubw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpsubw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.50                        vpsubw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpsubw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.50                        vpsubw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpsubw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      3     1.00                        vsubpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      10    1.00    *                   vsubpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      3     1.00                        vsubpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      10    1.00    *                   vsubpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      3     1.00                        vsubpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      10    1.00    *                   vsubpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      3     1.00                        vsubps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      10    1.00    *                   vsubps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      3     1.00                        vsubps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      10    1.00    *                   vsubps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      3     1.00                        vsubps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      10    1.00    *                   vsubps	(%rax), %zmm17, %zmm19 {%k1} {z}

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
# CHECK-NEXT:  -     432.00 42.00  54.00   -     36.00  27.00  27.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vaddpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vaddpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vaddpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vaddpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vaddpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vaddpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vaddps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vaddps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vaddps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vaddps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vaddps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vaddps	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -     44.00  2.50    -      -     0.50    -      -     vdivpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -     44.00  2.50    -      -     0.50   0.50   0.50   vdivpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -     44.00  2.50    -      -     0.50    -      -     vdivpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -     44.00  2.50    -      -     0.50   0.50   0.50   vdivpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -     44.00  2.50    -      -     0.50    -      -     vdivpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -     44.00  2.50    -      -     0.50   0.50   0.50   vdivpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -     28.00  2.50    -      -     0.50    -      -     vdivps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -     28.00  2.50    -      -     0.50   0.50   0.50   vdivps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -     28.00  2.50    -      -     0.50    -      -     vdivps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -     28.00  2.50    -      -     0.50   0.50   0.50   vdivps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -     28.00  2.50    -      -     0.50    -      -     vdivps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -     28.00  2.50    -      -     0.50   0.50   0.50   vdivps	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vmulpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vmulpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vmulpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vmulpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vmulpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vmulpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vmulps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vmulps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vmulps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vmulps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vmulps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vmulps	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpabsd	%zmm16, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpabsd	(%rax), %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpabsd	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpabsd	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpabsd	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpabsd	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpabsq	%zmm16, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpabsq	(%rax), %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpabsq	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpabsq	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpabsq	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpabsq	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddq	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddq	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddq	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddq	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddq	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddq	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpaddw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpaddw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubq	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubq	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubq	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubq	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubq	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubq	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpsubw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpsubw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vsubpd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vsubpd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vsubpd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vsubpd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vsubpd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vsubpd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vsubps	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vsubps	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vsubps	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vsubps	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vsubps	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vsubps	(%rax), %zmm17, %zmm19 {%k1} {z}
