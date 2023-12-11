.text
###
##
#       ECE350 Fall 2023: Pacman
#       Emily Shao, Jenny Green
##
###


nop
nop
nop
nop
nop
nop

addi $r2, $r0, 1    # TOTAL COINS
addi $r1, $r0, 0    # Coin Tracker



# Coin 1 -------------- (80, 56)
addi $r14, $r0, 280
addi $r15, $r0, 0
sw $r14, 0($r15)

addi $r14, $r0, 220
sw $r14, 1($r15)
# ------------------------------


# #INSTANTIATE EVERYTHING IN MEMORY AND SAVE THE POINTER TO THE FIRST ONE AND THE CURRENT ONE 
# instantiate:
# #curr
# addi $r12, $r0, 0
# #first
# addi $r13, $r0, 0
# #ADD CODE
# add $r11, $r0, $r0
# #basically addi $r11, $zero, WHATEVER THE VAL IS (0 or 1)
# #and then sw $r11, 0($r12)
# #then add 1 to $r12
# #and then repeat
# addi $r25, $r0, 12
# loop:
# #do the stuff
# addi $r12, $r12, 1
# addi $r25, $r25, -1
# beq $r25, $r0, end_loop
# j loop
# end_loop:



main_loop:
setPacX $r5, $r0, 0     # $r5 = pacman X value
setPacY $r6, $r0, 0     # $r6 = pacman Y value


cont_main:
lw $r9, 0($r15)         # $r9 = current x value = 80 
lw $r10, 1($r15)       # $r10 = current y value = 56

addi $r12, $r5, 22
addi $r13, $r6, 22

blt $r5, $r9, x_lt_cx
j no_touch

x_lt_cx:

blt $r9, $r12, cx_lt_x22
j no_touch

cx_lt_x22:
blt $r6, $r10, y_lt_cy
j no_touch

y_lt_cy:
blt $r10, $r13, cy_lt_y22
j no_touch

cy_lt_y22:
addi $r1, $r1, 1
#ADD COMMAND touching_coin
beq $r1, $r2, calc_high_score

no_touch:
addi $r3, $r3, 1
j main_loop

calc_high_score: 
canNotMove $r20, $r20, 1
# blt $r3, $r4, end
add $r4, $r3, $r0
j end

cant_move:
canNotMove $r20, $r20, 1
j cont_main

end:

