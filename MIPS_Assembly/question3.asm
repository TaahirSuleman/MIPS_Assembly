.data       #Declare memory and constants
    prompt:     .asciiz "Enter n and formulae:\n"
    output:     .asciiz "The values are:\n"
    str:        .space 20000 #allocates specified bytes to the str address.
    array:      
        .align 2 # ensures the array is properly aligned
        .space  800
    #size:       .word   20
.text       #Code section
.globl      main

# Taahir Suleman -- 13/10/2022
# Program that reads in a sum of positive integers and outputs the result

main:
    la      $a0, prompt #load address of the prompt string into $a0.
    li      $v0, 4 #used to print a string to the console with syscall.
    syscall
    li      $v0, 5 #used for the read integer syscall.
    syscall
    addi    $s0, $v0, 0
    add     $t0,$zero,$zero     # t0 used to store the index of array, starting at 0
    addi    $t1,$zero,1         # sets register t1 to store a counter initialised as 1
    la      $s2,str             # loads string storage address to register s2
    la      $s3,str
    li      $t4, 0              # used to store the running sum
    
read:
    bgt     $t1,$s0, print # if the counter is > the array length, the end of the array has been reached and we branch to output_reverse. This is the exit condition of the loop.
    # retrieve one line of text inputted from the user at a time.
    move    $a0, $s2    # indicates where to store the string inputted from the user
    li      $a1,20      # gives the max number of characters to read from the input string
    li      $v0,8       # loads the service code for reading a string into register v0
    syscall             # reads at most 20 characters of the inputted string into register s2
    move    $t2, $s2
    lb      $t3, ($t2)
    beq     $t3, '=', equals
    sw      $a0,array($t0)
    addi    $t0,$t0,4           # increment offset by one word
    addi    $t1,$t1,1           # increment counter by 1
    addi    $s2,$s2,20          # incrememnt string storage area by max bytes used by previous string
    b       add_value



equals:
    addi    $t2, $t2, 1
    lb      $t5, ($t2)
    sub     $t5, $t5, '0'
    mul     $t5, $t5, 4
    lw      $t7, array($t5)
    sw      $t7, array($t0)
    addi    $t0,$t0,4           # increment offset by one word
    addi    $t1,$t1,1           # increment counter by 1
    addi    $s2,$s2,20          # increment string storage area by max bytes used by previous string
    la      $t2, ($t7)
    b       add_value



add_value:
    lb      $t3, ($t2)
    addi    $t2, $t2, 1
    beq     $t3, 10, add_total
    sub     $t3, $t3, '0'
    mul     $t8, $t8, 10
    add     $t8, $t8, $t3
    b add_value

add_total:
    add     $t4, $t4, $t8
    add     $t8, $zero, $zero
    b read

print:
    # prints "The values are:" to the console
    la      $a0,output
    li      $v0,4
    syscall
    add     $t0, $zero, $zero   # sets array index to 0
    addi    $t1, $zero, 1       # sets counter equal to 1

loop:
    bgt     $t1,$s0, answer
    lw      $t2,array($t0)
    move    $a0,$t2
    li      $v0,4
    syscall
    addi    $t0,$t0,4           # increment array index by one word
    addi    $t1,$t1,1           # increment counter by 1
    j loop


answer:
    li      $v0, 1
    move    $a0, $t4
    syscall

exit:
    li      $v0, 10 # code used for the exit syscall.
    syscall