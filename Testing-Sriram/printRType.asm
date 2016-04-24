.text

.globl printRType

printRType:
#If Match, then send all necessary params to logOperand
	#li $v0, 4
	#move $a0, $s2 # print value at the array pointer
	#syscall 
	#li $v0, 4
	#move $a0, $s3 # print value at the array pointer
	#syscall 
	#li $v0, 4
	#move $a0, $s4 # print value at the array pointer
	#syscall 
	#li $v0, 4
	#move $a0, $s5 # print value at the array pointer
	#syscall 
	#li $v0, 4
	#move $a0, $s6 # print value at the array pointer
	#syscall 
 jr $ra