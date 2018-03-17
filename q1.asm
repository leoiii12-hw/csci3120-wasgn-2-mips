# int foo = 100;
# int [] A;
# int [] B;
# A = new int [10];
# B = new int [foo];


addi $sp, $sp, -4	# Follow the convention of the lecture note
			# for the stack machine where $sp points
			# to the next location in the stack.

addi $sp, $sp, -12	# Reserve space for
li   $t0, 100
sw   $t0, 12($sp)	# foo
sw   $0, 8($sp)		# A
sw   $0, 4($sp)		# B


# To allocate space for A[]
li $a0, 44		# 4 + 4 * 10 = 44 byte
li $v0, 9		# service 9 = sbrk (allocate heap memory)
syscall			# address of the allocated space is now in $v0

sw $v0, 8($sp)		# store address of A in stack
li $t0, 10
sw $t0, 0($v0)		# store size of A

# To initialize A[]
lw $a0, 8($sp)
jal arrayInitialize


# To allocate space for B[]
lw $t0, 12($sp)
mul $t0, $t0, 4
addi $t0, $t0, 4

add $a0, $0, $t0 	# 4 + 4 * 100 = 404 byte
li $v0, 9		# service 9 = sbrk (allocate heap memory)
syscall			# address of the allocated space is now in $v0

sw $v0, 4($sp)		# store address of B in stack
lw $t0, 12($sp)
sw $t0, 0($v0)		# store size of B

# To initialize B[]
lw $a0, 4($sp)
jal arrayInitialize


# Terminate
j exit


# Function arrayInitialize(a0 = arrayAddress)
arrayInitialize:
    # save
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # initialize values
    li $t0, 1		# index
    lw $t1, 0($a0)	# length
	
arrayInitializeLoop:
    bgt $t0, $t1, arrayInitializeExit
    
    addi $a0, $a0, 4
    li $t2, 0		# initValue
    sw $t2, 0($a0)
    
    addi $t0, $t0, 1
    j arrayInitializeLoop
    
arrayInitializeExit:
    # restore
    lw  $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra

exit:
    li $v0, 10
    syscall