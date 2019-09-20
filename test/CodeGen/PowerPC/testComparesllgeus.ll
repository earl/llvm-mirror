; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = local_unnamed_addr global i16 0, align 2

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeus(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: test_llgeus:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    not r3, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = zext i1 %cmp to i64
  ret i64 %conv3
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeus_sext(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: test_llgeus_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    addi r3, r3, -1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeus_z(i16 zeroext %a) {
; CHECK-LABEL: test_llgeus_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, 0
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeus_sext_z(i16 zeroext %a) {
; CHECK-LABEL: test_llgeus_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, -1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, 0
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind
define void @test_llgeus_store(i16 zeroext %a, i16 zeroext %b) {
; BE-LABEL: test_llgeus_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r3, r4
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    not r3, r3
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    sth r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeus_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r3, r4
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    not r3, r3
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    sth r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = zext i1 %cmp to i16
  store i16 %conv3, i16* @glob
  ret void
; CHECK_LABEL: test_llgeus_store:
}

; Function Attrs: norecurse nounwind
define void @test_llgeus_sext_store(i16 zeroext %a, i16 zeroext %b) {
; BE-LABEL: test_llgeus_sext_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r3, r4
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    addi r3, r3, -1
; BE-NEXT:    sth r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeus_sext_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r3, r4
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    addi r3, r3, -1
; LE-NEXT:    sth r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeus_z_store(i16 zeroext %a) {
; BE-LABEL: test_llgeus_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r3, r2, .LC0@toc@ha
; BE-NEXT:    li r4, 1
; BE-NEXT:    ld r3, .LC0@toc@l(r3)
; BE-NEXT:    sth r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeus_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r3, r2, glob@toc@ha
; LE-NEXT:    li r4, 1
; LE-NEXT:    sth r4, glob@toc@l(r3)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, 0
  %conv1 = zext i1 %cmp to i16
  store i16 %conv1, i16* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeus_sext_z_store(i16 zeroext %a) {
; BE-LABEL: test_llgeus_sext_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r3, r2, .LC0@toc@ha
; BE-NEXT:    li r4, -1
; BE-NEXT:    ld r3, .LC0@toc@l(r3)
; BE-NEXT:    sth r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeus_sext_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r3, r2, glob@toc@ha
; LE-NEXT:    li r4, -1
; LE-NEXT:    sth r4, glob@toc@l(r3)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, 0
  %conv1 = sext i1 %cmp to i16
  store i16 %conv1, i16* @glob
  ret void
}

