; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=+avx2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx2 | FileCheck %s --check-prefix=X64

;
; 128-bit Vectors
;

define void @test_demanded_haddps_128(<4 x float> %a0, <4 x float> %a1, float *%a2) nounwind {
; X86-LABEL: test_demanded_haddps_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_haddps_128:
; X64:       ## %bb.0:
; X64-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; X64-NEXT:    vmovss %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <4 x float> %a1, <4 x float> undef, <4 x i32> zeroinitializer
  %2 = call <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float> %a0, <4 x float> %1)
  %3 = extractelement <4 x float> %2, i32 0
  store float %3, float *%a2
  ret void
}

define void @test_demanded_hsubps_128(<4 x float> %a0, <4 x float> %a1, float *%a2) nounwind {
; X86-LABEL: test_demanded_hsubps_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhsubps %xmm1, %xmm0, %xmm0
; X86-NEXT:    vextractps $2, %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_hsubps_128:
; X64:       ## %bb.0:
; X64-NEXT:    vhsubps %xmm1, %xmm0, %xmm0
; X64-NEXT:    vextractps $2, %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <4 x float> %a0, <4 x float> undef, <4 x i32> zeroinitializer
  %2 = call <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float> %1, <4 x float> %a1)
  %3 = extractelement <4 x float> %2, i32 2
  store float %3, float *%a2
  ret void
}

define void @test_demanded_haddpd_128(<2 x double> %a0, <2 x double> %a1, double *%a2) nounwind {
; X86-LABEL: test_demanded_haddpd_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovlpd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_haddpd_128:
; X64:       ## %bb.0:
; X64-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vmovlpd %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <2 x double> %a1, <2 x double> undef, <2 x i32> zeroinitializer
  %2 = call <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double> %a0, <2 x double> %1)
  %3 = extractelement <2 x double> %2, i32 0
  store double %3, double *%a2
  ret void
}

define void @test_demanded_hsubpd_128(<2 x double> %a0, <2 x double> %a1, double *%a2) nounwind {
; X86-LABEL: test_demanded_hsubpd_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhsubpd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovlpd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_hsubpd_128:
; X64:       ## %bb.0:
; X64-NEXT:    vhsubpd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vmovlpd %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <2 x double> %a1, <2 x double> undef, <2 x i32> zeroinitializer
  %2 = call <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double> %a0, <2 x double> %1)
  %3 = extractelement <2 x double> %2, i32 0
  store double %3, double *%a2
  ret void
}

define void @test_demanded_phaddd_128(<4 x i32> %a0, <4 x i32> %a1, i32 *%a2) nounwind {
; X86-LABEL: test_demanded_phaddd_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phaddd_128:
; X64:       ## %bb.0:
; X64-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vmovd %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <4 x i32> %a1, <4 x i32> undef, <4 x i32> zeroinitializer
  %2 = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %a0, <4 x i32> %1)
  %3 = extractelement <4 x i32> %2, i32 0
  store i32 %3, i32 *%a2
  ret void
}

define void @test_demanded_phsubd_128(<4 x i32> %a0, <4 x i32> %a1, i32 *%a2) nounwind {
; X86-LABEL: test_demanded_phsubd_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vphsubd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vpextrd $1, %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phsubd_128:
; X64:       ## %bb.0:
; X64-NEXT:    vphsubd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vpextrd $1, %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <4 x i32> %a1, <4 x i32> undef, <4 x i32> zeroinitializer
  %2 = call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %a0, <4 x i32> %1)
  %3 = extractelement <4 x i32> %2, i32 1
  store i32 %3, i32 *%a2
  ret void
}

define void @test_demanded_phaddw_128(<8 x i16> %a0, <8 x i16> %a1, i16 *%a2) nounwind {
; X86-LABEL: test_demanded_phaddw_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpbroadcastw %xmm1, %xmm1
; X86-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpextrw $0, %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phaddw_128:
; X64:       ## %bb.0:
; X64-NEXT:    vpbroadcastw %xmm1, %xmm1
; X64-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpextrw $0, %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <8 x i16> %a1, <8 x i16> undef, <8 x i32> zeroinitializer
  %2 = call <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16> %a0, <8 x i16> %1)
  %3 = extractelement <8 x i16> %2, i16 0
  store i16 %3, i16 *%a2
  ret void
}

define void @test_demanded_phsubw_128(<8 x i16> %a0, <8 x i16> %a1, i16 *%a2) nounwind {
; X86-LABEL: test_demanded_phsubw_128:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpbroadcastw %xmm1, %xmm1
; X86-NEXT:    vphsubw %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpextrw $2, %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phsubw_128:
; X64:       ## %bb.0:
; X64-NEXT:    vpbroadcastw %xmm1, %xmm1
; X64-NEXT:    vphsubw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpextrw $2, %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = shufflevector <8 x i16> %a1, <8 x i16> undef, <8 x i32> zeroinitializer
  %2 = call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %a0, <8 x i16> %1)
  %3 = extractelement <8 x i16> %2, i16 2
  store i16 %3, i16 *%a2
  ret void
}

;
; 256-bit Vectors
;

define void @test_demanded_haddps_256(<8 x float> %a0, <8 x float> %a1, float *%a2) nounwind {
; X86-LABEL: test_demanded_haddps_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_haddps_256:
; X64:       ## %bb.0:
; X64-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; X64-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X64-NEXT:    vmovss %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <8 x float> %a1, <8 x float> undef, <8 x i32> zeroinitializer
  %2 = call <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float> %a0, <8 x float> %1)
  %3 = extractelement <8 x float> %2, i32 4
  store float %3, float *%a2
  ret void
}

define void @test_demanded_hsubps_256(<8 x float> %a0, <8 x float> %a1, float *%a2) nounwind {
; X86-LABEL: test_demanded_hsubps_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhsubps %ymm1, %ymm0, %ymm0
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X86-NEXT:    vextractps $3, %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_hsubps_256:
; X64:       ## %bb.0:
; X64-NEXT:    vhsubps %ymm1, %ymm0, %ymm0
; X64-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X64-NEXT:    vextractps $3, %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <8 x float> %a0, <8 x float> undef, <8 x i32> zeroinitializer
  %2 = call <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float> %1, <8 x float> %a1)
  %3 = extractelement <8 x float> %2, i32 7
  store float %3, float *%a2
  ret void
}

define void @test_demanded_haddpd_256(<4 x double> %a0, <4 x double> %a1, double *%a2) nounwind {
; X86-LABEL: test_demanded_haddpd_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X86-NEXT:    vmovlpd %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_haddpd_256:
; X64:       ## %bb.0:
; X64-NEXT:    vhaddpd %ymm0, %ymm0, %ymm0
; X64-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X64-NEXT:    vmovlpd %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <4 x double> %a1, <4 x double> undef, <4 x i32> zeroinitializer
  %2 = call <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double> %a0, <4 x double> %1)
  %3 = extractelement <4 x double> %2, i32 2
  store double %3, double *%a2
  ret void
}

define void @test_demanded_hsubpd_256(<4 x double> %a0, <4 x double> %a1, double *%a2) nounwind {
; X86-LABEL: test_demanded_hsubpd_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vhsubpd %ymm0, %ymm0, %ymm0
; X86-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X86-NEXT:    vmovlpd %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_hsubpd_256:
; X64:       ## %bb.0:
; X64-NEXT:    vhsubpd %ymm0, %ymm0, %ymm0
; X64-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X64-NEXT:    vmovlpd %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <4 x double> %a1, <4 x double> undef, <4 x i32> zeroinitializer
  %2 = call <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double> %a0, <4 x double> %1)
  %3 = extractelement <4 x double> %2, i32 2
  store double %3, double *%a2
  ret void
}

define void @test_demanded_phaddd_256(<8 x i32> %a0, <8 x i32> %a1, i32 *%a2) nounwind {
; X86-LABEL: test_demanded_phaddd_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; X86-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X86-NEXT:    vpextrd $3, %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phaddd_256:
; X64:       ## %bb.0:
; X64-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X64-NEXT:    vpextrd $3, %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <8 x i32> %a0, <8 x i32> undef, <8 x i32> zeroinitializer
  %2 = call <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32> %1, <8 x i32> %a1)
  %3 = extractelement <8 x i32> %2, i32 7
  store i32 %3, i32 *%a2
  ret void
}

define void @test_demanded_phsubd_256(<8 x i32> %a0, <8 x i32> %a1, i32 *%a2) nounwind {
; X86-LABEL: test_demanded_phsubd_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vphsubd %ymm0, %ymm0, %ymm0
; X86-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X86-NEXT:    vpextrd $1, %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phsubd_256:
; X64:       ## %bb.0:
; X64-NEXT:    vphsubd %ymm0, %ymm0, %ymm0
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm0
; X64-NEXT:    vpextrd $1, %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <8 x i32> %a1, <8 x i32> undef, <8 x i32> zeroinitializer
  %2 = call <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32> %a0, <8 x i32> %1)
  %3 = extractelement <8 x i32> %2, i32 5
  store i32 %3, i32 *%a2
  ret void
}

define void @test_demanded_phaddw_256(<16 x i16> %a0, <16 x i16> %a1, i16 *%a2) nounwind {
; X86-LABEL: test_demanded_phaddw_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpbroadcastw %xmm1, %xmm1
; X86-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpextrw $4, %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phaddw_256:
; X64:       ## %bb.0:
; X64-NEXT:    vpbroadcastw %xmm1, %xmm1
; X64-NEXT:    vphaddw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpextrw $4, %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <16 x i16> %a1, <16 x i16> undef, <16 x i32> zeroinitializer
  %2 = call <16 x i16> @llvm.x86.avx2.phadd.w(<16 x i16> %a0, <16 x i16> %1)
  %3 = extractelement <16 x i16> %2, i32 4
  store i16 %3, i16 *%a2
  ret void
}

define void @test_demanded_phsubw_256(<16 x i16> %a0, <16 x i16> %a1, i16 *%a2) nounwind {
; X86-LABEL: test_demanded_phsubw_256:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpbroadcastw %xmm0, %xmm0
; X86-NEXT:    vphsubw %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpextrw $6, %xmm0, (%eax)
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_demanded_phsubw_256:
; X64:       ## %bb.0:
; X64-NEXT:    vpbroadcastw %xmm0, %xmm0
; X64-NEXT:    vphsubw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpextrw $6, %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %1 = shufflevector <16 x i16> %a0, <16 x i16> undef, <16 x i32> zeroinitializer
  %2 = call <16 x i16> @llvm.x86.avx2.phsub.w(<16 x i16> %1, <16 x i16> %a1)
  %3 = extractelement <16 x i16> %2, i32 6
  store i16 %3, i16 *%a2
  ret void
}

declare <4 x float> @llvm.x86.sse3.hadd.ps(<4 x float>, <4 x float>)
declare <4 x float> @llvm.x86.sse3.hsub.ps(<4 x float>, <4 x float>)
declare <2 x double> @llvm.x86.sse3.hadd.pd(<2 x double>, <2 x double>)
declare <2 x double> @llvm.x86.sse3.hsub.pd(<2 x double>, <2 x double>)

declare <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16>, <8 x i16>)
declare <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32>, <4 x i32>)
declare <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16>, <8 x i16>)
declare <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32>, <4 x i32>)

declare <8 x float> @llvm.x86.avx.hadd.ps.256(<8 x float>, <8 x float>)
declare <8 x float> @llvm.x86.avx.hsub.ps.256(<8 x float>, <8 x float>)
declare <4 x double> @llvm.x86.avx.hadd.pd.256(<4 x double>, <4 x double>)
declare <4 x double> @llvm.x86.avx.hsub.pd.256(<4 x double>, <4 x double>)

declare <16 x i16> @llvm.x86.avx2.phadd.w(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.phadd.d(<8 x i32>, <8 x i32>)
declare <16 x i16> @llvm.x86.avx2.phsub.w(<16 x i16>, <16 x i16>)
declare <8 x i32> @llvm.x86.avx2.phsub.d(<8 x i32>, <8 x i32>)
