# This file is made to demonstrate test cases

	
			
.data        # Data declaration section
str1:   .asciiz "Hello Wold!\n"
str2:   .asciiz "Hello Wold!\n"

.text

main:
	la $a0, str1 ## load the fir
        la $a1, str2
        
        jal printStrComp ## you can also call strComp directly if you don't want to print to console