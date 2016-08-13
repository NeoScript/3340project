.data
first: 
	.asciiz "j" 
	.space 4
	.word 3
	
addi: 
	.asciiz "addi"
	.word 1
mult:
	.asciiz "mult"
	.word 4
add: 	
	.asciiz "add"
	.space 4
	.word 2
# addrs is a list of the starting addresses for each of the strings


cmdNotFound: .asciiz "Command not Found"
cmdFound: .asciiz "found"
curInput: .asciiz "add"

.text
.globl StoreData

StoreData:
	li $a2, 0	#Set the address increment to 0
	la $a1, first   #Load the first address(addi)
	j loop 	        #Jump to loop

loop:
#	jal print #Print the instruction in $a0
	addi $sp, $sp, -4
	sw $ra, ($sp) 
	jal StrEq #Compare $a0 with $a1
	lw $ra, ($sp)
	addi $sp $sp, 4
	
	beq $v0, 1, found #If strcmp returns 0, the instruction is found
	bge $a2, 48, fail #If address increment is too high, the operation doesn't exist
	addi $a2, $a2, 12 #Go to next instruction
	la $a1, first($a2) #Get next instruction
	j loop #Loop again

found:
	li $v0, 4
	la $a0, first($a2)
	syscall
	la $a0, cmdFound
	syscall
	jr $ra
fail:
	la $a0, cmdNotFound
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
#print:
#	li $v0, 4
#	syscall
#	jr $ra
