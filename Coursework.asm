.data 
menu: .asciiz "Actions: 1 - CLS, 2 - Draw Row, 3 - Draw Column, 4 - Logo, 5 - Exit\n"
question: .asciiz "Enter values 1 - 5 to choose an action: "
errorMessageText: .asciiz "The number entered doesn't match an option. Please enter a number between 1 and 5\n"

colour: .word 0x00000000
colourMenu: .asciiz "Colours: 1 - Red, 2 - Pink, 3 - Yellow, 4 - Main Menu\n"
colourQuestion: .asciiz "Enter values 1 - 3 to choose a colour, or 4 to go back to main menu: "
colourErrorMessage: .asciiz "The number entered doesn't match a colour option. Please enter a number between 1 and 4\n"

exitMessage: .asciiz "Program exited. Thank you.\n"

message2: .asciiz "Testing Menu\n"


.text
main:	
	# colouring the background
	lui $s0,0x1004		# bitmap display base address in $s0 (heap)
	add $t8,$zero,0xff00	# set colour to green in $t8
	addi $t0,$s0,0 		# initialise $t0 to base address
	lui $s1,0x100C		# sets end of screen area into $s1

	drawPixel: 
		sw $t8, 0($t0) 		# store colour $t8 in current target address
		addi $t0, $t0, 4 	# increment $t0 by one word
		bne $t0, $s1, drawPixel # if target hasn't been reached, repeat
	
	
	# print the user a prompt 
	pickAction:	addi $v0, $zero, 4	# printing the menu (syscall 4)
			la $a0, menu
			syscall
	
			addi $v0, $zero, 4	#printing the prompt for the user to choose an action
			la $a0, question
			syscall


			# user input
			li $v0, 5	# read integer and store into $v0
			syscall

			move $t0, $v0	# moves the entered integer into $t0
	
	
	# clear screen function call
	procedureCall1:
		addi $t1, $zero, 1			# set value of $t1 to 1
		bne $t0, $t1, procedureCall2		# if $t0 != $t1, jump to procedureCall2
		jal clearScreen				# if $t0 = $t1, jump to clearScreen procedure (if user input = 1)
	procedureCall2:
		addi $t1, $zero, 2			# set value of $t1 to 2
		bne $t0, $t1, procedureCall3		# if $t0 != $t1, jump to procedureCall3
		jal drawHorizontal			# if $t0 = $t1, jump to drawHorizontal procedure (if user input = 2)
	procedureCall3:
		addi $t1, $zero, 3			# set value of $t1 to 3
		bne $t0, $t1, procedureCall4		# if $t0 != $t1, jump to procedureCall4
		jal drawVertical			# if $t0 = $t1, jump to drawVertical procedure (if user input = 3)
	procedureCall4:
		addi $t1, $zero, 4			# set value of $t1 to 4
		bne $t0, $t1, procedureCall5		# if $t0 != $t1, jump to procedureCall5
		jal logo				# if $t0 = $t1, jump to drawVertical procedure (if user input = 4)
	procedureCall5:	
		addi $t1, $zero, 5			# set value of $t1 to 4
		bne $t0, $t1, errorMessage		# if $t0 != $t1, jump to errorMessage
		jal exit				# if $t0 = $t1, jump to exit procedure (if user input = 5)
	
actions:
	clearScreen:	# clear screen function
		backgroundColour:
				addi $v0, $zero, 4	# printing the menu (syscall 4)
				la $a0, colourMenu
				syscall
	
				addi $v0, $zero, 4	#printing the prompt for the user to choose an action (syscall 4)
				la $a0, colourQuestion
				syscall


				# user input
				li $v0, 5	# read integer and store into $v0
				syscall

				move $t0, $v0	# moves the entered integer into $t0
	
		pickBackgroundColour1: #set $t2 to colour red
			addi $t1, $zero, 1
			bne $t0, $t1, pickBackgroundColour2
			j colourRed
		pickBackgroundColour2: #set $t2 to colour pink
			addi $t1, $zero, 2
			bne $t0, $t1, pickBackgroundColour3
			j colourPink
		pickBackgroundColour3: #set $t2 to colour yellow
			addi $t1, $zero, 3
			bne $t0, $t1, pickBackgroundColourExit
			j colourYellow
		pickBackgroundColourExit:
			addi $t1, $zero, 4
			bne $t0, $t1, colourError
			j pickAction

		fillBackground: lui $s0,0x1004			# bitmap display base address in $s0 (heap)		# set colour to turquoise in $t8
				addi $t0,$s0,0 			# initialise $t0 to base address
				lui $s1,0x100C			# sets end of screen area into $s1

			drawPixel2: 
				sw $t8, 0($t0) 		# store colour $t8 in current target address
				addi $t0, $t0, 4 	# increment $t0 by one word
				bne $t0, $s1, drawPixel2 # if target hasn't been reached, repeat
			
			j backgroundColour
		
	drawHorizontal:
		addi $s0, $zero, 0			# initialising 
		lui $s0, 0x1004
		li $a0, 0x00FFFFFF
		sw $a0, colour
		addi $t1, $zero, 512
		
		bne $t3, $t1, drawHorizontalLine	# if counter and target are equal, reset counter. if not equal, jump to drawHorizontalLine
		addi $t3, $zero, 0			# resetting counter to 0 to prevent runtime exception (>512)
		
		drawHorizontalLine:
			addi $t3, $t3, 1
			sw $a0, 0($s0)
			addi $s0, $s0, 4
			bne $t3, $t1, drawHorizontalLine
			j pickAction
	
	drawVertical:
		addi $s0, $zero, 0
		lui $s0, 0x1004
		li $a0, 0x00FFFFFF
		sw $a0, colour
		addi $t1, $zero, 512
		
		drawVerticalLine:
			addi $t3, $t3, 1
			sw $a0, 0($s0)
			addi $s0, $s0, 4
			bne $t3, $t1, drawVerticalLine
			j pickAction

	logo:
		j pickAction

	exit:
		li $v0, 4
		la $a0, exitMessage
		syscall 
	
		li $v0, 10		# program exit (syscall 10)
		syscall

setColour: # procedures to set pixels to desired colour	
	colourRed: # setting colour to red
		li $t8, 0x00FF0000
		sw $t8, colour
		j fillBackground
	
	colourPink: # setting colour to pink
		li $t8, 0x00FF00C5
		sw $t8, colour
		j fillBackground
	
	colourYellow: # setting colour to yellow
		li $t8, 0x00FFFF00
		sw $t8, colour
		j fillBackground
		
	colourWhite:
		li $a0, 0x00FFFFFF
		sw $a0, colour
		j drawHorizontal
	
errors: # procedures to display error messages
	errorMessage:	# error message to display when a number out of the range 1 - 5 is entered when picking an action
		li $v0, 4
		la $a0, errorMessageText
		syscall
	
		j pickAction	
	
	colourError: # error message to display when a number out of the range 1 - 4 is entered when picking a colour
		li $v0, 4
		la $a0, colourErrorMessage
		syscall
	
		j backgroundColour
	
	
	
	

	





