.text
.globl main

list_sum: 
# arguments
# list : $a0
# Computes the sum of all values in a linked list.
# returns
# sum : $v0
  li $v0, 0 # sum : $v0 = 0
  move $t0, $a0 # current_node_ptr: $t0 = list
  j cond
  loop:
    lh $t1, 4($t0) # current_val = *(current_node_ptr + 4) 
    add $v0, $v0, $t1 # sum += current_val
    lw $t0, 0($t0) # current_node_ptr = *(current_node_ptr)
  cond: 
    bne $t0, $zero, loop
  jr $ra


print_list: 
# arguments
# list : $a0
# Prints all values in a linked list.
# no returns
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  addi $sp, $sp, -4
  sw $a0, 0($sp)
  move $t0, $a0 # current_node_ptr: $t0 = list
  j pl_cond
  pl_loop:
    lh $t1, 4($t0) # current_val = *(current_node_ptr + 4) 
    move $a0, $t1 
    jal print_int
    jal print_comma
    lw $t0, 0($t0) # current_node_ptr = *(current_node_ptr)
  pl_cond: 
    bne $t0, $zero, pl_loop

  jal print_newline

  lw $a1, 0($sp)
  addi $sp, $sp, 4

  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

print_int:
# arguments
# x : $a0
# Prints x.
# no returns
  li $v0, 1 # print_int syscall code
  syscall
  jr $ra

print_newline:
# no arguments
# Prints a newline.
# no returns
  li $a0, 10 # '\n'
  li $v0, 11 # print_char
  syscall  
  jr $ra

print_comma:
# no arguments
# Prints ", "
# no returns 
  la $a0, comma
  li $v0, 4 # print_string
  syscall # print_string(comma)
  jr $ra


main:
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  la $a0, node0
  jal print_list
  la $a0, node0
  jal list_sum 
  move $a0, $v0
  jal print_int
  jal print_newline

  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra


.data
node0: 
  .word node1
  .half 10
.space 2
node1: 
  .word node2
  .half 11
.space 2
node2: 
  .word node3
  .half 10
.space 2
node3: 
  .word 0
  .half 11
.space 2
comma: .asciiz ", "
