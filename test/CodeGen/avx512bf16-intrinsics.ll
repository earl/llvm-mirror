; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512bf16 --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bf16 --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64

declare <32 x i16> @llvm.x86.avx512bf16.cvtne2ps2bf16.512(<16 x float>, <16 x float>) #3

define <8 x i64> @test_mm512_cvtne2ps2bf16_512(<16 x float> %A, <16 x float> %B) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm512_cvtne2ps2bf16_512:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vcvtne2ps2bf16 %zmm1, %zmm0, %zmm0 # encoding: [0x62,0xf2,0x7f,0x48,0x72,0xc1]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
entry:
  %0 = tail call <32 x i16> @llvm.x86.avx512bf16.cvtne2ps2bf16.512(<16 x float> %A, <16 x float> %B) #4
  %1 = bitcast <32 x i16> %0 to <8 x i64>
  ret <8 x i64> %1
}

define <8 x i64> @test_mm512_maskz_cvtne2ps2bf16_512(<16 x float> %A, <16 x float> %B, i32 %U) local_unnamed_addr #2 {
; X86-LABEL: test_mm512_maskz_cvtne2ps2bf16_512:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf9,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vcvtne2ps2bf16 %zmm1, %zmm0, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x7f,0xc9,0x72,0xc1]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm512_maskz_cvtne2ps2bf16_512:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1 # encoding: [0xc5,0xfb,0x92,0xcf]
; X64-NEXT:    vcvtne2ps2bf16 %zmm1, %zmm0, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x7f,0xc9,0x72,0xc1]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call <32 x i16> @llvm.x86.avx512bf16.cvtne2ps2bf16.512(<16 x float> %A, <16 x float> %B) #4
  %1 = bitcast i32 %U to <32 x i1>
  %2 = select <32 x i1> %1, <32 x i16> %0, <32 x i16> zeroinitializer
  %3 = bitcast <32 x i16> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_mask_cvtne2ps2bf16_512(<8 x i64> %C, i32 %U, <16 x float> %A, <16 x float> %B) local_unnamed_addr #2 {
; X86-LABEL: test_mm512_mask_cvtne2ps2bf16_512:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf9,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vcvtne2ps2bf16 %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x77,0x49,0x72,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm512_mask_cvtne2ps2bf16_512:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1 # encoding: [0xc5,0xfb,0x92,0xcf]
; X64-NEXT:    vcvtne2ps2bf16 %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x77,0x49,0x72,0xc2]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call <32 x i16> @llvm.x86.avx512bf16.cvtne2ps2bf16.512(<16 x float> %A, <16 x float> %B) #4
  %1 = bitcast <8 x i64> %C to <32 x i16>
  %2 = bitcast i32 %U to <32 x i1>
  %3 = select <32 x i1> %2, <32 x i16> %0, <32 x i16> %1
  %4 = bitcast <32 x i16> %3 to <8 x i64>
  ret <8 x i64> %4
}

declare <16 x i16> @llvm.x86.avx512bf16.cvtneps2bf16.512(<16 x float>) #3

define <4 x i64> @test_mm512_cvtneps2bf16_512(<16 x float> %A) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm512_cvtneps2bf16_512:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vcvtneps2bf16 %zmm0, %ymm0 # encoding: [0x62,0xf2,0x7e,0x48,0x72,0xc0]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
entry:
  %0 = tail call <16 x i16> @llvm.x86.avx512bf16.cvtneps2bf16.512(<16 x float> %A) #4
  %1 = bitcast <16 x i16> %0 to <4 x i64>
  ret <4 x i64> %1
}

define <4 x i64> @test_mm512_maskz_cvtneps2bf16_512(<16 x float> %A, i16 %U) local_unnamed_addr #2 {
; X86-LABEL: test_mm512_maskz_cvtneps2bf16_512:
; X86:       # %bb.0: # %entry
; X86-NEXT:   kmovw 4(%esp), %k1 # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vcvtneps2bf16 %zmm0, %ymm0 {%k1} {z} # encoding: [0x62,0xf2,0x7e,0xc9,0x72,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm512_maskz_cvtneps2bf16_512:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1 # encoding: [0xc5,0xfb,0x92,0xcf]
; X64-NEXT:    vcvtneps2bf16 %zmm0, %ymm0 {%k1} {z} # encoding: [0x62,0xf2,0x7e,0xc9,0x72,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call <16 x i16> @llvm.x86.avx512bf16.cvtneps2bf16.512(<16 x float> %A) #4
  %1 = bitcast i16 %U to <16 x i1>
  %2 = select <16 x i1> %1, <16 x i16> %0, <16 x i16> zeroinitializer
  %3 = bitcast <16 x i16> %2 to <4 x i64>
  ret <4 x i64> %3
}

define <4 x i64> @test_mm512_mask_cvtneps2bf16_512(<4 x i64> %C, i16 %U, <16 x float> %A) local_unnamed_addr #2 {
; X86-LABEL: test_mm512_mask_cvtneps2bf16_512:
; X86:       # %bb.0: # %entry
; X86-NEXT:   kmovw 4(%esp), %k1 # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vcvtneps2bf16 %zmm1, %ymm0 {%k1} # encoding: [0x62,0xf2,0x7e,0x49,0x72,0xc1]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm512_mask_cvtneps2bf16_512:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1 # encoding: [0xc5,0xfb,0x92,0xcf]
; X64-NEXT:    vcvtneps2bf16 %zmm1, %ymm0 {%k1} # encoding: [0x62,0xf2,0x7e,0x49,0x72,0xc1]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call <16 x i16> @llvm.x86.avx512bf16.cvtneps2bf16.512(<16 x float> %A) #4
  %1 = bitcast <4 x i64> %C to <16 x i16>
  %2 = bitcast i16 %U to <16 x i1>
  %3 = select <16 x i1> %2, <16 x i16> %0, <16 x i16> %1
  %4 = bitcast <16 x i16> %3 to <4 x i64>
  ret <4 x i64> %4
}

declare <16 x float> @llvm.x86.avx512bf16.dpbf16ps.512(<16 x float>, <16 x i32>, <16 x i32>) #3

define <16 x float> @test_mm512_dpbf16ps_512(<16 x float> %E, <16 x i32> %A, <16 x i32> %B) local_unnamed_addr #2 {
; CHECK-LABEL: test_mm512_dpbf16ps_512:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vdpbf16ps       %zmm2, %zmm1, %zmm0 # encoding: [0x62,0xf2,0x76,0x48,0x52,0xc2]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512bf16.dpbf16ps.512(<16 x float> %E, <16 x i32> %A, <16 x i32> %B) #4
  ret <16 x float> %0
}

define <16 x float> @test_mm512_maskz_dpbf16ps_512(<16 x float> %E, <16 x i32> %A, <16 x i32> %B, i16 zeroext %U) local_unnamed_addr #2 {
; X86-LABEL: test_mm512_maskz_dpbf16ps_512:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw   4(%esp), %k1            # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vdpbf16ps       %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x76,0xc9,0x52,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm512_maskz_dpbf16ps_512:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1 # encoding: [0xc5,0xfb,0x92,0xcf]
; X64-NEXT:    vdpbf16ps       %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x76,0xc9,0x52,0xc2]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512bf16.dpbf16ps.512(<16 x float> %E, <16 x i32> %A, <16 x i32> %B) #4
  %1 = bitcast i16 %U to <16 x i1>
  %2 = select <16 x i1> %1, <16 x float> %0, <16 x float> zeroinitializer
  ret <16 x float> %2
}
define <16 x float> @test_mm512_mask_dpbf16ps_512(i16 zeroext %U, <16 x float> %E, <16 x i32> %A, <16 x i32> %B) local_unnamed_addr #2 {
; X86-LABEL: test_mm512_mask_dpbf16ps_512:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw   4(%esp), %k1            # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vdpbf16ps       %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x76,0x49,0x52,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_mm512_mask_dpbf16ps_512:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1 # encoding: [0xc5,0xfb,0x92,0xcf]
; X64-NEXT:    vdpbf16ps       %zmm2, %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x76,0x49,0x52,0xc2]
; X64-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512bf16.dpbf16ps.512(<16 x float> %E, <16 x i32> %A, <16 x i32> %B) #4
  %1 = bitcast i16 %U to <16 x i1>
  %2 = select <16 x i1> %1, <16 x float> %0, <16 x float> %E
  ret <16 x float> %2
}
