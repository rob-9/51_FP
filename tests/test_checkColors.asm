# Test checkColors function
.include "../fp_roberj4.asm"
.include "../fp_helpers.asm"

.text
.globl main

main:
    # Test 1: Valid colors
    li $a0, 0xF    # pc_bg
    li $a1, 0xF    # pc_fg  
    li $a2, 0xF    # gc_bg
    li $a3, 0xF    # gc_fg
    
    addi $sp, $sp, -4
    li $t0, 0x4    # err_bg
    sw $t0, 0($sp)
    
    jal checkColors
    addi $sp, $sp, 4
    
    # Expected: v0 = 0xFA35, v1 = 0x4
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
    
    # Test 2: Invalid colors (err_bg same as gc_fg)
    li $a0, 0xC    # pc_bg
    li $a1, 0x0    # pc_fg
    li $a2, 0xA    # gc_bg
    li $a3, 0x9    # gc_fg
    
    addi $sp, $sp, -4
    li $t0, 0x9    # err_bg (same as gc_fg)
    sw $t0, 0($sp)
    
    jal checkColors
    addi $sp, $sp, 4
    
    # Expected: v0 = 0xFFFF, v1 = 0xFF
    move $a0, $v0
    li $v0, 34
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    
    move $a0, $v1
    li $v0, 34
    syscall
    
    # Exit
    li $v0, 10
    syscall
