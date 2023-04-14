.data

.text

.globl main

main:
	#data dependency RAW
L1:
	add	x1, x0, x0
	addi	x1, x1, 9
	addi	x1, x1, 20	
	addi	x1, x1, -4	#x1 = 25
	
	addi	x2, x0, 15	#x2 = 15
	
	xori	x3, x1, 17	#x3 = 25 ^ 17 = 8
	ori	x4, x1, 20	#x4 = 25 | 20 = 29
	andi	x5, x1, 19	#x5 = 25 & 19 = 17
	
	slti	x6, x1, 100	#x6 = 1
	addi	x31, x0, -5	#x31 = -5
	slti	x7, x31, 100	#x7 = 1
	sltiu	x8, x31, 100	#x8 dosen't change
	
	slli	x9, x1, 2	#x9 = 25 * 4 = 100
	srli	x10, x1, 2	#x10 = 25/4 = 6
	srai	x11, x1, 2	#x11 = 
	
	jal	x30, L3

L2:
	addi	x20, x0, 50
	addi	x19, x0, 50
	addi	x18, x0, 50
L3:	
	blt	x31, x1, L1
	ebreak
	
