# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake-avx512 -instruction-tables < %s | FileCheck %s

vpabsb            %zmm16, %zmm19
vpabsb            (%rax), %zmm19
vpabsb            %zmm16, %zmm19 {k1}
vpabsb            (%rax), %zmm19 {k1}
vpabsb            %zmm16, %zmm19 {z}{k1}
vpabsb            (%rax), %zmm19 {z}{k1}

vpabsw            %zmm16, %zmm19
vpabsw            (%rax), %zmm19
vpabsw            %zmm16, %zmm19 {k1}
vpabsw            (%rax), %zmm19 {k1}
vpabsw            %zmm16, %zmm19 {z}{k1}
vpabsw            (%rax), %zmm19 {z}{k1}

vpaddb            %zmm16, %zmm17, %zmm19
vpaddb            (%rax), %zmm17, %zmm19
vpaddb            %zmm16, %zmm17, %zmm19 {k1}
vpaddb            (%rax), %zmm17, %zmm19 {k1}
vpaddb            %zmm16, %zmm17, %zmm19 {z}{k1}
vpaddb            (%rax), %zmm17, %zmm19 {z}{k1}

vpaddw            %zmm16, %zmm17, %zmm19
vpaddw            (%rax), %zmm17, %zmm19
vpaddw            %zmm16, %zmm17, %zmm19 {k1}
vpaddw            (%rax), %zmm17, %zmm19 {k1}
vpaddw            %zmm16, %zmm17, %zmm19 {z}{k1}
vpaddw            (%rax), %zmm17, %zmm19 {z}{k1}

vpermw            %zmm16, %zmm17, %zmm19
vpermw            (%rax), %zmm17, %zmm19
vpermw            %zmm16, %zmm17, %zmm19 {k1}
vpermw            (%rax), %zmm17, %zmm19 {k1}
vpermw            %zmm16, %zmm17, %zmm19 {z}{k1}
vpermw            (%rax), %zmm17, %zmm19 {z}{k1}

vpshufb           %zmm16, %zmm17, %zmm19
vpshufb           (%rax), %zmm17, %zmm19
vpshufb           %zmm16, %zmm17, %zmm19 {k1}
vpshufb           (%rax), %zmm17, %zmm19 {k1}
vpshufb           %zmm16, %zmm17, %zmm19 {z}{k1}
vpshufb           (%rax), %zmm17, %zmm19 {z}{k1}

vpshufhw          $0, %zmm16, %zmm19
vpshufhw          $0, (%rax), %zmm19
vpshufhw          $0, %zmm16, %zmm19 {k1}
vpshufhw          $0, (%rax), %zmm19 {k1}
vpshufhw          $0, %zmm16, %zmm19 {z}{k1}
vpshufhw          $0, (%rax), %zmm19 {z}{k1}

vpshuflw          $0, %zmm16, %zmm19
vpshuflw          $0, (%rax), %zmm19
vpshuflw          $0, %zmm16, %zmm19 {k1}
vpshuflw          $0, (%rax), %zmm19 {k1}
vpshuflw          $0, %zmm16, %zmm19 {z}{k1}
vpshuflw          $0, (%rax), %zmm19 {z}{k1}

vpsubb            %zmm16, %zmm17, %zmm19
vpsubb            (%rax), %zmm17, %zmm19
vpsubb            %zmm16, %zmm17, %zmm19 {k1}
vpsubb            (%rax), %zmm17, %zmm19 {k1}
vpsubb            %zmm16, %zmm17, %zmm19 {z}{k1}
vpsubb            (%rax), %zmm17, %zmm19 {z}{k1}

vpsubw            %zmm16, %zmm17, %zmm19
vpsubw            (%rax), %zmm17, %zmm19
vpsubw            %zmm16, %zmm17, %zmm19 {k1}
vpsubw            (%rax), %zmm17, %zmm19 {k1}
vpsubw            %zmm16, %zmm17, %zmm19 {z}{k1}
vpsubw            (%rax), %zmm17, %zmm19 {z}{k1}

vpunpckhbw        %zmm16, %zmm17, %zmm19
vpunpckhbw        (%rax), %zmm17, %zmm19
vpunpckhbw        %zmm16, %zmm17, %zmm19 {k1}
vpunpckhbw        (%rax), %zmm17, %zmm19 {k1}
vpunpckhbw        %zmm16, %zmm17, %zmm19 {z}{k1}
vpunpckhbw        (%rax), %zmm17, %zmm19 {z}{k1}

vpunpckhwd        %zmm16, %zmm17, %zmm19
vpunpckhwd        (%rax), %zmm17, %zmm19
vpunpckhwd        %zmm16, %zmm17, %zmm19 {k1}
vpunpckhwd        (%rax), %zmm17, %zmm19 {k1}
vpunpckhwd        %zmm16, %zmm17, %zmm19 {z}{k1}
vpunpckhwd        (%rax), %zmm17, %zmm19 {z}{k1}

vpunpcklbw        %zmm16, %zmm17, %zmm19
vpunpcklbw        (%rax), %zmm17, %zmm19
vpunpcklbw        %zmm16, %zmm17, %zmm19 {k1}
vpunpcklbw        (%rax), %zmm17, %zmm19 {k1}
vpunpcklbw        %zmm16, %zmm17, %zmm19 {z}{k1}
vpunpcklbw        (%rax), %zmm17, %zmm19 {z}{k1}

vpunpcklwd        %zmm16, %zmm17, %zmm19
vpunpcklwd        (%rax), %zmm17, %zmm19
vpunpcklwd        %zmm16, %zmm17, %zmm19 {k1}
vpunpcklwd        (%rax), %zmm17, %zmm19 {k1}
vpunpcklwd        %zmm16, %zmm17, %zmm19 {z}{k1}
vpunpcklwd        (%rax), %zmm17, %zmm19 {z}{k1}

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     1.00                        vpabsb	%zmm16, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpabsb	(%rax), %zmm19
# CHECK-NEXT:  1      1     1.00                        vpabsb	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpabsb	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpabsb	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpabsb	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpabsw	%zmm16, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpabsw	(%rax), %zmm19
# CHECK-NEXT:  1      1     1.00                        vpabsw	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpabsw	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpabsw	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpabsw	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.33                        vpaddb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpaddb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.33                        vpaddb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpaddb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.33                        vpaddb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpaddb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.33                        vpaddw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpaddw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.33                        vpaddw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpaddw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.33                        vpaddw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpaddw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      6     2.00                        vpermw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  3      13    2.00    *                   vpermw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  2      6     2.00                        vpermw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  3      13    2.00    *                   vpermw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      6     2.00                        vpermw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  3      13    2.00    *                   vpermw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpshufb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpshufb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     1.00                        vpshufb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpshufb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpshufb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpshufb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpshufhw	$0, %zmm16, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpshufhw	$0, (%rax), %zmm19
# CHECK-NEXT:  1      1     1.00                        vpshufhw	$0, %zmm16, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpshufhw	$0, (%rax), %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpshufhw	$0, %zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpshufhw	$0, (%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpshuflw	$0, %zmm16, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpshuflw	$0, (%rax), %zmm19
# CHECK-NEXT:  1      1     1.00                        vpshuflw	$0, %zmm16, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpshuflw	$0, (%rax), %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpshuflw	$0, %zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpshuflw	$0, (%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.33                        vpsubb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpsubb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.33                        vpsubb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpsubb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.33                        vpsubb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpsubb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     0.33                        vpsubw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     0.50    *                   vpsubw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     0.33                        vpsubw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     0.50    *                   vpsubw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     0.33                        vpsubw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     0.50    *                   vpsubw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpunpckhbw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpunpckhbw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     1.00                        vpunpckhbw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpunpckhbw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpunpckhbw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpunpckhbw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpunpckhwd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpunpckhwd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     1.00                        vpunpckhwd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpunpckhwd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpunpckhwd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpunpckhwd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpunpcklbw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpunpcklbw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     1.00                        vpunpcklbw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpunpcklbw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpunpcklbw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpunpcklbw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  1      1     1.00                        vpunpcklwd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  2      8     1.00    *                   vpunpcklwd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  1      1     1.00                        vpunpcklwd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  2      8     1.00    *                   vpunpcklwd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  1      1     1.00                        vpunpcklwd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  2      8     1.00    *                   vpunpcklwd	(%rax), %zmm17, %zmm19 {%k1} {z}

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SKXDivider
# CHECK-NEXT: [1]   - SKXFPDivider
# CHECK-NEXT: [2]   - SKXPort0
# CHECK-NEXT: [3]   - SKXPort1
# CHECK-NEXT: [4]   - SKXPort2
# CHECK-NEXT: [5]   - SKXPort3
# CHECK-NEXT: [6]   - SKXPort4
# CHECK-NEXT: [7]   - SKXPort5
# CHECK-NEXT: [8]   - SKXPort6
# CHECK-NEXT: [9]   - SKXPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     20.00  8.00   21.00  21.00   -     62.00   -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vpabsb	%zmm16, %zmm19
# CHECK-NEXT:  -      -     1.00    -     0.50   0.50    -      -      -      -     vpabsb	(%rax), %zmm19
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vpabsb	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -     0.50   0.50    -      -      -      -     vpabsb	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vpabsb	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -     0.50   0.50    -      -      -      -     vpabsb	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vpabsw	%zmm16, %zmm19
# CHECK-NEXT:  -      -     1.00    -     0.50   0.50    -      -      -      -     vpabsw	(%rax), %zmm19
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vpabsw	%zmm16, %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -     0.50   0.50    -      -      -      -     vpabsw	(%rax), %zmm19 {%k1}
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vpabsw	%zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     1.00    -     0.50   0.50    -      -      -      -     vpabsw	(%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpaddb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpaddb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpaddb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpaddb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpaddb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpaddb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpaddw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpaddw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpaddw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpaddw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpaddw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpaddw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     2.00    -      -     vpermw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     2.00    -      -     vpermw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     2.00    -      -     vpermw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     2.00    -      -     vpermw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     2.00    -      -     vpermw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     2.00    -      -     vpermw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshufb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshufb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshufb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshufb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshufb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshufb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshufhw	$0, %zmm16, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshufhw	$0, (%rax), %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshufhw	$0, %zmm16, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshufhw	$0, (%rax), %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshufhw	$0, %zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshufhw	$0, (%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshuflw	$0, %zmm16, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshuflw	$0, (%rax), %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshuflw	$0, %zmm16, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshuflw	$0, (%rax), %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpshuflw	$0, %zmm16, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpshuflw	$0, (%rax), %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpsubb	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpsubb	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpsubb	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpsubb	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpsubb	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpsubb	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpsubw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpsubw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpsubw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpsubw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     0.33    -      -     vpsubw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vpsubw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpckhbw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpckhbw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpckhbw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpckhbw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpckhbw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpckhbw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpckhwd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpckhwd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpckhwd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpckhwd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpckhwd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpckhwd	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpcklbw	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpcklbw	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpcklbw	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpcklbw	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpcklbw	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpcklbw	(%rax), %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpcklwd	%zmm16, %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpcklwd	(%rax), %zmm17, %zmm19
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpcklwd	%zmm16, %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpcklwd	(%rax), %zmm17, %zmm19 {%k1}
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpunpcklwd	%zmm16, %zmm17, %zmm19 {%k1} {z}
# CHECK-NEXT:  -      -      -      -     0.50   0.50    -     1.00    -      -     vpunpcklwd	(%rax), %zmm17, %zmm19 {%k1} {z}
