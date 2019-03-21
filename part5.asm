	.text
	.globl __start	
#t0: array
#t1: arraySize
#t2: point array
#t3: point arraySize
#t4: sum of greater integers
#t5: used in even odd
#t6: last bit of number 
#t7: no of occurances
#a1: 
#a2: used in sumGreater ----------------- sum of even numbers
#a3: sum of odd numbers
#s0: input
__start:

	la $t0, array #define array
	lw $t1, arraySize
	
	la $a0, message
	li $v0, 4
	syscall

	li $v0,5 #get number of the elements
	syscall
	
	#store user desired no of elements
	move $t1, $v0
	
	
loop:
	la $a0, elMsg		#"Enter array element: "
	li $v0,4		# prints "Enter array element: "
	syscall

	li $v0, 5		# reads elements one by one
	syscall
		
	sb $v0,0($t0)		#put elements to array
	addi $t0,$t0,4		#point next element
	addi $t1,$t1,-1		#decrease array size -1
	bgt $t1,$zero,loop	#do it untill array size = 0
	
############################ M E N U  ######################################
menu:
	
	#get selection
	la $a0, selection	#"Enter 1 to find sumation greater than input, 2 to summation ...
	li $v0, 4
	syscall

	li $v0,5 		#read selection
	syscall

	#li $t4,10 #sum of grater integers   
	
	beq $v0, 1, Sel1	#if selection = '1' go Sel1
	beq $v0, 2, evenOdd		#if selection = '2' go sumGreater
	beq $v0, 3, divisible		#if selection = '3' go divisible

	
############################ C A L C U L A T E S U M O F G R E A T E R N O S ######################################
Sel1:
	li $t4,0
	move $t2,$t0 #array
	move $t3,$t1 #size
	la $a0,displayMsg	# "Enter an input"
	li $v0,4
	syscall
	

	li $v0,5 		#get input
	syscall
	move $s2, $v0
	b sumGreater   
sumGreater:
	lw $s3,0($t2) 			#a2 holds first element of t2(t0) for now
	bgt $s3, $s2, compare		#if a2- element of the array greater than s0-input go compare

compare: 
	add $t4, $t4, $s3
 	j next
 	
next:
	addi $t2,$t2,4			#point next element
	addi $t3,$t3,-1			#decrease array size -1
	ble  $t3,$zero, printSumofGreater	#if we finish, go print
	j sumGreater

printSumofGreater:
	#print sum
	li $v0, 1
	move $a0, $t4
	syscall
	
	b menu
############################ E V E N - O D D ######################################
evenOdd:
	li $a3, 0 		#sum of odd numbers
	li $a2, 0 		#sum of even numbers #?????????????????????????????????????/
	sw $t5,0($t2)		#t5 points first element of t2-t0 fow now
	#addi $t2,$t2,4
	
	andi $t6, $t5, 1 	#find last bit of the number t6 = t5 * 1 
	beqz $t6, even		#if last bit is 0 it means its even so go even
	
	add $a3,$a3,$t5 	#if last bit is not 0 add odd numbers
	addi $t3,$t3,-1
	#bgt $t3,$zero,loop
	beq $t3, $zero, printEvenOdd	#if array size = 0 go and print result
	
even: 
	add $a2,$a2,$t5 #add even numbers
	jr $ra 			#???????????????????????????????
	
	move $t2,$t0 #array
	move $t3,$t1 #size
	
printEvenOdd:

	la $a0, evenMsg		#"No of Even numbers"
	li $v0, 4
	syscall
	
	la $a0, ($a2)
	li $v0, 4
	syscall
	
	la $a0, oddMsg		#"No of Even numbers"
	li $v0, 4
	syscall
	
	la $a0, ($a3)
	li $v0, 4
	syscall
	
############################ D I V I S I B L E ######################################
 	move $t2,$t0 #array
	move $t3,$t1 #size
divisible:
	li $t7, 0 		#no of occurances
	sw $t5,0($t2)
	blt $t5, $s0, divide	#if input is less than or equal to the array's element go divide
	
	#addi $t5, $t5, $s0
	beq $t5,0, printDivisible 
	#b next
	addi $t2,$t2,4
	addi $t3,$t3,-1
	bgt $t3,$zero,loop
	
divide:
	li $v0, 1
	move $a0, $t5
	syscall
	
	li $v0,10
	syscall

printDivisible:
	la $a0, ($t5)
	li $v0, 4
	syscall
	
	.data
array: .space 400
arraySize: .word 100
message: .asciiz "Enter the array size: \n"
evenMsg: .asciiz "No of Even numbers: \n"
oddMsg: .asciiz "No of odd numbers: \n"
displayMsg: .asciiz "Enter an input: \n"
elMsg: .asciiz "Enter array element: \n"
inputMsg: .asciiz "Enter an input to calculate summation of numbers stored in the array which is greater than an input number "
selection: .asciiz "Enter 1 to find sumation greater than input,\n 2 to summation of even and odd numbers,\n 3 to find the number of occurrences of the array elements divisible by a certain input number. "
