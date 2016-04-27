
.data
output_file_name:   .asciiz "output.txt"      
buffer: .asciiz "The quick brown fox jumps over the lazy dog."
file_descriptor: .word 0

.text

	
.globl openFileToWrite
openFileToWrite:	
  # Open (for writing) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, output_file_name     # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  sw $v0, file_descriptor   # save the file descriptor 
  jr $ra
  
 .globl write
 # a1: address of buffer from which to write
 # a2: buffer length
 write:
  # Write to file just opened
  li   $v0, 15       # system call for write to file
  lw $a0, file_descriptor      # file descriptor 
  syscall            # write to file
  jr $ra
  
.globl closeEditingFile
closeEditingFile:
  # Close the file 
  li   $v0, 16       # system call for close file
  lw $a0, file_descriptor      # file descriptor to close
  syscall            # close file
  jr $ra
