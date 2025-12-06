# Robert Ji
# roberj4

.text

##########################################
#  EC Functions
##########################################
setWinBoard:
	# void setWinBoard(CColor c)
	# a0: CColor data structure
	
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	
	move $s0, $a0
	
	# extract colors
	andi $s1, $s0, 0xFF
	srl $s2, $s0, 8
	andi $s2, $s2, 0xFF
	
	# set row 4
	li $s3, 0
swb_row4_loop:
	li $a0, 4
	move $a1, $s3
	jal getCell
	bltz $v1, swb_row4_next
	
	li $a0, 4
	move $a1, $s3
	li $a2, -1
	move $a3, $s2
	jal setCell
	
swb_row4_next:
	addi $s3, $s3, 1
	blt $s3, 9, swb_row4_loop
	
	# set col 4
	li $s3, 0
swb_col4_loop:
	beq $s3, 4, swb_col4_next
	
	move $a0, $s3
	li $a1, 4
	jal getCell
	bltz $v1, swb_col4_next
	
	move $a0, $s3
	li $a1, 4
	li $a2, -1
	move $a3, $s2
	jal setCell
	
swb_col4_next:
	addi $s3, $s3, 1
	blt $s3, 9, swb_col4_loop
	
	# set main diag
	li $s3, 1
swb_diag1_loop:
	beq $s3, 4, swb_diag1_next
	beq $s3, 8, swb_diag1_done
	
	move $a0, $s3
	move $a1, $s3
	jal getCell
	bltz $v1, swb_diag1_next
	
	move $a0, $s3
	move $a1, $s3
	li $a2, -1
	move $a3, $s1
	jal setCell
	
swb_diag1_next:
	addi $s3, $s3, 1
	blt $s3, 8, swb_diag1_loop
swb_diag1_done:
	
	# set anti-diag
	li $s3, 1
swb_diag2_loop:
	beq $s3, 4, swb_diag2_next
	beq $s3, 8, swb_diag2_done
	
	li $t0, 8
	sub $s4, $t0, $s3
	
	move $a0, $s3
	move $a1, $s4
	jal getCell
	bltz $v1, swb_diag2_next
	
	move $a0, $s3
	move $a1, $s4
	li $a2, -1
	move $a3, $s1
	jal setCell
	
swb_diag2_next:
	addi $s3, $s3, 1
	blt $s3, 8, swb_diag2_loop
swb_diag2_done:
	
	lw $s4, 0($sp)
	lw $s3, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra


saveBoard:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	srl $s2, $s1, 8
	andi $s2, $s2, 0xFF
	andi $s3, $s1, 0xFF
	
	andi $s4, $s2, 0x0F
	andi $s5, $s3, 0x0F
	
	li $v0, 13
	move $a0, $s0
	li $a1, 1
	li $a2, 0
	syscall
	move $s6, $v0
	bltz $s6, sb_error
	
	li $s7, 0
	li $t8, 0
	
	addi $sp, $sp, -8
	li $t0, 0
	
sb_row_loop:
	li $t1, 0
	
sb_col_loop:
	move $a0, $t0
	move $a1, $t1
	
	addi $sp, $sp, -8
	sw $t0, 4($sp)
	sw $t1, 0($sp)
	
	jal getCell
	lw $t1, 0($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	
	li $t2, -1
	beq $v1, $t2, sb_error_close
	beqz $v1, sb_next_cell
	
	li $t2, 1
	blt $v1, $t2, sb_error_close
	li $t2, 9
	bgt $v1, $t2, sb_error_close
	
	andi $t3, $v0, 0x0F
	bne $t3, $s4, sb_check_game
	li $t4, 'P'
	addi $s7, $s7, 1
	j sb_write_cell
	
sb_check_game:
	bne $t3, $s5, sb_error_close
	li $t4, 'G'
	addi $t8, $t8, 1

sb_write_cell:
	addi $t5, $t0, 0x30
	addi $t6, $t1, 0x41
	addi $t7, $v1, 0x30
	
	move $t9, $sp
	sb $t5, 0($t9)
	sb $t6, 1($t9)
	sb $t7, 2($t9)
	sb $t4, 3($t9)
	li $t5, '\n'
	sb $t5, 4($t9)
	
	li $v0, 15
	move $a0, $s6
	move $a1, $t9
	li $a2, 5
	syscall
	bltz $v0, sb_error_close
	
sb_next_cell:
	addi $t1, $t1, 1
	li $t2, 9
	blt $t1, $t2, sb_col_loop
	
	addi $t0, $t0, 1
	li $t2, 9
	blt $t0, $t2, sb_row_loop
	
	li $v0, 16
	move $a0, $s6
	syscall
	
	addi $sp, $sp, 8
	
	move $v0, $s7
	move $v1, $t8
	j sb_done

sb_error_close:
	li $v0, 16
	move $a0, $s6
	syscall
	addi $sp, $sp, 8

sb_error:
	li $v0, -1
	li $v1, -1

sb_done:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	jr $ra

hint:
	# halfword hint(char[] move, CColor playerColors)
	# $a0: move string
	# $a1: playerColors
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	sw $s6, 0($sp)
	
	move $s0, $a0    # move string
	move $s1, $a1    # playerColors
	
	# extract preset fg color
	srl $s2, $s1, 4
	andi $s2, $s2, 0xF
	
	# parse move to get row, col using getBoardInfo
	move $a0, $s0
	li $a1, 0        # flag = 0 for row/col
	jal getBoardInfo
	bltz $v0, hint_error
	move $s3, $v0    # row
	move $s4, $v1    # col
	
	# check if target cell is valid
	blt $s3, 0, hint_error
	bge $s3, 9, hint_error
	blt $s4, 0, hint_error
	bge $s4, 9, hint_error
	
	# get cell at target position
	move $a0, $s3
	move $a1, $s4
	jal getCell
	bltz $v1, hint_error
	
	# if cell has value, check if it's a preset cell
	beqz $v1, hint_calculate
	andi $t0, $v0, 0xF    # fg color
	beq $t0, $s2, hint_error    # preset cell
	
hint_calculate:
	# calculate valid moves using check function
	li $s5, 0    # result bitmask
	li $s6, 1    # test value
	
hint_test_loop:
	bgt $s6, 9, hint_done_calc
	
	# test if this value can be placed
	move $a0, $s3    # row
	move $a1, $s4    # col
	move $a2, $s6    # value to test
	li $a3, 0        # dummy error color
	li $t0, 0        # flag = 0 for complete check
	
	# save stack pointer for nested calls
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal check
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	# if check returns 0, value is valid
	beqz $v0, hint_valid_value
	j hint_next_value
	
hint_valid_value:
	# set bit for this value (bit position = value)
	li $t0, 1
	sllv $t0, $t0, $s6
	or $s5, $s5, $t0
	
hint_next_value:
	addi $s6, $s6, 1
	j hint_test_loop
	
hint_done_calc:
	move $v0, $s5
	j hint_done
	
hint_error:
	li $v0, 0xFFFF
	
hint_done:
	lw $s6, 0($sp)
	lw $s5, 4($sp)
	lw $s4, 8($sp)
	lw $s3, 12($sp)
	lw $s2, 16($sp)
	lw $s1, 20($sp)
	lw $s0, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	jr $ra
