.data
#File helpers:
file_location: .asciiz "/Users/Raviteja/Documents/Projects/MIPSprograms/MipsAssembler/Assembler/test.asm"
endOfFileLine: .asciiz ".end"
#Error Messages:
readErrorMsg: .asciiz "\nError in reading file\n"
openErrorMsg: .asciiz "\nError in opening file\n"
doneReadingLine: .asciiz "after Reading Reached\n"

.text
.globl main
main:	
	la $a0, file_location
	jal openFile			#openFile is called, the FileDescriptor is saved in $s0
	jal openFileToWrite		#output file is opened
	addi $sp, $sp, -4		#make room on the stack for one word (4 bytes)
	sw $s0, 0($sp)			#save the $s0 (the file descriptor) onto the stack for later
readlinefromfile:
	jal readLine			#readLine from the openFile and place that line into $a0

.globl afterReading
afterReading:
	jal parseStatements
	addi $sp, $sp, 4		#move the stack pointer
	lw $s0, 0($sp)			#take back the object stored on the stack ($s0 - file descriptor)
	j readlinefromfile		#jump back to reading line fromfile

notify:
	la $a0, doneReadingLine
	li $v0, 4
	syscall
	jr $ra

.globl endProgram
endProgram:

   
jal closeEditingFile

#PLAY THE SOUND
	li $v0,33
	li $a0, 60
	li $a1, 100
	li $a2, 10
	li $a3, 100
	syscall
	
	li $v0,33
	li $a0, 65
	li $a1, 700
	li $a2, 10
	li $a3, 100
	syscall
	
li $v0, 10
syscall
