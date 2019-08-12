; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -cost-model -analyze | FileCheck %s --check-prefixes=CHECK,SSE,SSE2

define i32 @extract_first_i32({i32, i32} %agg) {
; CHECK-LABEL: 'extract_first_i32'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i32 } %agg, 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = extractvalue {i32, i32} %agg, 0
  ret i32 %r
}

define i32 @extract_second_i32({i32, i32} %agg) {
; CHECK-LABEL: 'extract_second_i32'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i32 } %agg, 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = extractvalue {i32, i32} %agg, 1
  ret i32 %r
}

define i32 @extract_i32({i32, i1} %agg) {
; CHECK-LABEL: 'extract_i32'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i1 } %agg, 0
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %r
;
  %r = extractvalue {i32, i1} %agg, 0
  ret i32 %r
}

define i1 @extract_i1({i32, i1} %agg) {
; CHECK-LABEL: 'extract_i1'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, i1 } %agg, 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i1 %r
;
  %r = extractvalue {i32, i1} %agg, 1
  ret i1 %r
}

define float @extract_float({i32, float} %agg) {
; CHECK-LABEL: 'extract_float'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, float } %agg, 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret float %r
;
  %r = extractvalue {i32, float} %agg, 1
  ret float %r
}

define [42 x i42] @extract_array({i32, [42 x i42]} %agg) {
; CHECK-LABEL: 'extract_array'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, [42 x i42] } %agg, 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret [42 x i42] %r
;
  %r = extractvalue {i32, [42 x i42]} %agg, 1
  ret [42 x i42] %r
}

define <42 x i42> @extract_vector({i32, <42 x i42>} %agg) {
; CHECK-LABEL: 'extract_vector'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, <42 x i42> } %agg, 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <42 x i42> %r
;
  %r = extractvalue {i32, <42 x i42>} %agg, 1
  ret <42 x i42> %r
}

%T1 = type { i32, float, <4 x i1> }

define %T1 @extract_struct({i32, %T1} %agg) {
; CHECK-LABEL: 'extract_struct'
; CHECK-NEXT:  Cost Model: Unknown cost for instruction: %r = extractvalue { i32, %T1 } %agg, 1
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret %T1 %r
;
  %r = extractvalue {i32, %T1} %agg, 1
  ret %T1 %r
}
