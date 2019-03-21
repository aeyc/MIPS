##
##	that asks the user the size of an integer array 
##and initializes the array entries with random numbers 
##between 0 and 100. Returns the beginning address of the array in $a0,
## and array size in terms of number of integers in $a1. 
##For random number generation see the related syscall, stackoverflow etc.


#################################
#				#
#	text segment		#
#				#
#################################

	.text		
	.globl __start
 __start:
 	jal readArray
 	
 	 	
 	li $v0, 10
	syscall
readArray:
	move $s0, $ra
 	la $a0, sizeMsg		
	li $v0, 4		
	syscall

	li $v0,5 
	syscall
	
	move $t1, $v0 #size
	move $t2, $t1
	
	mul $a2, $t1, 4
	move $a0, $a2
 	li $v0, 9 #syscall 9 (sbrk: allocate heap memory)	
	syscall 
	
	move $t3,$v0
	move $t4,$v0
 	j menu
 	
 	move $ra, $s0

	
menu:
	la $a0, menuMsg		#print out the menu
	li $v0, 4
	syscall
	
	li $v0,5 
	syscall
	
	blt $v0, 1, errorMessage
	beq $v0, 1, randomNumbers
	beq $v0, 2, bubbleSort
	beq $v0, 3, minMax
	beq $v0, 4, noOfUniqueElements
	bgt $v0, 4, errorMessage
	bgt $v0, 0x40, errorMessage
	
errorMessage:
	la $a0, error	#if given value is not proper print an error message
	li $v0,4
	syscall
	
	j menu	

randomNumbers:
  	li $a0, 4
 	li $a1, 101
 	li $v0,42
 	syscall
 	
 	#addi $a0, $a0, 0

	sw $a0,0($t3)		
	addi $t3, $t3, 4		
 	addi $t1, $t1, -1
 	bgt $t1, $zero, randomNumbers
 	
 	move $t3,$t4
 	move $t1, $t2
 	
 	j printArray

printArray:
 	
 	lw $t5,0($t3)
 	
	move $a0, $t5
	li $v0,1
	syscall
	
	la $a0,endl		# print newline
	li $v0,4
	syscall
	
	addi $t3, $t3, 4		
 	addi $t1, $t1, -1
	bgt $t1, $zero,printArray
	
	move $t3,$t4		#array
 	move $t1, $t2		#size
 	move $a0, $t3		#array
 	move $a1, $t1
 	
 	j menu

###############################################################################################	
bubbleSort:
 	move $t3,$t4		#array
 	move $t1, $t2		#size
 	move $a0, $t3		#array
 	move $a1, $t1
	
	mul $t5, $a1, 4
	add $t3, $t3, $t5	#adding size *4 bits to $t3
flag:
	addi $t6,$zero, 0
	move $a0, $t4
bubble1:	
	lw $a2, 0($a0)
	lw $a3, 4($a0)
	
	bgt $a2,$a3,change
	j nextSort
	
	#addi $t6, $t6,1
	#blt $t6, $t7, bubble2
	
	#addi $t5, $t5,1
	#j bubble1
change:
	addi $t6,$zero, 1
	sw $a2, 4($a0)
	sw $a3, 0($a0)
nextSort:
	addi $a0, $a0, 4
	bne $a0, $t3, bubble1
	bne $t6, $0, flag
 printSorted:
 	lw $t7,0($t4)
 	
	move $a0, $t7
	li $v0,1
	syscall
	
	la $a0,endl		# print newline
	li $v0,4
	syscall
	
	addi $t4, $t4, 4		
 	addi $t1, $t1, -1
	bgt $t1, $zero,printSorted
	
	move $t3,$t4		#array
 	move $t1, $t2		#size
 	move $a0, $t3		#array
 	move $a1, $t1
 	
 	j menu
 
###############################################################################################
minMax:
	move $t3,$t4		#array
 	move $t1, $t2		#size
 	move $a0, $t3		#array
 	move $a1, $t1

	lw $a2,0($a0)		#MIN
	li $a3,0		#MAX
	j loop
loop:
	lw $t5, 0($a0)
	bgt $t5, $a3, max
	blt $t5, $a2,min
	j next
min:
	move $a2, $t5
	j next
max:
	move $a3, $t5
	j next
next:
	addi $a0,$a0, 4
	addi $a1, $a1,-1
	bgt $a1,$zero, loop
	j printMinMax
	
printMinMax:
	move $a0, $a2
	li $v0, 1
	syscall
	
	la $a0,endl		# print newline
	li $v0,4
	syscall
	
	move $a0, $a3
	li $v0, 1
	syscall
	
	move $t3,$t4		#array
 	move $t1, $t2		#size
 	move $a0, $t3		#array
 	move $a1, $t1
 	j menu

noOfUniqueElements:
	move $t3,$t4		#array
 	move $t1, $t2		#size
 	move $a0, $t3		#array
 	move $a1, $t1
 	
 	mul $t5, $a1, 4
	move $a0, $t5
 	li $v0, 9 #syscall 9 (sbrk: allocate heap memory)	
	syscall 
detect:
	lw $a2, 0($t3)
	lw $a3, 0($t7)
	
	bne $a2, $a3, addElm
	j uNext
addElm:
	sw $a2, 0($t7)
	addi $t3, $t3, 4
uNext:
	addi $t7, $t7, 4
	addi $t1, $t1, -1
	bgt $t1, $zero, detect
	
 exit:
 	li $v0,10		#exit option
	syscall
#################################
#				#
#	data segment		#
#				#
#################################
	  .data
sizeMsg:	.asciiz "\nEnter the array size: \n"
error:		.asciiz "\nError invalid value"
endl:		.asciiz "\n"
testRandom:	.asciiz "\nthe random values are passing...\n"
arrayElements:	.asciiz "\nArray elements\n"
menuMsg:		.asciiz "\nEnter 1 to random array \nEnter 2 to bubble sort \nEnter 3 to find min max \nEnter 4 for unique numbers\n \nEnter 5 for exit\n "