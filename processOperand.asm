.data

#Operations
tempZero:		.asciiz "$t0"
tempOne:		.asciiz "$t1"
savedZero:		.asciiz "$s0"
argumentZero:		.asciiz "$a0"

#Operation Types
tCero:		.asciiz "01000"
tUno:		.asciiz "10010"
sCero:		.asciiz "10001"
aCero:		.asciiz "10001"

#Parrallel Arrays
operands: 	.word tempZero, tempOne, savedZero, argumentZero #we will search this array
binaryCodes: 	.word tCero, tUno, sCero, aCero

#Misc
size: 	.word 4
space:	.asciiz " "
match:	.asciiz "It's a match!"
.text

.globl processOperand
	
processOperand:
	
	li $v0, 4
	la $a0, match
	syscall 
	
	la $t1, operands # get array address for operationss
	la $t2, binaryCodes # get array address for operation types
	li $t3, 0 # set loop counter
	lw $t4, size
	move $t5, $a0 #holds contents of userInput
	
	syscall 


loop:
	beq $t3, $t4, loop_end # While(Loop Counter != Size) 

	lw $t7, 0($t1) #move current operations[i] to $t7 for processing
	
	li $v0, 4
	#lw $t7, 0($t2) #move current operationType[i] into $t7 for processing
	la $a0, match # print value at the array pointer
	syscall 
	
	move $a0, $t5 #move  contents of userInput into $a0
	move $a1, $t7  # move current operations[i] into $a1
	
	 addi $sp, $sp, -24
	 sw 	 $ra, 0($sp)
   	 sw      $t1, 4($sp)
    	 sw      $t2, 8($sp) 
    	 sw      $t3, 12($sp) 
    	 sw      $t4, 16($sp) 
    	 sw      $t5, 20($sp) 
	 jal StrEq #Compare $a0 with $a1	
	 lw      $t5, 20($sp) 
	 lw 	 $t4, 16($sp)
	 lw 	 $t3, 12($sp)
	 lw 	 $t2, 8($sp)
   	 lw      $t1, 4($sp)
    	 lw      $ra, 0($sp)     #restore return address
    	 addi    $sp, $sp, 24    #reset the stack pointer
	
	beq $v0, 1, found #If strcmp returns 1, the instruction is found

	#Adjust counters for loop and index
	addi $t3, $t3, 1 
	addi $t1, $t1, 4 
	addi $t2, $t2, 4 

j loop # repeat the loop

foundOperand:
	#addi $s7, $zero, 1 
	
	#If Match, then send all necessary params to logOperand
	li $v0, 4
	la $a0, match
	syscall 
	
	#print operation

loop_end:
jr $ra
