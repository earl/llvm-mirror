; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

define zeroext i8 @uint8_arg_to_uint8_ret(i8 zeroext %a) nounwind {
; RV32I-LABEL: uint8_arg_to_uint8_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ret
  ret i8 %a
}

declare void @receive_uint8(i8 zeroext)

define void @pass_uint8_as_uint8(i8 zeroext %a) nounwind {
; RV32I-LABEL: pass_uint8_as_uint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_uint8)
; RV32I-NEXT:    addi a1, a1, %lo(receive_uint8)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  call void @receive_uint8(i8 zeroext %a)
  ret void
}

declare zeroext i8 @return_uint8()

define zeroext i8 @ret_callresult_uint8_as_uint8() nounwind {
; RV32I-LABEL: ret_callresult_uint8_as_uint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_uint8)
; RV32I-NEXT:    addi a0, a0, %lo(return_uint8)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call zeroext i8 @return_uint8()
  ret i8 %1
}

define signext i8 @uint8_arg_to_sint8_ret(i8 zeroext %a) nounwind {
; RV32I-LABEL: uint8_arg_to_sint8_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    ret
  ret i8 %a
}

declare void @receive_sint8(i8 signext)

define void @pass_uint8_as_sint8(i8 zeroext %a) nounwind {
; RV32I-LABEL: pass_uint8_as_sint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_sint8)
; RV32I-NEXT:    addi a1, a1, %lo(receive_sint8)
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret

  call void @receive_sint8(i8 signext %a)
  ret void
}

define signext i8 @ret_callresult_uint8_as_sint8() nounwind {
; RV32I-LABEL: ret_callresult_uint8_as_sint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_uint8)
; RV32I-NEXT:    addi a0, a0, %lo(return_uint8)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call zeroext i8 @return_uint8()
  ret i8 %1
}

define signext i32 @uint8_arg_to_anyint32_ret(i8 zeroext %a) nounwind {
; RV32I-LABEL: uint8_arg_to_anyint32_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ret
  %1 = zext i8 %a to i32
  ret i32 %1
}

declare void @receive_anyint32(i32 signext)

define void @pass_uint8_as_anyint32(i8 zeroext %a) nounwind {
; RV32I-LABEL: pass_uint8_as_anyint32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_anyint32)
; RV32I-NEXT:    addi a1, a1, %lo(receive_anyint32)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = zext i8 %a to i32
  call void @receive_anyint32(i32 signext %1)
  ret void
}

define signext i32 @ret_callresult_uint8_as_anyint32() nounwind {
; RV32I-LABEL: ret_callresult_uint8_as_anyint32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_uint8)
; RV32I-NEXT:    addi a0, a0, %lo(return_uint8)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call zeroext i8 @return_uint8()
  %2 = zext i8 %1 to i32
  ret i32 %2
}

define zeroext i8 @sint8_arg_to_uint8_ret(i8 signext %a) nounwind {
; RV32I-LABEL: sint8_arg_to_uint8_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    ret
  ret i8 %a
}

define void @pass_sint8_as_uint8(i8 signext %a) nounwind {
; RV32I-LABEL: pass_sint8_as_uint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    lui a1, %hi(receive_uint8)
; RV32I-NEXT:    addi a1, a1, %lo(receive_uint8)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  call void @receive_uint8(i8 zeroext %a)
  ret void
}

declare signext i8 @return_sint8()

define zeroext i8 @ret_callresult_sint8_as_uint8() nounwind {
; RV32I-LABEL: ret_callresult_sint8_as_uint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_sint8)
; RV32I-NEXT:    addi a0, a0, %lo(return_sint8)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call signext i8 @return_sint8()
  ret i8 %1
}

define signext i8 @sint8_arg_to_sint8_ret(i8 signext %a) nounwind {
; RV32I-LABEL: sint8_arg_to_sint8_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ret
  ret i8 %a
}

define void @pass_sint8_as_sint8(i8 signext %a) nounwind {
; RV32I-LABEL: pass_sint8_as_sint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_sint8)
; RV32I-NEXT:    addi a1, a1, %lo(receive_sint8)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  call void @receive_sint8(i8 signext %a)
  ret void
}

define signext i8 @ret_callresult_sint8_as_sint8() nounwind {
; RV32I-LABEL: ret_callresult_sint8_as_sint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_sint8)
; RV32I-NEXT:    addi a0, a0, %lo(return_sint8)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call signext i8 @return_sint8()
  ret i8 %1
}

define signext i32 @sint8_arg_to_anyint32_ret(i8 signext %a) nounwind {
; RV32I-LABEL: sint8_arg_to_anyint32_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ret
  %1 = sext i8 %a to i32
  ret i32 %1
}

define void @pass_sint8_as_anyint32(i8 signext %a) nounwind {
; RV32I-LABEL: pass_sint8_as_anyint32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_anyint32)
; RV32I-NEXT:    addi a1, a1, %lo(receive_anyint32)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = sext i8 %a to i32
  call void @receive_anyint32(i32 signext %1)
  ret void
}

define signext i32 @ret_callresult_sint8_as_anyint32() nounwind {
; RV32I-LABEL: ret_callresult_sint8_as_anyint32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_sint8)
; RV32I-NEXT:    addi a0, a0, %lo(return_sint8)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call signext i8 @return_sint8()
  %2 = sext i8 %1 to i32
  ret i32 %2
}

define zeroext i8 @anyint32_arg_to_uint8_ret(i32 signext %a) nounwind {
; RV32I-LABEL: anyint32_arg_to_uint8_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    ret
  %1 = trunc i32 %a to i8
  ret i8 %1
}

define void @pass_anyint32_as_uint8(i32 signext %a) nounwind {
; RV32I-LABEL: pass_anyint32_as_uint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    lui a1, %hi(receive_uint8)
; RV32I-NEXT:    addi a1, a1, %lo(receive_uint8)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = trunc i32 %a to i8
  call void @receive_uint8(i8 zeroext %1)
  ret void
}

declare signext i32 @return_anyint32()

define zeroext i8 @ret_callresult_anyint32_as_uint8() nounwind {
; RV32I-LABEL: ret_callresult_anyint32_as_uint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_anyint32)
; RV32I-NEXT:    addi a0, a0, %lo(return_anyint32)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call signext i32 @return_anyint32()
  %2 = trunc i32 %1 to i8
  ret i8 %2
}

define signext i8 @anyint32_arg_to_sint8_ret(i32 signext %a) nounwind {
; RV32I-LABEL: anyint32_arg_to_sint8_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    ret
  %1 = trunc i32 %a to i8
  ret i8 %1
}

define void @pass_anyint32_as_sint8(i32 signext %a) nounwind {
; RV32I-LABEL: pass_anyint32_as_sint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_sint8)
; RV32I-NEXT:    addi a1, a1, %lo(receive_sint8)
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = trunc i32 %a to i8
  call void @receive_sint8(i8 signext %1)
  ret void
}

define signext i8 @ret_callresult_anyint32_as_sint8() nounwind {
; RV32I-LABEL: ret_callresult_anyint32_as_sint8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_anyint32)
; RV32I-NEXT:    addi a0, a0, %lo(return_anyint32)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call signext i32 @return_anyint32()
  %2 = trunc i32 %1 to i8
  ret i8 %2
}

define signext i32 @anyint32_arg_to_anyint32_ret(i32 signext %a) nounwind {
; RV32I-LABEL: anyint32_arg_to_anyint32_ret:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ret
  ret i32 %a
}

define void @pass_anyint32_as_anyint32(i32 signext %a) nounwind {
; RV32I-LABEL: pass_anyint32_as_anyint32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, %hi(receive_anyint32)
; RV32I-NEXT:    addi a1, a1, %lo(receive_anyint32)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  call void @receive_anyint32(i32 signext %a)
  ret void
}

define signext i32 @ret_callresult_anyint32_as_anyint32() nounwind {
; RV32I-LABEL: ret_callresult_anyint32_as_anyint32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a0, %hi(return_anyint32)
; RV32I-NEXT:    addi a0, a0, %lo(return_anyint32)
; RV32I-NEXT:    jalr a0
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call signext i32 @return_anyint32()
  ret i32 %1
}

