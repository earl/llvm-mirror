// RUN:  llvm-mc -triple x86_64-apple-darwin -filetype=obj %s -o - | llvm-readobj -t | FileCheck %s

	// CHECK: Symbol {
	// CHECK: Name: _offsetsym0
	// CHECK: Flags [ (0x0)
	// CHECK: Value: 0x0

	// CHECK: Symbol {
	// CHECK: Name: _offsetsym1
	// CHECK: Flags [ (0x200)
	// CHECK: Value: 0x4

	// CHECK: Symbol {
	// CHECK: Name: _offsetsym2
	// CHECK: Flags [ (0x200)
	// CHECK: Value: 0x8

	// CHECK: Symbol {
	// CHECK: Name: _offsetsym3
	// CHECK: Flags [ (0x200)
	// CHECK: Value: 0x18

	// CHECK: Symbol {
	// CHECK: Symbol {
	// CHECK: Symbol {

	.section	__TEXT,__text,regular,pure_instructions
	.comm	_g0,4,2
	.section	__DATA,__data
	.globl	_s0
	.align	3
_s0:
	.long	31
	.long	32
	.quad	_g0

	.globl	_s1
	.align	3
_s1:
	.long	33
	.long	34
	.quad	_g0

	.globl	_offsetsym0
	_offsetsym0 = _s0
	.globl	_offsetsym1
	.alt_entry	_offsetsym1
	_offsetsym1 = _s0+4
	.globl	_offsetsym2
	.alt_entry	_offsetsym2
	_offsetsym2 = _s0+8
	.globl	_offsetsym3
	.alt_entry	_offsetsym3
	_offsetsym3 = _s1+8
	.subsections_via_symbols
