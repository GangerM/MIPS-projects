PRINT_STR = 4
READ_CHAR = 12
GTUAC = 90
LTUAC = 65
GV = 122
LV = 97
a = 97
e = 101
i = 105
o = 111
u = 117
A = 65
E = 69
I = 73
O = 79
U = 85
zero = 48
nine = 57
f = 102
F = 70
two = 2
	.data
result:	.asciiz	"Description of character ' ' is 0b    \n"
UPPER_FLAG:	.byte	0x8
LOWER_FLAG:	.byte	0x4
VOWEL_FLAG:	.byte	0x2
HEX_FLAG:	.byte	0x1
desc:	.byte	0x0
# CODE SECTION
	.text
main:
	# LOAD IN FLAGS TO $t REGISTERS
	lb	$t0, UPPER_FLAG
	lb	$t1, LOWER_FLAG
	lb	$t2, VOWEL_FLAG
	lb	$t3, HEX_FLAG
	lb	$t4, desc
	# TAKE INPUT
	li	$2, READ_CHAR
	syscall
	move	$t5, $2 # INPUT IS NOW IN $t5

# CHECK IF INPUT IS UPPER_CASE
	bgt	$t5, GTUAC , lower
	blt	$t5, LTUAC, lower
	
	or	$t4, $t4, $t0
	b lower
# CHECK IF INPUT IS LOWER CASE
lower:
	bgt	$t5, GV, vowel # CHECK OUT OF BOUNDS FOR LOWER CASE
	blt	$t5, LV, vowel
	
	or	$t4, $t4, $t1 # UPDATE desc SINCE IT IS LOWERCASE
	b vowel
# CHECK IF INPUT IS A VOWEL	
vowel:	
	beq	$t5, a, yes
	beq	$t5, e, yes
	beq	$t5, i, yes
	beq	$t5, o, yes
	beq	$t5, u, yes
	beq	$t5, A, yes
	beq	$t5, E, yes 
	beq	$t5, I, yes
	beq	$t5, O, yes
	beq	$t5, U, yes
	b hexa	# IF NOT VOWEL JUMP TO hexa
	
yes:
	or	$t4, $t4, $t2 # UPDATE desc IF IT IS A VOWEL

#CHECK IF HEXA
hexa:
	# check if it is in between 0 - 9
	bgt	$t5, nine, lowercase
	blt	$t5, zero, lowercase
	or	$t4, $t4, $t3
#check if a-f
lowercase: 
	bgt	$t5, f, uppercase
	blt	$t5, a, uppercase
	or	$t4, $t4, $t3
#check if A-F
uppercase:
	bgt	$t5, F, stringman
	blt	$t5, A, stringman
	or	$t4, $t4, $t3
	b stringman

# String manipulation to put the input
stringman:
	la	$t0, result # $t0 contains the addy of string "result"
	addiu	$t0, $t0, 26
	sb	$t5, 0($t0)

	li	$t3, 0 #set for the next loop
	li	$t1, 3 #next loop
	addiu	$t0, $t0, 11 #next loop start for string
	li	$t8, 2
	b loop

# String manipulation to get the end result
loop:
	blt	$t1, $t3, print # CHECK IF i ($s1) < 4
	#desc is in $t4
	div	$t4, $t8	#get the remainder for binary
	mfhi	$t9	 #bit is in $t9, mod%2 	
	
	srl	$t4, $t4, 1 #right shift for next loop
	add	$t9, $t9, '0'
		
	sb	$t9, 0($t0) # add bit to string
	
	subu	$t0, $t0, 1 # -- the index to print
	addiu	$t3, $t3, 1 # i++

	b loop
# print result
print:
	la	$4, result
	li	$2, PRINT_STR
	syscall
	li	$2, 10 #END PROGRAM
	syscall
	
	

	
