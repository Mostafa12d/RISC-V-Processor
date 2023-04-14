.data

.text

.globl main

main:
	addi	x1, x0, 9
	addi	x2, x0, 2
	addi	x31, x0, -10
	
	add	x3, x1, x2 #x3 = 11
	sub	x4, x1, x2 #x4 = 7
	and	x5, x1, x2 #x5 = 0
	or	x6, x1, x2 #x6 = 11
	xor	x7, x1, x2 #x7 = 11
	sll	x8, x1, x2 #x8 = 36
	srl	x9, x31, x2 #x9 = 1073741821
	sra	x10, x31, x2 #x10 = -3
	slt	x13, x31, x1 #x13 = 1
	sltu	x10, x31, x1 #x10 = 0
	
	#RAW dependency
	add	x11, x1, x2  #x11 = 11
	add	x11, x11, x2 #x11 = 13
	add	x12, x11, x3 #x12 = 13 + 11 = 24
	
	 #try putting ecall in the middle ofthe instructions to test halting 
