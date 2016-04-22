## Note: currently reads information from files using 1024 buffer, not currently in a loop until I can figure out how to read line by line
# Save operand to $s7, then operands to $s6, $s5, $s4, 
.data
file_loc: .asciiz "test.asm" #note: when launching from commandline, test.asm should be within the same folder as Mars.jar else it will default to base of the c:/ drive
buffer: .space 1
new_line: .asciiz "\n"
space_char: .asciiz " "
endOfFileLine: .asciiz ".end\n"
currInput: .space 23

#error strings
readErrorMsg: .asciiz "\nError in reading file\n"
openErrorMsg: .asciiz "\nError in opening file\n"
newLineFound: .asciiz "\nFound a New Line\n"
currLineMsg: .asciiz "\nCurrLine:"
currBufferMsg: .asciiz "\nCurrBuffer:"

.text
.globl openFile
openFile:
	#Open file for for reading purposes
	li $v0, 13			#syscall 13 - open file
	la $a0, file_loc		#passing in file name
	li $a1, 0			#set to read mode
	li $a2, 0			#mode is ignored
	syscall
	bltz $v0, openError		#if $v0 is less than 0, there is an error found
	move $s0, $v0			#else save the file descriptor
	jr $ra
	
.globl readLine
readLine:
	jal clearCurrInputLine
continueread:
	jal printCurrBuffer
	jal printCurrInput
	jal printNewLine
	
	#Read input from file until new_line and store into currInput
	li $v0, 14			#syscall 14 - read file
	move $a0, $s0			#sets $a0 to file descriptor
	la $a1, buffer			#stores read info into buffer
	li $a2, 1			#hardcoded size of buffer
	syscall				#store 1 read char into buffer
	bltz $v0, readError		#if error it will go to read error
					#else if no error continue working on method
    isNewLine:
	#running the string compare
	lbu $a0, buffer			#setting $a0 to buffer
	li $a1, 10			#setting $a1 to value of newLine character
	sne $v0, $a0, $a1		#if the buffer is not equal to the new line character then $v0 = 1
	
	blez $v0, doneReading		#if $v0 equals to zero, then it means it has reached the new line character, and is done reading
	b continueReading		#else the buffer does not contain the new line character, it continues reading

	jr $ra # go back to whatever called it
	
continueReading:
	#add the current char to currInput
	la $a0, buffer
	la $a1, currInput
	jal StrCat
	
	#then jump back to reading till space
	b continueread

doneReading:
	jal printFoundNewLine
	la $a0, space_char
	la $a1, currInput
	jal StrCat
	la $a0, currInput #set $a0 to the current read line
	j afterReading
	
printCurrInput:
	li $v0, 4
	la $a0, currLineMsg
	syscall
	li $v0, 4
	la $a0, currInput
	syscall
	jr $ra
	
printCurrBuffer:
	li $v0, 4
	la $a0, currBufferMsg
	syscall
	li $v0, 1
	lbu $a0, buffer
	syscall
	jr $ra
	
printFoundNewLine:
	li $v0, 4
	la $a0, newLineFound
	syscall
	jr $ra
	
printNewLine:
	li $v0, 4
	la $a0, new_line
	syscall
	jr $ra

	
closeFile:
	#Close the file 
	li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file
	jr $ra

openError:
	la $a0, openErrorMsg
	li $v0, 4
	syscall
	j endProgram

readError:
	la $a0, readErrorMsg
	li $v0, 4
	syscall
	j endProgram

clearCurrInputLine:
# 23 space buffer
	li $t1, 0				#sets t1 to zero, uses it as index counter
	la $a0, currInput				#loads stringNoSpace into $a0
	add $t0, $zero, $a0			#t0 it set to the base address of a0
	clearloop:
	sb $zero, 0($t0)			#set the content at t0 to zero
	bge $t1, 23, endclearloop		#if we reached 23 bits then we done
	addi $t0, $t0 1				#else add 1 to the address, thus we are on the next character
	addi $t1, $t1, 1			#also add 1 to the counter
	j clearloop
	
	endclearloop:
	jr $ra