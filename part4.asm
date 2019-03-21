##
## part4.asm - prints out the result of given formula
##     [(a-7b)*3 +2] %4
##	t0 - a
##	t1 - b

#################################
#				#
#		text segment	#
#				#
#################################

	.text		
	.globl __start	

__start:
	#read first input
	la $a0, getInput1 	
	li $v0,4		
	syscall

	li $v0, 5		
	syscall
	
	sw $v0,a #a
	lw $t0, a		#store a in $t0
	
	#read second input
	la $a0, getInput2
	li $v0,4		
	syscall

	li $v0, 5
	syscall
	
	sw $v0,c #b
	lw $t1, c		#store b in $t1
	
	mul $t1, $t1,7		#b*7
	
	sub $t2, $t0, $t1	#t2 = a - 7b
	
	mul $t2, $t2, 3		#t2 = 3*t2 = 3*(a - 7b)
	
	addi $t2, $t2, 2	#t2 = 2+t2=3*(a - 7b)+2
	
	blt $t2, 0, negativeDiv		#if [(a-7b)*3 +2] is negative go negativeDiv
	li $a2, 4
divide: 
	blt $t2, $a2, remainder #if a1 < a2 go remainder - (a-7b) * 3 + 2 > 4
	addi $t2,$t2, -4	#do division with subtraction
	b divide

negativeDiv:			#if [(a-7b)*3 +2] is negative 
	bgt $t2, 0, remainder
	addi $t2, $t2, 4
	b negativeDiv
	
remainder:
	li $v0, 1
	move $a0, $t2	#print remainder
	syscall
	
	li $v0, 10
	syscall
	
	.data
getInput1:	.asciiz "Enter first input: \n"
getInput2:	.asciiz "Enter second input: \n"
a: .word 10
c: .word 1
