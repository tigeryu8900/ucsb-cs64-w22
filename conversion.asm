# conversion.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.text
j main

conv:
    li $v0, 0
    li $t0, 0
    loop:
        sll $t1, $a0, 3
        sub $v0, $v0, $t1
        add $v0, $v0, $a1
        slti $t1, $a0, 2
        bnez $t1, end_if
            addi $a1, $a1, -1
        end_if:
        addi $a0, $a0, 1
        addi $t0, $t0, 1
        slti $t1, $t0, 8
        bnez $t1, loop
    jr $ra

main:
    li $a0, 5
    li $a1, 7

    jal conv

    move $a0, $v0
    li $v0, 1
    syscall

exit:
    li $v0, 10
    syscall
