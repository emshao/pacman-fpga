.text

###
##
#       ECE350 Fall 2023: Pacman
#       Emily Shao, Jenny Green
##
###
addi $r2, $zero, TOTAL_COINS

#INSTANTIATE EVERYTHING IN MEMORY AND SAVE THE POINTER TO THE FIRST ONE AND THE CURRENT ONE 
instantiate:
    #curr
    addi $r12, $zero, $zero
    #first
    addi $r13, $zero, $zero
    #ADD CODE
    add $r11, $zero, $zero
    #basically addi $r11, $zero, WHATEVER THE VAL IS (0 or 1)
    #and then sw $r11, 0($r12)
    #then add 1 to $r12
    #and then repeat
addi $r25, $zero, 12
loop:
    #do the stuff
    addi $r12, $r12, 1
    addi $r25, $r25, -1
    beq $r25, $zero, end_loop
    j loop

end_loop:



#AND THEN AT EACH STEP CHECK IF VALID
#AND THEN DEFINE INSTR TO MAKE CANNOT MOVE 1 IF NOT VALID AND 0 IF VALID
#UPDATE: ^THESE DONE


main_loop:
    setPacX, $r5, 0
    setPacY, $r6, 0
    addi $r7, $zero, 640
    mul $r8, $r6, $r7
    add $r8, $r5, $r8 # x + 640*y -> r8
    add $r9, $r8, $r13 # r8 + r13 -> r9 (address to search for in mem)
    lw $r10, 0($r9) # r10 = mem[r9]
    #beq $r10, $zero, cant_move # if not allowed to be there, execute the corresponding logic
    
cont_main:
    addcoin, $r1, $r1, 1
    addi, $r3, $r3, 1
    beq $r1, $r2, calc_high_score

    j main_loop

calc_high_score: 
    blt $r3, $r4, end
    add $r4, $r3, $zero
    j end

cant_move:
    canNotMove, $r20, $r20, 1
    j cont_main

end:
    jr $ra


#.data
#    TOTAL_COINS = 5
#    nums = [1,0,1,1,0]