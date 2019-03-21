#	.text		
#	.globl __start
 
#__start:
	la $t1, a
	la $t2, b
	
	syscall
	
	.data
str:	.asciiz	"\nHello\n"
a:	.word	1, 2, 3, 4
b:	.word   	1
