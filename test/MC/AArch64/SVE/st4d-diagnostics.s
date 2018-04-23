// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve  2>&1 < %s| FileCheck %s


// --------------------------------------------------------------------------//
// Immediate out of lower bound [-32, 28].

st4d {z12.d, z13.d, z14.d, z15.d}, p4, [x12, #-36, MUL VL]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: index must be a multiple of 4 in range [-32, 28].
// CHECK-NEXT: st4d {z12.d, z13.d, z14.d, z15.d}, p4, [x12, #-36, MUL VL]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

st4d {z7.d, z8.d, z9.d, z10.d}, p3, [x1, #32, MUL VL]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: index must be a multiple of 4 in range [-32, 28].
// CHECK-NEXT: st4d {z7.d, z8.d, z9.d, z10.d}, p3, [x1, #32, MUL VL]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// --------------------------------------------------------------------------//
// Immediate not a multiple of four.

st4d {z12.d, z13.d, z14.d, z15.d}, p4, [x12, #-7, MUL VL]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: index must be a multiple of 4 in range [-32, 28].
// CHECK-NEXT: st4d {z12.d, z13.d, z14.d, z15.d}, p4, [x12, #-7, MUL VL]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

st4d {z7.d, z8.d, z9.d, z10.d}, p3, [x1, #5, MUL VL]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: index must be a multiple of 4 in range [-32, 28].
// CHECK-NEXT: st4d {z7.d, z8.d, z9.d, z10.d}, p3, [x1, #5, MUL VL]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// --------------------------------------------------------------------------//
// error: restricted predicate has range [0, 7].

st4d {z2.d, z3.d, z4.d, z5.d}, p8, [x15, #10, MUL VL]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: restricted predicate has range [0, 7].
// CHECK-NEXT: st4d {z2.d, z3.d, z4.d, z5.d}, p8, [x15, #10, MUL VL]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// --------------------------------------------------------------------------//
// Invalid vector list.

st4d { }, p0, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: vector register expected
// CHECK-NEXT: st4d { }, p0, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

st4d { z0.d, z1.d, z2.d, z3.d, z4.d }, p0, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid number of vectors
// CHECK-NEXT: st4d { z0.d, z1.d, z2.d, z3.d, z4.d }, p0, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

st4d { z0.d, z1.d, z2.d, z3.b }, p0, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: mismatched register size suffix
// CHECK-NEXT: st4d { z0.d, z1.d, z2.d, z3.b }, p0, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

st4d { z0.d, z1.d, z3.d, z5.d }, p0, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: registers must be sequential
// CHECK-NEXT: st4d { z0.d, z1.d, z3.d, z5.d }, p0, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

st4d { v0.2d, v1.2d, v2.2d }, p0, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid operand
// CHECK-NEXT: st4d { v0.2d, v1.2d, v2.2d }, p0, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
