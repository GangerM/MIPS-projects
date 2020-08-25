## Constants
PRINT_INT = 1
PRINT_STR = 4
READ_INT = 5

## Data section
	.data
enter:	.asciiz "Amount of cents to change: "
quarters: .asciiz "\nNumber of quarters: "
dimes: .asciiz "\nNumber of dimes: "
nickels: .asciiz "\nNumber of nickels: "
pennies: .asciiz "\nNumber of pennies: "
newline: .asciiz "\n"
quarter: .word 25
dime: .word 10
nickel: .word 5
penny: .word 1


## COde section
	.text
main:
	##Load in my integers for division
	la	$t1, quarter # quarter = $t2
	lw	$t2, 0($t1)
	
	la	$t1, dime    # dime = $t3
	lw	$t3, 0($t1)

	la	$t1, nickel  # t4 = nickel
	lw	$t4, 0($t1)

	la	$t1, penny   # t5 = penny
	lw	$t5, 0($t1)

	#li $v0, PRINT_INT
	#move $a0, $t5
	#syscall	

	#Print out "amount of cents to change string"
	la	$4, enter
	li	$2, PRINT_STR
	syscall
 
	# Take in input
	li	$2, READ_INT
	syscall
	move	$t0, $2 ## num_cents is now in $t0
		
	# Echo the input back to syscall
	li	$2, PRINT_INT
	move	$a0, $t0
	syscall

	#QUARTER START	
	div	$t0, $t2   #divide input/25
	mflo	$16  #$16 = num of quarters
	mul	$17, $16, $t2 # $17 = total of quarters
	sub	$18, $t0, $17 # $12 number of cents left

	#PRINT QUARTERS
	la	$4, quarters
	li	$2, PRINT_STR
	syscall
	li	$2, PRINT_INT
	move	$a0, $16
	syscall

	# START DIMES
	div	$18, $t3 #divide cents left by 10
	mflo	$16 # $16 is num of dimes
	mul	$17, $16, $t3 # totall amount of dimes
	sub	$19, $18, $17 # $19 = num of cents left

	#PRINT DIMES
	la	$4, dimes
	li	$2, PRINT_STR
	syscall
	li	$2, PRINT_INT
	move	$a0, $16
	syscall 

	#START NICKELS
	div	$19, $t4
	mflo	$16 # num of nickels
	mul	$17, $16, $t4 # total amount of dimes
	sub	$20, $19, $17 # $20 = num of cents left
	
	# PRINT NICKELS
	la	$4, nickels
	li	$2, PRINT_STR
	syscall
	li	$2, PRINT_INT
	move	$a0, $16
	syscall

	#START PENNIES
	div	$20, $t5
	mflo	$16 # num of pennies
	
	#PRINT PENNIES
	la	$4, pennies
	li	$2, PRINT_STR
	syscall
	li	$2, PRINT_INT
	move	$a0, $16
	syscall 
	

	## li	$t0, PRINT_INT
	## syscall
	
	la	$4, newline
	li	$2, PRINT_STR
	syscall
		
	
	

	li $2, 10
	syscall
	









