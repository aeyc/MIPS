##
## Program1.asm - prints out "hello world"
##
##	t0 - c
##	t1 - d
##	t2 -  the value that printing
##

#################################
#				#
#		text segment    #
#				#
#################################
	.text		
	.globl __start	

__start:
	lw $t0, c #x= (c - d) % 2
	lw $t1, d
	sub $t2, $t0, $t1 #t3= c-d 
	li $a1,2
next:
	blt $t2,$a1, remainder
	addi $t2, $t2,-2
	b next

remainder: 
	li $v0,1
	move $a0,$t2
	syscall
	#stop execution
	
	li $v0,10
	syscall
#################################
#				#
#     	 data segment		#
#				#
#################################
	.data
c:	.word 20
d:	.word 10
x:	.word 0

##
## end of file Program1.asm
