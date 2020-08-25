# Constants
OVERFLOW = 12
FOUR = 4
# System data
	.kdata
newline:	.asciiz	"\n"
		.align	2
registers:	.space 112
unhandled:	.asciiz	"Unhandled exception\n"
# System code
	.ktext	0x80000180

###PROLOGUE
.set	noat	#allow access to $at
	move	$k1, $at # copy $at
.set	at	# get rid of acess
	la	$k0, registers	# get addy of the space for arg regs
	sw	$v0, ($k0)
	sw	$v1, 4($k0)	# save v0
	sw	$a0, 8($k0)	# save a0
	sw	$a1, 12($k0)
	sw	$a2, 16($k0)
	sw	$a3, 20($k0)
	sw	$t0, 24($k0)
	sw	$t1, 28($k0)
	sw	$t2, 32($k0)
	sw	$t3, 36($k0)
	sw	$t4, 40($k0)
	sw	$t5, 44($k0)
	sw	$t6, 48($k0)
	sw	$t7, 52($k0)
	sw	$s0, 56($k0)
	sw	$s1, 60($k0)
	sw	$s2, 64($k0)
	sw	$s3, 68($k0)
	sw	$s4, 72($k0)
	sw	$s5, 76($k0)
	sw	$s6, 80($k0)
	sw	$s7, 84($k0)
	sw	$t8, 88($k0)
	sw	$t9, 92($k0)
	sw	$k1, 96($k0)
#	sw	$gp, 104($k0)
	sw	$sp, 108($k0)
#	sw	$ra, 112($k0)

###BODY
	mfc0	$k0, $13	# extract the error
	srl	$k0, $k0, 2	# get ExcCode
	andi	$k0, $k0, 0x1F
	
	beq	$k0, OVERFLOW, arith	# if exception is overflow, branch to arith
	
	# if not overflow:
	la	$a0, unhandled
	li	$v0, 4
	syscall		# print out "unhandled exception"
	
	li	$a0, 1
	li	$v0, 17
	syscall		# exit2() terminate with value

	# arithmetic overflow ****
	arith:
		mfc0	$k1, $14	# EPC into $k1
		lw	$k0, ($k1)	# actual instruction in $k0

		srl	$k1, $k0, 26	# get opcode, put it in $k1
		
		beqz	$k1, Rtype	# if opcode = 000000, then go to rtype

		#if not, its an I type:
		sll	$k0, $k0, 11
		srl	$k0, $k0, 27
			
		la	$k1, registers
		addiu	$k0, $k0, -2
		
		mul	$k0, $k0, FOUR
		addu	$k1, $k1, $k0
			
		li	$k0, 42
		sw	$k0, ($k1)	
		
		b	nextinst
		
		Rtype:
			sll	$k0, $k0, 16
			srl	$k0, $k0, 27	# $k0 is now equal to destination register
		
			la	$k1, registers
			addiu	$k0, $k0, -2	# offset for $k1 register array of saved regs
			
			mul	$k0, $k0, FOUR	# get addy offset of destination reg
			addu	$k1, $k1, $k0	# get dest of dest reg

			li	$k0, 42
			sw	$k0, ($k1)	# Store 42 at dest reg
		
		nextinst:
			# go to next instruction
			mfc0	$k1, $14	# EPC into $k1
			addiu	$k1, $k1, 4	# next instruction
			mtc0	$k1, $14	# move $k1 into epc again

### EPILOGUE
	la	$k0, registers
	lw	$v0, ($k0)
	lw	$v1, 4($k0)	#
	lw	$a0, 8($k0)	# 
	lw	$a1, 12($k0)
	lw	$a2, 16($k0)
	lw	$a3, 20($k0)
	lw	$t0, 24($k0)
	lw	$t1, 28($k0)
	lw	$t2, 32($k0)
	lw	$t3, 36($k0)
	lw	$t4, 40($k0)
	lw	$t5, 44($k0)
	lw	$t6, 48($k0)
	lw	$t7, 52($k0)
	lw	$s0, 56($k0)
	lw	$s1, 60($k0)
	lw	$s2, 64($k0)
	lw	$s3, 68($k0)
	lw	$s4, 72($k0)
	lw	$s5, 76($k0)
	lw	$s6, 80($k0)
	lw	$s7, 84($k0)
	lw	$t8, 88($k0)
	lw	$t9, 92($k0)
	lw	$k1, 96($k0)
#	lw	$gp, 104($k0)
	lw	$sp, 108($k0)
#	lw	$ra, 112($k0)
.set	noat
	move	$at, $k1
.set	at
	eret	# return to instruction

# Startup routine for user code
    .text
    .globl __start
__start:
        jal main        # main()
        li  $v0, 10
        syscall         # exit()
