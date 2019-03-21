##
## Program5.asm - provides a menu options to calculate
## summation of the numbers which are greater than user input
## summation of even and odd numbers
## divisible numbers with user input
##
##
##

#################################
#				#
#	text segment	        #
#				#
#################################

	.text		
	.globl __start 

__start:			# execution starts here
	la $t1, array		# define array	
	lw $t2, arraySize	# define arraySize
	
	la $a0, sizeMsg		#Enter array size - get arraySize as a user input
	li $v0, 4
	syscall

	li $v0,5 
	syscall
	
	move $t2, $v0		
	
	la $a0, getElmntsMsg	# Print a message to get elements
	li $v0, 4
	syscall
	
	move $t3, $t1		#array $t1, $t3
	move $t4, $t2		#arraySize $t2 $t4
	
getElements:			#getElements loop to get elements one by one by the user
	li $v0,5 
	syscall
	
	sw $v0, 0($t3)		# put user inout v0 to t3
	add $t3, $t3, 4		# next element
	addi $t4, $t4 , -1	# decrease size for loop 
	bgt $t4, $zero, getElements	#do it while size is zero
	
menu:
	la $a0, menuMsg		#print out the menu
	li $v0, 4
	syscall
	
	li $v0,5 
	syscall
	
	beq $v0, 1, sel1
	beq $v0, 2, evenoddTmp
	beq $v0, 3, sel3
	beq $v0, 4, exit
	
sel1:
	move $t3, $t1		#array $t1, $t3
	move $t4, $t2		#arraySize $t2 $t4
	
	la $a0, inputMsg	#get input for first selection
	li $v0, 4
	syscall
	
	li $v0,5 
	syscall
	
	move $a1, $v0 	       #a1 = input put input to a1
greater:
	lw $a2, 0($t3)
	bgt $a2, $a1, sum      #if pointed array's element is greater than input go to sum
	j next
sum:
	add $t5, $t5, $a2	#add array's elements which are greater than input
next:
	add $t3, $t3, 4
	addi $t4, $t4, -1
	bgt $t4, $zero, greater
	
	li $v0, 1
	move $a0, $t5	
	syscall
	j menu
	
evenoddTmp:
	move $t3, $t1		#array $t1, $t3
	move $t4, $t2		#arraySize $t2 $t4
evenodd:
	lw $t5, 0($t3)
	
	andi $a2, $t5, 1 	#find last bit of the number t6 = t5 * 0001 
	beqz $a2, even		#if last bit is 0 than number is eve fly to even
	add $t7, $t7, $t5	#else add this value to t7 $t7=$t7+$t5 $t7 is the summation of odd numbers
	j nextEo
even:
	add $t6, $t6, $t5	#t6 is the summation of even numbers
nextEo: 
	add $t3, $t3, 4
	addi $t4, $t4, -1
	bgt $t4, $zero, evenodd	#provides loop
	
	la $a0, oddMsg		#print summation of odd no.s
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t7	
	syscall
	
	la $a0, evenMsg		#print summation of even no.s
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t6	
	syscall
	
	j menu
	
sel3:
	li $t7,0
	move $t3, $t1		#array $t1, $t3
	move $t4, $t2		#arraySize $t2 $t4
	
	la $a0, inputMsg	#get input to find divisible array elements with this input
	li $v0, 4
	syscall
	
	li $v0,5 
	syscall
	
	move $a1, $v0 	       #a1 = input put input to $a1

divide:
	lw $a2, 0($t3)
	rem $a3, $a2, $a1       #if the array elemet % input = 0 rem is 0
	beqz $a3, divisible	#if rem = 0 fly divisible
	j nextDivide
	
divisible:
	addi $t7,$t7,1		#count divisible numbers
	
nextDivide: 
	add $t3, $t3, 4
	addi $t4, $t4, -1
	bgt $t4, $zero, divide
	
	la $a0, divisionOccurenceMsg	#display occurence in array
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t7	
	syscall
	
	j menu
exit:
	li $v0,10		#exit option
	syscall
#################################
#				#
#     	 data segment		#
#				#
#################################

	.data
array:		.space  400
arraySize:	.word	100
sizeMsg:	.asciiz "\nEnter array size \n"
getElmntsMsg:   .asciiz "\nEnter array elements\n"
menuMsg:	.asciiz "\nEnter 1 to summation of numbers stored in the array which is greater than an input number \nEnter 2 to summation of even and odd numbers and display them. \nEnter 3 the number of occurrences of the array elements divisible by a certain input number. \nEnter 4 for exit\n"
inputMsg:	.asciiz "\nEnter an input\n"
oddMsg:		.asciiz "\nSum of odds: "
evenMsg:	.asciiz "\nSum of evens: "
divisionOccurenceMsg: .asciiz "\nNo of occurence of the input: "