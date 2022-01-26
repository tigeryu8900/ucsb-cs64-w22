# arithmetic.asm
# A simple calculator program in MIPS Assembly for CS64
#

.text
main:
	# set $a0 as x
	li $v0, 5
	syscall
	move $a0, $v0
	
	# subtract y from $a0
	li $v0, 5
	syscall
	sub $a0, $a0, $v0
	
	# shift $a0 left by 6 (multiply by 64)
	sll $a0, $a0, 6
	
	# or $a0 by 32 (same as add since the 5th bit of $a0 is 0)
	ori $a0, $a0, 32
	
	li $v0, 1
	syscall

exit:
	li $v0, 10
	syscall
