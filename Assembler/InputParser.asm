.data
str:        .space 23   # buffer for input string
strNS:      .space 23   # buffer for string w/o spaces
prompt:     .asciiz "Enter a string up to 80 characters\n"
head1:      .asciiz "\nOriginal String:  "
head2:      .asciiz "\nNumber of spaces:  "
head3:      .asciiz "\nWith spaces removed:  "
head4:      .asciiz "\nSeparated:  "
endOfFileLine: .asciiz ".end"


.text
.globl countSpace
countSpace:
    la      $s0, strNS
    addi    $sp, $sp, -12   #adjust the stack pointer for saving
    sw      $s0, 8($sp)     #store addr of nospace string
    sw      $ra, 4($sp)     #store return addr on the stack
    sw      $a0, 0($sp)     #store the count on the stack

    #Begin counting spaces
    addi    $t3, $a0, 0     #$t3 has addr of user input
    addi    $t5, $s0, 0     #$t5 has addr of string with no spaces
    li      $t6, 0          #$t6 holds index of string with no spaces 
    li      $t0, 0          #$t0 will hold the count of spaces
    li      $t4, 0          #$t4 holds the index of the string
loop:   
    add     $t1, $t3, $t4   #$t1 = addr of str[i]
    lb      $t2, 0($t1)     #$t2 = character in str[i]
    beq     $t2, $zero, exitCS  #break from loop if $t2 contains null character
    addi    $a0, $t2, 0     #place value to be checked in $a0

    #save values onto stack from temp registers to preserve them
    addi    $sp, $sp, -24   #adjust the stack pointer for 5 values
    #sw      $t6, 20($sp)    #save index of string with no spaces
    sw      $t5, 20($sp)    #save addr of string with no spaces
    sw      $t4, 16($sp)    #save index of user input
    sw      $t3, 12($sp)    #save the addr of user input
    sb      $t2, 8($sp)     #save the character in str[i]
    sw      $t1, 4($sp)     #save the address of str[i] 
    sw      $t0, 0($sp)     #save the count of spaces

    jal     isSpace         #result from this jump and link will be in $v0 after call

    #pop saved values from the stack, then reset the pointer
    #lw      $t6, 20($sp)
    lw      $t5, 20($sp)
    lw      $t4, 16($sp)
    lw      $t3, 12($sp)
    lb      $t2, 8($sp)
    lw      $t1, 4($sp)
    lw      $t0, 0($sp)
    addi    $sp, $sp, 24    #reset stack pointer
  
    beq     $v0, $zero, addTo   #if not a space, continue to next character
    addi    $t0, $t0, 1     #if it is a space, increment count
        
addTo:  
    bne     $v0, $zero, nextChar #If character is a space, branch
    move     $t7, $t6     #index if nospaces string stores width of 4
    add     $t7, $t7, $t5   #now $t7 points at nospaces[i]
    sb      $t2, 0($t7)     #store the character in the nospaces string
    addi    $t6, $t6, 1     #increment the index of nospaces

nextChar:

    addi    $t4, $t4, 1     #increment the index value
    j       loop            #jump back to loop and continue processing

exitCS:
    addi    $v0, $t0, 0     #count of spaces placed into $v0
    addi    $v1, $t5, 0
    lw      $ra, 4($sp)     #load return addr from the stack
    lw      $a0, 0($sp)     #load value to check from the stack
    addi    $sp, $sp, 8     #reset stack pointer
    jr      $ra             #return

isSpace:
    addi    $sp, $sp, -16   #adjust stack pointer to make room
    sw 	    $t0, 12($sp)
    sw      $s0, 8($sp)
    sw      $ra, 4($sp)     #store value of return addr onto stack
    sw      $a0, 0($sp)     #store value to check onto stack

    #Check to see if the character is a space
    li      $t0, 32         #ascii value for space character loaded into $t0
    li      $v0, 0          #Set default return to 0, or "not a space character"
    bne     $t0, $a0, endSC #if ascii values match, character is a space
    li      $v0, 1          #$v0 = 1 means it is a space character 
 
 processWord:
 li   $v0, 4   
 la   $a0, head4      #print the word
 syscall 
 move    $a0, $t5      #print the word
 syscall 
 
#PROCESS T5
	jal checkEOF	#check to see if we have reached end of file
	#Done checking for EOF, if we reached this point we can now check for operands/registers
	
	addi $sp, $sp, -12
        sw  $ra, 0($sp) 
        sw      $t5, 4($sp)
        sw      $t7, 8($sp) 
    		jal processOperation #do processing on the input argument   
        lw      $t7, 8($sp) 
        lw      $t5, 4($sp)
        lw  $ra, 0($sp)
    	addi $sp, $sp, 12

    
#CLEAR
 	jal clearBuffer
 add   $t6, $zero, $zero     #increment the index of nospaces
 
 
endSC:  
    sw 	    $t0, 12($sp)
    lw      $s0, 8($sp)
    lw      $ra, 4($sp)     #restore return address
    lw      $a0, 0($sp)     #restore addr of str
    addi    $sp, $sp, 16    #reset the stack pointer

 
end:    jr $ra

clearBuffer:
# 23 space buffer
	li $t1, 0				#sets t1 to zero, uses it as index counter
	la $a0, strNS				#loads stringNoSpace into $a0
	add $t0, $zero, $a0			#t0 it set to the base address of a0
	clearloop:
	sb $zero, 0($t0)			#set the content at t0 to zero
	bge $t1, 23, endclearloop		#if we reached 23 bits then we done
	addi $t0, $t0 1				#else add 1 to the address, thus we are on the next character
	addi $t1, $t1, 1			#also add 1 to the counter
	j clearloop
	
	endclearloop:
	jr $ra
	
checkEOF:
	addi $sp $sp, -4
	sw $ra, 0($sp)
	
	la $a1, endOfFileLine
	jal StrCmp
	
	beqz $v0, endProgram
		
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
