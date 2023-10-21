.data       #Declare memory and constants
    prompt:     .asciiz "Enter n, followed by n lines of text:\n"
    output:     .asciiz "The values are:\n"
    str:        .space 18000 #allocates specified bytes to the str address.
    array:      
        .align 2 # ensures the array is properly aligned
        .space  80
    size:       .word   20
.text       #Code section
.globl      main

# Taahir Suleman -- 10/10/2022
# Program that reads in a specified number of strings and outputs them in reverse

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
    
read:
    bgt     $t1,$s0,output_reverse # if the counter is > the array length, the end of the array has been reached and we branch to output_reverse. This is the exit condition of the loop.
    # retrieve one line of text inputted from the user at a time.
    move    $a0, $s2    # indicates where to store the string inputted from the user
    li      $a1,20      # gives the max number of characters to read from the input string
    li      $v0,8       # loads the service code for reading a string into register v0
    syscall             # reads at most 20 characters of the inputted string into register s2
    
    sw      $a0,array($t0)
    addi    $t0,$t0,4           # increment offset by one word
    addi    $t1,$t1,1           # increment counter by 1
    addi    $s2,$s2,20          # incrememnt string storage area by max bytes used by previous string

    j read

output_reverse:
    addi    $t0,$t0,-4          # sets index of the array to the start of the last string
    addi    $t1,$zero,1         # sets the counter = 1 at the start

    # prints "The values are:" to the console
    la      $a0,output
    li      $v0,4
    syscall

while_loop:
    bgt     $t1,$s0, exit        # checks if there are more strings to output, exiting if not
    lw      $t2,array($t0)       # loads the current string pointer


    li      $v0,4 # service code used to output strings
    move    $a0,$t2 # gets the string to output
    syscall

    addi    $t0,$t0,-4           # decrements array index by one word
    addi    $t1,$t1,1           # increments counter by 1
    j       while_loop               # jumps to next iteration of the while loop

exit:
    li      $v0, 10 # code used for the exit syscall.
    syscall