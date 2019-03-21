##
##	interactWithUser.asm receives the beginning address of an asciiz string
##	returns decimal equivalent
##	v0- the returning decimal value
##      a0- the hexadecimal value in string

#################################
#				#
#	text segment		#
#				#
#################################

	.text		
	.globl __start
 __start:
 	jal interactWithUser
 	
 	li $v0,10		#exit option
	syscall
	
interactWithUser:		# execution starts here
	move $s1, $ra		#protect address of the program 
	
	la $a0, msg		#output the message to take a hexNo
	li $v0, 4		#take string
	syscall

	la $a0, input		#load address of given hexNo to $a0 register
	li $a1, 100		#a1 holds max size when we use v0
	li $v0,8
	syscall
	
	li $t5,0		#set length to zero- $t5 register is my string length
	li $v0,0
	
	move $a3, $a0		#I use a1 to copy $a3 to protect it
	jal strlength		#go to strlength method to find given hexNo' length
	jal convertHexToDec	#if we found the string's length go to convertHexToDec to calculate
	
	move $a0, $v0		#get calculated decimal and print it here my decimal is hold in $v0
	li $v0, 1
	syscall
	
	move $ra, $s1		#get address which is hold in $s1
	
	li $v0,10		
	syscall
	
strlength:
	lbu $a2,0($a3)      	#calculate given hexNo length 
        beq $a2,10,finished	#if it is equal to 10 because we calculate null character here and do not want to calculate
        #beq $a2,0,finished   
        addi $t5,$t5,1        	#increment string length
        addi $a3,$a3,1        
        j strlength
	
	
	# result comes in $v0	
	
convertHexToDec:
	lbu $t1, 0($a0)
	#determine error cases
	blt $t1, 0x30, errorCase
	bgt $t1, 0x46, errorCase
	
	#go to number or letter label according to its ascii convertion
	bgt $t1, 0x40, letters
	blt $t1, 0x39, numbers
	

letters:
	addi $t1, $t1, -0x37	#calculate its convertion in hexadecimals
	move $t6, $t5
	addi $t6, $t6, -1
	beqz $t6, sum
	j mult16
	
numbers:
	addi $t1, $t1, -0x30	#calculate its convertion in hexadecimals
	move $t6, $t5
	addi $t6, $t6, -1
	beqz $t6, sum
	j mult16	
	
mult16:	
	mul $t1, $t1, 16	#if the character/number is not in 16^0 order, multiply with 16 till reach its order
	addi $t6, $t6, -1
	bgt $t6, $zero, mult16
	j sum	
	
sum:
	add $v0, $v0, $t1
	j next
	
errorCase:
	la $a0, errorMsg	#if given value is not proper print an error message
	li $v0,4
	syscall
	
	j __start	#if given string is not proper ask user again and again

next:
	addi $a0, $a0, 1	#get next char of given string
	addi $t5, $t5, -1	#length = length - 1
	bge $t5,1, convertHexToDec	#do it till length > 1
	
	j finished	#jump finished label
	
finished:
	jr $ra		#jump to hold address

#################################
#				#
#	data segment		#
#				#
#################################
	  .data
msg:		.asciiz "\nEnter a hexadecimal\n"
input:		.space 100
errorMsg:	.asciiz "\nERROR given argument is not proper\n"
test:		.asciiz "test\n"
