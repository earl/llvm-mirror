; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm-eabi -mattr=+v6 %s -o - | FileCheck %s

define i32 @test1(i32 %X) nounwind {
; CHECK-LABEL: test1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rev16 r0, r0
; CHECK-NEXT:    bx lr
        %tmp1 = lshr i32 %X, 8
        %X15 = bitcast i32 %X to i32
        %tmp4 = shl i32 %X15, 8
        %tmp2 = and i32 %tmp1, 16711680
        %tmp5 = and i32 %tmp4, -16777216
        %tmp9 = and i32 %tmp1, 255
        %tmp13 = and i32 %tmp4, 65280
        %tmp6 = or i32 %tmp5, %tmp2
        %tmp10 = or i32 %tmp6, %tmp13
        %tmp14 = or i32 %tmp10, %tmp9
        ret i32 %tmp14
}

define i32 @test2(i32 %X) nounwind {
; CHECK-LABEL: test2:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    revsh r0, r0
; CHECK-NEXT:    bx lr
        %tmp1 = lshr i32 %X, 8
        %tmp1.upgrd.1 = trunc i32 %tmp1 to i16
        %tmp3 = trunc i32 %X to i16
        %tmp2 = and i16 %tmp1.upgrd.1, 255
        %tmp4 = shl i16 %tmp3, 8
        %tmp5 = or i16 %tmp2, %tmp4
        %tmp5.upgrd.2 = sext i16 %tmp5 to i32
        ret i32 %tmp5.upgrd.2
}

; rdar://9147637
define i32 @test3(i16 zeroext %a) nounwind {
; CHECK-LABEL: test3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    revsh r0, r0
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call i16 @llvm.bswap.i16(i16 %a)
  %1 = sext i16 %0 to i32
  ret i32 %1
}

declare i16 @llvm.bswap.i16(i16) nounwind readnone

define i32 @test4(i16 zeroext %a) nounwind {
; CHECK-LABEL: test4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    revsh r0, r0
; CHECK-NEXT:    bx lr
entry:
  %conv = zext i16 %a to i32
  %shr9 = lshr i16 %a, 8
  %conv2 = zext i16 %shr9 to i32
  %shl = shl nuw nsw i32 %conv, 8
  %or = or i32 %conv2, %shl
  %sext = shl i32 %or, 16
  %conv8 = ashr exact i32 %sext, 16
  ret i32 %conv8
}

; rdar://9609059
define i32 @test5(i32 %i) nounwind readnone {
; CHECK-LABEL: test5:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    revsh r0, r0
; CHECK-NEXT:    bx lr
entry:
  %shl = shl i32 %i, 24
  %shr = ashr exact i32 %shl, 16
  %shr23 = lshr i32 %i, 8
  %and = and i32 %shr23, 255
  %or = or i32 %shr, %and
  ret i32 %or
}

; rdar://9609108
define i32 @test6(i32 %x) nounwind readnone {
; CHECK-LABEL: test6:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    rev16 r0, r0
; CHECK-NEXT:    bx lr
entry:
  %and = shl i32 %x, 8
  %shl = and i32 %and, 65280
  %and2 = lshr i32 %x, 8
  %shr11 = and i32 %and2, 255
  %shr5 = and i32 %and2, 16711680
  %shl9 = and i32 %and, -16777216
  %or = or i32 %shr5, %shl9
  %or6 = or i32 %or, %shr11
  %or10 = or i32 %or6, %shl
  ret i32 %or10
}

; rdar://9164521
define i32 @test7(i32 %a) nounwind readnone {
; CHECK-LABEL: test7:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    rev r0, r0
; CHECK-NEXT:    lsr r0, r0, #16
; CHECK-NEXT:    bx lr
entry:
  %and = lshr i32 %a, 8
  %shr3 = and i32 %and, 255
  %and2 = shl i32 %a, 8
  %shl = and i32 %and2, 65280
  %or = or i32 %shr3, %shl
  ret i32 %or
}

define i32 @test8(i32 %a) nounwind readnone {
; CHECK-LABEL: test8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    revsh r0, r0
; CHECK-NEXT:    bx lr
entry:
  %and = lshr i32 %a, 8
  %shr4 = and i32 %and, 255
  %and2 = shl i32 %a, 8
  %or = or i32 %shr4, %and2
  %sext = shl i32 %or, 16
  %conv3 = ashr exact i32 %sext, 16
  ret i32 %conv3
}

; rdar://10750814
define zeroext i16 @test9(i16 zeroext %v) nounwind readnone {
; CHECK-LABEL: test9:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    rev16 r0, r0
; CHECK-NEXT:    bx lr
entry:
  %conv = zext i16 %v to i32
  %shr4 = lshr i32 %conv, 8
  %shl = shl nuw nsw i32 %conv, 8
  %or = or i32 %shr4, %shl
  %conv3 = trunc i32 %or to i16
  ret i16 %conv3
}
