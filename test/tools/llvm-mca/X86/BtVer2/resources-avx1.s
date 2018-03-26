# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -instruction-tables < %s | FileCheck %s --check-prefixes=CHECK,BTVER2

vaddpd            %xmm0, %xmm1, %xmm2
vaddpd            (%rax), %xmm1, %xmm2

vaddpd            %ymm0, %ymm1, %ymm2
vaddpd            (%rax), %ymm1, %ymm2

vaddps            %xmm0, %xmm1, %xmm2
vaddps            (%rax), %xmm1, %xmm2

vaddps            %ymm0, %ymm1, %ymm2
vaddps            (%rax), %ymm1, %ymm2

vaddsd            %xmm0, %xmm1, %xmm2
vaddsd            (%rax), %xmm1, %xmm2

vaddss            %xmm0, %xmm1, %xmm2
vaddss            (%rax), %xmm1, %xmm2

vaddsubpd         %xmm0, %xmm1, %xmm2
vaddsubpd         (%rax), %xmm1, %xmm2

vaddsubpd         %ymm0, %ymm1, %ymm2
vaddsubpd         (%rax), %ymm1, %ymm2

vaddsubps         %xmm0, %xmm1, %xmm2
vaddsubps         (%rax), %xmm1, %xmm2

vaddsubps         %ymm0, %ymm1, %ymm2
vaddsubps         (%rax), %ymm1, %ymm2

vaesdec           %xmm0, %xmm1, %xmm2
vaesdec           (%rax), %xmm1, %xmm2

vaesdeclast       %xmm0, %xmm1, %xmm2
vaesdeclast       (%rax), %xmm1, %xmm2

vaesenc           %xmm0, %xmm1, %xmm2
vaesenc           (%rax), %xmm1, %xmm2

vaesenclast       %xmm0, %xmm1, %xmm2
vaesenclast       (%rax), %xmm1, %xmm2

vaesimc           %xmm0, %xmm2
vaesimc           (%rax), %xmm2

vaeskeygenassist  $22, %xmm0, %xmm2
vaeskeygenassist  $22, (%rax), %xmm2

vandnpd           %xmm0, %xmm1, %xmm2
vandnpd           (%rax), %xmm1, %xmm2

vandnpd           %ymm0, %ymm1, %ymm2
vandnpd           (%rax), %ymm1, %ymm2

vandnps           %xmm0, %xmm1, %xmm2
vandnps           (%rax), %xmm1, %xmm2

vandnps           %ymm0, %ymm1, %ymm2
vandnps           (%rax), %ymm1, %ymm2

vandpd            %xmm0, %xmm1, %xmm2
vandpd            (%rax), %xmm1, %xmm2

vandpd            %ymm0, %ymm1, %ymm2
vandpd            (%rax), %ymm1, %ymm2

vandps            %xmm0, %xmm1, %xmm2
vandps            (%rax), %xmm1, %xmm2

vandps            %ymm0, %ymm1, %ymm2
vandps            (%rax), %ymm1, %ymm2

vblendpd          $11, %xmm0, %xmm1, %xmm2
vblendpd          $11, (%rax), %xmm1, %xmm2

vblendpd          $11, %ymm0, %ymm1, %ymm2
vblendpd          $11, (%rax), %ymm1, %ymm2

vblendps          $11, %xmm0, %xmm1, %xmm2
vblendps          $11, (%rax), %xmm1, %xmm2

vblendps          $11, %ymm0, %ymm1, %ymm2
vblendps          $11, (%rax), %ymm1, %ymm2

vblendvpd         %xmm3, %xmm0, %xmm1, %xmm2
vblendvpd         %xmm3, (%rax), %xmm1, %xmm2

vblendvpd         %ymm3, %ymm0, %ymm1, %ymm2
vblendvpd         %ymm3, (%rax), %ymm1, %ymm2

vblendvps         %xmm3, %xmm0, %xmm1, %xmm2
vblendvps         %xmm3, (%rax), %xmm1, %xmm2

vblendvps         %ymm3, %ymm0, %ymm1, %ymm2
vblendvps         %ymm3, (%rax), %ymm1, %ymm2

vbroadcastf128    (%rax), %ymm2

vbroadcastsd      (%rax), %ymm2

vbroadcastss      (%rax), %xmm2
vbroadcastss      (%rax), %ymm2

vcmppd            $0, %xmm0, %xmm1, %xmm2
vcmppd            $0, (%rax), %xmm1, %xmm2

vcmppd            $0, %ymm0, %ymm1, %ymm2
vcmppd            $0, (%rax), %ymm1, %ymm2

vcmpps            $0, %xmm0, %xmm1, %xmm2
vcmpps            $0, (%rax), %xmm1, %xmm2

vcmpps            $0, %ymm0, %ymm1, %ymm2
vcmpps            $0, (%rax), %ymm1, %ymm2

vcmpsd            $0, %xmm0, %xmm1, %xmm2
vcmpsd            $0, (%rax), %xmm1, %xmm2

vcmpss            $0, %xmm0, %xmm1, %xmm2
vcmpss            $0, (%rax), %xmm1, %xmm2

vcomisd           %xmm0, %xmm1
vcomisd           (%rax), %xmm1

vcomiss           %xmm0, %xmm1
vcomiss           (%rax), %xmm1

vcvtdq2pd         %xmm0, %xmm2
vcvtdq2pd         (%rax), %xmm2

vcvtdq2pd         %xmm0, %ymm2
vcvtdq2pd         (%rax), %ymm2

vcvtdq2ps         %xmm0, %xmm2
vcvtdq2ps         (%rax), %xmm2

vcvtdq2ps         %ymm0, %ymm2
vcvtdq2ps         (%rax), %ymm2

vcvtpd2dqx        %xmm0, %xmm2
vcvtpd2dqx        (%rax), %xmm2

vcvtpd2dqy        %ymm0, %xmm2
vcvtpd2dqy        (%rax), %xmm2

vcvtpd2psx        %xmm0, %xmm2
vcvtpd2psx        (%rax), %xmm2

vcvtpd2psy        %ymm0, %xmm2
vcvtpd2psy        (%rax), %xmm2

vcvtps2dq         %xmm0, %xmm2
vcvtps2dq         (%rax), %xmm2

vcvtps2dq         %ymm0, %ymm2
vcvtps2dq         (%rax), %ymm2

vcvtps2pd         %xmm0, %xmm2
vcvtps2pd         (%rax), %xmm2

vcvtps2pd         %xmm0, %ymm2
vcvtps2pd         (%rax), %ymm2

vcvtsd2si         %xmm0, %ecx
vcvtsd2si         %xmm0, %rcx
vcvtsd2si         (%rax), %ecx
vcvtsd2si         (%rax), %rcx

vcvtsd2ss         %xmm0, %xmm1, %xmm2
vcvtsd2ss         (%rax), %xmm1, %xmm2

vcvtsi2sdl        %ecx, %xmm0, %xmm2
vcvtsi2sdq        %rcx, %xmm0, %xmm2
vcvtsi2sdl        (%rax), %xmm0, %xmm2
vcvtsi2sdq        (%rax), %xmm0, %xmm2

vcvtsi2ssl        %ecx, %xmm0, %xmm2
vcvtsi2ssq        %rcx, %xmm0, %xmm2
vcvtsi2ssl        (%rax), %xmm0, %xmm2
vcvtsi2ssq        (%rax), %xmm0, %xmm2

vcvtss2sd         %xmm0, %xmm1, %xmm2
vcvtss2sd         (%rax), %xmm1, %xmm2

vcvtss2si         %xmm0, %ecx
vcvtss2si         %xmm0, %rcx
vcvtss2si         (%rax), %ecx
vcvtss2si         (%rax), %rcx

vcvttpd2dqx       %xmm0, %xmm2
vcvttpd2dqx       (%rax), %xmm2

vcvttpd2dqy       %ymm0, %xmm2
vcvttpd2dqy       (%rax), %xmm2

vcvttps2dq        %xmm0, %xmm2
vcvttps2dq        (%rax), %xmm2

vcvttps2dq        %ymm0, %ymm2
vcvttps2dq        (%rax), %ymm2

vcvttsd2si        %xmm0, %ecx
vcvttsd2si        %xmm0, %rcx
vcvttsd2si        (%rax), %ecx
vcvttsd2si        (%rax), %rcx

vcvttss2si        %xmm0, %ecx
vcvttss2si        %xmm0, %rcx
vcvttss2si        (%rax), %ecx
vcvttss2si        (%rax), %rcx

vdivpd            %xmm0, %xmm1, %xmm2
vdivpd            (%rax), %xmm1, %xmm2

vdivpd            %ymm0, %ymm1, %ymm2
vdivpd            (%rax), %ymm1, %ymm2

vdivps            %xmm0, %xmm1, %xmm2
vdivps            (%rax), %xmm1, %xmm2

vdivps            %ymm0, %ymm1, %ymm2
vdivps            (%rax), %ymm1, %ymm2

vdivsd            %xmm0, %xmm1, %xmm2
vdivsd            (%rax), %xmm1, %xmm2

vdivss            %xmm0, %xmm1, %xmm2
vdivss            (%rax), %xmm1, %xmm2

vdppd             $22, %xmm0, %xmm1, %xmm2
vdppd             $22, (%rax), %xmm1, %xmm2

vdpps             $22, %xmm0, %xmm1, %xmm2
vdpps             $22, (%rax), %xmm1, %xmm2

vdpps             $22, %ymm0, %ymm1, %ymm2
vdpps             $22, (%rax), %ymm1, %ymm2

vextractf128      $1, %ymm0, %xmm2
vextractf128      $1, %ymm0, (%rax)

vextractps        $1, %xmm0, %rcx
vextractps        $1, %xmm0, (%rax)

vhaddpd           %xmm0, %xmm1, %xmm2
vhaddpd           (%rax), %xmm1, %xmm2

vhaddpd           %ymm0, %ymm1, %ymm2
vhaddpd           (%rax), %ymm1, %ymm2

vhaddps           %xmm0, %xmm1, %xmm2
vhaddps           (%rax), %xmm1, %xmm2

vhaddps           %ymm0, %ymm1, %ymm2
vhaddps           (%rax), %ymm1, %ymm2

vhsubpd           %xmm0, %xmm1, %xmm2
vhsubpd           (%rax), %xmm1, %xmm2

vhsubpd           %ymm0, %ymm1, %ymm2
vhsubpd           (%rax), %ymm1, %ymm2

vhsubps           %xmm0, %xmm1, %xmm2
vhsubps           (%rax), %xmm1, %xmm2

vhsubps           %ymm0, %ymm1, %ymm2
vhsubps           (%rax), %ymm1, %ymm2

vinsertf128       $1, %xmm0, %ymm1, %ymm2
vinsertf128       $1, (%rax), %ymm1, %ymm2

vinsertps         $1, %xmm0, %xmm1, %xmm2
vinsertps         $1, (%rax), %xmm1, %xmm2

vlddqu            (%rax), %xmm2
vlddqu            (%rax), %ymm2

vldmxcsr          (%rax)

vmaskmovdqu       %xmm0, %xmm1

vmaskmovpd        (%rax), %xmm0, %xmm2
vmaskmovpd        (%rax), %ymm0, %ymm2

vmaskmovpd        %xmm0, %xmm1, (%rax)
vmaskmovpd        %ymm0, %ymm1, (%rax)

vmaskmovps        (%rax), %xmm0, %xmm2
vmaskmovps        (%rax), %ymm0, %ymm2

vmaskmovps        %xmm0, %xmm1, (%rax)
vmaskmovps        %ymm0, %ymm1, (%rax)

vmaxpd            %xmm0, %xmm1, %xmm2
vmaxpd            (%rax), %xmm1, %xmm2

vmaxpd            %ymm0, %ymm1, %ymm2
vmaxpd            (%rax), %ymm1, %ymm2

vmaxps            %xmm0, %xmm1, %xmm2
vmaxps            (%rax), %xmm1, %xmm2

vmaxps            %ymm0, %ymm1, %ymm2
vmaxps            (%rax), %ymm1, %ymm2

vmaxsd            %xmm0, %xmm1, %xmm2
vmaxsd            (%rax), %xmm1, %xmm2

vmaxss            %xmm0, %xmm1, %xmm2
vmaxss            (%rax), %xmm1, %xmm2

vminpd            %xmm0, %xmm1, %xmm2
vminpd            (%rax), %xmm1, %xmm2

vminpd            %ymm0, %ymm1, %ymm2
vminpd            (%rax), %ymm1, %ymm2

vminps            %xmm0, %xmm1, %xmm2
vminps            (%rax), %xmm1, %xmm2

vminps            %ymm0, %ymm1, %ymm2
vminps            (%rax), %ymm1, %ymm2

vminsd            %xmm0, %xmm1, %xmm2
vminsd            (%rax), %xmm1, %xmm2

vminss            %xmm0, %xmm1, %xmm2
vminss            (%rax), %xmm1, %xmm2

vmovapd           %xmm0, %xmm2
vmovapd           %xmm0, (%rax)
vmovapd           (%rax), %xmm2

vmovapd           %ymm0, %ymm2
vmovapd           %ymm0, (%rax)
vmovapd           (%rax), %ymm2

vmovaps           %xmm0, %xmm2
vmovaps           %xmm0, (%rax)
vmovaps           (%rax), %xmm2

vmovaps           %ymm0, %ymm2
vmovaps           %ymm0, (%rax)
vmovaps           (%rax), %ymm2

vmovd             %eax, %xmm2
vmovd             (%rax), %xmm2

vmovd             %xmm0, %ecx
vmovd             %xmm0, (%rax)

vmovddup          %xmm0, %xmm2
vmovddup          (%rax), %xmm2

vmovddup          %ymm0, %ymm2
vmovddup          (%rax), %ymm2

vmovdqa           %xmm0, %xmm2
vmovdqa           %xmm0, (%rax)
vmovdqa           (%rax), %xmm2

vmovdqa           %ymm0, %ymm2
vmovdqa           %ymm0, (%rax)
vmovdqa           (%rax), %ymm2

vmovdqu           %xmm0, %xmm2
vmovdqu           %xmm0, (%rax)
vmovdqu           (%rax), %xmm2

vmovdqu           %ymm0, %ymm2
vmovdqu           %ymm0, (%rax)
vmovdqu           (%rax), %ymm2

vmovhlps          %xmm0, %xmm1, %xmm2
vmovlhps          %xmm0, %xmm1, %xmm2

vmovhpd           %xmm0, (%rax)
vmovhpd           (%rax), %xmm1, %xmm2

vmovhps           %xmm0, (%rax)
vmovhps           (%rax), %xmm1, %xmm2

vmovlpd           %xmm0, (%rax)
vmovlpd           (%rax), %xmm1, %xmm2

vmovlps           %xmm0, (%rax)
vmovlps           (%rax), %xmm1, %xmm2

vmovmskpd         %xmm0, %rcx
vmovmskpd         %ymm0, %rcx

vmovmskps         %xmm0, %rcx
vmovmskps         %ymm0, %rcx

vmovntdq          %xmm0, (%rax)
vmovntdq          %ymm0, (%rax)

vmovntdqa         (%rax), %xmm2
vmovntdqa         (%rax), %ymm2

vmovntpd          %xmm0, (%rax)
vmovntpd          %ymm0, (%rax)

vmovntps          %xmm0, (%rax)
vmovntps          %ymm0, (%rax)

vmovq             %xmm0, %xmm2

vmovq             %rax, %xmm2
vmovq             (%rax), %xmm2

vmovq             %xmm0, %rcx
vmovq             %xmm0, (%rax)

vmovsd            %xmm0, %xmm1, %xmm2
vmovsd            %xmm0, (%rax)
vmovsd            (%rax), %xmm2

vmovshdup         %xmm0, %xmm2
vmovshdup         (%rax), %xmm2

vmovshdup         %ymm0, %ymm2
vmovshdup         (%rax), %ymm2

vmovsldup         %xmm0, %xmm2
vmovsldup         (%rax), %xmm2

vmovsldup         %ymm0, %ymm2
vmovsldup         (%rax), %ymm2

vmovss            %xmm0, %xmm1, %xmm2
vmovss            %xmm0, (%rax)
vmovss            (%rax), %xmm2

vmovupd           %xmm0, %xmm2
vmovupd           %xmm0, (%rax)
vmovupd           (%rax), %xmm2

vmovupd           %ymm0, %ymm2
vmovupd           %ymm0, (%rax)
vmovupd           (%rax), %ymm2

vmovups           %xmm0, %xmm2
vmovups           %xmm0, (%rax)
vmovups           (%rax), %xmm2

vmovups           %ymm0, %ymm2
vmovups           %ymm0, (%rax)
vmovups           (%rax), %ymm2

vmpsadbw          $1, %xmm0, %xmm1, %xmm2
vmpsadbw          $1, (%rax), %xmm1, %xmm2

vmulpd            %xmm0, %xmm1, %xmm2
vmulpd            (%rax), %xmm1, %xmm2

vmulpd            %ymm0, %ymm1, %ymm2
vmulpd            (%rax), %ymm1, %ymm2

vmulps            %xmm0, %xmm1, %xmm2
vmulps            (%rax), %xmm1, %xmm2

vmulps            %ymm0, %ymm1, %ymm2
vmulps            (%rax), %ymm1, %ymm2

vmulsd            %xmm0, %xmm1, %xmm2
vmulsd            (%rax), %xmm1, %xmm2

vmulss            %xmm0, %xmm1, %xmm2
vmulss            (%rax), %xmm1, %xmm2

vorpd             %xmm0, %xmm1, %xmm2
vorpd             (%rax), %xmm1, %xmm2

vorpd             %ymm0, %ymm1, %ymm2
vorpd             (%rax), %ymm1, %ymm2

vorps             %xmm0, %xmm1, %xmm2
vorps             (%rax), %xmm1, %xmm2

vorps             %ymm0, %ymm1, %ymm2
vorps             (%rax), %ymm1, %ymm2

vpabsb            %xmm0, %xmm2
vpabsb            (%rax), %xmm2

vpabsd            %xmm0, %xmm2
vpabsd            (%rax), %xmm2

vpabsw            %xmm0, %xmm2
vpabsw            (%rax), %xmm2

vpackssdw         %xmm0, %xmm1, %xmm2
vpackssdw         (%rax), %xmm1, %xmm2

vpacksswb         %xmm0, %xmm1, %xmm2
vpacksswb         (%rax), %xmm1, %xmm2

vpackusdw         %xmm0, %xmm1, %xmm2
vpackusdw         (%rax), %xmm1, %xmm2

vpackuswb         %xmm0, %xmm1, %xmm2
vpackuswb         (%rax), %xmm1, %xmm2

vpaddb            %xmm0, %xmm1, %xmm2
vpaddb            (%rax), %xmm1, %xmm2

vpaddd            %xmm0, %xmm1, %xmm2
vpaddd            (%rax), %xmm1, %xmm2

vpaddq            %xmm0, %xmm1, %xmm2
vpaddq            (%rax), %xmm1, %xmm2

vpaddsb           %xmm0, %xmm1, %xmm2
vpaddsb           (%rax), %xmm1, %xmm2

vpaddsw           %xmm0, %xmm1, %xmm2
vpaddsw           (%rax), %xmm1, %xmm2

vpaddusb          %xmm0, %xmm1, %xmm2
vpaddusb          (%rax), %xmm1, %xmm2

vpaddusw          %xmm0, %xmm1, %xmm2
vpaddusw          (%rax), %xmm1, %xmm2

vpaddw            %xmm0, %xmm1, %xmm2
vpaddw            (%rax), %xmm1, %xmm2

vpalignr          $1, %xmm0, %xmm1, %xmm2
vpalignr          $1, (%rax), %xmm1, %xmm2

vpand             %xmm0, %xmm1, %xmm2
vpand             (%rax), %xmm1, %xmm2

vpandn            %xmm0, %xmm1, %xmm2
vpandn            (%rax), %xmm1, %xmm2

vpavgb            %xmm0, %xmm1, %xmm2
vpavgb            (%rax), %xmm1, %xmm2

vpavgw            %xmm0, %xmm1, %xmm2
vpavgw            (%rax), %xmm1, %xmm2

vpblendvb         %xmm3, %xmm0, %xmm1, %xmm2
vpblendvb         %xmm3, (%rax), %xmm1, %xmm2

vpblendw          $11, %xmm0, %xmm1, %xmm2
vpblendw          $11, (%rax), %xmm1, %xmm2

vpclmulqdq        $11, %xmm0, %xmm1, %xmm2
vpclmulqdq        $11, (%rax), %xmm1, %xmm2

vpcmpeqb          %xmm0, %xmm1, %xmm2
vpcmpeqb          (%rax), %xmm1, %xmm2

vpcmpeqd          %xmm0, %xmm1, %xmm2
vpcmpeqd          (%rax), %xmm1, %xmm2

vpcmpeqq          %xmm0, %xmm1, %xmm2
vpcmpeqq          (%rax), %xmm1, %xmm2

vpcmpeqw          %xmm0, %xmm1, %xmm2
vpcmpeqw          (%rax), %xmm1, %xmm2

vpcmpgtb          %xmm0, %xmm1, %xmm2
vpcmpgtb          (%rax), %xmm1, %xmm2

vpcmpgtd          %xmm0, %xmm1, %xmm2
vpcmpgtd          (%rax), %xmm1, %xmm2

vpcmpgtq          %xmm0, %xmm1, %xmm2
vpcmpgtq          (%rax), %xmm1, %xmm2

vpcmpgtw          %xmm0, %xmm1, %xmm2
vpcmpgtw          (%rax), %xmm1, %xmm2

vperm2f128        $1, %ymm0, %ymm1, %ymm2
vperm2f128        $1, (%rax), %ymm1, %ymm2

vpermilpd         $1, %xmm0, %xmm2
vpermilpd         $1, (%rax), %xmm2
vpermilpd         %xmm0, %xmm1, %xmm2
vpermilpd         (%rax), %xmm1, %xmm2

vpermilpd         $1, %ymm0, %ymm2
vpermilpd         $1, (%rax), %ymm2
vpermilpd         %ymm0, %ymm1, %ymm2
vpermilpd         (%rax), %ymm1, %ymm2

vpermilps         $1, %xmm0, %xmm2
vpermilps         $1, (%rax), %xmm2
vpermilps         %xmm0, %xmm1, %xmm2
vpermilps         (%rax), %xmm1, %xmm2

vpermilps         $1, %ymm0, %ymm2
vpermilps         $1, (%rax), %ymm2
vpermilps         %ymm0, %ymm1, %ymm2
vpermilps         (%rax), %ymm1, %ymm2

vpextrb           $1, %xmm0, %ecx
vpextrb           $1, %xmm0, (%rax)

vpextrd           $1, %xmm0, %ecx
vpextrd           $1, %xmm0, (%rax)

vpextrq           $1, %xmm0, %rcx
vpextrq           $1, %xmm0, (%rax)

vpextrw           $1, %xmm0, %ecx
vpextrw           $1, %xmm0, (%rax)

vphaddd           %xmm0, %xmm1, %xmm2
vphaddd           (%rax), %xmm1, %xmm2

vphaddsw          %xmm0, %xmm1, %xmm2
vphaddsw          (%rax), %xmm1, %xmm2

vphaddw           %xmm0, %xmm1, %xmm2
vphaddw           (%rax), %xmm1, %xmm2

vphminposuw       %xmm0, %xmm2
vphminposuw       (%rax), %xmm2

vphsubd           %xmm0, %xmm1, %xmm2
vphsubd           (%rax), %xmm1, %xmm2

vphsubsw          %xmm0, %xmm1, %xmm2
vphsubsw          (%rax), %xmm1, %xmm2

vphsubw           %xmm0, %xmm1, %xmm2
vphsubw           (%rax), %xmm1, %xmm2

vpinsrb           $1, %eax, %xmm1, %xmm2
vpinsrb           $1, (%rax), %xmm1, %xmm2

vpinsrd           $1, %eax, %xmm1, %xmm2
vpinsrd           $1, (%rax), %xmm1, %xmm2

vpinsrq           $1, %rax, %xmm1, %xmm2
vpinsrq           $1, (%rax), %xmm1, %xmm2

vpinsrw           $1, %eax, %xmm1, %xmm2
vpinsrw           $1, (%rax), %xmm1, %xmm2

vpmaddubsw        %xmm0, %xmm1, %xmm2
vpmaddubsw        (%rax), %xmm1, %xmm2

vpmaddwd          %xmm0, %xmm1, %xmm2
vpmaddwd          (%rax), %xmm1, %xmm2

vpmaxsb           %xmm0, %xmm1, %xmm2
vpmaxsb           (%rax), %xmm1, %xmm2

vpmaxsd           %xmm0, %xmm1, %xmm2
vpmaxsd           (%rax), %xmm1, %xmm2

vpmaxsw           %xmm0, %xmm1, %xmm2
vpmaxsw           (%rax), %xmm1, %xmm2

vpmaxub           %xmm0, %xmm1, %xmm2
vpmaxub           (%rax), %xmm1, %xmm2

vpmaxud           %xmm0, %xmm1, %xmm2
vpmaxud           (%rax), %xmm1, %xmm2

vpmaxuw           %xmm0, %xmm1, %xmm2
vpmaxuw           (%rax), %xmm1, %xmm2

vpminsb           %xmm0, %xmm1, %xmm2
vpminsb           (%rax), %xmm1, %xmm2

vpminsd           %xmm0, %xmm1, %xmm2
vpminsd           (%rax), %xmm1, %xmm2

vpminsw           %xmm0, %xmm1, %xmm2
vpminsw           (%rax), %xmm1, %xmm2

vpminub           %xmm0, %xmm1, %xmm2
vpminub           (%rax), %xmm1, %xmm2

vpminud           %xmm0, %xmm1, %xmm2
vpminud           (%rax), %xmm1, %xmm2

vpminuw           %xmm0, %xmm1, %xmm2
vpminuw           (%rax), %xmm1, %xmm2

vpmovmskb         %xmm0, %rcx

vpmovsxbd         %xmm0, %xmm2
vpmovsxbd         (%rax), %xmm2

vpmovsxbq         %xmm0, %xmm2
vpmovsxbq         (%rax), %xmm2

vpmovsxbw         %xmm0, %xmm2
vpmovsxbw         (%rax), %xmm2

vpmovsxdq         %xmm0, %xmm2
vpmovsxdq         (%rax), %xmm2

vpmovsxwd         %xmm0, %xmm2
vpmovsxwd         (%rax), %xmm2

vpmovsxwq         %xmm0, %xmm2
vpmovsxwq         (%rax), %xmm2

vpmovzxbd         %xmm0, %xmm2
vpmovzxbd         (%rax), %xmm2

vpmovzxbq         %xmm0, %xmm2
vpmovzxbq         (%rax), %xmm2

vpmovzxbw         %xmm0, %xmm2
vpmovzxbw         (%rax), %xmm2

vpmovzxdq         %xmm0, %xmm2
vpmovzxdq         (%rax), %xmm2

vpmovzxwd         %xmm0, %xmm2
vpmovzxwd         (%rax), %xmm2

vpmovzxwq         %xmm0, %xmm2
vpmovzxwq         (%rax), %xmm2

vpmuldq           %xmm0, %xmm1, %xmm2
vpmuldq           (%rax), %xmm1, %xmm2

vpmulhrsw         %xmm0, %xmm1, %xmm2
vpmulhrsw         (%rax), %xmm1, %xmm2

vpmulhuw          %xmm0, %xmm1, %xmm2
vpmulhuw          (%rax), %xmm1, %xmm2

vpmulhw           %xmm0, %xmm1, %xmm2
vpmulhw           (%rax), %xmm1, %xmm2

vpmulld           %xmm0, %xmm1, %xmm2
vpmulld           (%rax), %xmm1, %xmm2

vpmullw           %xmm0, %xmm1, %xmm2
vpmullw           (%rax), %xmm1, %xmm2

vpmuludq          %xmm0, %xmm1, %xmm2
vpmuludq          (%rax), %xmm1, %xmm2

vpor              %xmm0, %xmm1, %xmm2
vpor              (%rax), %xmm1, %xmm2

vpsadbw           %xmm0, %xmm1, %xmm2
vpsadbw           (%rax), %xmm1, %xmm2

vpshufb           %xmm0, %xmm1, %xmm2
vpshufb           (%rax), %xmm1, %xmm2

vpshufd           $1, %xmm0, %xmm2
vpshufd           $1, (%rax), %xmm2

vpshufhw          $1, %xmm0, %xmm2
vpshufhw          $1, (%rax), %xmm2

vpshuflw          $1, %xmm0, %xmm2
vpshuflw          $1, (%rax), %xmm2

vpsignb           %xmm0, %xmm1, %xmm2
vpsignb           (%rax), %xmm1, %xmm2

vpsignd           %xmm0, %xmm1, %xmm2
vpsignd           (%rax), %xmm1, %xmm2

vpsignw           %xmm0, %xmm1, %xmm2
vpsignw           (%rax), %xmm1, %xmm2

vpslld            $1, %xmm0, %xmm2
vpslld            %xmm0, %xmm1, %xmm2
vpslld            (%rax), %xmm1, %xmm2

vpslldq           $1, %xmm1, %xmm2

vpsllq            $1, %xmm0, %xmm2
vpsllq            %xmm0, %xmm1, %xmm2
vpsllq            (%rax), %xmm1, %xmm2

vpsllw            $1, %xmm0, %xmm2
vpsllw            %xmm0, %xmm1, %xmm2
vpsllw            (%rax), %xmm1, %xmm2

vpsrad            $1, %xmm0, %xmm2
vpsrad            %xmm0, %xmm1, %xmm2
vpsrad            (%rax), %xmm1, %xmm2

vpsraw            $1, %xmm0, %xmm2
vpsraw            %xmm0, %xmm1, %xmm2
vpsraw            (%rax), %xmm1, %xmm2

vpsrld            $1, %xmm0, %xmm2
vpsrld            %xmm0, %xmm1, %xmm2
vpsrld            (%rax), %xmm1, %xmm2

vpsrldq           $1, %xmm1, %xmm2

vpsrlq            $1, %xmm0, %xmm2
vpsrlq            %xmm0, %xmm1, %xmm2
vpsrlq            (%rax), %xmm1, %xmm2

vpsrlw            $1, %xmm0, %xmm2
vpsrlw            %xmm0, %xmm1, %xmm2
vpsrlw            (%rax), %xmm1, %xmm2

vpsubb            %xmm0, %xmm1, %xmm2
vpsubb            (%rax), %xmm1, %xmm2

vpsubd            %xmm0, %xmm1, %xmm2
vpsubd            (%rax), %xmm1, %xmm2

vpsubq            %xmm0, %xmm1, %xmm2
vpsubq            (%rax), %xmm1, %xmm2

vpsubsb           %xmm0, %xmm1, %xmm2
vpsubsb           (%rax), %xmm1, %xmm2

vpsubsw           %xmm0, %xmm1, %xmm2
vpsubsw           (%rax), %xmm1, %xmm2

vpsubusb          %xmm0, %xmm1, %xmm2
vpsubusb          (%rax), %xmm1, %xmm2

vpsubusw          %xmm0, %xmm1, %xmm2
vpsubusw          (%rax), %xmm1, %xmm2

vpsubw            %xmm0, %xmm1, %xmm2
vpsubw            (%rax), %xmm1, %xmm2

vptest            %xmm0, %xmm1
vptest            (%rax), %xmm1

vptest            %ymm0, %ymm1
vptest            (%rax), %ymm1

vpunpckhbw        %xmm0, %xmm1, %xmm2
vpunpckhbw        (%rax), %xmm1, %xmm2

vpunpckhdq        %xmm0, %xmm1, %xmm2
vpunpckhdq        (%rax), %xmm1, %xmm2

vpunpckhqdq       %xmm0, %xmm1, %xmm2
vpunpckhqdq       (%rax), %xmm1, %xmm2

vpunpckhwd        %xmm0, %xmm1, %xmm2
vpunpckhwd        (%rax), %xmm1, %xmm2

vpunpcklbw        %xmm0, %xmm1, %xmm2
vpunpcklbw        (%rax), %xmm1, %xmm2

vpunpckldq        %xmm0, %xmm1, %xmm2
vpunpckldq        (%rax), %xmm1, %xmm2

vpunpcklqdq       %xmm0, %xmm1, %xmm2
vpunpcklqdq       (%rax), %xmm1, %xmm2

vpunpcklwd        %xmm0, %xmm1, %xmm2
vpunpcklwd        (%rax), %xmm1, %xmm2

vpxor             %xmm0, %xmm1, %xmm2
vpxor             (%rax), %xmm1, %xmm2

vrcpps            %xmm0, %xmm2
vrcpps            (%rax), %xmm2

vrcpps            %ymm0, %ymm2
vrcpps            (%rax), %ymm2

vrcpss            %xmm0, %xmm1, %xmm2
vrcpss            (%rax), %xmm1, %xmm2

vroundpd          $1, %xmm0, %xmm2
vroundpd          $1, (%rax), %xmm2

vroundpd          $1, %ymm0, %ymm2
vroundpd          $1, (%rax), %ymm2

vroundps          $1, %xmm0, %xmm2
vroundps          $1, (%rax), %xmm2

vroundps          $1, %ymm0, %ymm2
vroundps          $1, (%rax), %ymm2

vroundsd          $1, %xmm0, %xmm1, %xmm2
vroundsd          $1, (%rax), %xmm1, %xmm2

vroundss          $1, %xmm0, %xmm1, %xmm2
vroundss          $1, (%rax), %xmm1, %xmm2

vrsqrtps          %xmm0, %xmm2
vrsqrtps          (%rax), %xmm2

vrsqrtps          %ymm0, %ymm2
vrsqrtps          (%rax), %ymm2

vrsqrtss          %xmm0, %xmm1, %xmm2
vrsqrtss          (%rax), %xmm1, %xmm2

vshufpd           $1, %xmm0, %xmm1, %xmm2
vshufpd           $1, (%rax), %xmm1, %xmm2

vshufpd           $1, %ymm0, %ymm1, %ymm2
vshufpd           $1, (%rax), %ymm1, %ymm2

vshufps           $1, %xmm0, %xmm1, %xmm2
vshufps           $1, (%rax), %xmm1, %xmm2

vshufps           $1, %ymm0, %ymm1, %ymm2
vshufps           $1, (%rax), %ymm1, %ymm2

vsqrtpd           %xmm0, %xmm2
vsqrtpd           (%rax), %xmm2

vsqrtpd           %ymm0, %ymm2
vsqrtpd           (%rax), %ymm2

vsqrtps           %xmm0, %xmm2
vsqrtps           (%rax), %xmm2

vsqrtps           %ymm0, %ymm2
vsqrtps           (%rax), %ymm2

vsqrtsd           %xmm0, %xmm1, %xmm2
vsqrtsd           (%rax), %xmm1, %xmm2

vsqrtss           %xmm0, %xmm1, %xmm2
vsqrtss           (%rax), %xmm1, %xmm2

vstmxcsr          (%rax)

vsubpd            %xmm0, %xmm1, %xmm2
vsubpd            (%rax), %xmm1, %xmm2

vsubpd            %ymm0, %ymm1, %ymm2
vsubpd            (%rax), %ymm1, %ymm2

vsubps            %xmm0, %xmm1, %xmm2
vsubps            (%rax), %xmm1, %xmm2

vsubps            %ymm0, %ymm1, %ymm2
vsubps            (%rax), %ymm1, %ymm2

vsubsd            %xmm0, %xmm1, %xmm2
vsubsd            (%rax), %xmm1, %xmm2

vsubss            %xmm0, %xmm1, %xmm2
vsubss            (%rax), %xmm1, %xmm2

vtestpd          %xmm0, %xmm1
vtestpd          (%rax), %xmm1

vtestpd          %ymm0, %ymm1
vtestpd          (%rax), %ymm1

vtestps          %xmm0, %xmm1
vtestps          (%rax), %xmm1

vtestps          %ymm0, %ymm1
vtestps          (%rax), %ymm1

vucomisd          %xmm0, %xmm1
vucomisd          (%rax), %xmm1

vucomiss          %xmm0, %xmm1
vucomiss          (%rax), %xmm1

vunpckhpd         %xmm0, %xmm1, %xmm2
vunpckhpd         (%rax), %xmm1, %xmm2

vunpckhpd         %ymm0, %ymm1, %ymm2
vunpckhpd         (%rax), %ymm1, %ymm2

vunpckhps         %xmm0, %xmm1, %xmm2
vunpckhps         (%rax), %xmm1, %xmm2

vunpckhps         %ymm0, %ymm1, %ymm2
vunpckhps         (%rax), %ymm1, %ymm2

vunpcklpd         %xmm0, %xmm1, %xmm2
vunpcklpd         (%rax), %xmm1, %xmm2

vunpcklpd         %ymm0, %ymm1, %ymm2
vunpcklpd         (%rax), %ymm1, %ymm2

vunpcklps         %xmm0, %xmm1, %xmm2
vunpcklps         (%rax), %xmm1, %xmm2

vunpcklps         %ymm0, %ymm1, %ymm2
vunpcklps         (%rax), %ymm1, %ymm2

vxorpd            %xmm0, %xmm1, %xmm2
vxorpd            (%rax), %xmm1, %xmm2

vxorpd            %ymm0, %ymm1, %ymm2
vxorpd            (%rax), %ymm1, %ymm2

vxorps            %xmm0, %xmm1, %xmm2
vxorps            (%rax), %xmm1, %xmm2

vxorps            %ymm0, %ymm1, %ymm2
vxorps            (%rax), %ymm1, %ymm2

vzeroall
vzeroupper

# CHECK:      Resources:
# CHECK-NEXT: [0] - JALU0
# CHECK-NEXT: [1] - JALU1
# CHECK-NEXT: [2] - JDiv
# CHECK-NEXT: [3] - JFPA
# CHECK-NEXT: [4] - JFPM
# CHECK-NEXT: [5] - JFPU0
# CHECK-NEXT: [6] - JFPU1
# CHECK-NEXT: [7] - JLAGU
# CHECK-NEXT: [8] - JMul
# CHECK-NEXT: [9] - JSAGU
# CHECK-NEXT: [10] - JSTC
# CHECK-NEXT: [11] - JVALU0
# CHECK-NEXT: [12] - JVALU1
# CHECK-NEXT: [13] - JVIMUL

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   	Instructions:
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vaddpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vaddpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vaddpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vaddpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vaddps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vaddps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vaddsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vaddsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vaddss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vaddss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vaddsubpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vaddsubpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vaddsubpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vaddsubpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vaddsubps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vaddsubps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vaddsubps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vaddsubps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vaesdec	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vaesdec	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vaesdeclast	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vaesdeclast	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vaesenc	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vaesenc	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vaesenclast	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vaesenclast	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vaesimc	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vaesimc	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vaeskeygenassist	$22, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vaeskeygenassist	$22, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vandnpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vandnpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vandnpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vandnpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vandnps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vandnps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vandnps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vandnps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vandpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vandpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vandpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vandpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vandps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vandps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vandps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vandps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vblendpd	$11, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vblendpd	$11, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vblendpd	$11, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vblendpd	$11, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vblendps	$11, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vblendps	$11, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vblendps	$11, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vblendps	$11, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50    -      -      -      -      -      -      -     	vblendvpd	%xmm3, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50   1.00    -      -      -      -      -      -     	vblendvpd	%xmm3, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00    -      -      -      -      -      -      -     	vblendvpd	%ymm3, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00   2.00    -      -      -      -      -      -     	vblendvpd	%ymm3, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50    -      -      -      -      -      -      -     	vblendvps	%xmm3, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50   1.00    -      -      -      -      -      -     	vblendvps	%xmm3, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00    -      -      -      -      -      -      -     	vblendvps	%ymm3, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00   2.00    -      -      -      -      -      -     	vblendvps	%ymm3, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vbroadcastf128	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     2.00   2.00   1.00   1.00   1.00    -      -      -      -      -      -     	vbroadcastsd	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vbroadcastss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   1.00   1.00   1.00    -      -      -      -      -      -     	vbroadcastss	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vcmppd	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vcmppd	$0, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vcmppd	$0, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vcmppd	$0, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vcmpps	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vcmpps	$0, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vcmpps	$0, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vcmpps	$0, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vcmpsd	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vcmpsd	$0, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vcmpss	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vcmpss	$0, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vcomisd	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vcomisd	(%rax), %xmm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vcomiss	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vcomiss	(%rax), %xmm1
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtdq2pd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtdq2pd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -      -     2.00    -      -      -     	vcvtdq2pd	%xmm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00   2.00    -      -     2.00    -      -      -     	vcvtdq2pd	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtdq2ps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtdq2ps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -      -     2.00    -      -      -     	vcvtdq2ps	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00   2.00    -      -     2.00    -      -      -     	vcvtdq2ps	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtpd2dq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtpd2dqx	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00    -     2.00    -      -      -     2.00    -      -      -     	vcvtpd2dq	%ymm0, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00    -     2.00   2.00    -      -     2.00    -      -      -     	vcvtpd2dqy	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtpd2ps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtpd2psx	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00    -     2.00    -      -      -     2.00    -      -      -     	vcvtpd2ps	%ymm0, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00    -     2.00   2.00    -      -     2.00    -      -      -     	vcvtpd2psy	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtps2dq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtps2dq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -      -     2.00    -      -      -     	vcvtps2dq	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00   2.00    -      -     2.00    -      -      -     	vcvtps2dq	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtps2pd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtps2pd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtps2pd	%xmm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtps2pd	(%rax), %ymm2
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsd2si	%xmm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsd2si	%xmm0, %rcx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsd2si	(%rax), %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsd2si	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsd2ss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsd2ss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsi2sdl	%ecx, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsi2sdq	%rcx, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsi2sdl	(%rax), %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsi2sdq	(%rax), %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsi2ssl	%ecx, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtsi2ssq	%rcx, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsi2ssl	(%rax), %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtsi2ssq	(%rax), %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvtss2sd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtss2sd	(%rax), %xmm1, %xmm2
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvtss2si	%xmm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvtss2si	%xmm0, %rcx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtss2si	(%rax), %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvtss2si	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvttpd2dq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvttpd2dqx	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00    -     2.00    -      -      -     2.00    -      -      -     	vcvttpd2dq	%ymm0, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00    -     2.00   2.00    -      -     2.00    -      -      -     	vcvttpd2dqy	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -     1.00    -      -      -     	vcvttps2dq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvttps2dq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -      -     2.00    -      -      -     	vcvttps2dq	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00   2.00    -      -     2.00    -      -      -     	vcvttps2dq	(%rax), %ymm2
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvttsd2si	%xmm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvttsd2si	%xmm0, %rcx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvttsd2si	(%rax), %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvttsd2si	(%rax), %rcx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvttss2si	%xmm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00    -      -      -     1.00    -      -      -     	vcvttss2si	%xmm0, %rcx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvttss2si	(%rax), %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -      -     1.00   1.00    -      -     1.00    -      -      -     	vcvttss2si	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00    -      -      -      -      -      -      -     	vdivpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00   1.00    -      -      -      -      -      -     	vdivpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     38.00   -     2.00    -      -      -      -      -      -      -     	vdivpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     38.00   -     2.00   2.00    -      -      -      -      -      -     	vdivpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00    -      -      -      -      -      -      -     	vdivps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00   1.00    -      -      -      -      -      -     	vdivps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     38.00   -     2.00    -      -      -      -      -      -      -     	vdivps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     38.00   -     2.00   2.00    -      -      -      -      -      -     	vdivps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00    -      -      -      -      -      -      -     	vdivsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00   1.00    -      -      -      -      -      -     	vdivsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00    -      -      -      -      -      -      -     	vdivss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     19.00   -     1.00   1.00    -      -      -      -      -      -     	vdivss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     3.00   3.00    -     1.00    -      -      -      -      -      -      -     	vdppd	$22, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     3.00   3.00    -     1.00   1.00    -      -      -      -      -      -     	vdppd	$22, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     3.00   3.00    -     1.00    -      -      -      -      -      -      -     	vdpps	$22, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     3.00   3.00    -     1.00   1.00    -      -      -      -      -      -     	vdpps	$22, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     6.00   6.00    -     2.00    -      -      -      -      -      -      -     	vdpps	$22, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     6.00   6.00    -     2.00   2.00    -      -      -      -      -      -     	vdpps	$22, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vextractf128	$1, %ymm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vextractf128	$1, %ymm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vextractps	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -     1.00    -      -      -      -     	vextractps	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vhaddpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vhaddpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vhaddpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vhaddpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vhaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vhaddps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vhaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vhaddps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vhsubpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vhsubpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vhsubpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vhsubpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vhsubps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vhsubps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vhsubps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vhsubps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vinsertf128	$1, %xmm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vinsertf128	$1, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vinsertps	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vinsertps	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vlddqu	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vlddqu	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -      -     	vldmxcsr	(%rax)
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmaskmovdqu	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     1.00   1.00   0.50   0.50   1.00    -      -      -      -      -      -     	vmaskmovpd	(%rax), %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   1.00   1.00   2.00    -      -      -      -      -      -     	vmaskmovpd	(%rax), %ymm0, %ymm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50    -      -     1.00    -      -      -      -     	vmaskmovpd	%xmm0, %xmm1, (%rax)
# CHECK-NEXT:  -      -      -     2.00   2.00   1.00   1.00    -      -     2.00    -      -      -      -     	vmaskmovpd	%ymm0, %ymm1, (%rax)
# CHECK-NEXT:  -      -      -     1.00   1.00   0.50   0.50   1.00    -      -      -      -      -      -     	vmaskmovps	(%rax), %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   1.00   1.00   2.00    -      -      -      -      -      -     	vmaskmovps	(%rax), %ymm0, %ymm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50    -      -     1.00    -      -      -      -     	vmaskmovps	%xmm0, %xmm1, (%rax)
# CHECK-NEXT:  -      -      -     2.00   2.00   1.00   1.00    -      -     2.00    -      -      -      -     	vmaskmovps	%ymm0, %ymm1, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmaxpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vmaxpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vmaxpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vmaxpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmaxps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vmaxps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vmaxps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vmaxps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmaxsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vmaxsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmaxss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vmaxss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vminpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vminpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vminpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vminpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vminps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vminps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vminps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vminps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vminsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vminsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vminss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vminss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovapd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovapd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovapd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovapd	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovapd	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovapd	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovaps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovaps	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovaps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovaps	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovaps	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovaps	(%rax), %ymm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     	vmovd	%eax, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -      -     	vmovd	(%rax), %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     	vmovd	%xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovddup	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovddup	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vmovddup	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vmovddup	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vmovdqa	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovdqa	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vmovdqa	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vmovdqa	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovdqa	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vmovdqa	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vmovdqu	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovdqu	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vmovdqu	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vmovdqu	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovdqu	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vmovdqu	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovhlps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovlhps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovhpd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovhpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovhps	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovhps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovlpd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovlpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovlps	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovlps	(%rax), %xmm1, %xmm2
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmovmskpd	%xmm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmovmskpd	%ymm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmovmskps	%xmm0, %ecx
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vmovmskps	%ymm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovntdq	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -     2.00   2.00    -      -      -     	vmovntdq	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vmovntdqa	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vmovntdqa	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovntpd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -     2.00   2.00    -      -      -     	vmovntpd	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovntps	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -     2.00   2.00    -      -      -     	vmovntps	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vmovq	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     	vmovq	%rax, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -      -     	vmovq	(%rax), %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     	vmovq	%xmm0, %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovq	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovsd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -      -     	vmovsd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovshdup	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovshdup	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vmovshdup	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vmovshdup	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovsldup	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovsldup	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vmovsldup	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vmovsldup	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vmovss	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -      -     	vmovss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovupd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovupd	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovupd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovupd	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovupd	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovupd	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovups	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovups	%xmm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovups	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vmovups	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -     1.00   1.00    -      -      -     	vmovups	%ymm0, (%rax)
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vmovups	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     2.00   	vmpsadbw	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     2.00   	vmpsadbw	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     2.00    -     1.00    -      -      -      -      -      -      -     	vmulpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     2.00    -     1.00   1.00    -      -      -      -      -      -     	vmulpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     4.00    -     2.00    -      -      -      -      -      -      -     	vmulpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     4.00    -     2.00   2.00    -      -      -      -      -      -     	vmulpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -     	vmulps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00    -      -      -      -      -      -     	vmulps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     2.00    -     2.00    -      -      -      -      -      -      -     	vmulps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     2.00    -     2.00   2.00    -      -      -      -      -      -     	vmulps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     2.00    -     1.00    -      -      -      -      -      -      -     	vmulsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     2.00    -     1.00   1.00    -      -      -      -      -      -     	vmulsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -     	vmulss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00    -      -      -      -      -      -     	vmulss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vorpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vorpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vorpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vorpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vorps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vorps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vorps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vorps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpabsb	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpabsb	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpabsd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpabsd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpabsw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpabsw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpackssdw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpackssdw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpacksswb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpacksswb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpackusdw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpackusdw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpackuswb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpackuswb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddsb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddsb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddusb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddusb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddusw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddusw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpaddw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpaddw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpalignr	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpalignr	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpand	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpand	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpandn	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpandn	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpavgb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpavgb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpavgw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpavgw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     2.00   2.00    -     	vpblendvb	%xmm3, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     2.00   2.00    -     	vpblendvb	%xmm3, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpblendw	$11, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpblendw	$11, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpclmulqdq	$11, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpclmulqdq	$11, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpeqb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpeqb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpeqd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpeqd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpeqq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpeqq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpeqw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpeqw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpgtb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpgtb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpgtd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpgtd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpgtq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpgtq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpcmpgtw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpcmpgtw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vperm2f128	$1, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vperm2f128	$1, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vpermilpd	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vpermilpd	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50    -      -      -      -      -      -      -     	vpermilpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50   1.00    -      -      -      -      -      -     	vpermilpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vpermilpd	$1, %ymm0, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vpermilpd	$1, (%rax), %ymm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00    -      -      -      -      -      -      -     	vpermilpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00   2.00    -      -      -      -      -      -     	vpermilpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vpermilps	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vpermilps	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50    -      -      -      -      -      -      -     	vpermilps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00   2.00   0.50   0.50   1.00    -      -      -      -      -      -     	vpermilps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vpermilps	$1, %ymm0, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vpermilps	$1, (%rax), %ymm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00    -      -      -      -      -      -      -     	vpermilps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     3.00   3.00   1.00   1.00   2.00    -      -      -      -      -      -     	vpermilps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpextrb	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -     1.00    -     0.50   0.50    -     	vpextrb	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpextrd	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -     1.00    -     0.50   0.50    -     	vpextrd	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpextrq	$1, %xmm0, %rcx
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -     1.00    -     0.50   0.50    -     	vpextrq	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpextrw	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -     1.00    -     0.50   0.50    -     	vpextrw	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vphaddd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vphaddd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vphaddsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vphaddsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vphaddw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vphaddw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vphminposuw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vphminposuw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vphsubd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vphsubd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vphsubsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vphsubsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vphsubw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vphsubw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpinsrb	$1, %eax, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpinsrb	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpinsrd	$1, %eax, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpinsrd	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpinsrq	$1, %rax, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpinsrq	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpinsrw	$1, %eax, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpinsrw	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmaddubsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmaddubsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmaddwd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmaddwd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmaxsb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmaxsb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmaxsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmaxsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmaxsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmaxsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmaxub	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmaxub	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmaxud	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmaxud	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmaxuw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmaxuw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpminsb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpminsb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpminsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpminsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpminsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpminsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpminub	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpminub	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpminud	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpminud	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpminuw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpminuw	(%rax), %xmm1, %xmm2
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vpmovmskb	%xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovsxbd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovsxbd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovsxbq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovsxbq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovsxbw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovsxbw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovsxdq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovsxdq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovsxwd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovsxwd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovsxwq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovsxwq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovzxbd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovzxbd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovzxbq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovzxbq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovzxbw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovzxbw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovzxdq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovzxdq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovzxwd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovzxwd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpmovzxwq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpmovzxwq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmuldq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmuldq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmulhrsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmulhrsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmulhuw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmulhuw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmulhw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmulhw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmulld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmulld	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmullw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmullw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -     1.00   	vpmuludq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -     1.00    -      -      -      -      -     1.00   	vpmuludq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpor	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpor	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsadbw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsadbw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     2.00   2.00    -     	vpshufb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     2.00   2.00    -     	vpshufb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpshufd	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpshufd	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpshufhw	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpshufhw	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpshuflw	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpshuflw	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsignb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsignb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsignd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsignd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsignw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsignw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpslld	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpslld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpslld	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpslldq	$1, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsllq	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsllq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsllq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsllw	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsllw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsllw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrad	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrad	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsrad	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsraw	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsraw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsraw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrld	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsrld	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrldq	$1, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrlq	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrlq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsrlq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrlw	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsrlw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsrlw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubsb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubsb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubsw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubsw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubusb	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubusb	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubusw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubusw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpsubw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpsubw	(%rax), %xmm1, %xmm2
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vptest	%xmm0, %xmm1
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vptest	(%rax), %xmm1
# CHECK-NEXT: 1.00    -      -     3.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vptest	%ymm0, %ymm1
# CHECK-NEXT: 1.00    -      -     3.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vptest	(%rax), %ymm1
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpckhbw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpckhbw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpckhdq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpckhdq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpckhqdq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpckhqdq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpckhwd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpckhwd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpcklbw	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpcklbw	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpckldq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpckldq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpcklqdq	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpcklqdq	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpunpcklwd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpunpcklwd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     	vpxor	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   1.00    -      -      -     0.50   0.50    -     	vpxor	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -     	vrcpps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00    -      -      -      -      -      -     	vrcpps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     2.00    -     2.00    -      -      -      -      -      -      -     	vrcpps	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -     2.00    -     2.00   2.00    -      -      -      -      -      -     	vrcpps	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -     	vrcpss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00    -      -      -      -      -      -     	vrcpss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vroundpd	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vroundpd	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -      -     2.00    -      -      -     	vroundpd	$1, %ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00   2.00    -      -     2.00    -      -      -     	vroundpd	$1, (%rax), %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vroundps	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vroundps	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00    -      -      -     2.00    -      -      -     	vroundps	$1, %ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -     2.00   2.00    -      -     2.00    -      -      -     	vroundps	$1, (%rax), %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vroundsd	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vroundsd	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vroundss	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vroundss	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -     	vrsqrtps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00    -      -      -      -      -      -     	vrsqrtps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     2.00    -     2.00    -      -      -      -      -      -      -     	vrsqrtps	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -     2.00    -     2.00   2.00    -      -      -      -      -      -     	vrsqrtps	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00    -      -      -      -      -      -      -     	vrsqrtss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00    -      -      -      -      -      -     	vrsqrtss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vshufpd	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vshufpd	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vshufpd	$1, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vshufpd	$1, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vshufps	$1, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vshufps	$1, (%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vshufps	$1, %ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vshufps	$1, (%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -     27.00   -     1.00    -      -      -      -      -      -      -     	vsqrtpd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     27.00   -     1.00   1.00    -      -      -      -      -      -     	vsqrtpd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     54.00   -     2.00    -      -      -      -      -      -      -     	vsqrtpd	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -     54.00   -     2.00   2.00    -      -      -      -      -      -     	vsqrtpd	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -     21.00   -     1.00    -      -      -      -      -      -      -     	vsqrtps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     21.00   -     1.00   1.00    -      -      -      -      -      -     	vsqrtps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     42.00   -     2.00    -      -      -      -      -      -      -     	vsqrtps	%ymm0, %ymm2
# CHECK-NEXT:  -      -      -      -     42.00   -     2.00   2.00    -      -      -      -      -      -     	vsqrtps	(%rax), %ymm2
# CHECK-NEXT:  -      -      -      -     27.00   -     1.00    -      -      -      -      -      -      -     	vsqrtsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     27.00   -     1.00   1.00    -      -      -      -      -      -     	vsqrtsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     21.00   -     1.00    -      -      -      -      -      -      -     	vsqrtss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -     21.00   -     1.00   1.00    -      -      -      -      -      -     	vsqrtss	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     	vstmxcsr	(%rax)
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vsubpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vsubpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vsubpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vsubpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vsubps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vsubps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -      -      -      -      -      -      -      -     	vsubps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     2.00    -     2.00    -     2.00    -      -      -      -      -      -     	vsubps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vsubsd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vsubsd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vsubss	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vsubss	(%rax), %xmm1, %xmm2
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vtestpd	%xmm0, %xmm1
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vtestpd	(%rax), %xmm1
# CHECK-NEXT: 1.00    -      -     3.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vtestpd	%ymm0, %ymm1
# CHECK-NEXT: 1.00    -      -     3.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vtestpd	(%rax), %ymm1
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vtestps	%xmm0, %xmm1
# CHECK-NEXT: 1.00    -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vtestps	(%rax), %xmm1
# CHECK-NEXT: 1.00    -      -     3.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vtestps	%ymm0, %ymm1
# CHECK-NEXT: 1.00    -      -     3.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vtestps	(%rax), %ymm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vucomisd	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vucomisd	(%rax), %xmm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -      -      -      -      -      -      -     	vucomiss	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -     	vucomiss	(%rax), %xmm1
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vunpckhpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vunpckhpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vunpckhpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vunpckhpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vunpckhps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vunpckhps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vunpckhps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vunpckhps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vunpcklpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vunpcklpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vunpcklpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vunpcklpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vunpcklps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vunpcklps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vunpcklps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vunpcklps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vxorpd	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vxorpd	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vxorpd	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vxorpd	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -     	vxorps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50   1.00    -      -      -      -      -      -     	vxorps	(%rax), %xmm1, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00    -      -      -      -      -      -      -     	vxorps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -     1.00   1.00   1.00   1.00   2.00    -      -      -      -      -      -     	vxorps	(%rax), %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     	vzeroall
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     	vzeroupper
