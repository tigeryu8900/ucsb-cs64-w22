# Pow.asm program
#

# C++ (NON-RECURSIVE) code snippet of pow(x,n):
#    int x, n, pow=1;
#   cout << "Enter a number x:\n";
#   cin >> x;
#   cout << "Enter the exponent n:\n";
#   cin >> n;
#   for (int i = 1; i <= n; i++) {
#       pow = pow * x;
#   }
#   cout << "Power(x,n) is:\n" << pow << "\n";
#
# Assembly (NON-RECURSIVE) code version of pow(x,n):
#
.data
    number:   .asciiz "Enter a number x:\n"
    exponent: .asciiz "Enter the exponent n:\n"
    answer:   .asciiz "Power(x,n) is:\n"
    newline:  .asciiz "\n"

#Text Area (i.e. instructions)
.text
main:
    # print "Enter a number x:\n"
    li $v0, 4
    la $a0, number
    syscall

    # get integer
    li $v0, 5
    syscall
    move $s0, $v0

    # print "Enter the exponent n:\n"
    li $v0, 4
    la $a0, exponent
    syscall

    # get integer
    li $v0, 5
    syscall
    move $s1, $v0

    li $s2, 1

    loop:
        beqz $s1, then
        mult $s0, $s2
        mflo $s2
        addi $s1, $s1, -1
        j loop
    then:

    # print result
    li $v0, 4
    la $a0, answer
    syscall
    move $a0, $s2
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    j exit

exit:
    li  $v0, 10
    syscall
