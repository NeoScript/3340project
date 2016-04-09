	
.data        # Data declaration section
str1:   .asciiz "Hello World!\n"
str2:   .asciiz "Hello Wold!\n"

.text
.globl printStrComp

 printStrComp:   # Start of code section

        # Load the address of the message
        # into the $a0 register. Then load 4 into

        # the $v0 register to tell the processor
        # that you want to print a string.
        
        jal StrCmp
	
	add $a0, $t0, $zero  # load desired value into argument register $a0, using pseudo-op
        li $v0, 1
        syscall
        
        # Now do a graceful exit
        li $v0, 10
        syscall

   
.globl StrCmp:
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
	
Zero:						# returned if s1 == s1
	li		$v0,0
	jr		$ra
	.end
