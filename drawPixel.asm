lui $s0,0x1004		# bitmap display base address in $s0 (heap)
addi $t8,$zero,0x00ff	# set colour to blue in $t8
addi $t0,$s0,0 		# initialise $t0 to base address
lui $s1,0x100B

drawPixel: 
	sw $t8, 0($t0) 		# store colour $t8 in current target address
	addi $t0, $t0, 4 	# increment $t0 by one word
	bne $t0, $s1, drawPixel # if target hasn't been reached, repeat
