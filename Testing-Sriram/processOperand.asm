.data

#Operations
tempZero:	.asciiz "$t0"
tempOne:	.asciiz "$t1"
tempTwo:	.asciiz "$t2"
tempThree:	.asciiz "$t3"


#Operation Types
t0:		.asciiz "00000"
t1:		.asciiz "11111"
t2:		.asciiz "22222"




#Parrallel Arrays
operations: 	.word tempZero, tempOne, tempTwo #we will search this array
operationType: 	.word t0, t1, t2

#Misc
size: 	.word 3
space:	.asciiz " "
match:	.asciiz "It's a match!"
.text

.globl processOperand
	
processOperand:
	
	la $t1, operations # get array address for operationss
	la $t2, operationType # get array address for operation types
	li $t3, 0 # set loop counter
	lw $t4, size
	move $t5, $a0 #holds contents of userInput


print_loop:
	beq $t3, $t4, print_end # While(Loop Counter != Size) 
	lw $t7, 0($t1) #move current operations[i] to $t7 for processing
	
	
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
    	 
	beq $v0, 1, foundOperand #If strcmp returns 1, the instruction is found
	
	#Adjust counters for loop and index
	
	addi $t1, $t1, 4 
	addi $t2, $t2, 4 
	addi $t3, $t3, 1 
	
	j print_loop # repeat the loop

foundOperand:
	#If Match, then send all necessary params to processType
	
	lw $t7, 0($t2) #move current operationType[i] into $t7 for processing
	
	addi $s7, $s7, 1 #keeps track of current operand#
	
	move $a0, $s7 #Global register, we will be using this to keep track of operands. We will also be clearing this in other files
	move $a1, $t7 
	
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
	
	
	#Operand # in $a0
	#Operand Code in #a1

				
print_end:
jr $ra
