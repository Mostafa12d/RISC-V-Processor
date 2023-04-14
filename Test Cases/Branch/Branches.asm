.data

.text

.globl main

main:
	addi	x1, x0, 5	#x1 = 5
	addi	x2, x0, 5	#x2 = 5
	beq	x1, x2, L1	#5 = 5, branch taken
	add	x3, x1, x2	#skipped 
L1:
	addi	x4, x0, 9	#x4 = 9
	bne	x1, x4, L2	#5 != 9 branch taken
	sub	x3, x1, x2	#skipped
	
L2:
	blt	x1, x4, L3	# 5 < 9 branch taken
	add	x3, x1, x2	#skipped

L3:
	bge	x4, x1, L4	#9 > 5 branch taken
	add	x3, x1, x2	#skipped

L4:
	addi	x6, x0, -10	#x6 = -10
	bltu	x6, x1, L5	#not taken
	add	x7, x1, x4	#x7 = 14
	blt	x6, x1, L6	#-10 < 5 branch taken

L5:
	addi	x10, x1, 69	#skipped
L6:	
	addi	x11, x1, 69	#executed x11 = 10
	bge	x6, x1, L7	#not taken
	addi	x12, x1, 69	#skipped
	bgeu	x6, x1, L8
	
L7:
	addi	x13, x0, 69	#skipped
L8:
	addi	x15, x0, 69
	ecall
	
	#shouldn't be executed
	addi	x31, x0, 69
	addi	x30, x0, 60
	addi	x29, x0, 69