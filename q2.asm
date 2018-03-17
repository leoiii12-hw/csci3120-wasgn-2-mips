.data 
    array: .word 6, 1, 2, 3, 4, 5, 6
    
.text

addi $sp, $sp, -4	# Follow the convention of the lecture note
			# for the stack machine where $sp points
			# to the next location in the stack.

addi $sp, $sp, -4	# Reserve space for
sw $0, 4($sp)		# B

la $t0, array		# load address
sw $t0, 4($sp)		# store address of B in stack

lw $a0, 4($sp)
jal sum

j exit

# Function sum(a0 = arrayAddress)
sum:
    # save
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # initialize values
    li $t0, 1		# index
    lw $t1, 0($a0)	# length
    li $t2, 0		# sum
	
sumLoop:
    bgt $t0, $t1, sumExit
    
    addi $a0, $a0, 4
    lw $t3, 0($a0)
    add $t2, $t2, $t3
    
    addi $t0, $t0, 1
    j sumLoop
    
sumExit:
    # restore
    lw  $ra, 0($sp)
    addi $sp, $sp, 4
    
    # return
    move $a0, $t2
    
    jr $ra

exit:
    li $v0, 10
    syscall