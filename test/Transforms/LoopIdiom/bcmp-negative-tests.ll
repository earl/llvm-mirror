; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-idiom < %s -S | FileCheck %s

; CHECK: source_filename
; CHECK-NOT; bcmp
; CHECK-NOT; memcmp

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

define i1 @three_blocks_and_two_latches_in_loop(i8* %ptr0, i8* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ], [ 0, %for.passthrough ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp eq i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.passthrough, label %cleanup

for.passthrough:
  br i1 true, label %for.cond, label %for.body

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @three_blocks_in_loop(i8* %ptr0, i8* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp eq i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.passthrough, label %cleanup

for.passthrough:
  br label %for.cond

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @body_cmp_is_not_equality(i8* %ptr0, i8* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp ult i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @only_one_load(i8* %ptr0, i8* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %cmp3 = icmp eq i8 %v0, 0
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @loads_of_less_than_byte(i7* %ptr0, i7* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i7, i7* %ptr0, i64 %i.08
  %v0 = load i7, i7* %arrayidx
  %arrayidx1 = getelementptr inbounds i7, i7* %ptr1, i64 %i.08
  %v1 = load i7, i7* %arrayidx1
  %cmp3 = icmp ult i7 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @loads_of_not_multiple_of_a_byte(i9* %ptr0, i9* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i9, i9* %ptr0, i64 %i.08
  %v0 = load i9, i9* %arrayidx
  %arrayidx1 = getelementptr inbounds i9, i9* %ptr1, i64 %i.08
  %v1 = load i9, i9* %arrayidx1
  %cmp3 = icmp ult i9 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @loop_instruction_used_in_phi_node_outside_loop(i8* %ptr0, i8* %ptr1) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp eq i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ %cmp3, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @loop_has_write(i8* %ptr0, i8* %ptr1, i32* %write) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp eq i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  store i32 0, i32* %write
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

declare void @sink()
define i1 @loop_has_call(i8* %ptr0, i8* %ptr1, i32* %load) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp eq i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  tail call void @sink()
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @loop_has_atomic_load(i8* %ptr0, i8* %ptr1, i32* %load) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.cond ]
  %arrayidx = getelementptr inbounds i8, i8* %ptr0, i64 %i.08
  %v0 = load i8, i8* %arrayidx
  %arrayidx1 = getelementptr inbounds i8, i8* %ptr1, i64 %i.08
  %v1 = load i8, i8* %arrayidx1
  %cmp3 = icmp eq i8 %v0, %v1
  %inc = add nuw nsw i64 %i.08, 1
  br i1 %cmp3, label %for.cond, label %cleanup

for.cond:
  %cmp = icmp ult i64 %inc, 8
  %tmp = load atomic i32, i32* %load unordered, align 1
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.cond ]
  ret i1 %res
}

define i1 @different_load_step(i8* %ptr) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.015 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.014 = phi i8* [ %add.ptr, %entry ], [ %add.ptr3, %for.inc ]
  %ptr0.013 = phi i8* [ %ptr, %entry ], [ %incdec.ptr, %for.inc ]
  %v0 = load i8, i8* %ptr0.013
  %v1 = load i8, i8* %ptr1.014
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.015, 1
  %incdec.ptr = getelementptr inbounds i8, i8* %ptr0.013, i64 1
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr1.014, i64 2
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @step_is_variable(i8* %ptr, i64 %step) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.015 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.014 = phi i8* [ %add.ptr, %entry ], [ %add.ptr3, %for.inc ]
  %ptr0.013 = phi i8* [ %ptr, %entry ], [ %incdec.ptr, %for.inc ]
  %v0 = load i8, i8* %ptr0.013
  %v1 = load i8, i8* %ptr1.014
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.015, %step
  %incdec.ptr = getelementptr inbounds i8, i8* %ptr0.013, i64 1
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr1.014, i64 1
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @load_step_is_variable(i8* %ptr, i64 %step) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.015 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.014 = phi i8* [ %add.ptr, %entry ], [ %add.ptr3, %for.inc ]
  %ptr0.013 = phi i8* [ %ptr, %entry ], [ %incdec.ptr, %for.inc ]
  %v0 = load i8, i8* %ptr0.013
  %v1 = load i8, i8* %ptr1.014
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.015, 1
  %incdec.ptr = getelementptr inbounds i8, i8* %ptr0.013, i64 %step
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr1.014, i64 %step
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @step_and_load_step_is_variable(i8* %ptr, i64 %step) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.015 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.014 = phi i8* [ %add.ptr, %entry ], [ %add.ptr3, %for.inc ]
  %ptr0.013 = phi i8* [ %ptr, %entry ], [ %incdec.ptr, %for.inc ]
  %v0 = load i8, i8* %ptr0.013
  %v1 = load i8, i8* %ptr1.014
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.015, %step
  %incdec.ptr = getelementptr inbounds i8, i8* %ptr0.013, i64 %step
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr1.014, i64 %step
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @load_step_not_affine(i8* %ptr) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.018 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.017 = phi i8* [ %add.ptr, %entry ], [ %add.ptr4, %for.inc ]
  %ptr0.016 = phi i8* [ %ptr, %entry ], [ %add.ptr3, %for.inc ]
  %v0 = load i8, i8* %ptr0.016
  %v1 = load i8, i8* %ptr1.017
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.018, 1
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr0.016, i64 %inc
  %add.ptr4 = getelementptr inbounds i8, i8* %ptr1.017, i64 %inc
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @no_overlap_between_loads(i8* %ptr) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.016 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.015 = phi i8* [ %add.ptr, %entry ], [ %add.ptr4, %for.inc ]
  %ptr0.014 = phi i8* [ %ptr, %entry ], [ %add.ptr3, %for.inc ]
  %v0 = load i8, i8* %ptr0.014
  %v1 = load i8, i8* %ptr1.015
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.016, 1
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr0.014, i64 2
  %add.ptr4 = getelementptr inbounds i8, i8* %ptr1.015, i64 2
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @volatile_loads(i8* %ptr) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.016 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.015 = phi i8* [ %add.ptr, %entry ], [ %add.ptr4, %for.inc ]
  %ptr0.014 = phi i8* [ %ptr, %entry ], [ %add.ptr3, %for.inc ]
  %v0 = load volatile i8, i8* %ptr0.014
  %v1 = load volatile i8, i8* %ptr1.015
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.016, 1
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr0.014, i64 1
  %add.ptr4 = getelementptr inbounds i8, i8* %ptr1.015, i64 1
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @atomic_loads(i8* %ptr) {
entry:
  %add.ptr = getelementptr inbounds i8, i8* %ptr, i64 8
  br label %for.body

for.body:
  %i.016 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.015 = phi i8* [ %add.ptr, %entry ], [ %add.ptr4, %for.inc ]
  %ptr0.014 = phi i8* [ %ptr, %entry ], [ %add.ptr3, %for.inc ]
  %v0 = load atomic i8, i8* %ptr0.014 unordered, align 1
  %v1 = load atomic i8, i8* %ptr1.015 unordered, align 1
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.016, 1
  %add.ptr3 = getelementptr inbounds i8, i8* %ptr0.014, i64 1
  %add.ptr4 = getelementptr inbounds i8, i8* %ptr1.015, i64 1
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}

define i1 @address_space(i8 addrspace(1)* %ptr) {
entry:
  %add.ptr = getelementptr inbounds i8, i8 addrspace(1)* %ptr, i64 8
  br label %for.body

for.body:
  %i.016 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %ptr1.015 = phi i8 addrspace(1)* [ %add.ptr, %entry ], [ %add.ptr4, %for.inc ]
  %ptr0.014 = phi i8 addrspace(1)* [ %ptr, %entry ], [ %add.ptr3, %for.inc ]
  %v0 = load i8, i8 addrspace(1)* %ptr0.014
  %v1 = load i8, i8 addrspace(1)* %ptr1.015
  %cmp2 = icmp eq i8 %v0, %v1
  br i1 %cmp2, label %for.inc, label %cleanup

for.inc:
  %inc = add nuw nsw i64 %i.016, 1
  %add.ptr3 = getelementptr inbounds i8, i8 addrspace(1)* %ptr0.014, i64 1
  %add.ptr4 = getelementptr inbounds i8, i8 addrspace(1)* %ptr1.015, i64 1
  %cmp = icmp ult i64 %inc, 16
  br i1 %cmp, label %for.body, label %cleanup

cleanup:
  %res = phi i1 [ false, %for.body ], [ true, %for.inc ]
  ret i1 %res
}
