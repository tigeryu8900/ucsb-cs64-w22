# Data Area
.data
    buffer: .space 100
    input_prompt:   .asciiz "Enter string:\n"
    output_prompt:   .asciiz "Output:\n"
    convention: .asciiz "Convention Check\n"
    newline:    .asciiz "\n"

.text

main:
    la $a0, input_prompt    # prompt user for string input
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0   # save string to s0

    ori $s1, $0, 0
    ori $s2, $0, 0
    ori $s3, $0, 0
    ori $s4, $0, 0
    ori $s5, $0, 0
    ori $s6, $0, 0
    ori $s7, $0, 0

    move $a0, $s0
    jal Swap_Case

    add $s1, $s1, $s2
    add $s1, $s1, $s3
    add $s1, $s1, $s4
    add $s1, $s1, $s5
    add $s1, $s1, $s6
    add $s1, $s1, $s7
    add $s0, $s0, $s1

    la $a0, output_prompt    # give Output prompt
    li $v0, 4
    syscall

    move $a0, $s0
    jal DispString

    j Exit

DispString:
    addi $a0, $a0, 0
    li $v0, 4
    syscall
    jr $ra

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

# COPYFROMHERE - DO NOT REMOVE THIS LINE

Swap_Case:
    addiu $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0

    loop:
        lb $t0, ($s0)
        beqz $t0, end_loop

        check_lower:
            sltiu $t2, $t0, 'a'
            bnez $t2, check_upper
            sltiu $t2, $t0, 123 # 'z' + 1
            beqz $t2, default

            # $t0 is lowercase
            addiu $t1, $t0, -32
            j both

        check_upper:
            sltiu $t2, $t0, 'A'
            bnez $t2, default
            sltiu $t2, $t0, 91 # 'Z' + 1
            beqz $t2, default

            # $t0 is uppercase
            addiu $t1, $t0, 32
            j both

        both:
            move $a0, $t0
            li $v0, 11
            syscall
            li $a0, '\n'
            syscall
            move $a0, $t1
            syscall
            li $a0, '\n'
            syscall

            sb $t1, ($s0)

            jal ConventionCheck
        default:

        addiu $s0, $s0, 1
        j loop
    end_loop:

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addiu $sp, $sp, 12

    # Do not remove this line
    jr $ra