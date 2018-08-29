# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=22 -dispatch-stats -register-file-stats -resource-pressure=false -timeline -timeline-max-iterations=3 < %s | FileCheck %s

idiv %eax

# CHECK:      Iterations:        22
# CHECK-NEXT: Instructions:      22
# CHECK-NEXT: Total Cycles:      553
# CHECK-NEXT: Total uOps:        44

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.08
# CHECK-NEXT: IPC:               0.04
# CHECK-NEXT: Block RThroughput: 25.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      25    25.00                 U     idivl	%eax

# CHECK:      Dynamic Dispatch Stall Cycles:
# CHECK-NEXT: RAT     - Register unavailable:                      6
# CHECK-NEXT: RCU     - Retire tokens unavailable:                 0
# CHECK-NEXT: SCHEDQ  - Scheduler full:                            0
# CHECK-NEXT: LQ      - Load queue full:                           0
# CHECK-NEXT: SQ      - Store queue full:                          0
# CHECK-NEXT: GROUP   - Static restrictions on the dispatch group: 0

# CHECK:      Dispatch Logic - number of cycles where we saw N instructions dispatched:
# CHECK-NEXT: [# dispatched], [# cycles]
# CHECK-NEXT:  0,              531  (96.0%)
# CHECK-NEXT:  1,              22  (4.0%)

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    66
# CHECK-NEXT: Max number of mappings used:         63

# CHECK:      *  Register File #1 -- JFpuPRF:
# CHECK-NEXT:    Number of physical registers:     72
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- JIntegerPRF:
# CHECK-NEXT:    Number of physical registers:     64
# CHECK-NEXT:    Total number of mappings created: 66
# CHECK-NEXT:    Max number of mappings used:      63

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789          0123456789          01234567
# CHECK-NEXT: Index     0123456789          0123456789          0123456789          0123456789

# CHECK:      [0,0]     DeeeeeeeeeeeeeeeeeeeeeeeeeER  .    .    .    .    .    .    .    .    .    . .   idivl	%eax
# CHECK-NEXT: [1,0]     .D========================eeeeeeeeeeeeeeeeeeeeeeeeeER  .    .    .    .    . .   idivl	%eax
# CHECK-NEXT: [2,0]     . D================================================eeeeeeeeeeeeeeeeeeeeeeeeeER   idivl	%eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     25.0   0.3    0.0       idivl	%eax
