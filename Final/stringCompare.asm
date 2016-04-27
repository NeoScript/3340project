.data
newlineChar: .asciiz "\n"

.text
# -----------------------------------------------------------------------------
# Module Name: StrCat
# Description: String Catenate function written in MIPS
# Input Params:  The address of the source string in $a0
#		 The address of the destination string in $a1 
# Return values: none
# -----------------------------------------------------------------------------
.globl StrCat
StrCat:
	lb $t0, newlineChar				# will store the newline character in for comparison		
							# a1 points to the beginning of the dest string.
							# Adjust it to point to the end (NULL)
findEndLoop:
	lbu		$t1,0($a1)		# Load a byte from the string
	beq		$t1,$0,endExit		# If it is NULL, exit
	beq	$t1, $t0, endExit 		#if it is the newline character, exit
	addi	$a1,$a1,1
	b		findEndLoop
endExit:					
							# Now a0 holds the address of the beginning of
							# the source string, and a1 holds the address of
							# the NULL at the end of the destination string.
appendLoop:
	lbu		$t1,0($a0)		# Load a byte from the source string.
	sb		$t1,0($a1)		# Store it in at the end of the destination 
	beq		$t1,$0,catExit	# string. Terminate if the NULL was just moved. 
	addi	$a0,$a0,1		# Increment both addresses.
	addi	$a1,$a1,1
	b		appendLoop
	
catExit:
	jr		$ra

        
.globl StrCmp
 StrCmp:
	lbu		$t0,0($a0)		# Load a byte from the first source string.
	lbu		$t1,0($a1)		# Load a byte from the second source string.
	 
							# Compare the two characters loaded.
	blt		$t0,$t1,Minus	# Return -1 if the first is < the second. 
	bgt		$t0,$t1,Plus	# Return +1 if the first is > the second.
							# Both characters are the same.
	beqz	$t1,Zero		# Return 0 if both are equal to NULL

continue:					# o/w Increment both addresses and continue.
	addi	$a0,$a0,1		
	addi	$a1,$a1,1
	b		StrCmp

Minus:						# returned if s1 < s2
	li		$v0,-1
	jr		$ra
	
Plus:						# returned if s1 > s2
	li		$v0,1
	jr		$ra
	
Zero:						# returned if s1 == s2
	li		$v0,0
	jr		$ra

