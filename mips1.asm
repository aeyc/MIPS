	.text
	.globl __start	

__start:

	la $t0, array #define array
	lw $t1, arraySize
	
	la $a0, message
	li $v0, 4
	syscall

	li $v0,5 #get number of the elements
	syscall
	
	move $t1, $v0
	
loop:
	la $a0, elMsg		#"Enter array element: "
	li $v0,4		# prints "Enter array element: "
	syscall

	li $v0, 5		# reads elements one by one
	syscall
		
	sw $v0,0($t2)		#put elements to array
	addi $t2,$t2,4		#point next element
	addi $t3,$t3,-1		#decrease array size -1
	bgt $t3,$zero,loop	#do it untill array size = 0
	
menu:
	
	#get selection
	la $a0, selection	#"Enter 1 to find sumation greater than input, 2 to summation ...
	li $v0, 4
	syscall

	li $v0,5 		#read selection
	syscall
	
	move $t2,$t0 #array
	move $t3,$t1 #size
	#li $t4,10 #sum of grater integers   
	
	beq $v0, '1', sumGreater	#if selection = '1' go sumGreater
	#beq $v0, '2', evenOdd		#if selection = '2' go sumGreater
	#beq $v0, '3', divisible		#if selection = '3' go divisible

sumGreater:
	#enter an input
	la $a0,displayMsg	# "Enter an input"
	li $v0,4
	syscall
	
	li $v0,5 		#get input
	syscall
	
	move $s2, $v0
	
	sw $a2,0($t2) 			#a2 holds first element of t2(t0) for now
	bgt $a2, $s0, compare		#if a2- element of the array greater than s0-input go compare
	
compare: 
	add $t4, $t4, $a2
 	j next
 	
next:
	addi $t2,$t2,4			#point next element
	#bgt $t3,$zero,loop
	#beq  $t3,$zero, printSumofGreater	#if we finish, go print
	addi $t3,$t3,-1			#decrease array size -1
	beq  $t3,$zero, printSumofGreater	#if we finish, go print
	j sumGreater
	
	
printSumofGreater:
	#print sum
	li $v0, 1
	move $a0, $t4
	syscall
	
	b menu
	.data
array: .space 400
arraySize: .word 100
message: .asciiz "Enter the array size: "
evenMsg: .asciiz "No of Even numbers: "
oddMsg: .asciiz "No of odd numbers: "
displayMsg: .asciiz "Enter an input: "
elMsg: .asciiz "Enter array element: "
inputMsg: .asciiz "Enter an input to calculate summation of numbers stored in the array which is greater than an input number "
selection: .asciiz "Enter 1 to find sumation greater than input, 2 to summation of even and odd numbers, 3 to find the number of occurrences of the array elements divisible by a certain input number. "
