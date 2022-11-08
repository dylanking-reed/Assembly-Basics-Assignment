.text

swap:
# arguments
# ptr1 : $a0
# ptr2 : $a1
# swaps the values at the pointers.
# no returns
  lw $s0, 0($a0) # a = *ptr1
  lw $s1, 0($a1) # b = *ptr2
  sw $s0, 0($a1) # *ptr2 = a 
  sw $s1, 0($a0) # *ptr1 = b
  jr $ra 


array_permutation:
# arguments
# array : $a0
# permutations : $a1
# length : $a2
# Equivalent behavior to this C:
# for (int i = 0; i < length; i++) {
#   swap(&array[i], &array[permutations[i]]);
# }
# no returns
  addi $sp, $sp, -4
  sw $ra, 0($sp)


  li $t0, 0 # i : $t0 = 0   
  li $t4, 4 # $t4 = 4 
  j cond
  loop:
    addi $sp, $sp, -4
    sw $a0, 0($sp)

    addi $sp, $sp, -4
    sw $a1, 0($sp)
    
    mul $t1, $t0, $t4 # i_bytes : $t1 = i * 4
    add $a0, $a0, $t1 # &array[i] : $a0 = array + i_bytes
    add $t2, $a1, $t1 # &permutations[i] : $t2 = permutations + i_bytes
    lw $t3, 0($t2) # permutations[i] : $t3 = *$t2
    add $a1, $a0, $t3 # &array[permutations[i]] : $a1 = array + *(permutations + i_bytes)
    jal swap
    
    lw $a1, 0($sp)
    addi $sp, $sp, 4

    lw $a0, 0($sp)
    addi $sp, $sp, 4

    addi $t0, $t0, 1
  cond:
    blt $t0, $a2, loop    

  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
