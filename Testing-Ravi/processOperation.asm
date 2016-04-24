.data

#Operations
addImmediate:		.asciiz "addi"
multiply:		.asciiz "mult"
addNormal:		.asciiz "add"
branchEqual:		.asciiz "beq"

#FunctionCodes
addImmediateF:		.asciiz "01000"
multiplyF:		.asciiz "00000"
addNormalF:		.asciiz "11010"
branchEqualF:		.asciiz "10000"

#OpCodes
addImmediateOP:		.asciiz "01000"
multiplyOP:		.asciiz "00000"
addNormalOP:		.asciiz "10010"
branchEqualOP:		.asciiz "00000"

#Operation Types
typeR:		.asciiz "R"
typeI:		.asciiz "I"
typeJ:		.asciiz "J"


#Parrallel Arrays
operations: 	.word addImmediate, addNormal, multiply,branchEqual #we will search this array
functionCodes: 	.word addImmediateF, addNormalF, multiplyF, branchEqualF 
opCodes: 	.word addImmediateOP, addNormalOP, multiplyOP, branchEqualOP 
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
	la $t6, functionCodes # get array address for functCodes types
	la $t8, opCodes # get array address for functCodes types
	
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
	
	#Check if Operand
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
    	 
	beq $v0, 1, foundOperation #If strcmp returns 1, the instruction is found
    	
	#Adjust counters for loop and index
	addi $t1, $t1, 4 
	addi $t2, $t2, 4 
	addi $t6, $t6, 4
	addi $t8, $t8, 4
	
	
	addi $t3, $t3, 1  #loop counter

j print_loop # repeat the loop

print_loop_end:
beq $v0, 0, foundOperand #If Operation was not found, must be a operand

foundOperation:
	bnez $s7,clear
	
	
	
	move $a0, $s7 #Global register, we will be using this to keep track of operands. We will also be clearing this in other files


	lw $t7, 0($t8) #get the current opCode
	
	move $a1, $t7 #load the binary opcode
	
	lw $t7, 0($t6) #get the current FunctionCode
	move $a2, $t7 #load the function code if any
	
	addi $sp, $sp, -16
	 sw      $ra, 0($sp) 
	 sw      $t0, 4($sp) 
	 sw      $t1, 8($sp) 
    	 sw      $s7, 12($sp) 
    	 
  	jal handleRType
  	 
	 lw      $s7, 12($sp) 
	 sw      $t1, 8($sp) 
	 sw      $t0, 4($sp) 
	 lw 	 $ra, 0($sp)
	addi $sp, $sp, 16
	
finished:
	jr $ra

clear:
add $s7, $zero, $zero
j foundOperation
	
		
foundOperand:
    	 addi $sp, $sp, -24
	 sw 	 $ra, 0($sp)
   	 sw      $t1, 4($sp)
    	 sw      $t2, 8($sp) 
    	 sw      $t3, 12($sp) 
    	 sw      $t4, 16($sp) 
    	 sw      $t5, 20($sp) 
    	 
	 jal processOperand #take value of $a0 and process It	
	 
	 lw      $t5, 20($sp) 
	 lw 	 $t4, 16($sp)
	 lw 	 $t3, 12($sp)
	 lw 	 $t2, 8($sp)
   	 lw      $t1, 4($sp)
    	 lw      $ra, 0($sp)     #restore return address
    	 addi    $sp, $sp, 24    #reset the stack pointer
    	 
	 jr $ra    #return out of function
