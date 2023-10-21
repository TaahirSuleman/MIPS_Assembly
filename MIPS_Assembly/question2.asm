.data                   #Declare memory and constants
    prompt:     .asciiz "Enter a sum:\n"
    output:     .asciiz "The value is:\n"
    str:        .space 18000 #allocates specified bytes to the str address.
    size:       .word   1000
.text           #Code section
.globl      main

# Taahir Suleman -- 11/10/2022
# Program that reads in a sum of positive integers and outputs the result

main:
    la      $a0, prompt #load address of the prompt string into $a0.
    li      $v0, 4 #used to print a string to the console with syscall.
    syscall
    #la      $s2,str

read:
    li      $v0, 8 # service code used for reading strings
    la      $a0, str    # indicates where to store the string sum inputted from the user
    li      $a1, 1000   # max bytes to be read in
    syscall
    la  $t0, str
    li  $t2, 0
    li  $t3, 1

multiply_sum:
    lb $t1, ($t0)
    addu $t0, $t0, 1
    lb $t4, ($t0)
    beq $t1, 10, output_result
    beq $t1, '+', plus_sign
    beq $t4, '+', no_multiply
    beq $t4, 10, no_multiply
    beq $t3, 1, sum
    #mul $t2, $t2, 10
    sub $t1, $t1, '0' 
    move $t5, $t0
    b multiply


sum:
    beq $t4, '+', no_multiply
    beq $t4, 10, no_multiply
    sub $t1, $t1, '0' 
    move $t5, $t0
    b multiply

no_multiply:
    sub $t1, $t1, '0' 
    add $t2, $t2, $t1
    add $t3, $zero, $zero
    b multiply_sum

multiply:
    mul $t1, $t1, 10
    addu $t0, $t0, 1
    lb $t4, ($t0)
    beq $t4, 10, add_value
    bne $t4, '+', multiply
    move $t0, $t5

add_value:
    add $t2, $t2, $t1
    add $t3, $zero, $zero
    b multiply_sum

plus_sign:
    li  $t3, 1
    b multiply_sum




output_result:
    la      $a0, output
    li      $v0, 4
    syscall
    move     $a0, $t2
    li      $v0, 1
    syscall




exit:
    li      $v0, 10 # code used for the exit syscall.
    syscall