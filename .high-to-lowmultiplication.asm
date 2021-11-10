#POP and PUSH macros shamelessly stolen from examples. As always inspired by more competent students

.macro	PUSH (%reg)
	addi	$sp,$sp,-4              # decrement stack pointer (stack builds "downwards" in memory)
	sw	    %reg,0($sp)             # save value to stack
.end_macro

.macro	POP (%reg)
	lw	    %reg,0($sp)             # load value from stack to given registry
	addi	$sp,$sp,4               # increment stack pointer (stack builds "downwards" in memory)
.end_macro

.data
new:     .asciiz "\n"
.text

main: 
	#multiplication
	li $a0, 20
	li $a1, 1
	
	jal multiply
	move $a3, $v1
	li $v0, 1
	syscall
	
	#newline
    	li      $v0, 4                  # magic code to print string
    	la      $a0, new                 # load address of string HW into $a0
    syscall    
	
	#faculty
	li $a0, 5
	jal faculty
	
	
	final:
	move $a0, $s4
	li $v0, 1
	syscall
	
	#exit program DO NOT DELETE AGAIN
	li $v0, 10
	syscall
	
multiply:
	PUSH($s0)
	PUSH($s1)
	move $s0, $a0 
	move $s1, $a1
	 
	li $t0, 0  # int i = 0
	
	loopy:
		add $v1, $v1, $s1
		addi $t0,$t0,1     # increment loop index
 		bne $t0,$s0,loopy  # if $t2, loop 
  	
  	end:
  		POP($s0)
  		POP($s1)
  		jr $ra

faculty:
	PUSH($s3)
	li	$v1, 0 
	li	$s3, 0
	li	$s4, 1
	move 	$t2, $a0 # int i = 0
	
	dirtyLoops:
		add	$s3,$s3, 1
		move	$a0,$s3
		move	$a1,$s4
		jal 	multiply
		move	$s4,$v1
		li $v1, 0
		bne $t2,$s3, dirtyLoops  # if $t2, loop 		
		
	fin:
		POP ($s3)
	
		j final
