.globl StrEq
StrEq:
	lbu $t0,0($a0)	# Load a byte from the first source string.
	lbu $t1,0($a1)	# Load a byte from the second source string.
	
	or $t2, $t0, $t1	#0 if both are null
	
	beqz $t2, same	#If both are null the string is the same
	beq $t0, $t1, continue #If both are the same, go to the next character
	
	li $v0, 0 #Both character aren't the same so return 0
	jr $ra

continue:
	#Move to next character
	addi $a0,$a0,1	
	addi $a1,$a1,1
	j StrEq
	
same:
	#Strings are equal so return 1
	li $v0, 1
	jr $ra
	
	
	
	