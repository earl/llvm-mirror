; RUN: llvm-as %s -o /dev/null
; RUN: verify-uselistorder %s -preserve-bc-use-list-order -num-shuffles=5

define void @test(i32 %X) {
        call void @test( i32 6 )
        ret void
}
