# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3 -iterations=1 -scheduler-stats -resource-pressure=false -instruction-info=false < %s | FileCheck %s -check-prefixes=ALL,M3
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m1 -iterations=1 -scheduler-stats -resource-pressure=false -instruction-info=false < %s | FileCheck %s -check-prefixes=ALL,M1

  b   t

# ALL:      Iterations:        1
# ALL-NEXT: Instructions:      1
# ALL-NEXT: Total Cycles:      2

# M1-NEXT:  Dispatch Width:    4
# M3-NEXT:  Dispatch Width:    6

# ALL-NEXT: IPC:               0.50

# M1-NEXT:  Block RThroughput: 0.3
# M3-NEXT:  Block RThroughput: 0.2

# ALL:      Schedulers - number of cycles where we saw N instructions issued:
# ALL-NEXT: [# issued], [# cycles]
# ALL-NEXT:  0,          1  (50.0%)
# ALL-NEXT:  1,          1  (50.0%)

# ALL:      Scheduler's queue usage:
# ALL-NEXT: No scheduler resources used.
