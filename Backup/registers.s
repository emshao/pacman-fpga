.text

addi $r2, $r0, 310
addi $r3, $r0, 230

# ----------------------- coin 1
addi $r5, $r0, 80
addi $r6, $r0, 0
sw $r5, 0($r6)

addi $r5, $r0, 56
sw $r5, 10($r6)
setPacX $r5, $r0, 1
# -----------------------
hello:
    addi $r5, $r0, 1

