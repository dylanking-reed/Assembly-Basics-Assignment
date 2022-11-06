.text
.globl main

fibonacci:    
  # Computes the nth fibonacci number. n is stored in $a0 and the result is stored in $v0.
  li $t0, 1 # $t0 = 1
  li $v0, 1 # $v0 = 1
  li $t1, 0 # $t1 = 0 : loop counter
  j cond
  compute_next:
  mov $t2, $t0       # $t2 = $t0
  add $t0, $t0, $v0  # $t0 += $v0
  mov $v0, $t2       # $v0 = $t2
  addi $t1, $t1, 1   # $t1 += 1
  cond:
  blt $t1, $a0, compute_next # if i < n goto compute_next 
  jr $ra
  
main:
  jal fibonacci
  
  
