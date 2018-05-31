; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -vector-library=SVML -loop-vectorize -force-vector-interleave=1  -S < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare float @sinf(float) #0
declare float @cosf(float) #0
declare float @expf(float) #0
declare float @llvm.exp.f32(float) #0
declare float @logf(float) #0
declare float @powf(float, float) #0
declare float @llvm.pow.f32(float, float) #0

define void @sin_f32(float* nocapture %varray) {
; CHECK-LABEL: @sin_f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND1]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = call <4 x float> @__svml_sinf4(<4 x float> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[VARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP7]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <4 x i32> [[VEC_IND1]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @sinf(float [[CONV]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[CALL]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !2
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = tail call float @sinf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

define void @cos_f32(float* nocapture %varray) {
; CHECK-LABEL: @cos_f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND1]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = call <4 x float> @__svml_cosf4(<4 x float> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[VARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP7]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <4 x i32> [[VEC_IND1]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !4
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @cosf(float [[CONV]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[CALL]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !5
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = tail call float @cosf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

define void @exp_f32(float* nocapture %varray) {
; CHECK-LABEL: @exp_f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND1]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = call <4 x float> @__svml_expf4(<4 x float> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[VARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP7]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <4 x i32> [[VEC_IND1]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !6
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @expf(float [[CONV]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[CALL]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !7
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = tail call float @expf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

define void @exp_f32_intrin(float* nocapture %varray) {
; CHECK-LABEL: @exp_f32_intrin(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND1]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = call <4 x float> @__svml_expf4(<4 x float> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[VARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP7]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <4 x i32> [[VEC_IND1]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !8
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @llvm.exp.f32(float [[CONV]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[CALL]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !9
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = tail call float @llvm.exp.f32(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

define void @log_f32(float* nocapture %varray) {
; CHECK-LABEL: @log_f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND1]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = call <4 x float> @__svml_logf4(<4 x float> [[TMP4]])
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[VARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP7]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <4 x i32> [[VEC_IND1]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !10
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @logf(float [[CONV]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[CALL]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !11
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %call = tail call float @logf(float %conv)
  %arrayidx = getelementptr inbounds float, float* %varray, i64 %iv
  store float %call, float* %arrayidx, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

define void @pow_f32(float* nocapture %varray, float* nocapture readonly %exp) {
; CHECK-LABEL: @pow_f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VARRAY1:%.*]] = bitcast float* [[VARRAY:%.*]] to i8*
; CHECK-NEXT:    [[EXP3:%.*]] = bitcast float* [[EXP:%.*]] to i8*
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr float, float* [[VARRAY]], i64 1000
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast float* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr float, float* [[EXP]], i64 1000
; CHECK-NEXT:    [[SCEVGEP45:%.*]] = bitcast float* [[SCEVGEP4]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[VARRAY1]], [[SCEVGEP45]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[EXP3]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[MEMCHECK_CONFLICT:%.*]] = and i1 [[FOUND_CONFLICT]], true
; CHECK-NEXT:    br i1 [[MEMCHECK_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND6:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT7:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND6]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float, float* [[EXP]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast float* [[TMP6]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP7]], align 4, !alias.scope !12
; CHECK-NEXT:    [[TMP8:%.*]] = call <4 x float> @__svml_powf4(<4 x float> [[TMP4]], <4 x float> [[WIDE_LOAD]])
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds float, float* [[TMP9]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast float* [[TMP10]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP8]], <4 x float>* [[TMP11]], align 4, !alias.scope !15, !noalias !12
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT7]] = add <4 x i32> [[VEC_IND6]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !17
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[EXP]], i64 [[IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = tail call float @powf(float [[CONV]], float [[TMP1]])
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !18
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %arrayidx = getelementptr inbounds float, float* %exp, i64 %iv
  %tmp1 = load float, float* %arrayidx, align 4
  %tmp2 = tail call float @powf(float %conv, float %tmp1)
  %arrayidx2 = getelementptr inbounds float, float* %varray, i64 %iv
  store float %tmp2, float* %arrayidx2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

define void @pow_f32_intrin(float* nocapture %varray, float* nocapture readonly %exp) {
; CHECK-LABEL: @pow_f32_intrin(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VARRAY1:%.*]] = bitcast float* [[VARRAY:%.*]] to i8*
; CHECK-NEXT:    [[EXP3:%.*]] = bitcast float* [[EXP:%.*]] to i8*
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr float, float* [[VARRAY]], i64 1000
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast float* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr float, float* [[EXP]], i64 1000
; CHECK-NEXT:    [[SCEVGEP45:%.*]] = bitcast float* [[SCEVGEP4]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[VARRAY1]], [[SCEVGEP45]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[EXP3]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[MEMCHECK_CONFLICT:%.*]] = and i1 [[FOUND_CONFLICT]], true
; CHECK-NEXT:    br i1 [[MEMCHECK_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND6:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT7:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[VEC_IND6]] to <4 x float>
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float, float* [[EXP]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast float* [[TMP6]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP7]], align 4, !alias.scope !19
; CHECK-NEXT:    [[TMP8:%.*]] = call <4 x float> @__svml_powf4(<4 x float> [[TMP4]], <4 x float> [[WIDE_LOAD]])
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds float, float* [[TMP9]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast float* [[TMP10]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP8]], <4 x float>* [[TMP11]], align 4, !alias.scope !22, !noalias !19
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[VEC_IND_NEXT7]] = add <4 x i32> [[VEC_IND6]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP12:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !24
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[EXP]], i64 [[IV]]
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = tail call float @llvm.pow.f32(float [[CONV]], float [[TMP1]])
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[VARRAY]], i64 [[IV]]
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !25
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %tmp = trunc i64 %iv to i32
  %conv = sitofp i32 %tmp to float
  %arrayidx = getelementptr inbounds float, float* %exp, i64 %iv
  %tmp1 = load float, float* %arrayidx, align 4
  %tmp2 = tail call float @llvm.pow.f32(float %conv, float %tmp1)
  %arrayidx2 = getelementptr inbounds float, float* %varray, i64 %iv
  store float %tmp2, float* %arrayidx2, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, 1000
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}

attributes #0 = { nounwind readnone }
