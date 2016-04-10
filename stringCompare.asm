
.globl StrCmp #make global

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
	j 		StrCmp

Minus:						# returned if s1 < s2
	li		$v0,-1
	jr		$ra
	
Plus:						# returned if s1 > s2
	li		$v0,1
	jr		$ra
	
Zero:						# returned if s1 == s1
	li		$v0,0
	jr		$ra
	.end
