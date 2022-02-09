# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
    array: .word 1 2 3 4 5 6 7 8 9 10
    cout: .asciiz "The contents of the array in reverse order are:\n"

.text
j main

printA:
    sll $a1, $a1, 2
    move $t0, $a0
    addu $t1, $t0, $a1

    loop:
        addiu $t1, $t1, -4
        li $v0, 1
        lw $a0, ($t1)
        syscall

        li $v0, 11
        li $a0, '\n'
        syscall

        bne $t0, $t1, loop
    
    jr $ra

main:
    li $v0, 4
    la $a0, cout
    syscall

    la $a0, array
    li $a1, 10

    jal printA

exit:
    li $v0, 10
    syscall
