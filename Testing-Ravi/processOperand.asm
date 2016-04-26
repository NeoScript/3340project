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
tempFour:	.asciiz "$t7"
tempFive:	.asciiz "$t5"
tempSix:	.asciiz "$t6"
tempSeven:	.asciiz "$t7"
savedTempOne:	.asciiz "$s0"
savedTempTwo:	.asciiz "$s1"
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
constZeroIntVal:	.asciiz "$0"
constZeroStrVal:	.asciiz "$zero"
assemblerTempVal:	.asciiz "$at"
vZeroVal:		.asciiz "$v0"
vOneVal:		.asciiz "$v1"
argZeroVal:		.asciiz "$a0"
argOneVal:		.asciiz "$a1"
argTwoVal:		.asciiz "$a2"
tempZeroVal:		.asciiz "$t0"
tempOneVal:		.asciiz "$t1"
tempTwoVal:		.asciiz "$t2"
tempThreeVal:		.asciiz "$t3"
tempFourVal:		.asciiz "$t7"
tempFiveVal:		.asciiz "$t5"
tempSixVal:		.asciiz "$t6"
tempSevenVal:		.asciiz "$t7"
savedTempOneVal:	.asciiz "$s0"
savedTempTwoVal:	.asciiz "$s1"
savedTempThreeVal:	.asciiz "$s3"
savedTempFourVal:	.asciiz "$s4"
savedTempFiveVal:	.asciiz	"$s5"
savedTempSixVal:	.asciiz "$s6"
savedTempSevenVal:	.asciiz	"$s7"
tempEightVal:		.asciiz "$t8"
tempNineVal:		.asciiz "$t9"
kernelZeroVal:		.asciiz "$k0"
kernelOneVal:		.asciiz "$k1"
globalPointerVal:	.asciiz	"$gp"
stackPointerVal:	.asciiz "$sp"
framePointerVal:	.asciiz	"$fp"
returnAddressVal:	.asciiz	"$ra"




#Parrallel Arrays
operations: 	.word constZeroInt,constZeroStr,assemblerTemp,vZero,vOne,argZero,argOne,argTwo,tempZero,tempOne,tempTwo,tempThree,tempFour,tempSix,tempSeven,savedTempOne,savedTempTwo,savedTempThree,savedTempFour,savedTempFive,savedTempSix,savedTempSeven,tempEight,tempNine,kernelZero,kernelOne,globalPointer,stackPointer,framePointer,returnAddress #we will search this array
operationType: 	.word constZeroIntVal,constZeroStrVal,assemblerTempVal,vZeroVal,vOneVal,argZeroVal,argOneVal,argTwoVal,tempZeroVal,tempOneVal,tempTwoVal,tempThreeVal,tempFourVal,tempSixVal,tempSevenVal,savedTempOneVal,savedTempTwoVal,savedTempThreeVal,savedTempFourVal,savedTempFiveVal,savedTempSixVal,savedTempSevenVal,tempEightVal,tempNineVal,kernelZeroVal,kernelOneVal,globalPointerVal,stackPointerVal,framePointerVal,returnAddressVal

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
