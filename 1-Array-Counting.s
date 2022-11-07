.text
.globl main

array_counts:
# arguments
# array  : $a0
# length : $a1
# lower  : $t0
# middle : $t1
# upper  : $t2
# program has undefined behavior if `lower < middle < upper` does not hold.
# returns
# amt of values in `array` in the interval (-infty, lower)  : $s0
# amt of values in `array` in the interval [lower , middle) : $s1
# amt of values in `array` in the interval [middle, upper)  : $s2
# amt of values in `array` in the interval [upper , infty)  : $s3
  move $t3, $a0      # current_elem   : $t3 = array : $a0
  li $t9, 4          # four           : $t9 = 4
  mul $t8, $a1, $t9  # length_in_bytes: $t8 = length * four
  add  $t4, $a0, $t8 # end            : $t4 = array : $a0 + length_in_bytes : $t8
  j loop_if_in_bounds
  increment_counts:
    lw $t5, 0($t3) # current_elem_value : $t5 = *current_elem
    
    slt $t6, $t5, $t0 # $t6 = current_elem_value < lower
    add $s0, $s0, $t6  # lowest += $t6
    bne $t6, $zero, continue_counting
 
    slt $t6, $t5, $t1 # $t6 = current_elem_value < middle  
    add $s1, $s1, $t6  # low += $t6
    bne $t6, $zero, continue_counting
   
    slt $t6, $t5, $t2 # $t6 = current_elem_value < upper  
    add $s2, $s2, $t6  # high += $t6
    bne $t6, $zero, continue_counting 

    addi $s3, $s3, 1
  continue_counting:
    addi $t3, $t3, 4 # current_elem: $t3 += 1
  loop_if_in_bounds:
    blt $t3, $t4, increment_counts
  jr $ra

print_int:
# arguments
# x : $a0
# Prints x.
# no returns
  li $v0, 1 # print_int syscall code
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

print_newline:
# no arguments
# Prints a newline.
# no returns
  li $a0, 10 # '\n'
  li $v0, 11 # print_char
  syscall  
  jr $ra

print_s0_thru_s3:
  # push $ra
  addi $sp, $sp, -4
  sw $ra, 0($sp) 

  move $a0, $s0
  jal print_int # print_int($s0)
  jal print_comma
  move $a0, $s1
  jal print_int # print_int($s1)
  jal print_comma
  move $a0, $s2
  jal print_int # print_int($s2)
  jal print_comma
  move $a0, $s3
  jal print_int # print_int($s3)
  jal print_newline

  # pop $ra
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra


main:
  # push $ra
  addi $sp, $sp, -4
  sw $ra, 0($sp) 

  la $a0, test_array
  li $a1, 10
  li $t0, 2 
  li $t1, 4 
  li $t2, 6 
  jal array_counts # array_counts(test_array, 10, 2, 4, 6)
  jal print_s0_thru_s3

  # pop $ra
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

# exit:
#   li $v0, 10 # exit
#   syscall
 
.data 

test_array: .word 0, 1, 2, 3, 4, 5, 6, 7 8, 9
comma: .asciiz ", "
