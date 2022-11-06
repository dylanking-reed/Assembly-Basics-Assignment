.text
.globl main

fibonacci:    
  # Computes the nth fibonacci number. n is stored in $a0 and the result is stored in $v0.
  li $t0, 1 # $t0 = 1
  li $v0, 1 # $v0 = 1
  li $t1, 0 # $t1 = 0 : loop counter
  j cond
  compute_next:
  move $t2, $t0      # $t2 = $t0
  add $t0, $t0, $v0  # $t0 += $v0
  move $v0, $t2      # $v0 = $t2
  addi $t1, $t1, 1   # $t1 += 1
  cond:
  blt $t1, $a0, compute_next # if i < n goto compute_next 
  jr $ra
  
main:
  li $a0, 5
  jal fibonacci
  move $a0, $v0
  li $v0, 1 # print_int
  syscall
exit:
  li $v0, 10 # exit
  syscall
  
  
