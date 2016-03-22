; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; Make sure LLVM knows about the convergent attribute on the
; llvm.cuda.syncthreads intrinsic.

declare void @llvm.cuda.syncthreads()

; CHECK: declare void @llvm.cuda.syncthreads() #[[ATTRNUM:[0-9]+]]
; CHECK: attributes #[[ATTRNUM]] = { convergent nounwind }
