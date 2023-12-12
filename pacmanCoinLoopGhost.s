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

addi $r1, $r0, 3    # TOTAL COINS
addi $r2, $r0, 0    # Number of Coin Tracker



# Coin 1 -------------- (130, 200)
addi $r3, $r0, 130
addi $r4, $r0, 0
sw $r3, 0($r4)

addi $r3, $r0, 200
sw $r3, 1($r4)
# ------------------------------


# Coin 2 -------------- (340, 220)
addi $r3, $r0, 340
sw $r3, 2($r4)

addi $r3, $r0, 220
sw $r3, 3($r4)
# ------------------------------


# Coin 3 -------------- (380, 290)
addi $r3, $r0, 280
sw $r3, 4($r4)

addi $r3, $r0, 220
sw $r3, 5($r4)
# ------------------------------

# --------------------------------------------- stored three coins into memory, can add more



main_loop:
setPacX $r5, $r0, 1     # $r5 = pacman X value
setPacY $r6, $r0, 1     # $r6 = pacman Y value
addi $r7, $r5, 22       # $r7 = pacman X + 22
addi $r8, $r6, 22       # $r8 = pacman Y + 22
addi $r9, $r4, 0        # $r9 = incremental memory location
addi $r10, $r0, 0       # $r10 = counter

setGhostX $r13, $r0, 1  # $r13 = ghost X value
setGhostY $r14, $r0, 1  # $r14 = ghost Y value
addi $r15, $r13, 22     # $r15 = ghost X + 22
addi $r16, $r14, 22     # $r16 = ghost Y + 22




#start of coin for loop
check_coin_loop:
beq $r10, $r1, end_coin_check # leave loop
lw $r11, 0($r9)         # $r11 = x value from memory
lw $r12, 1($r9)         # $r12 = y value from memory

#check logic
x_lt_cx:
blt $r5, $r11, cx_lt_x22
j no_touch

cx_lt_x22:
blt $r11, $r7, y_lt_cy
j no_touch

y_lt_cy:
blt $r6, $r12, cy_lt_y22
j no_touch

cy_lt_y22:
blt $r12, $r8, touching_coin
j no_touch

#passed all four check
touching_coin:
addi $r2, $r2, 1
sw $r0, 0($r9)
sw $r0, 1($r9)
beq $r1, $r2, got_all_coins     # if all coins are touched
touch $r20, $r10, $r21           # return the index of coin touched
j end_coin_check

# update and loop
no_touch:
addi $r9, $r9, 2
addi $r10, $r10, 1
j check_coin_loop

end_coin_check:     # starting ghost check
j check_ghost_loop




# start of ghost logic
check_ghost_loop:
blt $r5, $r15, ghost_2
j no_ghost

ghost_2:
blt $r13, $r7, ghost_3
j no_ghost

ghost_3:
blt $r6, $r16, ghost_4
j no_ghost

ghost_4:
blt $r14, $r8, touching_ghost
j no_ghost

touching_ghost:
hasLost $r20, $r20, 1       # send a losing flag
j end

no_ghost:
j main_loop





got_all_coins:
canNotMove $r20, $r20, 1    # send a winning flag
j end

end:

