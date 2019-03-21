##
##	convertHexToDec.asm receives the beginning address of an asciiz string
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
__start:			# execution starts here
	jal program
	
	li $v0,10		
	syscall 
program:	
	move $s1, $ra		#we put the address of the program because we have 2 jal instruction
			
	la   $a0, hexNo		#load address of given hexNo to $a0 register
	move $a1, $a0		#I use a1 to copy $a0 to protect it
	li $t5,0		#set length to zero- $t5 register is my string length
	li $v0,0
	jal strlength		#go to strlength method to find given hexNo' length
	jal convertHexToDec	#if we found the string's length go to convertHexToDec to calculate
	
	# result comes in $v0
	move $a0, $v0		#get calculated decimal and print it here my decimal is hold in $v0
	li $v0, 1		#print integer
	syscall
	
	move $ra, $s1		#get address which is hold in $s1
	
	li $v0,10		#end program
	syscall
	
strlength:
	lbu $a2,0($a1)      	#calculate given hexNo length 
        beq $a2,$0,finished   	#if we reach the null character we are done
        addi $t5,$t5,1        	#increment of length
        addi $a1,$a1,1        	#next 
        j strlength		#do it till the null character
	
		
	
convertHexToDec:
	lbu $t1, 0($a0)		#load a byte of given hexNo

	#determine if given hexNo is not proper
	blt $t1, 0x30, errorCase	#detect error cases
	bgt $t1, 0x46, errorCase
	
	#if it is proper move on
	bgt $t1, 0x40, letters		#if given hexNo's ASCII convertion is bigger than 0x40 it is a letter go to letter label
	blt $t1, 0x39, numbers		#if it is less than 0x39 it is a number go to number label
	

letters:
	addi $t1, $t1, -0x37		#given value is -0x37 bigger than real value so subract it
	move $t6, $t5			#protect string length
	addi $t6, $t6, -1		#length = length - 1
	beqz $t6, sum			#if it's in 16^0 base go to sum
	j mult16			#else jump to mult 16 to calculate base and multiply according to it
	
numbers:
	addi $t1, $t1, -0x30
	move $t6, $t5
	addi $t6, $t6, -1
	beqz $t6, sum
	j mult16	
	
mult16:	
	mul $t1, $t1, 16		#multiply the value with 16 till reach the order of it
	addi $t6, $t6, -1		#length = length -1
	bgt $t6, $zero, mult16		#do it while length > 0
	j sum				#if it is done go to sum
	
sum:
	add $v0, $v0, $t1		#add the value to $v0
	j next				#go to next label
	
errorCase:
	la $a0, errorMsg		#print an error message
	li $v0,4
	syscall
	
	li $v0,10			#exit option
	syscall

next:
	addi $a0, $a0, 1		#next character of given string hexNo
	addi $t5, $t5, -1		#length = length - 1
	bge $t5,1, convertHexToDec	#if length > 1 continue
	
	j finished			#else go to finished label
	
finished:
	jr $ra				#return the hold address of program
#################################
#				#
#	data segment		#
#				#
#################################
	  .data
hexNo:   .asciiz "1A"
errorMsg: .asciiz "\nERROR given argument is not proper\n"
test: .asciiz "test\n"
