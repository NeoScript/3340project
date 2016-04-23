.data

#Operations
addImmediate:		.asciiz "addi"
multiply:		.asciiz "mult"
addNormal:		.asciiz "add"
branchEqual:		.asciiz "beq"


#Operation Types
typeR:		.asciiz "R"
typeI:		.asciiz "I"
typeJ:		.asciiz "J"


#Parrallel Arrays
operations: 	.word addImmediate, addNormal, multiply,branchEqual #we will search this array
operationType: 	.word typeR, typeR, typeR, typeI

#Misc
size: 	.word 4
space:	.asciiz " "
match:	.asciiz "It's a match!"
.text

.globl processOperation
	
processOperation:
	
	la $t1, operations # get array address for operationss
	la $t2, operationType # get array address for operation types
	li $t3, 0 # set loop counter
	lw $t4, size
	move $t5, $a0 #holds contents of userInput


print_loop:
	beq $t3, $t4, print_loop_end # While(Loop Counter != Size) 

	lw $t7, 0($t1) #move current operations[i] to $t7 for processing
	
	li $v0, 4
	#lw $t7, 0($t2) #move current operationType[i] into $t7 for processing
	la $a0, space # print value at the array pointer
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

j print_loop # repeat the loop

found:
	addi $s7, $zero, 1 
	
	#If Match, then send all necessary params to logOperand
	li $v0, 4
	lw $t7, 0($t2) #move current operationType[i] into $t7 for processing
	move $a0, $t7 # print value at the array pointer
	syscall 
	
	#bnez $s7, logOperand
	#jal logOperation

print_loop_end:
jr $ra
