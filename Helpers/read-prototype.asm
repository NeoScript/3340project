## Note: currently reads information from files using 1024 buffer, not currently in a loop until I can figure out how to read line by line

.data
file_loc: .asciiz "test.asm" #note: when launching from commandline, test.asm should be within the same folder as Mars.jar else it will default to base of the c:/ drive
buffer: .space 1
new_line: .asciiz "\n"
currInput: .space 20

#error strings
readErrorMsg: .asciiz "\nError in reading file\n"
openErrorMsg: .asciiz "\nError in opening file\n"

.text
main:
	jal openFile
	jal readTillSpace
	jal printCurrInput
	jal closeFile
	j endProgram

openFile:
	#Open file for for reading purposes
	li $v0, 13			#syscall 13 - open file
	la $a0, file_loc		#passing in file name
	li $a1, 0				#set to read mode
	li $a2, 0				#mode is ignored
	syscall
	bltz $v0, openError		#if $v0 is less than 0, there is an error found
	move $s0, $v0			#else save the file descriptor
	jr $ra
	
readTillSpace:
	and $t1, $t1, $zero		#set $t1 to zero
	beqz $t1, continueread		#if $t1 is zero continue to read
	
	continueread:
	#Read input from file until space and store into currInput
	li $v0, 14			#syscall 14 - read file
	move $a0, $s0			#sets $a0 to file descriptor
	la $a1, buffer			#stores read info into buffer
	li $a2, 1			#hardcoded size of buffer
	syscall				
	bltz $v0, readError		#if error it will go to read error
					#else if no error continue working on method
					
					#if input is not a space, then add it to the currInput buffer
					#else if input is a space, then disregard it and leave this method
	jr $ra
	
printCurrInput:
	li $v0, 4
	la $a0, buffer
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


endProgram:
	li $v0, 10
	syscall
