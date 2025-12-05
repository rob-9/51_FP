# Test checkColors function
.include "../fp_roberj4.asm"
.include "../fp_helpers.asm"

.text
.globl main

main:
    # valid
    li $a0, 0xF    # pc_bg
    li $a1, 0xF    # pc_fg  
    li $a2, 0x3    # gc_bg
    li $a3, 0x5    # gc_fg
    
    addi $sp, $sp, -4
    li $t0, 0x4    # err_bg
    sw $t0, 0($sp)
    
    jal checkColors
    addi $sp, $sp, 4
    
    move $a0, $v0
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    
    move $a0, $v1
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, '\n'
    syscall
    
    # invalid
    li $a0, 0xC    # pc_bg
    li $a1, 0x0    # pc_fg
    li $a2, 0xA    # gc_bg
    li $a3, 0x9    # gc_fg
    
    addi $sp, $sp, -4
    li $t0, 0x9    # err_bg (same as gc_fg)
    sw $t0, 0($sp)
    
    jal checkColors
    addi $sp, $sp, 4
    
    move $a0, $v0
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    
    move $a0, $v1
    li $v0, 34
    syscall
    
    li $v0, 10
    syscall
