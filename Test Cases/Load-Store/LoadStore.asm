addi x1, x0, 4
addi x2, x0, 0x0f0
lui  x3, 0xff0ff
sw x3, 4(x0)
sh x2, 8(x0)
sb x1, 12(x0) 

lw x5, 4(x0)
lh x6, 8(x0) 
lb x7, 12(x0)

addi x8, x0, -5
sw x8, 16(x0) 
lhu x9, 16(x0) 




