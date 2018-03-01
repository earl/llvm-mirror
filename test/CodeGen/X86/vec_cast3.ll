; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=corei7-avx -mattr=+avx | FileCheck %s
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=corei7-avx -mattr=+avx -x86-experimental-vector-widening-legalization | FileCheck %s --check-prefix=CHECK-WIDE

define <2 x float> @cvt_v2i8_v2f32(<2 x i8> %src) {
; CHECK-LABEL: cvt_v2i8_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpsllq $56, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $24, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2i8_v2f32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vpmovsxbd %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = sitofp <2 x i8> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2i16_v2f32(<2 x i16> %src) {
; CHECK-LABEL: cvt_v2i16_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpsllq $48, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $16, %xmm0, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2i16_v2f32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vpmovsxwd %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = sitofp <2 x i16> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2i32_v2f32(<2 x i32> %src) {
; CHECK-LABEL: cvt_v2i32_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2i32_v2f32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = sitofp <2 x i32> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2u8_v2f32(<2 x i8> %src) {
; CHECK-LABEL: cvt_v2u8_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[8],zero,zero,zero,xmm0[u,u,u,u,u,u,u,u]
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2u8_v2f32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = uitofp <2 x i8> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2u16_v2f32(<2 x i16> %src) {
; CHECK-LABEL: cvt_v2u16_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1],zero,zero,xmm0[8,9],zero,zero,xmm0[8,9],zero,zero,xmm0[10,11],zero,zero
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2u16_v2f32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = uitofp <2 x i16> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2u32_v2f32(<2 x i32> %src) {
; CHECK-LABEL: cvt_v2u32_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; CHECK-NEXT:    vmovaps {{.*#+}} xmm1 = [4.503600e+15,4.503600e+15]
; CHECK-NEXT:    vorps %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vcvtpd2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2u32_v2f32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; CHECK-WIDE-NEXT:    vmovdqa {{.*#+}} xmm1 = [4.503600e+15,4.503600e+15]
; CHECK-WIDE-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vcvtpd2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = uitofp <2 x i32> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x i8> @cvt_v2f32_v2i8(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subl $68, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 72
; CHECK-NEXT:    vmovss %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    vextractps $1, %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll (%esp)
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrd $1, {{[0-9]+}}(%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $2, (%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $3, {{[0-9]+}}(%esp), %xmm0, %xmm0
; CHECK-NEXT:    addl $68, %esp
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2f32_v2i8:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm1, %eax
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %ecx
; CHECK-WIDE-NEXT:    vmovd %ecx, %xmm0
; CHECK-WIDE-NEXT:    vpinsrb $1, %eax, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = fptosi <2 x float> %src to <2 x i8>
  ret <2 x i8> %res
}

define <2 x i16> @cvt_v2f32_v2i16(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subl $68, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 72
; CHECK-NEXT:    vmovss %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    vextractps $1, %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll (%esp)
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrd $1, {{[0-9]+}}(%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $2, (%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $3, {{[0-9]+}}(%esp), %xmm0, %xmm0
; CHECK-NEXT:    addl $68, %esp
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2f32_v2i16:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    ## kill: def $xmm0 killed $xmm0 def $ymm0
; CHECK-WIDE-NEXT:    vcvttps2dq %ymm0, %ymm0
; CHECK-WIDE-NEXT:    vextractf128 $1, %ymm0, %xmm1
; CHECK-WIDE-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vzeroupper
; CHECK-WIDE-NEXT:    retl
  %res = fptosi <2 x float> %src to <2 x i16>
  ret <2 x i16> %res
}

define <2 x i32> @cvt_v2f32_v2i32(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2f32_v2i32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = fptosi <2 x float> %src to <2 x i32>
  ret <2 x i32> %res
}

define <2 x i8> @cvt_v2f32_v2u8(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2u8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subl $68, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 72
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; CHECK-NEXT:    vcmpltss %xmm2, %xmm1, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm1, %xmm4, %xmm3
; CHECK-NEXT:    vmovss %xmm3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    vcmpltss %xmm2, %xmm0, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm0, %xmm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm0, %xmm4, %xmm3
; CHECK-NEXT:    vmovss %xmm3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll (%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    vucomiss %xmm2, %xmm1
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    shll $31, %eax
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    vucomiss %xmm2, %xmm0
; CHECK-NEXT:    setae %cl
; CHECK-NEXT:    shll $31, %ecx
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $2, (%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $3, %eax, %xmm0, %xmm0
; CHECK-NEXT:    addl $68, %esp
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2f32_v2u8:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm1, %eax
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %ecx
; CHECK-WIDE-NEXT:    vmovd %ecx, %xmm0
; CHECK-WIDE-NEXT:    vpinsrb $1, %eax, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = fptoui <2 x float> %src to <2 x i8>
  ret <2 x i8> %res
}

define <2 x i16> @cvt_v2f32_v2u16(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2u16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subl $68, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 72
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; CHECK-NEXT:    vcmpltss %xmm2, %xmm1, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm1, %xmm4, %xmm3
; CHECK-NEXT:    vmovss %xmm3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    vcmpltss %xmm2, %xmm0, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm0, %xmm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm0, %xmm4, %xmm3
; CHECK-NEXT:    vmovss %xmm3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll (%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    vucomiss %xmm2, %xmm1
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    shll $31, %eax
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    vucomiss %xmm2, %xmm0
; CHECK-NEXT:    setae %cl
; CHECK-NEXT:    shll $31, %ecx
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $2, (%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $3, %eax, %xmm0, %xmm0
; CHECK-NEXT:    addl $68, %esp
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2f32_v2u16:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    ## kill: def $xmm0 killed $xmm0 def $ymm0
; CHECK-WIDE-NEXT:    vcvttps2dq %ymm0, %ymm0
; CHECK-WIDE-NEXT:    vextractf128 $1, %ymm0, %xmm1
; CHECK-WIDE-NEXT:    vpackusdw %xmm1, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vzeroupper
; CHECK-WIDE-NEXT:    retl
  %res = fptoui <2 x float> %src to <2 x i16>
  ret <2 x i16> %res
}

define <2 x i32> @cvt_v2f32_v2u32(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2u32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subl $68, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 72
; CHECK-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; CHECK-NEXT:    vcmpltss %xmm2, %xmm1, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm1, %xmm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm1, %xmm4, %xmm3
; CHECK-NEXT:    vmovss %xmm3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    vcmpltss %xmm2, %xmm0, %xmm3
; CHECK-NEXT:    vsubss %xmm2, %xmm0, %xmm4
; CHECK-NEXT:    vblendvps %xmm3, %xmm0, %xmm4, %xmm3
; CHECK-NEXT:    vmovss %xmm3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll (%esp)
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    vucomiss %xmm2, %xmm1
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    shll $31, %eax
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    vucomiss %xmm2, %xmm0
; CHECK-NEXT:    setae %cl
; CHECK-NEXT:    shll $31, %ecx
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $2, (%esp), %xmm0, %xmm0
; CHECK-NEXT:    vpinsrd $3, %eax, %xmm0, %xmm0
; CHECK-NEXT:    addl $68, %esp
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: cvt_v2f32_v2u32:
; CHECK-WIDE:       ## %bb.0:
; CHECK-WIDE-NEXT:    subl $68, %esp
; CHECK-WIDE-NEXT:    .cfi_def_cfa_offset 72
; CHECK-WIDE-NEXT:    vmovss %xmm0, {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    vextractps $1, %xmm0, {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    vextractps $2, %xmm0, {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    vextractps $3, %xmm0, {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    fisttpll {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-WIDE-NEXT:    fisttpll (%esp)
; CHECK-WIDE-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-WIDE-NEXT:    vpinsrd $1, {{[0-9]+}}(%esp), %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vpinsrd $2, {{[0-9]+}}(%esp), %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vpinsrd $3, (%esp), %xmm0, %xmm0
; CHECK-WIDE-NEXT:    addl $68, %esp
; CHECK-WIDE-NEXT:    retl
  %res = fptoui <2 x float> %src to <2 x i32>
  ret <2 x i32> %res
}
