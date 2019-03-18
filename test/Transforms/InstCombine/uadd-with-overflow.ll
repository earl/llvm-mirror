; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32>, <2 x i32>)

declare { <2 x i8>, <2 x i1> } @llvm.uadd.with.overflow.v2i8(<2 x i8>, <2 x i8>)

declare { i32, i1 } @llvm.uadd.with.overflow.i32(i32, i32)

declare { i8, i1 } @llvm.uadd.with.overflow.i8(i8, i8)

define { i32, i1 } @simple_fold(i32 %x) {
; CHECK-LABEL: @simple_fold(
; CHECK-NEXT:    [[A:%.*]] = add nuw i32 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[A]], i32 13)
; CHECK-NEXT:    ret { i32, i1 } [[B]]
;
  %a = add nuw i32 %x, 7
  %b = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %a, i32 13)
  ret { i32, i1 } %b
}

define { i8, i1 } @fold_on_constant_add_no_overflow(i8 %x) {
; CHECK-LABEL: @fold_on_constant_add_no_overflow(
; CHECK-NEXT:    [[A:%.*]] = add nuw i8 [[X:%.*]], -56
; CHECK-NEXT:    [[B:%.*]] = tail call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 [[A]], i8 55)
; CHECK-NEXT:    ret { i8, i1 } [[B]]
;
  %a = add nuw i8 %x, 200
  %b = tail call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %a, i8 55)
  ret { i8, i1 } %b
}

define { i8, i1 } @no_fold_on_constant_add_overflow(i8 %x) {
; CHECK-LABEL: @no_fold_on_constant_add_overflow(
; CHECK-NEXT:    [[A:%.*]] = add nuw i8 [[X:%.*]], -56
; CHECK-NEXT:    [[B:%.*]] = tail call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 [[A]], i8 56)
; CHECK-NEXT:    ret { i8, i1 } [[B]]
;
  %a = add nuw i8 %x, 200
  %b = tail call { i8, i1 } @llvm.uadd.with.overflow.i8(i8 %a, i8 56)
  ret { i8, i1 } %b
}

define { <2 x i8>, <2 x i1> } @no_fold_vector_no_overflow(<2 x i8> %x) {
; CHECK-LABEL: @no_fold_vector_no_overflow(
; CHECK-NEXT:    [[A:%.*]] = add nuw <2 x i8> [[X:%.*]], <i8 -57, i8 -56>
; CHECK-NEXT:    [[B:%.*]] = tail call { <2 x i8>, <2 x i1> } @llvm.uadd.with.overflow.v2i8(<2 x i8> [[A]], <2 x i8> <i8 55, i8 55>)
; CHECK-NEXT:    ret { <2 x i8>, <2 x i1> } [[B]]
;
  %a = add nuw <2 x i8> %x, <i8 199, i8 200>
  %b = tail call { <2 x i8>, <2 x i1> } @llvm.uadd.with.overflow.v2i8(<2 x i8> %a, <2 x i8> <i8 55, i8 55>)
  ret { <2 x i8>, <2 x i1> } %b
}

define { <2 x i8>, <2 x i1> } @no_fold_vector_overflow(<2 x i8> %x) {
; CHECK-LABEL: @no_fold_vector_overflow(
; CHECK-NEXT:    [[A:%.*]] = add nuw <2 x i8> [[X:%.*]], <i8 -56, i8 -55>
; CHECK-NEXT:    [[B:%.*]] = tail call { <2 x i8>, <2 x i1> } @llvm.uadd.with.overflow.v2i8(<2 x i8> [[A]], <2 x i8> <i8 55, i8 55>)
; CHECK-NEXT:    ret { <2 x i8>, <2 x i1> } [[B]]
;
  %a = add nuw <2 x i8> %x, <i8 200, i8 201>
  %b = tail call { <2 x i8>, <2 x i1> } @llvm.uadd.with.overflow.v2i8(<2 x i8> %a, <2 x i8> <i8 55, i8 55>)
  ret { <2 x i8>, <2 x i1> } %b
}

define { <2 x i32>, <2 x i1> } @fold_simple_splat_constant(<2 x i32> %x) {
; CHECK-LABEL: @fold_simple_splat_constant(
; CHECK-NEXT:    [[A:%.*]] = add nuw <2 x i32> [[X:%.*]], <i32 12, i32 12>
; CHECK-NEXT:    [[B:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32> [[A]], <2 x i32> <i32 30, i32 30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[B]]
;
  %a = add nuw <2 x i32> %x, <i32 12, i32 12>
  %b = tail call { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32> %a, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %b
}

define { <2 x i32>, <2 x i1> } @no_fold_splat_undef_constant(<2 x i32> %x) {
; CHECK-LABEL: @no_fold_splat_undef_constant(
; CHECK-NEXT:    [[A:%.*]] = add nuw <2 x i32> [[X:%.*]], <i32 12, i32 undef>
; CHECK-NEXT:    [[B:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32> [[A]], <2 x i32> <i32 30, i32 30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[B]]
;
  %a = add nuw <2 x i32> %x, <i32 12, i32 undef>
  %b = tail call { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32> %a, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %b
}

define { <2 x i32>, <2 x i1> } @no_fold_splat_not_constant(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @no_fold_splat_not_constant(
; CHECK-NEXT:    [[A:%.*]] = add nuw <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[B:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32> [[A]], <2 x i32> <i32 30, i32 30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[B]]
;
  %a = add nuw <2 x i32> %x, %y
  %b = tail call { <2 x i32>, <2 x i1> } @llvm.uadd.with.overflow.v2i32(<2 x i32> %a, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %b
}

define { i32, i1 } @fold_nuwnsw(i32 %x) {
; CHECK-LABEL: @fold_nuwnsw(
; CHECK-NEXT:    [[A:%.*]] = add nuw nsw i32 [[X:%.*]], 12
; CHECK-NEXT:    [[B:%.*]] = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[A]], i32 30)
; CHECK-NEXT:    ret { i32, i1 } [[B]]
;
  %a = add nuw nsw i32 %x, 12
  %b = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %a, i32 30)
  ret { i32, i1 } %b
}

define { i32, i1 } @no_fold_nsw(i32 %x) {
; CHECK-LABEL: @no_fold_nsw(
; CHECK-NEXT:    [[A:%.*]] = add nsw i32 [[X:%.*]], 12
; CHECK-NEXT:    [[B:%.*]] = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[A]], i32 30)
; CHECK-NEXT:    ret { i32, i1 } [[B]]
;
  %a = add nsw i32 %x, 12
  %b = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %a, i32 30)
  ret { i32, i1 } %b
}

define { i32, i1 } @no_fold_wrapped_add(i32 %x) {
; CHECK-LABEL: @no_fold_wrapped_add(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], 12
; CHECK-NEXT:    [[B:%.*]] = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 [[A]], i32 30)
; CHECK-NEXT:    ret { i32, i1 } [[B]]
;
  %a = add i32 %x, 12
  %b = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 30, i32 %a)
  ret { i32, i1 } %b
}
