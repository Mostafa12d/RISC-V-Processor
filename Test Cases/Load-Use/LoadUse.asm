.data

.text

.globl main

main:
	lw 	x1, 0(x0)
	addi 	x1, x1, 10

	lw 	x1, 4(x0)
	add 	x4, x1, x1

	lw 	x1, 8(x0)
	add 	x1, x1, x1

	addi 	x2, x0, 10
	addi 	x2, x2, 15
	addi 	x2, x2, 20

	sw 	x2, 4(x0)
	lw 	x3, 4(x0)