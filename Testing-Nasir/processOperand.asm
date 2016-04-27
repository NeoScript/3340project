.data

#Registers
constZeroInt:	.asciiz "$0"
constZeroStr:	.asciiz "$zero"

assemblerTemp:	.asciiz "$at"

vZero:		.asciiz "$v0"
vOne:		.asciiz "$v1"

argZero:	.asciiz "$a0"
argOne:		.asciiz "$a1"
argTwo:		.asciiz "$a2"

tempZero:	.asciiz "$t0"
tempOne:	.asciiz "$t1"
tempTwo:	.asciiz "$t2"
tempThree:	.asciiz "$t3"
tempFour:	.asciiz "$t4"
tempFive:	.asciiz "$t5"
tempSix:	.asciiz "$t6"
tempSeven:	.asciiz "$t7"

savedTempZero:	.asciiz "$s0"
savedTempOne:	.asciiz "$s1"
savedTempTwo:	.asciiz	"$s2"
savedTempThree:	.asciiz "$s3"
savedTempFour:	.asciiz "$s4"
savedTempFive:	.asciiz	"$s5"
savedTempSix:	.asciiz "$s6"
savedTempSeven:	.asciiz	"$s7"

tempEight:	.asciiz "$t8"
tempNine:	.asciiz "$t9"

kernelZero:	.asciiz "$k0"
kernelOne:	.asciiz "$k1"

globalPointer:	.asciiz	"$gp"
stackPointer:	.asciiz "$sp"
framePointer:	.asciiz	"$fp"
returnAddress:	.asciiz	"$ra"


#Register values - in binary
# TODO: convert the registers to binary representations (5 bit representations)
constZeroIntVal:	.asciiz "00000"
constZeroStrVal:	.asciiz "00000"

assemblerTempVal:	.asciiz "00001"

vZeroVal:		.asciiz "00010"
vOneVal:		.asciiz "00011"

argZeroVal:		.asciiz "00100"
argOneVal:		.asciiz "00101"
argTwoVal:		.asciiz "00110"
argThreeVal:		.asciiz "00111"

tempZeroVal:		.asciiz "01000"
tempOneVal:		.asciiz "01001"
tempTwoVal:		.asciiz "01010"
tempThreeVal:		.asciiz "01011"
tempFourVal:		.asciiz "01100"
tempFiveVal:		.asciiz "01101"
tempSixVal:		.asciiz "01110"
tempSevenVal:		.asciiz "01111"

savedTempZeroVal:	.asciiz "10000"
savedTempOneVal:	.asciiz "10001"
savedTempTwoVal:	.asciiz "10010"
savedTempThreeVal:	.asciiz "10011"
savedTempFourVal:	.asciiz	"10100"
savedTempFiveVal:	.asciiz "10101"
savedTempSixVal:	.asciiz	"10110"
savedTempSevenVal:	.asciiz "10111

tempEightVal:		.asciiz "11000"
tempNineVal:		.asciiz "11001"

kernelZeroVal:		.asciiz "11010"
kernelOneVal:		.asciiz "11011"

globalPointerVal:	.asciiz	"11100"
stackPointerVal:	.asciiz "11101"
framePointerVal:	.asciiz	"11110"
returnAddressVal:	.asciiz	"11111"




#Parrallel Arrays
operations: 	.word constZeroInt, constZeroStr, assemblerTemp, vZero, vOne, argZero, argOne, argTwo, argThree, tempZero, tempOne, tempTwo, tempThree, tempFour, tempFive, tempSix, tempSeven, savedTempZero, savedTempOne, savedTempTwo, savedTempThree, savedTempFour, savedTempFive, savedTempSix, savedTempSeven, tempEight, tempNine, kernelZero, kernelOne, globalPointer, stackPointer, framePointer, returnAddress #we will search this array
operationType: 	.word constZeroIntVal, constZeroStrVal, assemblerTempVal, vZeroVal, vOneVal, argZeroVal, argOneVal, argTwoVal, argThreeVal, tempZeroVal, tempOneVal, tempTwoVal, tempThreeVal, tempFourVal, tempFiveVal, tempSixVal, tempSevenVal, savedTempZeroVal, savedTempOneVal, savedTempTwoVal, savedTempThreeVal, savedTempFourVal, savedTempFiveVal, savedTempSixVal, savedTempSevenVal, tempEightVal, tempNineVal, kernelZeroVal, kernelOneVal, globalPointerVal, stackPointerVal, framePointerVal, returnAddressVal 

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
