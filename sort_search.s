	### COPYRIGHT MITUL GANGER  NOV 26 2019

READ_INT = 5

	.data
input_array:	.space	40
notfound:	.asciiz "Not found\n"
new_line:	.asciiz	"\n"
found:		.asciiz	"Found at index "

	.text
main:

###PROLOGUE

	addiu	$sp, $sp, -24	# save space for 4 arguments plus return register
	sw	$ra, 20($sp)
	sw	$s0, 16($sp)	# saved register for array length returned from load func

###BODY

	###LOAD FUNCTION
	addi	$a1, $zero, 10	# SAVE PARAMETER (max array len)
	la	$a0, input_array #save parameter (array)	
	jal	load		# call load function
	
	move	$s0, $v0	# $s0 = length of inputted array

	### SORT FUNCTION
	move	$a0, $s0	#length of inputted array now in $a0
	la	$a1, input_array
	jal	sort
	

	### FIND FUNCTION
	addiu	$a1, $s0, 0	 # high
	la	$a0, input_array # array addy
	jal	find
	
###EPILOGUE

	lw	$s0, 16($sp)
	lw	$ra, 20($sp)  	
	addiu	$sp, $sp, 24
	jr	$ra


### LOAD FUNCTION
load:

###PROLOGUE

	addiu	$sp, $sp, -4		# 1 parameter, new array, and $ra
	sw	$ra, ($sp)		# RETURN ADDY AT
	sw	$a0, 8($sp)
	addiu	$t9, $a1, -1		## max size of array

###BODY
	lw	$a0, 8($sp)
	li	$t1, 0	# number to be incremented to access indecies
	loop_load:
		
		li	$v0, READ_INT	#read int
		syscall
		move	$t2, $v0	#number to be inputted into array is in $t2

		blt	$t2, $zero, load_end	## if input is -1, go to endloop
		
		sw	$t2, ($a0)	# save input into array
		addiu	$t1, $t1, 1	# iter ++
		addiu	$a1, $a1, 4	# array offset  +=4
		
		bgt	$t1, $t9, load_end	## if array full, go to load_end
	
		j	loop_load

	load_end:
		
		addiu	$v0, $t1, 0 	## save array size into return addy
				
### EPILOGUE	

		lw	$ra, ($sp)
		addiu	$sp, $sp, 4 
		jr	$ra


### SORT FUNCTION
sort:

###PROLOGUE

	addiu	$sp, $sp, -4	# save ra
	sw	$ra, ($sp)

###BODY

	li	$t2, 1	# i = 1
	while1:
		bge	$t2, $a0, sort_end	#while i < length	
		move	$t3, $t2	# j = i
		move	$t9, $t2	# $t9 = i
		#loop to get to position i
		addy:
			beqz	$t9, while2
			addiu	$a1, $a1, 4
			addiu	$t9, $t9, -1
			j	addy

		while2:
			beqz	$t3, end_while2 	# j > 0

			lw	$t4, -4($a1) 	# $t4 =  A[j - 1]
			lw	$t5, 0($a1)	# $t5 = A[j]
			
			ble	$t4, $t5, end_while2	#if A[j - 1] < = A[j], end while2
	
			## assuming the conitions are met we can swap
			sw	$t4, 0($a1)	#Swap A[j - 1] to A[j]
			sw	$t5, -4($a1)	#Swap A[j] to A[j - 1]
	
			addiu	$a1, $a1, -4	# -- the index
			addiu	$t3, $t3, -1	#J--				

			j	while2

		# end while
		end_while2:
			addi	$t2, $t2, 1	# i++		
			
			move	$t6, $t3	# t6 = j
			
			# loop to restore addy
			restore:
				beqz	$t6, jumpw
				addiu	$a1, $a1, -4
				addiu	$t6, $t6, -1	# iter --
				j restore

			jumpw:
				j	while1

###EPILOGUE

	sort_end:
		lw	$ra, ($sp)
		addiu	$sp, $sp, 4
		jr	$ra
	

### FUNCTION BSEARCH
bsearch:

###PROLOGUE

	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)	# store return address
	sw	$a1, 24($sp)	# store low
	sw	$a2, 28($sp)	# store high
	sw	$a0, 20($sp)	# save addy of array
	lw	$a0, 20($sp)	# load addy, since it doesnt change
	sw	$a3, 32($sp)	# save KEY
	lw	$a3, 32($sp) 	# load key, since it doesnt change

###BODY

	blt	$a2, $a1, not_found	# if high < low go to not found
		
	add	$t2, $a1, $a2	# mid = $t2 = low + high
	srl	$t2, $t2, 1	# mid / 2 aka $t2 >> 1
 
	# set offset of $a0 calling set_offset
	move	$t3, $t2	# globaliterator for set _offset
	move	$t4, $0		# addy adder 
	jal	set_offset
	
	add	$a0, $a0, $t4	# add offset to point to A[mid]
		
	lw	$t5, ($a0)	# $t5 = A[mid]
	
	sub	$a0, $a0, $t4 	# restore offset

	#if A[mid] > key
	bgt	$t5, $a3, if

	#if A[mid] < key
	blt	$t5, $a3, if_else

	beq	$t5, $a3, else	# return mid

	#comparisons
	if:
		addiu	$a2, $t2, -1	# high = mid - 1
		sw 	$a2, 28($sp)
		lw 	$a2, 28($sp)
		lw 	$a1, 24($sp)
		
		jal	bsearch		# recursive call to bsearch
		j	end

	if_else:
		addiu	$a1, $t2, 1	# low = mid + 1
		sw 	$a1, 24($sp)
		lw 	$a1, 24($sp)
		lw	$a2, 28($sp)

		jal	bsearch
		j	end
	else:
		addiu	$v0, $t2, 0	# return mid
		j end

	not_found:
		li	$v0, -10
		j	end
	
	set_offset:
		beqz	$t3, nope
		addiu	$t4, $t4, 4
		addiu	$t3, $t3, -1
		j	set_offset
		nope:
			jr	$ra
	
### EPILOGUE
	end:
		lw	$ra,16($sp)
		
		addiu	$sp, $sp, 20
		jr	$ra
		
### FIND FUNCTION	
find:
	
### PROLOGUE

	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)	#Save returm addy
	sw	$a0, 20($sp)	# save array addy
	lw	$a0, 20($sp)
	sw	$a1, 24($sp)	# save length	
	lw	$a1, 24($sp)
	
	
### BODY
	input:
		lw	$a0, 20($sp)
		lw	$a1, 24($sp)
		li	$v0, READ_INT	# read integer from user
		syscall
		move	$t3, $v0	
		move	$a3, $t3

		sw	$a3, 32($sp)	# store key		
		lw	$a3, 32($sp)	

		bltz	$t3,  endf	# if input negative end function
		
		lw	$a2, 24($sp)	# load high
		addiu	$a2, $a2, -1	# sub len by 1
		move	$a1, $0		# low = 0
	
		jal	bsearch		# call bsearch 
		move	$t1, $v0	# result of bsearch in $t1	 
				
		
		blt	$t1, $0, notfound2	# if bsearch result is negative
		

		# print found at index ___
		#print string
		li	$v0, 4
		la	$a0, found
		syscall

		# print result
		li	$v0, 1
		move	$a0, $t1
		syscall

		#print newline
		li	$v0, 4
		la	$a0, new_line
		syscall
				
		j	jumpfound

		# print Not found
		notfound2:
			#print string
			li	$v0, 4
			la	$a0, notfound
			syscall	
		
		jumpfound:
			j	input		# keep loop of getting numbers
		
### EPILOGUE

	endf:
		lw	$ra, 16($sp)
		addiu	$sp, $sp, 20
		jr	$ra
		

