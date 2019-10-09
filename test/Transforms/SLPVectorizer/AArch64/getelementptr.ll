; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer -slp-threshold=-18 -dce -instcombine -pass-remarks-output=%t < %s | FileCheck %s
; RUN: cat %t | FileCheck -check-prefix=YAML %s
; RUN: opt -S -passes='slp-vectorizer,dce,instcombine' -slp-threshold=-18 -pass-remarks-output=%t < %s | FileCheck %s
; RUN: cat %t | FileCheck -check-prefix=YAML %s


target datalayout = "e-m:e-i32:64-i128:128-n32:64-S128"
target triple = "aarch64--linux-gnu"

; These tests check that we remove from consideration pairs of seed
; getelementptrs when they are known to have a constant difference. Such pairs
; are likely not good candidates for vectorization since one can be computed
; from the other. We use an unprofitable threshold to force vectorization.
;
; int getelementptr(int *g, int n, int w, int x, int y, int z) {
;   int sum = 0;
;   for (int i = 0; i < n ; ++i) {
;     sum += g[2*i + w]; sum += g[2*i + x];
;     sum += g[2*i + y]; sum += g[2*i + z];
;   }
;   return sum;
; }
;

; YAML-LABEL: Function:        getelementptr_4x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '11'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '5'

; YAML:      --- !Passed
; YAML-NEXT: Pass:            slp-vectorizer
; YAML-NEXT: Name:            VectorizedList
; YAML-NEXT: Function:        getelementptr_4x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '6'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '3'

define i32 @getelementptr_4x32(i32* nocapture readonly %g, i32 %n, i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @getelementptr_4x32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP31:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP31]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i32> <i32 0, i32 undef>, i32 [[X:%.*]], i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> undef, i32 [[Y:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i32> [[TMP1]], i32 [[Z:%.*]], i32 1
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x i32> [[TMP22:%.*]], i32 1
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[TMP3]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <2 x i32> [ zeroinitializer, [[FOR_BODY_PREHEADER]] ], [ [[TMP22]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i32> [[TMP4]], i32 0
; CHECK-NEXT:    [[T4:%.*]] = shl nsw i32 [[TMP5]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i32> undef, i32 [[T4]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <2 x i32> [[TMP6]], <2 x i32> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = add nsw <2 x i32> [[TMP7]], [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = sext i32 [[TMP9]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[G:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[T6:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x i32> [[TMP4]], i32 1
; CHECK-NEXT:    [[ADD1:%.*]] = add nsw i32 [[T6]], [[TMP11]]
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x i32> [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP13:%.*]] = sext i32 [[TMP12]] to i64
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP13]]
; CHECK-NEXT:    [[T8:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[ADD6:%.*]] = add nsw i32 [[ADD1]], [[T8]]
; CHECK-NEXT:    [[TMP14:%.*]] = add nsw <2 x i32> [[TMP7]], [[TMP2]]
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x i32> [[TMP14]], i32 0
; CHECK-NEXT:    [[TMP16:%.*]] = sext i32 [[TMP15]] to i64
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP16]]
; CHECK-NEXT:    [[T10:%.*]] = load i32, i32* [[ARRAYIDX10]], align 4
; CHECK-NEXT:    [[ADD11:%.*]] = add nsw i32 [[ADD6]], [[T10]]
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <2 x i32> [[TMP14]], i32 1
; CHECK-NEXT:    [[TMP18:%.*]] = sext i32 [[TMP17]] to i64
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP18]]
; CHECK-NEXT:    [[T12:%.*]] = load i32, i32* [[ARRAYIDX15]], align 4
; CHECK-NEXT:    [[TMP19:%.*]] = insertelement <2 x i32> undef, i32 [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP20:%.*]] = insertelement <2 x i32> [[TMP19]], i32 [[ADD11]], i32 1
; CHECK-NEXT:    [[TMP21:%.*]] = insertelement <2 x i32> <i32 1, i32 undef>, i32 [[T12]], i32 1
; CHECK-NEXT:    [[TMP22]] = add nsw <2 x i32> [[TMP20]], [[TMP21]]
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <2 x i32> [[TMP22]], i32 0
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[TMP23]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  %cmp31 = icmp sgt i32 %n, 0
  br i1 %cmp31, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add16, %for.cond.cleanup.loopexit ]
  ret i32 %sum.0.lcssa

for.body:
  %indvars.iv = phi i32 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %sum.032 = phi i32 [ 0, %for.body.preheader ], [ %add16, %for.body ]
  %t4 = shl nsw i32 %indvars.iv, 1
  %t5 = add nsw i32 %t4, 0
  %arrayidx = getelementptr inbounds i32, i32* %g, i32 %t5
  %t6 = load i32, i32* %arrayidx, align 4
  %add1 = add nsw i32 %t6, %sum.032
  %t7 = add nsw i32 %t4, %x
  %arrayidx5 = getelementptr inbounds i32, i32* %g, i32 %t7
  %t8 = load i32, i32* %arrayidx5, align 4
  %add6 = add nsw i32 %add1, %t8
  %t9 = add nsw i32 %t4, %y
  %arrayidx10 = getelementptr inbounds i32, i32* %g, i32 %t9
  %t10 = load i32, i32* %arrayidx10, align 4
  %add11 = add nsw i32 %add6, %t10
  %t11 = add nsw i32 %t4, %z
  %arrayidx15 = getelementptr inbounds i32, i32* %g, i32 %t11
  %t12 = load i32, i32* %arrayidx15, align 4
  %add16 = add nsw i32 %add11, %t12
  %indvars.iv.next = add nuw nsw i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next , %n
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

; YAML-LABEL: Function:        getelementptr_2x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '11'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '5'

; YAML:      --- !Passed
; YAML-NEXT: Pass:            slp-vectorizer
; YAML-NEXT: Name:            VectorizedList
; YAML-NEXT: Function:        getelementptr_2x32
; YAML-NEXT: Args:
; YAML-NEXT:   - String:          'SLP vectorized with cost '
; YAML-NEXT:   - Cost:            '6'
; YAML-NEXT:   - String:          ' and with tree size '
; YAML-NEXT:   - TreeSize:        '3'

define i32 @getelementptr_2x32(i32* nocapture readonly %g, i32 %n, i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @getelementptr_2x32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP31:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP31]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i32> undef, i32 [[Y:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> [[TMP0]], i32 [[Z:%.*]], i32 1
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x i32> [[TMP18:%.*]], i32 1
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[TMP2]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    ret i32 [[SUM_0_LCSSA]]
; CHECK:       for.body:
; CHECK-NEXT:    [[TMP3:%.*]] = phi <2 x i32> [ zeroinitializer, [[FOR_BODY_PREHEADER]] ], [ [[TMP18]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i32> [[TMP3]], i32 0
; CHECK-NEXT:    [[T4:%.*]] = shl nsw i32 [[TMP4]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = sext i32 [[T4]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[G:%.*]], i64 [[TMP5]]
; CHECK-NEXT:    [[T6:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x i32> [[TMP3]], i32 1
; CHECK-NEXT:    [[ADD1:%.*]] = add nsw i32 [[T6]], [[TMP6]]
; CHECK-NEXT:    [[T7:%.*]] = or i32 [[T4]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = sext i32 [[T7]] to i64
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP7]]
; CHECK-NEXT:    [[T8:%.*]] = load i32, i32* [[ARRAYIDX5]], align 4
; CHECK-NEXT:    [[ADD6:%.*]] = add nsw i32 [[ADD1]], [[T8]]
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <2 x i32> undef, i32 [[T4]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <2 x i32> [[TMP8]], <2 x i32> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = add nsw <2 x i32> [[TMP9]], [[TMP1]]
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x i32> [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = sext i32 [[TMP11]] to i64
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP12]]
; CHECK-NEXT:    [[T10:%.*]] = load i32, i32* [[ARRAYIDX10]], align 4
; CHECK-NEXT:    [[ADD11:%.*]] = add nsw i32 [[ADD6]], [[T10]]
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x i32> [[TMP10]], i32 1
; CHECK-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; CHECK-NEXT:    [[ARRAYIDX15:%.*]] = getelementptr inbounds i32, i32* [[G]], i64 [[TMP14]]
; CHECK-NEXT:    [[T12:%.*]] = load i32, i32* [[ARRAYIDX15]], align 4
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <2 x i32> undef, i32 [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP16:%.*]] = insertelement <2 x i32> [[TMP15]], i32 [[ADD11]], i32 1
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <2 x i32> <i32 1, i32 undef>, i32 [[T12]], i32 1
; CHECK-NEXT:    [[TMP18]] = add nsw <2 x i32> [[TMP16]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x i32> [[TMP18]], i32 0
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[TMP19]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  %cmp31 = icmp sgt i32 %n, 0
  br i1 %cmp31, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add16, %for.cond.cleanup.loopexit ]
  ret i32 %sum.0.lcssa

for.body:
  %indvars.iv = phi i32 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %sum.032 = phi i32 [ 0, %for.body.preheader ], [ %add16, %for.body ]
  %t4 = shl nsw i32 %indvars.iv, 1
  %t5 = add nsw i32 %t4, 0
  %arrayidx = getelementptr inbounds i32, i32* %g, i32 %t5
  %t6 = load i32, i32* %arrayidx, align 4
  %add1 = add nsw i32 %t6, %sum.032
  %t7 = add nsw i32 %t4, 1
  %arrayidx5 = getelementptr inbounds i32, i32* %g, i32 %t7
  %t8 = load i32, i32* %arrayidx5, align 4
  %add6 = add nsw i32 %add1, %t8
  %t9 = add nsw i32 %t4, %y
  %arrayidx10 = getelementptr inbounds i32, i32* %g, i32 %t9
  %t10 = load i32, i32* %arrayidx10, align 4
  %add11 = add nsw i32 %add6, %t10
  %t11 = add nsw i32 %t4, %z
  %arrayidx15 = getelementptr inbounds i32, i32* %g, i32 %t11
  %t12 = load i32, i32* %arrayidx15, align 4
  %add16 = add nsw i32 %add11, %t12
  %indvars.iv.next = add nuw nsw i32 %indvars.iv, 1
  %exitcond = icmp eq i32 %indvars.iv.next , %n
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}
