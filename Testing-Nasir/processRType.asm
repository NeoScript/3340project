.data
    opCode: .space 20
    funcCode: .space 20
    firstArgument: .space 20
    secondArgument: .space 20
    thirdArgument: .space 20
    
    printString:      .space 23   # buffer for string w/o spaces
    
    shamtPlaceHolder: .asciiz "00000"
    
    test: .asciiz "hello"
    
#Process R-Type
.text
.globl handleRType

handleRType:
	move $t0, $a0 #holds operand #
	move $t1, $a1 #holds binary code to print (OP-Code if operation, value if operand)
	move $t2, $a2 #hold funct code
	la   $s6, printString
	sw   $s6, 8($sp)     #store addr of nospace string
	addi $t5, $s0, 0     #$t5 has addr of string with no spaces
	
	# load first Argument into buffer

#Simple Switch statement to execute based on operation given
	beq $t0, 0,  addInitialArguments
	beq $t0, 1 , addFirstArgument
	beq $t0, 2 , addSecondArgument
	beq $t0, 3 , addThirdArgument
	
 
addInitialArguments:
#add opCode to memory 
add $a0, $t1, $zero
la $a1, opCode

#make room on the stack and copy the string to Store
addi $sp, $sp, -12		
	sw $ra, 0($sp)	
	sw $t1, 4($sp)
	sw $t2, 8($sp)
 	jal StrCpy
 	lw $ra, 0($sp)
 	lw $t1, 4($sp)
 	lw $t2, 8($sp)	
 addi $sp, $sp, 12		
 
#add function code to memory 
add $a0, $t2, $zero
la $a1, funcCode 

addi $sp, $sp, -12		
	sw $ra, 0($sp)	
	sw $t1, 4($sp)
	sw $t2, 8($sp)
 	jal StrCpy
 	lw $ra, 0($sp)
 	lw $t1, 4($sp)
 	lw $t2, 8($sp)	
 addi $sp, $sp, 12	
 

 jr $ra
 
addFirstArgument:
# load first Argument into buffer
#add function code to memory 
add $a0, $t1, $zero
la $a1, firstArgument 

addi $sp, $sp, -12		
	sw $ra, 0($sp)	
	sw $t1, 4($sp)
	sw $t2, 8($sp)
 	jal StrCpy
 	lw $ra, 0($sp)
 	lw $t1, 4($sp)
 	lw $t2, 8($sp)	
 addi $sp, $sp, 12	
 

 jr $ra

addSecondArgument:
 #move secondArgument, $t0  # load first Argument into buffer
add $a0, $t1, $zero
la $a1, secondArgument 

addi $sp, $sp, -12		
	sw $ra, 0($sp)	
	sw $t1, 4($sp)
	sw $t2, 8($sp)
 	jal StrCpy
 	lw $ra, 0($sp)
 	lw $t1, 4($sp)
 	lw $t2, 8($sp)	
 addi $sp, $sp, 12	
 

 jr $ra
 
addThirdArgument:
 #move thirdArgument, $t0  # load first Argument into buffer
add $a0, $t1, $zero
la $a1, thirdArgument 

addi $sp, $sp, -12		
	sw $ra, 0($sp)	
	sw $t1, 4($sp)
	sw $t2, 8($sp)
 	jal StrCpy
 	lw $ra, 0($sp)
 	lw $t1, 4($sp)
 	lw $t2, 8($sp)	
 addi $sp, $sp, 12	

addi $sp, $sp, -4	
 sw $ra, 0($sp)	 

  jal printRtype
 
 lw $ra, 0($sp)	
addi $sp, $sp, 4
 
 jr $ra

printRtype:
	li $v0, 4
	la $a0, opCode # print value at the array pointer
	syscall 
	li $v0, 4
	la $a0, firstArgument # print value at the array pointer
	syscall 
	li $v0, 4
	la $a0, secondArgument # print value at the array pointer
	syscall 
	li $v0, 4
	la $a0, thirdArgument # print value at the array pointer
	syscall 
	li $v0, 4
	la $a0, shamtPlaceHolder # print value at the array pointer
	syscall
	li $v0, 4
	la $a0, funcCode   # print value at the array pointer
	syscall
jr $ra 


##Helper method to move from registers to memory 
StrCpy:

	lbu		$t1,0($a0)		# Load a byte from the source string
	sb 		$t1,0($a1)		# Store the byte in the destination string
	beq		$t1,$0,cpyExit		# Stop when th NULL is transferred.
	addi		$a0,$a0,1		# Increment both addresses.
	addi		$a1,$a1,1
	j		StrCpy
	
cpyExit:
	jr		$ra



	
	

	
	
	


	

