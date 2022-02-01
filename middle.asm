# middle.asm program
#

.data
    prompt:  .asciiz "Enter the next number:\n"
    answer:  .asciiz "Second Largest: "
    newline: .asciiz "\n"

#Text Area (i.e. instructions)
.text

main:
    # get numbers
    jal getNum
    move $s0, $v0
    jal getNum
    move $s1, $v0
    jal getNum
    move $s2, $v0

    move $a0, $s0
    move $a1, $s1
    jal sort2
    move $s3, $v0
    move $a0, $v1
    move $a1, $s2
    jal sort2
    move $a0, $s3
    move $a1, $v0
    jal sort2
    move $s4, $v1

    # print result
    li $v0, 4
    la $a0, answer
    syscall
    move $a0, $s4
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall
   
    j exit

getNum:
    # print "Enter the next number:\n"
    li $v0, 4
    la $a0, prompt
    syscall

    # get integer
    li $v0, 5
    syscall

    jr $ra

sort2:
    slt $t0, $a0, $a1
    beqz $t0, reta1a0

        # $a0 < $a1
        move $v0, $a0
        move $v1, $a1
        jr $ra

    reta1a0:
        # $a0 >= $a1
        move $v0, $a1
        move $v1, $a0
        jr $ra

exit:
    li  $v0, 10
    syscall
