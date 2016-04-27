
.data
placeholderBuffer: .space 20
labelsPlaceHolder: .asciiz "$placeholder"
saved: .asciiz " saved: "
labels: .word labelsPlaceHolder,labelsPlaceHolder,labelsPlaceHolder,labelsPlaceHolder #we will replace these values
labelAddresses: .word 0,1,2,3 #this will hold PC addresses for the label, we will return this when queried

size: 	.word 4

.text
.globl processLabel
processLabel:

	la $t1, labels # get array address for operationss
	la $t2, labelAddresses # get array address for operation types
	lw $t4, size #set the size for the arrays
	addi $t3, $zero, 0  # initialize loop counter as size
	
	move $t5, $a0 #holds the label ascii value
	
add_loop:
	beq $t3, $t4, add_loop_end # While(Loop Counter != Size) 
	lw $t7, 0($t1) #move current labels[i] to $t7 for processing
	
	move $a0, $t7 #move  contents of current Label ascii value
	la $a1, labelsPlaceHolder  # check if it is the labelsPlaceHolder
	
	
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
    	 
	beq $v0, 1, addtoArray #If strcmp returns 1, the placeholder is found, we can replace it
    	
	#Adjust counters for loop and index
	addi $t1, $t1, 4 
	addi $t2, $t2, 4
	
	addi $t3, $t3, 1  #loop counter

j add_loop # repeat the loop

addtoArray:

add $a0, $t5, $zero 
move $a1, $t7

addi $sp, $sp, -12		
	sw $ra, 0($sp)	
	sw $t1, 4($sp)
	sw $t2, 8($sp)
 	jal StrCpy
 	lw $ra, 0($sp)
 	lw $t1, 4($sp)
 	lw $t2, 8($sp)	
 addi $sp, $sp, 12	

sw $t7, 0($t1) #set the current label
sw $t6, 0($t2) #set the current label PC code

#lw $t7, 0($t1) #move current labels[i] to $t7 for processing


li $v0, 1   #return true if the label was added to the saved lists

add_loop_end:
jr $ra


.globl getLabelAddress
getLabelAddress:
	la $t1, labels # get array address for operationss
	la $t2, labelAddresses # get array address for operation types
	lw $t4, size #set the size for the arrays
	addi $t3, $zero, 0  # initialize loop counter as size
	
	move $t5, $a0 #holds the search key value
	
search_loop:
	beq $t3, $t4, search_end # While(Loop Counter != Size) 
	
	lw $t7, 0($t1) #move current labels[i] to $t7 for processing
	
	li $v0, 4
	move $a0, $t7
	syscall
	
	move $a0, $t5 #move  contents of searchKey into $a0
	move $a1, $t7  # move current labels[i] into $a1
	
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
    	 
	beq $v0, 1, foundAddress #If streq returns 1, the instruction is found
    	
	#Adjust counters for loop and index
	addi $t1, $t1, 4 
	addi $t2, $t2, 4 
	
	
	addi $t3, $t3, 1  #loop counter

j search_loop # repeat the loop

foundAddress:
	#lw $t7, 0($t2) #get the current address code,
	add $v0, $t7,$zero  #return the address code
	j	end

search_end:
	li $v0, -1  #return -1 if label was not found
	
end:
jr $ra
