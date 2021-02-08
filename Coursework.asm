.data 
menu: .asciiz "1 - CLS, 2 - Draw Row, 3 - Draw Column, 4 - Logo, 5 - Exit"
question: .asciiz "Enter values 1 - 5 to choose an action: "
newLine: .asciiz "\n"

.text
#colouring the background
lui $s0,0x1004		# bitmap display base address in $s0 (heap)
addi $t8,$zero,0xff00	# set colour to green in $t8
addi $t0,$s0,0 		# initialise $t0 to base address
lui $s1,0x100B		# sets end of screen area into $s1

drawPixel: 
	sw $t8, 0($t0) 		# store colour $t8 in current target address
	addi $t0, $t0, 4 	# increment $t0 by one word
	bne $t0, $s1, drawPixel # if target hasn't been reached, repeat

# print the user a prompt 
addi $v0, $zero, 4	#printing the menu
la $a0, menu
syscall

addi $v0, $zero, 4	# printing a new line
la $a0, newLine
syscall

addi $v0, $zero, 4	#printing the prompt for the user to choose an action
la $a0, question
syscall

# user input
li $v0, 5	# read integer and store into $v0
syscall

move $t0, $v0	# moves the entered integer into $t0





