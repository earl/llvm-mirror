; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=mipsel -relocation-model=pic -O0 -fast-isel=true -mcpu=mips32r2 \
; RUN:     < %s -verify-machineinstrs | FileCheck %s


define i32 @foobar(i32*) {
bb0:
; CHECK-LABEL: foobar:
; CHECK:       # %bb.0: # %bb0
; CHECK:        lw $[[REG0:[0-9]+]], 0($4)
; CHECK-NEXT:   sltiu $[[REG1:[0-9]+]], $[[REG0]], 1
; CHECK:        sw $[[REG1]], [[SPILL:[0-9]+]]($sp) # 4-byte Folded Spill
  %1 = load  i32, i32* %0 , align 4
  %2 = icmp eq i32 %1, 0
  store atomic i32 0, i32* %0 monotonic, align 4
  br label %bb1
bb1:
; CHECK:       # %bb.1: # %bb1
; CHECK-NEXT:    lw $[[REG2:[0-9]+]], [[SPILL]]($sp) # 4-byte Folded Reload
; CHECK-NEXT:    bgtz $[[REG2]], $BB0_3
  br i1 %2, label %bb2, label %bb3
bb2:
; CHECK:         $BB0_3: # %bb2
; CHECK-NEXT:    addiu $2, $zero, 1
  ret i32 1
bb3:
  ret i32 0
}
