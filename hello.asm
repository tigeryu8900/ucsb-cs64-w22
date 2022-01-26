# hello.asm
# A "Hello World" program in MIPS Assembly for CS64
#
#  Data Area - allocate and initialize variables
.data
	msg: .asciiz "Enter an integer: "

#Text Area (i.e. instructions)
.text
main:
	# print "Enter an integer: "
	li $v0, 4
	la $a0, msg
	syscall
	
	# get integer
	li $v0, 5
	syscall
	
	# save integer to $t0
	move $t0, $v0
	
	#check parity of integer
	andi $v0, $v0, 1
	beqz $v0, else
	
	# integer is odd
	li $t1, 9
	j then

else:
	# integer is even
	li $t1, 6

then:
	# set $a0 = $t0 * $t1
	mult $t0, $t1
	mflo $a0
	
	# print $a0
	li $v0, 1
	syscall

exit:
	li  $v0, 10
	syscall
