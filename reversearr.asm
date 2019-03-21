##
## reversearr.asm - defines and array and prints its reverse
##
##	t1 array
##	t4 arraySize
##

#################################
#				#
#		text segment	#
#				#
#################################
  	.text
	.globl __start	

__start:

	la $t1, array #define array
	lw $t4, arraySize
	la $a0, message
	li $v0, 4
	syscall

	li $v0,5 #get number of the elements
	syscall
	
	#store user desired no of elements
	move $t4,$v0
	move $t5,$t1 #array
	move $t6,$t4 #size
loop:
	la $a0, elMsg
	li $v0,4		# syscall 4 prints the string
	syscall

	li $v0, 5		# syscall 5 reads an integer
	syscall
		
	sb $v0,0($t5)		#point first element of array
	addi $t5,$t5,4		#next element
	addi $t6,$t6,-1		#size -1
	bgt $t6,$zero,loop

	
	la $a0,displayMsg	#"Array contents: "
	li $v0,4
	syscall
	
	move $t5,$t1
	move $t6,$t4
	
display: #display array elements

	lb $t7,0($t5)
	move $a0, $t7
	li $v0,1
	syscall
	
	addi $t5,$t5,4
	addi $t6,$t6,-1
	bgt $t6, $zero,display
	
	la $a0,reverseMsg #Reverse version: "
	li $v0,4
	syscall
	

	
	add $t5,$zero,$t1
	add $t6,$zero,$t4
	subi $t6, $t6,1
	mul $t6,$t6,4
	add $t6,$t1,$t6
	
reverse:
	lw $t2,0($t5)
	lw $t3,0($t6)
	
	sw $t2,0($t6)
	sw $t3,0($t5)
	
	addi $t6, $t6,-4
	addi $t5,$t5,4
	
	bgt $t6,$t5,reverse

	move $t5,$t1
	move $t6,$t4
		
displayReverse:

	lb $t7,0($t5)
	move $a0, $t7
	li $v0,1
	syscall
	
	addi $t5,$t5,4
	addi $t6,$t6,-1
	bgt $t6, $zero,displayReverse
	

	li $v0,10
	syscall
	
#################################
#				#
#     	 data segment		#
#				#
#################################	
	.data
message: .asciiz "Enter the array size: "
elMsg: .asciiz "Enter array element: "
displayMsg: .asciiz "Array contents: "
reverseMsg: .asciiz "Reverse version: "
array: .space 80
arraySize: .word 20 
l: .word 0
m: .word 4

##
## end of file reversearr.asm
	
