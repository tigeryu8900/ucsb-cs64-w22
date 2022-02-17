.data 
    array: 
            .word 1, 2, 9
            .word 1, 6, 2
            .word 1, 3, 2
            .word 1, 12, 2

    row_size: .word 4
    column_size: .word 3 

    convention: .asciiz "Convention Check\n"
    newline:    .asciiz "\n"
    space: .asciiz " "

.text

main: 
    jal print_2D

    la $a1, row_size
    lw $a1, 0($a1) 	# a1 stores row_size
    la $a2, column_size
    lw $a2, 0($a2) 	# a2 stores column_size 
    la $a0, array 	# a0 stores array address
    jal sort_by_row

    jal print_2D
    j Exit

ConventionCheck:
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra

Exit:
    ori     $v0, $0, 10
    syscall

print_2D: 
    li $t0, 0 	# row counter
    li $t1, 0 	# column counter 

    la $t2, row_size
    lw $t2, 0($t2) 	# t2 stores row_size
    la $t3, column_size
    lw $t3, 0($t3) 	# t3 stores column_size 

    la $t4, array 	# t4 stores array address

    iterate_row:
        #   reset column counter
        li $t1, 0 

        iterate_col:
            #   offset  =  ((colSize * curRow) + curCol) * 4
            mult $t3, $t0  
            mflo $t5
            add $t5, $t5, $t1
            sll $t5, $t5, 2
            add $t5, $t4, $t5 # add offset with array 

            #   start printing word at position
            li $v0, 1
            lw $a0, 0($t5)
            syscall 

            li $v0, 4
            la $a0, space
            syscall 

            #   increment column counter
            addi $t1, $t1, 1
            blt $t1, $t3, iterate_col

        #   increment row counter
        addi $t0, $t0, 1

        # add new line 
        li $v0, 4
        la $a0, newline
        syscall

        blt $t0, $t2, iterate_row

    jr $ra

average_row:
    # a0 stores row address return average of row in $v0

    move $t0, $a0

    la $t1, column_size
    lw $t1, 0($t1)

    li $t2, 0 	# $t2 is loop counter 
    li $t3, 0 	# total sum 
    sum_row_loop: 
        #   offset = loop counter * 4
        sll $t4, $t2, 2
        add $t4, $t4, $t0 
        lw $t4, 0($t4)

        add $t3, $t3, $t4

        #   increment loop counter 
        add $t2, $t2, 1 
        blt $t2, $t1, sum_row_loop

    div $t3, $t1
    mflo $v0 

    jr $ra 

swap_rows: #takes in the address of the rows you want to swap and swaps them.
    addi $sp, $sp, -20
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)

    move $s0, $a0 # address of row1
    move $s1, $a1 # address of row2

    la $s2, column_size
    lw $s2, 0($s2)

    li $s3, 0 # counter 

    swap_iterate: 
        sll $t0, $s3, 2 
        add $t1, $t0, $s0 
        add $t2, $t0, $s1

        # swap elements in array 
        lw $t3, 0($t1)
        lw $t4, 0($t2)
        sw $t3, 0($t2)
        sw $t4, 0($t1)

        # increment loop counter
        addi $s3, $s3, 1
        blt $s3, $s2, swap_iterate 

    jal ConventionCheck

    lw $s0, 0($sp) 
    lw $s1, 4($sp) 
    lw $s2, 8($sp) 
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addiu $sp, $sp, 20

    jr $ra

# COPYFROMHERE - DO NOT REMOVE THIS LINE
sort_by_row: 
    # a0 stores the array address, a1 and a2 store the size of row and column respectively

    addiu $sp, $sp, -36
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)

    beqz $a2, end_while

    move $s0, $a0
    sll $s2, $a2, 2
    multu $s2, $a2
    mflo $s1
    addu $s1, $s0, $s1

    while:
        li $s3, 0
        move $s4, $s0
        addu $s5, $s0, $s2
        for:
            beq $s1, $s5, end_for

            move $a0, $s4
            jal average_row
            move $s6, $v0
            move $a0, $s5
            jal average_row
            move $s7, $v0
            
            slt $t0, $s7, $s6
            beqz $t0, dont_swap
            do_swap:
                move $a0, $s4
                move $a1, $s5
                jal swap_rows
                li $s3, 1
            dont_swap:

            move $s4, $s5
            addu $s5, $s2, $s5
            j for
        end_for:
        bnez $s3, while
    end_while:

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    lw $s5, 24($sp)
    lw $s6, 28($sp)
    lw $s7, 32($sp)
    addiu $sp, $sp, 36

    # Do not remove this line
    jr $ra
