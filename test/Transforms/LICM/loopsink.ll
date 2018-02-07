; RUN: opt -S -loop-sink < %s | FileCheck %s
; RUN: opt -S -aa-pipeline=basic-aa -passes=loop-sink < %s | FileCheck %s

@g = global i32 0, align 4

;     b1
;    /  \
;   b2  b6
;  /  \  |
; b3  b4 |
;  \  /  |
;   b5   |
;    \  /
;     b7
; preheader: 1000
; b2: 15
; b3: 7
; b4: 7
; Sink load to b2
; CHECK: t1
; CHECK: .b2:
; CHECK: load i32, i32* @g
; CHECK: .b3:
; CHECK-NOT:  load i32, i32* @g
define i32 @t1(i32, i32) #0 !prof !0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load i32, i32* @g
  br label %.b1

.b1:
  %iv = phi i32 [ %t7, %.b7 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b6, !prof !1

.b2:
  %c2 = icmp sgt i32 %iv, 1
  br i1 %c2, label %.b3, label %.b4

.b3:
  %t3 = sub nsw i32 %invariant, %iv
  br label %.b5

.b4:
  %t4 = add nsw i32 %invariant, %iv
  br label %.b5

.b5:
  %p5 = phi i32 [ %t3, %.b3 ], [ %t4, %.b4 ]
  %t5 = mul nsw i32 %p5, 5
  br label %.b7

.b6:
  %t6 = add nsw i32 %iv, 100
  br label %.b7

.b7:
  %p7 = phi i32 [ %t6, %.b6 ], [ %t5, %.b5 ]
  %t7 = add nuw nsw i32 %iv, 1
  %c7 = icmp eq i32 %t7, %p7
  br i1 %c7, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

;     b1
;    /  \
;   b2  b6
;  /  \  |
; b3  b4 |
;  \  /  |
;   b5   |
;    \  /
;     b7
; preheader: 500
; b1: 16016
; b3: 8
; b6: 8
; Sink load to b3 and b6
; CHECK: t2
; CHECK: .preheader:
; CHECK-NOT: load i32, i32* @g
; CHECK: .b3:
; CHECK: load i32, i32* @g
; CHECK: .b4:
; CHECK: .b6:
; CHECK: load i32, i32* @g
; CHECK: .b7:
define i32 @t2(i32, i32) #0 !prof !0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load i32, i32* @g
  br label %.b1

.b1:
  %iv = phi i32 [ %t7, %.b7 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b6, !prof !2

.b2:
  %c2 = icmp sgt i32 %iv, 1
  br i1 %c2, label %.b3, label %.b4, !prof !1

.b3:
  %t3 = sub nsw i32 %invariant, %iv
  br label %.b5

.b4:
  %t4 = add nsw i32 5, %iv
  br label %.b5

.b5:
  %p5 = phi i32 [ %t3, %.b3 ], [ %t4, %.b4 ]
  %t5 = mul nsw i32 %p5, 5
  br label %.b7

.b6:
  %t6 = add nsw i32 %iv, %invariant
  br label %.b7

.b7:
  %p7 = phi i32 [ %t6, %.b6 ], [ %t5, %.b5 ]
  %t7 = add nuw nsw i32 %iv, 1
  %c7 = icmp eq i32 %t7, %p7
  br i1 %c7, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

;     b1
;    /  \
;   b2  b6
;  /  \  |
; b3  b4 |
;  \  /  |
;   b5   |
;    \  /
;     b7
; preheader: 500
; b3: 8
; b5: 16008
; Do not sink load from preheader.
; CHECK: t3
; CHECK: .preheader:
; CHECK: load i32, i32* @g
; CHECK: .b1:
; CHECK-NOT: load i32, i32* @g
define i32 @t3(i32, i32) #0 !prof !0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load i32, i32* @g
  br label %.b1

.b1:
  %iv = phi i32 [ %t7, %.b7 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b6, !prof !2

.b2:
  %c2 = icmp sgt i32 %iv, 1
  br i1 %c2, label %.b3, label %.b4, !prof !1

.b3:
  %t3 = sub nsw i32 %invariant, %iv
  br label %.b5

.b4:
  %t4 = add nsw i32 5, %iv
  br label %.b5

.b5:
  %p5 = phi i32 [ %t3, %.b3 ], [ %t4, %.b4 ]
  %t5 = mul nsw i32 %p5, %invariant
  br label %.b7

.b6:
  %t6 = add nsw i32 %iv, 5
  br label %.b7

.b7:
  %p7 = phi i32 [ %t6, %.b6 ], [ %t5, %.b5 ]
  %t7 = add nuw nsw i32 %iv, 1
  %c7 = icmp eq i32 %t7, %p7
  br i1 %c7, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

; For single-BB loop with <=1 avg trip count, sink load to b1
; CHECK: t4
; CHECK: .preheader:
; CHECK-not: load i32, i32* @g
; CHECK: .b1:
; CHECK: load i32, i32* @g
; CHECK: .exit:
define i32 @t4(i32, i32) #0 !prof !0 {
.preheader:
  %invariant = load i32, i32* @g
  br label %.b1

.b1:
  %iv = phi i32 [ %t1, %.b1 ], [ 0, %.preheader ]
  %t1 = add nsw i32 %invariant, %iv
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b1, label %.exit, !prof !1

.exit:
  ret i32 10
}

;     b1
;    /  \
;   b2  b6
;  /  \  |
; b3  b4 |
;  \  /  |
;   b5   |
;    \  /
;     b7
; preheader: 1000
; b2: 15
; b3: 7
; b4: 7
; There is alias store in loop, do not sink load
; CHECK: t5
; CHECK: .preheader:
; CHECK: load i32, i32* @g
; CHECK: .b1:
; CHECK-NOT: load i32, i32* @g
define i32 @t5(i32, i32*) #0 !prof !0 {
  %3 = icmp eq i32 %0, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load i32, i32* @g
  br label %.b1

.b1:
  %iv = phi i32 [ %t7, %.b7 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b6, !prof !1

.b2:
  %c2 = icmp sgt i32 %iv, 1
  br i1 %c2, label %.b3, label %.b4

.b3:
  %t3 = sub nsw i32 %invariant, %iv
  br label %.b5

.b4:
  %t4 = add nsw i32 %invariant, %iv
  br label %.b5

.b5:
  %p5 = phi i32 [ %t3, %.b3 ], [ %t4, %.b4 ]
  %t5 = mul nsw i32 %p5, 5
  br label %.b7

.b6:
  %t6 = call i32 @foo()
  br label %.b7

.b7:
  %p7 = phi i32 [ %t6, %.b6 ], [ %t5, %.b5 ]
  %t7 = add nuw nsw i32 %iv, 1
  %c7 = icmp eq i32 %t7, %p7
  br i1 %c7, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

;     b1
;    /  \
;   b2  b6
;  /  \  |
; b3  b4 |
;  \  /  |
;   b5   |
;    \  /
;     b7
; preheader: 1000
; b2: 15
; b3: 7
; b4: 7
; Regardless of aliasing store in loop this load from constant memory can be sunk.
; CHECK: t5_const_memory
; CHECK: .preheader:
; CHECK-NOT: load i32, i32* @g_const
; CHECK: .b2:
; CHECK: load i32, i32* @g_const
; CHECK: br i1 %c2, label %.b3, label %.b4
define i32 @t5_const_memory(i32, i32*) #0 !prof !0 {
  %3 = icmp eq i32 %0, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load i32, i32* @g_const
  br label %.b1

.b1:
  %iv = phi i32 [ %t7, %.b7 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b6, !prof !1

.b2:
  %c2 = icmp sgt i32 %iv, 1
  br i1 %c2, label %.b3, label %.b4

.b3:
  %t3 = sub nsw i32 %invariant, %iv
  br label %.b5

.b4:
  %t4 = add nsw i32 %invariant, %iv
  br label %.b5

.b5:
  %p5 = phi i32 [ %t3, %.b3 ], [ %t4, %.b4 ]
  %t5 = mul nsw i32 %p5, 5
  br label %.b7

.b6:
  %t6 = call i32 @foo()
  br label %.b7

.b7:
  %p7 = phi i32 [ %t6, %.b6 ], [ %t5, %.b5 ]
  %t7 = add nuw nsw i32 %iv, 1
  %c7 = icmp eq i32 %t7, %p7
  br i1 %c7, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

;     b1
;    /  \
;   b2  b3
;    \  /
;     b4
; preheader: 1000
; b2: 15
; b3: 7
; Do not sink unordered atomic load to b2
; CHECK: t6
; CHECK: .preheader:
; CHECK:  load atomic i32, i32* @g unordered, align 4
; CHECK: .b2:
; CHECK-NOT: load atomic i32, i32* @g unordered, align 4
define i32 @t6(i32, i32) #0 !prof !0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load atomic i32, i32* @g unordered, align 4
  br label %.b1

.b1:
  %iv = phi i32 [ %t3, %.b4 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b3, !prof !1

.b2:
  %t1 = add nsw i32 %invariant, %iv
  br label %.b4

.b3:
  %t2 = add nsw i32 %iv, 100
  br label %.b4

.b4:
  %p1 = phi i32 [ %t2, %.b3 ], [ %t1, %.b2 ]
  %t3 = add nuw nsw i32 %iv, 1
  %c2 = icmp eq i32 %t3, %p1
  br i1 %c2, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

@g_const = constant i32 0, align 4

;     b1
;    /  \
;   b2  b3
;    \  /
;     b4
; preheader: 1000
; b2: 0.5
; b3: 999.5
; Sink unordered atomic load to b2. It is allowed to sink into loop unordered
; load from constant.
; CHECK: t7
; CHECK: .preheader:
; CHECK-NOT:  load atomic i32, i32* @g_const unordered, align 4
; CHECK: .b2:
; CHECK: load atomic i32, i32* @g_const unordered, align 4
define i32 @t7(i32, i32) #0 !prof !0 {
  %3 = icmp eq i32 %1, 0
  br i1 %3, label %.exit, label %.preheader

.preheader:
  %invariant = load atomic i32, i32* @g_const unordered, align 4
  br label %.b1

.b1:
  %iv = phi i32 [ %t3, %.b4 ], [ 0, %.preheader ]
  %c1 = icmp sgt i32 %iv, %0
  br i1 %c1, label %.b2, label %.b3, !prof !1

.b2:
  %t1 = add nsw i32 %invariant, %iv
  br label %.b4

.b3:
  %t2 = add nsw i32 %iv, 100
  br label %.b4

.b4:
  %p1 = phi i32 [ %t2, %.b3 ], [ %t1, %.b2 ]
  %t3 = add nuw nsw i32 %iv, 1
  %c2 = icmp eq i32 %t3, %p1
  br i1 %c2, label %.b1, label %.exit, !prof !3

.exit:
  ret i32 10
}

%a = type { i8 }

; CHECK-LABEL: @t8
; CHECK: ret void
define void @t8() !prof !0 {
bb:
  br label %bb1

bb1:                                              ; preds = %bb
  %tmp = getelementptr inbounds %a, %a* undef, i64 0, i32 0
  br label %bb2

bb2:                                              ; preds = %bb16, %bb1
  br i1 undef, label %bb16, label %bb3

bb3:                                              ; preds = %bb2
  br i1 undef, label %bb16, label %bb4

bb4:                                              ; preds = %bb3
  br i1 undef, label %bb5, label %bb16

bb5:                                              ; preds = %bb4
  br i1 undef, label %bb16, label %bb6

bb6:                                              ; preds = %bb5
  br i1 undef, label %bb16, label %bb7

bb7:                                              ; preds = %bb15, %bb6
  br i1 undef, label %bb8, label %bb16

bb8:                                              ; preds = %bb7
  br i1 undef, label %bb9, label %bb15

bb9:                                              ; preds = %bb8
  br i1 undef, label %bb10, label %bb15

bb10:                                             ; preds = %bb9
  br i1 undef, label %bb11, label %bb15

bb11:                                             ; preds = %bb10
  br i1 undef, label %bb12, label %bb15

bb12:                                             ; preds = %bb11
  %tmp13 = load i8, i8* %tmp, align 8
  br i1 undef, label %bb15, label %bb14

bb14:                                             ; preds = %bb12
  call void @bar(i8* %tmp)
  br label %bb16

bb15:                                             ; preds = %bb12, %bb11, %bb10, %bb9, %bb8
  br i1 undef, label %bb16, label %bb7

bb16:                                             ; preds = %bb15, %bb14, %bb7, %bb6, %bb5, %bb4, %bb3, %bb2
  br i1 undef, label %bb17, label %bb2

bb17:                                             ; preds = %bb16
  ret void
}

declare i32 @foo()
declare void @bar(i8*)

!0 = !{!"function_entry_count", i64 1}
!1 = !{!"branch_weights", i32 1, i32 2000}
!2 = !{!"branch_weights", i32 2000, i32 1}
!3 = !{!"branch_weights", i32 100, i32 1}
