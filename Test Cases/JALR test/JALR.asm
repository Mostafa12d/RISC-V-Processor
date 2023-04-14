.data

.text

.globl main

main:
	addi	x1, x0, 9
	addi	x2, x0, 4
	jal	x31, L1
	addi	x20, x0, 69
	ebreak
L1:
	addi	x3, x0, 10
	addi	x4, x0, 15
	jalr	x0, x31, 0
	
	 #try putting ecall in the middle ofthe instructions to test halting 
