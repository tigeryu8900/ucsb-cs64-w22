# hello.asm
# A "Hello World" program in MIPS Assembly for CS64
#
#  Data Area - allocate and initialize variables
.data
	msg: .asciiz "Hello World"

#Text Area (i.e. instructions)
.text
main:
	li $v0, 4
	la $a0, msg
	syscall

exit:
	li $v0, 10
	syscall
