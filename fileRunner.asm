
# This file is made to demonstrate test cases
		
.data        # Data declaration section
str1:   .asciiz "Hello World!\n"
str2:   .asciiz "Hello World!\n"

.text

.globl main
main:
	la $a0, str1 ## load the fir
        la $a1, str2
        
        jal printStrCmp ## you can also call strComp directly if you don't want to print to console
