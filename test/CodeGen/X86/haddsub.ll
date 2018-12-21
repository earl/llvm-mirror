; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse3           | FileCheck %s --check-prefixes=SSE3,SSE3-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse3,fast-hops | FileCheck %s --check-prefixes=SSE3,SSE3-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx            | FileCheck %s --check-prefixes=AVX,AVX-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops  | FileCheck %s --check-prefixes=AVX,AVX-FAST

define <2 x double> @haddpd1(<2 x double> %x, <2 x double> %y) {
; SSE3-LABEL: haddpd1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddpd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: haddpd1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = shufflevector <2 x double> %x, <2 x double> %y, <2 x i32> <i32 0, i32 2>
  %b = shufflevector <2 x double> %x, <2 x double> %y, <2 x i32> <i32 1, i32 3>
  %r = fadd <2 x double> %a, %b
  ret <2 x double> %r
}

define <2 x double> @haddpd2(<2 x double> %x, <2 x double> %y) {
; SSE3-LABEL: haddpd2:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddpd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: haddpd2:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = shufflevector <2 x double> %x, <2 x double> %y, <2 x i32> <i32 1, i32 2>
  %b = shufflevector <2 x double> %y, <2 x double> %x, <2 x i32> <i32 2, i32 1>
  %r = fadd <2 x double> %a, %b
  ret <2 x double> %r
}

define <2 x double> @haddpd3(<2 x double> %x) {
; SSE3-SLOW-LABEL: haddpd3:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movapd %xmm0, %xmm1
; SSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-SLOW-NEXT:    addpd %xmm0, %xmm1
; SSE3-SLOW-NEXT:    movapd %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: haddpd3:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddpd %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: haddpd3:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-SLOW-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: haddpd3:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 0, i32 undef>
  %b = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %r = fadd <2 x double> %a, %b
  ret <2 x double> %r
}

define <4 x float> @haddps1(<4 x float> %x, <4 x float> %y) {
; SSE3-LABEL: haddps1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddps %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: haddps1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %b = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @haddps2(<4 x float> %x, <4 x float> %y) {
; SSE3-LABEL: haddps2:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddps %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: haddps2:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 1, i32 2, i32 5, i32 6>
  %b = shufflevector <4 x float> %y, <4 x float> %x, <4 x i32> <i32 4, i32 7, i32 0, i32 3>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @haddps3(<4 x float> %x) {
; SSE3-SLOW-LABEL: haddps3:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm0[2,3]
; SSE3-SLOW-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: haddps3:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: haddps3:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,2,2,3]
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: haddps3:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 4, i32 6>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 3, i32 5, i32 7>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @haddps4(<4 x float> %x) {
; SSE3-SLOW-LABEL: haddps4:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm0[2,3]
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: haddps4:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: haddps4:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,2,2,3]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; AVX-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: haddps4:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 undef>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 1, i32 3, i32 undef, i32 undef>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @haddps5(<4 x float> %x) {
; SSE3-SLOW-LABEL: haddps5:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,3],xmm0[2,3]
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,2,2,3]
; SSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: haddps5:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: haddps5:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,3,2,3]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,2,2,3]
; AVX-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: haddps5:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 0, i32 3, i32 undef, i32 undef>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 1, i32 2, i32 undef, i32 undef>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @haddps6(<4 x float> %x) {
; SSE3-SLOW-LABEL: haddps6:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: haddps6:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: haddps6:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-SLOW-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: haddps6:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @haddps7(<4 x float> %x) {
; SSE3-SLOW-LABEL: haddps7:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE3-SLOW-NEXT:    addps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: haddps7:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: haddps7:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-SLOW-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: haddps7:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 3, i32 undef, i32 undef>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 undef, i32 undef>
  %r = fadd <4 x float> %a, %b
  ret <4 x float> %r
}

define <2 x double> @hsubpd1(<2 x double> %x, <2 x double> %y) {
; SSE3-LABEL: hsubpd1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    hsubpd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: hsubpd1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhsubpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = shufflevector <2 x double> %x, <2 x double> %y, <2 x i32> <i32 0, i32 2>
  %b = shufflevector <2 x double> %x, <2 x double> %y, <2 x i32> <i32 1, i32 3>
  %r = fsub <2 x double> %a, %b
  ret <2 x double> %r
}

define <2 x double> @hsubpd2(<2 x double> %x) {
; SSE3-SLOW-LABEL: hsubpd2:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movapd %xmm0, %xmm1
; SSE3-SLOW-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-SLOW-NEXT:    subpd %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: hsubpd2:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    hsubpd %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: hsubpd2:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-SLOW-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: hsubpd2:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhsubpd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 0, i32 undef>
  %b = shufflevector <2 x double> %x, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %r = fsub <2 x double> %a, %b
  ret <2 x double> %r
}

define <4 x float> @hsubps1(<4 x float> %x, <4 x float> %y) {
; SSE3-LABEL: hsubps1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    hsubps %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: hsubps1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhsubps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %b = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %r = fsub <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @hsubps2(<4 x float> %x) {
; SSE3-SLOW-LABEL: hsubps2:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm0[2,3]
; SSE3-SLOW-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE3-SLOW-NEXT:    subps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    movaps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: hsubps2:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    hsubps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: hsubps2:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,2,2,3]
; AVX-SLOW-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,0]
; AVX-SLOW-NEXT:    vsubps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: hsubps2:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhsubps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 4, i32 6>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 undef, i32 3, i32 5, i32 7>
  %r = fsub <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @hsubps3(<4 x float> %x) {
; SSE3-SLOW-LABEL: hsubps3:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm0[2,3]
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE3-SLOW-NEXT:    subps %xmm0, %xmm1
; SSE3-SLOW-NEXT:    movaps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: hsubps3:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    hsubps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: hsubps3:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,2,2,3]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; AVX-SLOW-NEXT:    vsubps %xmm0, %xmm1, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: hsubps3:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhsubps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 0, i32 2, i32 undef, i32 undef>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 1, i32 3, i32 undef, i32 undef>
  %r = fsub <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @hsubps4(<4 x float> %x) {
; SSE3-SLOW-LABEL: hsubps4:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-SLOW-NEXT:    subps %xmm1, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: hsubps4:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    hsubps %xmm0, %xmm0
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: hsubps4:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-SLOW-NEXT:    vsubps %xmm1, %xmm0, %xmm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: hsubps4:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhsubps %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
  %b = shufflevector <4 x float> %x, <4 x float> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %r = fsub <4 x float> %a, %b
  ret <4 x float> %r
}

define <8 x float> @vhaddps1(<8 x float> %x, <8 x float> %y) {
; SSE3-LABEL: vhaddps1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddps %xmm2, %xmm0
; SSE3-NEXT:    haddps %xmm3, %xmm1
; SSE3-NEXT:    retq
;
; AVX-LABEL: vhaddps1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = shufflevector <8 x float> %x, <8 x float> %y, <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
  %b = shufflevector <8 x float> %x, <8 x float> %y, <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
  %r = fadd <8 x float> %a, %b
  ret <8 x float> %r
}

define <8 x float> @vhaddps2(<8 x float> %x, <8 x float> %y) {
; SSE3-LABEL: vhaddps2:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddps %xmm2, %xmm0
; SSE3-NEXT:    haddps %xmm3, %xmm1
; SSE3-NEXT:    retq
;
; AVX-LABEL: vhaddps2:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = shufflevector <8 x float> %x, <8 x float> %y, <8 x i32> <i32 1, i32 2, i32 9, i32 10, i32 5, i32 6, i32 13, i32 14>
  %b = shufflevector <8 x float> %y, <8 x float> %x, <8 x i32> <i32 8, i32 11, i32 0, i32 3, i32 12, i32 15, i32 4, i32 7>
  %r = fadd <8 x float> %a, %b
  ret <8 x float> %r
}

define <8 x float> @vhaddps3(<8 x float> %x) {
; SSE3-SLOW-LABEL: vhaddps3:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm1, %xmm2
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm1[2,3]
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm3
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm3 = xmm3[0,2],xmm0[2,3]
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,3,2,3]
; SSE3-SLOW-NEXT:    addps %xmm2, %xmm1
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE3-SLOW-NEXT:    addps %xmm3, %xmm0
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: vhaddps3:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    haddps %xmm0, %xmm0
; SSE3-FAST-NEXT:    haddps %xmm1, %xmm1
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: vhaddps3:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} ymm1 = ymm0[0,2,2,3,4,6,6,7]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[1,3,2,3,5,7,6,7]
; AVX-SLOW-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: vhaddps3:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <8 x float> %x, <8 x float> undef, <8 x i32> <i32 undef, i32 2, i32 8, i32 10, i32 4, i32 6, i32 undef, i32 14>
  %b = shufflevector <8 x float> %x, <8 x float> undef, <8 x i32> <i32 1, i32 3, i32 9, i32 undef, i32 5, i32 7, i32 13, i32 15>
  %r = fadd <8 x float> %a, %b
  ret <8 x float> %r
}

define <8 x float> @vhsubps1(<8 x float> %x, <8 x float> %y) {
; SSE3-LABEL: vhsubps1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    hsubps %xmm2, %xmm0
; SSE3-NEXT:    hsubps %xmm3, %xmm1
; SSE3-NEXT:    retq
;
; AVX-LABEL: vhsubps1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhsubps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = shufflevector <8 x float> %x, <8 x float> %y, <8 x i32> <i32 0, i32 2, i32 8, i32 10, i32 4, i32 6, i32 12, i32 14>
  %b = shufflevector <8 x float> %x, <8 x float> %y, <8 x i32> <i32 1, i32 3, i32 9, i32 11, i32 5, i32 7, i32 13, i32 15>
  %r = fsub <8 x float> %a, %b
  ret <8 x float> %r
}

define <8 x float> @vhsubps3(<8 x float> %x) {
; SSE3-SLOW-LABEL: vhsubps3:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movaps %xmm1, %xmm2
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm1[2,3]
; SSE3-SLOW-NEXT:    movaps %xmm0, %xmm3
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm3 = xmm3[0,2],xmm0[2,3]
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,3,2,3]
; SSE3-SLOW-NEXT:    subps %xmm1, %xmm2
; SSE3-SLOW-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE3-SLOW-NEXT:    subps %xmm0, %xmm3
; SSE3-SLOW-NEXT:    movaps %xmm3, %xmm0
; SSE3-SLOW-NEXT:    movaps %xmm2, %xmm1
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: vhsubps3:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    hsubps %xmm0, %xmm0
; SSE3-FAST-NEXT:    hsubps %xmm1, %xmm1
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: vhsubps3:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} ymm1 = ymm0[0,2,2,3,4,6,6,7]
; AVX-SLOW-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[1,3,2,3,5,7,6,7]
; AVX-SLOW-NEXT:    vsubps %ymm0, %ymm1, %ymm0
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: vhsubps3:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vhsubps %ymm0, %ymm0, %ymm0
; AVX-FAST-NEXT:    retq
  %a = shufflevector <8 x float> %x, <8 x float> undef, <8 x i32> <i32 undef, i32 2, i32 8, i32 10, i32 4, i32 6, i32 undef, i32 14>
  %b = shufflevector <8 x float> %x, <8 x float> undef, <8 x i32> <i32 1, i32 3, i32 9, i32 undef, i32 5, i32 7, i32 13, i32 15>
  %r = fsub <8 x float> %a, %b
  ret <8 x float> %r
}

define <4 x double> @vhaddpd1(<4 x double> %x, <4 x double> %y) {
; SSE3-LABEL: vhaddpd1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddpd %xmm2, %xmm0
; SSE3-NEXT:    haddpd %xmm3, %xmm1
; SSE3-NEXT:    retq
;
; AVX-LABEL: vhaddpd1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  %b = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  %r = fadd <4 x double> %a, %b
  ret <4 x double> %r
}

define <4 x double> @vhsubpd1(<4 x double> %x, <4 x double> %y) {
; SSE3-LABEL: vhsubpd1:
; SSE3:       # %bb.0:
; SSE3-NEXT:    hsubpd %xmm2, %xmm0
; SSE3-NEXT:    hsubpd %xmm3, %xmm1
; SSE3-NEXT:    retq
;
; AVX-LABEL: vhsubpd1:
; AVX:       # %bb.0:
; AVX-NEXT:    vhsubpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 0, i32 4, i32 2, i32 6>
  %b = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 1, i32 5, i32 3, i32 7>
  %r = fsub <4 x double> %a, %b
  ret <4 x double> %r
}

define <2 x float> @haddps_v2f32(<4 x float> %v0) {
; SSE3-LABEL: haddps_v2f32:
; SSE3:       # %bb.0:
; SSE3-NEXT:    haddps %xmm0, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: haddps_v2f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %v0.0 = extractelement <4 x float> %v0, i32 0
  %v0.1 = extractelement <4 x float> %v0, i32 1
  %v0.2 = extractelement <4 x float> %v0, i32 2
  %v0.3 = extractelement <4 x float> %v0, i32 3
  %op0 = fadd float %v0.0, %v0.1
  %op1 = fadd float %v0.2, %v0.3
  %res0 = insertelement <2 x float> undef, float %op0, i32 0
  %res1 = insertelement <2 x float> %res0, float %op1, i32 1
  ret <2 x float> %res1
}

define float @extract_extract_v4f32_fadd_f32(<4 x float> %x) {
; SSSE3-LABEL: extract_extract_v4f32_fadd_f32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    addss %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f32_fadd_f32:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    addss %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f32_fadd_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <4 x float> %x, i32 0
  %x1 = extractelement <4 x float> %x, i32 1
  %x01 = fadd float %x0, %x1
  ret float %x01
}

define float @extract_extract_v4f32_fadd_f32_commute(<4 x float> %x) {
; SSSE3-LABEL: extract_extract_v4f32_fadd_f32_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    addss %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f32_fadd_f32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    addss %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f32_fadd_f32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <4 x float> %x, i32 0
  %x1 = extractelement <4 x float> %x, i32 1
  %x01 = fadd float %x1, %x0
  ret float %x01
}

define float @extract_extract_v8f32_fadd_f32(<8 x float> %x) {
; SSSE3-LABEL: extract_extract_v8f32_fadd_f32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    addss %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v8f32_fadd_f32:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    addss %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v8f32_fadd_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <8 x float> %x, i32 0
  %x1 = extractelement <8 x float> %x, i32 1
  %x01 = fadd float %x0, %x1
  ret float %x01
}

define float @extract_extract_v8f32_fadd_f32_commute(<8 x float> %x) {
; SSSE3-LABEL: extract_extract_v8f32_fadd_f32_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    addss %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v8f32_fadd_f32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    addss %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v8f32_fadd_f32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <8 x float> %x, i32 0
  %x1 = extractelement <8 x float> %x, i32 1
  %x01 = fadd float %x1, %x0
  ret float %x01
}

define float @extract_extract_v4f32_fsub_f32(<4 x float> %x) {
; SSSE3-LABEL: extract_extract_v4f32_fsub_f32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    subss %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f32_fsub_f32:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    subss %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f32_fsub_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <4 x float> %x, i32 0
  %x1 = extractelement <4 x float> %x, i32 1
  %x01 = fsub float %x0, %x1
  ret float %x01
}

define float @extract_extract_v4f32_fsub_f32_commute(<4 x float> %x) {
; SSSE3-LABEL: extract_extract_v4f32_fsub_f32_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    subss %xmm0, %xmm1
; SSSE3-NEXT:    movaps %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f32_fsub_f32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    subss %xmm0, %xmm1
; SSE3-NEXT:    movaps %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f32_fsub_f32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vsubss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <4 x float> %x, i32 0
  %x1 = extractelement <4 x float> %x, i32 1
  %x01 = fsub float %x1, %x0
  ret float %x01
}

define float @extract_extract_v8f32_fsub_f32(<8 x float> %x) {
; SSSE3-LABEL: extract_extract_v8f32_fsub_f32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    subss %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v8f32_fsub_f32:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    subss %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v8f32_fsub_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <8 x float> %x, i32 0
  %x1 = extractelement <8 x float> %x, i32 1
  %x01 = fsub float %x0, %x1
  ret float %x01
}

define float @extract_extract_v8f32_fsub_f32_commute(<8 x float> %x) {
; SSSE3-LABEL: extract_extract_v8f32_fsub_f32_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSSE3-NEXT:    subss %xmm0, %xmm1
; SSSE3-NEXT:    movaps %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v8f32_fsub_f32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE3-NEXT:    subss %xmm0, %xmm1
; SSE3-NEXT:    movaps %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v8f32_fsub_f32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vsubss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <8 x float> %x, i32 0
  %x1 = extractelement <8 x float> %x, i32 1
  %x01 = fsub float %x1, %x0
  ret float %x01
}

define double @extract_extract_v2f64_fadd_f64(<2 x double> %x) {
; SSSE3-LABEL: extract_extract_v2f64_fadd_f64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    addsd %xmm0, %xmm1
; SSSE3-NEXT:    movapd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v2f64_fadd_f64:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    addsd %xmm0, %xmm1
; SSE3-NEXT:    movapd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v2f64_fadd_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <2 x double> %x, i32 0
  %x1 = extractelement <2 x double> %x, i32 1
  %x01 = fadd double %x0, %x1
  ret double %x01
}

define double @extract_extract_v2f64_fadd_f64_commute(<2 x double> %x) {
; SSSE3-LABEL: extract_extract_v2f64_fadd_f64_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    addsd %xmm0, %xmm1
; SSSE3-NEXT:    movapd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v2f64_fadd_f64_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    addsd %xmm0, %xmm1
; SSE3-NEXT:    movapd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v2f64_fadd_f64_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <2 x double> %x, i32 0
  %x1 = extractelement <2 x double> %x, i32 1
  %x01 = fadd double %x1, %x0
  ret double %x01
}

define double @extract_extract_v4f64_fadd_f64(<4 x double> %x) {
; SSSE3-LABEL: extract_extract_v4f64_fadd_f64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    addsd %xmm0, %xmm1
; SSSE3-NEXT:    movapd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f64_fadd_f64:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    addsd %xmm0, %xmm1
; SSE3-NEXT:    movapd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f64_fadd_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <4 x double> %x, i32 0
  %x1 = extractelement <4 x double> %x, i32 1
  %x01 = fadd double %x0, %x1
  ret double %x01
}

define double @extract_extract_v4f64_fadd_f64_commute(<4 x double> %x) {
; SSSE3-LABEL: extract_extract_v4f64_fadd_f64_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    addsd %xmm0, %xmm1
; SSSE3-NEXT:    movapd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f64_fadd_f64_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    addsd %xmm0, %xmm1
; SSE3-NEXT:    movapd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f64_fadd_f64_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <4 x double> %x, i32 0
  %x1 = extractelement <4 x double> %x, i32 1
  %x01 = fadd double %x1, %x0
  ret double %x01
}

define double @extract_extract_v2f64_fsub_f64(<2 x double> %x) {
; SSSE3-LABEL: extract_extract_v2f64_fsub_f64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    subsd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v2f64_fsub_f64:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    subsd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v2f64_fsub_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <2 x double> %x, i32 0
  %x1 = extractelement <2 x double> %x, i32 1
  %x01 = fsub double %x0, %x1
  ret double %x01
}

define double @extract_extract_v2f64_fsub_f64_commute(<2 x double> %x) {
; SSSE3-LABEL: extract_extract_v2f64_fsub_f64_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    subsd %xmm0, %xmm1
; SSSE3-NEXT:    movapd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v2f64_fsub_f64_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    subsd %xmm0, %xmm1
; SSE3-NEXT:    movapd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v2f64_fsub_f64_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vsubsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <2 x double> %x, i32 0
  %x1 = extractelement <2 x double> %x, i32 1
  %x01 = fsub double %x1, %x0
  ret double %x01
}

define double @extract_extract_v4f64_fsub_f64(<4 x double> %x) {
; SSSE3-LABEL: extract_extract_v4f64_fsub_f64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    subsd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f64_fsub_f64:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    subsd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f64_fsub_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <4 x double> %x, i32 0
  %x1 = extractelement <4 x double> %x, i32 1
  %x01 = fsub double %x0, %x1
  ret double %x01
}

define double @extract_extract_v4f64_fsub_f64_commute(<4 x double> %x) {
; SSSE3-LABEL: extract_extract_v4f64_fsub_f64_commute:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movapd %xmm0, %xmm1
; SSSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSSE3-NEXT:    subsd %xmm0, %xmm1
; SSSE3-NEXT:    movapd %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE3-LABEL: extract_extract_v4f64_fsub_f64_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movapd %xmm0, %xmm1
; SSE3-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE3-NEXT:    subsd %xmm0, %xmm1
; SSE3-NEXT:    movapd %xmm1, %xmm0
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4f64_fsub_f64_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vsubsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <4 x double> %x, i32 0
  %x1 = extractelement <4 x double> %x, i32 1
  %x01 = fsub double %x1, %x0
  ret double %x01
}

