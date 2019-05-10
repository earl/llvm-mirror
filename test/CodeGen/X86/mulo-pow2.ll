; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX

declare { <4 x i32>, <4 x i1> } @llvm.umul.with.overflow.v4i32(<4 x i32>, <4 x i32>)
declare { <4 x i32>, <4 x i1> } @llvm.smul.with.overflow.v4i32(<4 x i32>, <4 x i32>)

define <4 x i32> @umul_v4i32_0(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: umul_v4i32_0:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.umul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> zeroinitializer)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @umul_v4i32_1(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: umul_v4i32_1:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.umul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 1, i32 1, i32 1, i32 1>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @umul_v4i32_2(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: umul_v4i32_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddd %xmm0, %xmm0, %xmm2
; AVX-NEXT:    vpmaxud %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.umul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 2, i32 2, i32 2, i32 2>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @umul_v4i32_8(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: umul_v4i32_8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $3, %xmm0, %xmm2
; AVX-NEXT:    vpsrld $3, %xmm2, %xmm3
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm3, %xmm0
; AVX-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.umul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 8, i32 8, i32 8, i32 8>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @umul_v4i32_2pow31(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: umul_v4i32_2pow31:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm2
; AVX-NEXT:    vpsrld $31, %xmm2, %xmm3
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm3, %xmm0
; AVX-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.umul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @smul_v4i32_0(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: smul_v4i32_0:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.smul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> zeroinitializer)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @smul_v4i32_1(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: smul_v4i32_1:
; AVX:       # %bb.0:
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.smul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 1, i32 1, i32 1, i32 1>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @smul_v4i32_2(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: smul_v4i32_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpgtd %xmm0, %xmm2, %xmm3
; AVX-NEXT:    vpcmpeqd %xmm4, %xmm4, %xmm4
; AVX-NEXT:    vpxor %xmm4, %xmm3, %xmm3
; AVX-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vpcmpgtd %xmm0, %xmm2, %xmm2
; AVX-NEXT:    vpxor %xmm4, %xmm2, %xmm2
; AVX-NEXT:    vpcmpeqd %xmm2, %xmm3, %xmm2
; AVX-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.smul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 2, i32 2, i32 2, i32 2>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @smul_v4i32_8(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: smul_v4i32_8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $3, %xmm0, %xmm2
; AVX-NEXT:    vpsrad $3, %xmm2, %xmm3
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm3, %xmm0
; AVX-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.smul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 8, i32 8, i32 8, i32 8>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}

define <4 x i32> @smul_v4i32_2pow31(<4 x i32> %a, <4 x i32> %b) nounwind {
; AVX-LABEL: smul_v4i32_2pow31:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm2
; AVX-NEXT:    vpsrld $31, %xmm2, %xmm3
; AVX-NEXT:    vpcmpeqd %xmm0, %xmm3, %xmm0
; AVX-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; AVX-NEXT:    retq
    %x = call { <4 x i32>, <4 x i1> } @llvm.smul.with.overflow.v4i32(<4 x i32> %a, <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>)
    %y = extractvalue { <4 x i32>, <4 x i1> } %x, 0
    %z = extractvalue { <4 x i32>, <4 x i1> } %x, 1
    %u = select <4 x i1> %z, <4 x i32> %b, <4 x i32> %y
    ret <4 x i32> %u
}
