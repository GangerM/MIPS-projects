PRINT_STR = 4
READ_FLOAT = 6
READ_INT = 5
PRINT_INT = 1
PRINT_FLOAT = 2

        .data
enter:  .asciiz "Temperature in Fahrenheit: "
result: .asciiz "\nTemperature in Celsius is: "
newline:.asciiz "\n"
coef:   .float 0.555555
subtr:  .float 32.0
z:      .float 0.0

#CODE SECTION
        .text
main:
        # $f1 = coef 5/9, $f2 = sub, $f4 = 0.0000
        lwc1    $f1, coef
        lwc1    $f2, subtr
        lwc1    $f4, z

        ## LOAD IN FLOAT FOR CALCULATIONS
        li      $2, READ_INT
        syscall
        move    $t0, $2 # INPUT IS IN $2

        # PRINT PROMPT AND ECHO BACK THE INPUT
        la      $4, enter
        li      $2, PRINT_STR
        syscall
        li      $2, PRINT_INT
        move    $a0, $t0
        syscall

        mtc1    $t0, $f5 # $f5 = INPUT IN FLOATING POINT
        cvt.s.w $f5, $f5 # CONVERT INTO FLOATING POINT

        sub.s   $f6, $f5, $f2 #SUBTRACT INPUT WITH 32
        mul.s   $f7, $f1, $f6 #MULT RESULT FROM ABOVE WITH COEF

        la      $4, result
        li      $2, PRINT_STR
        syscall

        li      $v0, PRINT_FLOAT
        mov.s   $f12, $f7
        syscall

        la      $4, newline
        li      $2, PRINT_STR
        syscall

        jr      $31
