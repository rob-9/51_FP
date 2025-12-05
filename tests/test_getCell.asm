# test getCell function
.include "../fp_roberj4.asm"
.include "../fp_helpers.asm"

.text
.globl main

main:
    # set test cell
    li $a0, 2
    li $a1, 1
    li $a2, 7
    li $a3, 0xA5
    jal setCell
    
    # get cell
    li $a0, 2
    li $a1, 1
    jal getCell
    move $a0, $v0
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    move $a0, $v1
    li $v0, 1
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    
    # empty cell
    li $a0, 0
    li $a1, 0
    jal getCell
    move $a0, $v0
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    move $a0, $v1
    li $v0, 1
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    
    # invalid bounds
    li $a0, -1
    li $a1, 1
    jal getCell
    move $a0, $v0
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    move $a0, $v1
    li $v0, 1
    syscall
    
    li $v0, 10
    syscall