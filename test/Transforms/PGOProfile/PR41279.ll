; Test that instrumentaiton works fine for the case of failing the split critical edges.
; RUN: opt < %s -pgo-instr-gen -S | FileCheck %s --check-prefix=GEN
; RUN: opt < %s -passes=pgo-instr-gen -S | FileCheck %s --check-prefix=GEN

declare void @f3({ i8*, i64 }*, { i8*, i64 }*, i64)
declare { i8*, i64 } @f0({ i8*, i64 }*)
declare i64 @f1()
declare void @invok2({ i8*, i64 }*, i8* noalias readonly align 1, i64)
declare void @invok1({ i8*, i64 }*, { i8*, i64 }*, i64)
declare i32 @__CxxFrameHandler3(...)

define internal void @foo({ i8*, i64 }*, { i8*, i64 }*) personality i32 (...)* @__CxxFrameHandler3 {
  %3 = alloca i8, align 1
  store i8 0, i8* %3, align 1
  %4 = call i64 @f1()
  %5 = icmp ult i64 %4, 32
  br i1 %5, label %7, label %13

6:
  cleanupret from %17 unwind to caller
; GEN: 6:
; GEN:  call void @llvm.instrprof.increment(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__profn__stdin__foo, i32 0, i32 0), i64 60927483247, i32 4, i32 2)

7:
  store i8 1, i8* %3, align 1
  %8 = call { i8*, i64 } @f0({ i8*, i64 }* %0)
  %9 = extractvalue { i8*, i64 } %8, 0
  %10 = extractvalue { i8*, i64 } %8, 1
  invoke void @invok1({ i8*, i64 }* %1, { i8*, i64 }* %0, i64 1)
          to label %11 unwind label %16
; GEN: 7:
; GEN-NOT: call void @llvm.instrprof.increment

11:
  store i8 0, i8* %3, align 1
  invoke void @invok2({ i8*, i64 }* %1, i8* noalias readonly align 1 %9, i64 %10)
          to label %12 unwind label %16
; GEN: 11:
; GEN-NOT: call void @llvm.instrprof.increment

12:
  store i8 0, i8* %3, align 1
  br label %14
; GEN: 12:
; GEN:  call void @llvm.instrprof.increment(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__profn__stdin__foo, i32 0, i32 0), i64 60927483247, i32 4, i32 1)

13:
  call void @f3({ i8*, i64 }* %0, { i8*, i64 }* %1, i64 1)
  br label %14
; GEN: 13:
; GEN:  call void @llvm.instrprof.increment(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__profn__stdin__foo, i32 0, i32 0), i64 60927483247, i32 4, i32 0)

14:
  ret void

15:
  store i8 0, i8* %3, align 1
  br label %6
; GEN: 15:
; GEN:  call void @llvm.instrprof.increment(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__profn__stdin__foo, i32 0, i32 0), i64 60927483247, i32 4, i32 3)

16:
  %17 = cleanuppad within none []
  %18 = load i8, i8* %3, align 1
  %19 = trunc i8 %18 to i1
  br i1 %19, label %15, label %6
}
