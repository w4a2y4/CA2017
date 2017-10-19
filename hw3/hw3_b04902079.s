.data
	input_n:
		.word	0
	input_c:
		.word	0
	operater:
		.word	0
	output_ascii:
		.byte	'X', 'X', 'X', 'X'

# TODO : change the file name/path to access the files
# NOTE : Before you submit the code, make sure these two fields are "input.txt" and "output.txt"
	file_in:
		.asciiz	"/Users/w4a2y4/Desktop/CA/CA2017/hw3/input.txt"
	file_out:
		.asciiz	"/Users/w4a2y4/Desktop/CA/CA2017/hw3/output.txt"


.text
	main:    #start of your program

#STEP1: open input file
# ($s0: fd_in)

	li	$v0, 13			# 13 = open file
	la	$a0, file_in	# $a2 <= filepath

	# NOTE: this syscall is system-dependent
	# 0x4000 is _O_TEXT in Windows, but it's invalid in Linux
	# (io.h) for Windows, (fcntl-linux.h) for Linux
	# For Linux, 0x0000 (O_RDONLY) should be used instead
	li	$a1, 0x4000		# $a1 <= flags = 0x4000 for Windows, 0x0000 for Linux
	li	$a2, 0			# $a2 <= mode = 0
	syscall				# $v0 <= $s0 = fd
	move	$s0, $v0	# store fd_in in $s0, fd_in is the file descriptor just returned by syscall

#STEP2: read inputs (chars) from file to registers
# ($s1: input_n, $s2: input_c)

#   2 bytes for the first operand
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0	# $a0 <= fd_in
	la	$a1, input_n		# $a1 <= input1
	li	$a2, 2			# read 2 bytes to the address given by input1
	syscall

#   1 byte for ","
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0	# $a0 <= fd_in
	la	$a1, operater	# $a1 <= operater
	li	$a2, 1			# read 1 bytes to the address given by operater
	syscall

#   2 bytes for the second operand
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0	# $a0 <= fd_in
	la	$a1, input_c	# $a1 <= input2
	li	$a2, 2			# read 2 bytes to the address given by input2
	syscall

#STEP3: turn the chars into integers

	la	$a0, input_n
	bal	atoi
	move	$s1, $v0	# $s0 <= atoi(input_n)

	la	$a0, input_c
	bal	atoi	 
	move	$s2, $v0	# $s1 <= atoi(input_c)

	# set arguments for recursion
	move	$a0, $s1
	move	$a1, $s2
	jal T
	move	$s4, $v0
	j result


T:
	bgt	$a0, 1, recurse
	# if n < 2, return c
	move	$v0, $a1
	jr	$ra

recurse:
	# alloc sp & store $ra and $a0
	sub $sp, $sp, 8
	sw $ra, 0($sp) 
	sw $a0, 4($sp)

	# n = n/2
	srl $a0, $a0, 1
	# call functionT !
	jal T

	# retrieve $ra and $a0 & restore sp
	lw $ra, 0($sp) 
	lw $a0, 4($sp)
	addi $sp, $sp, 8

	# do the calculate
	sll $t0, $v0, 1		# t0 <- T(n/2)*2
	mult $a0, $a1		# t1 <- n * c
	mflo $t1
	add $v0, $t0, $t1
	
	jr $ra


#STEP5: turn the integer into pritable char
result:
	move	$a0, $s4
	bal	itoa		# itoa($s4)
	j	ret

itoa:
    # Input: ($a0 = input integer)
    # Output: ( output_ascii )
    addi    $t0, $zero, 10	# divider
    addi    $a1, $zero, 4	# counter
    la      $v0, output_ascii
    addi    $v0, $v0, 3		# the first byte

    loop:
        addi    $a1, $a1, -1
        div     $a0, $t0
        mflo    $a0				# num /= 10
        mfhi    $t1				# num % 10 => $t1
        addi    $t1, $t1, 48	# convert to ascii
        sb      $t1, 0($v0)
        addi    $v0, $v0, -1	# shift one byte each time
        bne     $a1, $zero, loop

    jr  $ra     # return


ret:

#STEP6: write result (output_ascii) to file_out
# ($s4 = fd_out)

	li	$v0, 13			# 13 = open file
	la	$a0, file_out	# $a2 <= filepath
	li	$a1, 0x4301		# $a1 <= flags = 0x4301 for Windows, 0x41 for Linux
	li	$a2, 0x1a4		# $a2 <= mode = 0
	syscall				# $v0 <= $s0 = fd_out
	move	$s4, $v0	# store fd_out in $s4

	li	$v0, 15			# 15 = write file
	move	$a0, $s4	# $a0 <= $s4 = fd_out
	la	$a1, output_ascii
	li	$a2, 4
	syscall				# $v0 <= $s0 = fd


#STEP8: close file_in and file_out

	li	$v0, 16			# 16 = close file
	move	$a0, $s0	# $a0 <= $s0 = fd_in
	syscall				# close file

	li	$v0, 16			# 16 = close file
	move	$a0, $s4	# $a0 <= $s4 = fd_out
	syscall				# close file

	j exit


exit:

	li	$v0, 10
	syscall



#######################################################################################
#
#  int atoi ( const char *str );
#
#  Parse the cstring str into an integral value
#
#  Author: http://stackoverflow.com/questions/9649761/mips-store-integer-data-into-array-from-file
atoi:
    	or      $v0, $zero, $zero   	# num = 0
   		or      $t1, $zero, $zero   	# isNegative = false
    	lb      $t0, 0($a0)
    	bne     $t0, '+', .isp      	# consume a positive symbol
    	addi    $a0, $a0, 1
.isp:
    	lb      $t0, 0($a0)
    	bne     $t0, '-', .num
    	addi    $t1, $zero, 1       	# isNegative = true
    	addi    $a0, $a0, 1
.num:
    	lb      $t0, 0($a0)
    	slti    $t2, $t0, 58        	# *str <= '9'
    	slti    $t3, $t0, '0'       	# *str < '0'
    	beq     $t2, $zero, .done
    	bne     $t3, $zero, .done
    	sll     $t2, $v0, 1
    	sll     $v0, $v0, 3
    	add     $v0, $v0, $t2       	# num *= 10, using: num = (num << 3) + (num << 1)
    	addi    $t0, $t0, -48
    	add     $v0, $v0, $t0       	# num += (*str - '0')
    	addi    $a0, $a0, 1         	# ++num
    	j   .num
.done:
    	beq     $t1, $zero, .out    	# if (isNegative) num = -num
    	sub     $v0, $zero, $v0	
.out:
    	jr      $ra         			# return
