.ifndef OutputCompare
    OutputCompare:
    
    # #########################################################################
    # setupOCx
    # 
    # a0: (1) Timer 3	(0) Timer 2
    # a1: (1) 32-Bit	(0) 16-Bit	
    # 
    # #########################################################################
    
#     .ent setupOC1
#     setupOC1:
# 	# Turn OC1 off while setting up
# 	SW $zero, OC1CON
# 
# 	# Duty Cycle of Zero (initially)
# 	SW $zero, OC1R
# 	SW $zero, OC1RS
# 
# 	# Setup OC1 for PWM and enable it
# 	MOVE $t0, $zero
# 	SLL $a0, $a0, 3		# Set Timer3 or Timer2
# 	OR $t0, $t0, $a0    
# 	SLL $a1, $a1, 5		# Set 32-Bit or 16-Bit
# 	OR $t0, $t0, $a1
# 	ORI $t0, $t0, 6		# PWM mode
# 	ORI $t0, $t0, 1 << 15	# Enable output compare module
# 	SW $t0, OC1CON    
# 	
# 	JR $ra
#     .end setupOC1
    
    
    .ent setupOC2
    setupOC2:
	# Turn OC2 off while setting up
	SW $zero, OC2CON

	# Duty Cycle of Zero (initially)
	SW $zero, OC2R
	SW $zero, OC2RS

	# Setup OC2 for PWM and enable it
	MOVE $t0, $zero
	SLL $a0, $a0, 3		# Set Timer3 or Timer2
	OR $t0, $t0, $a0    
	SLL $a1, $a1, 5		# Set 32-Bit or 16-Bit
	OR $t0, $t0, $a1
	ORI $t0, $t0, 6		# PWM mode
	ORI $t0, $t0, 1 << 15	# Enable output compare module
	SW $t0, OC2CONSET    
	
	JR $ra
    .end setupOC2
    
    
    
    .ent setupOC3
    setupOC3:
	# Turn OC3 off while setting up
	SW $zero, OC3CON

	# Duty Cycle of Zero (initially)
	SW $zero, OC3R
	SW $zero, OC3RS

	# Setup OC3 for PWM and enable it
	MOVE $t0, $zero
	SLL $a0, $a0, 3		# Set Timer3 or Timer2
	OR $t0, $t0, $a0    
	SLL $a1, $a1, 5		# Set 32-Bit or 16-Bit
	OR $t0, $t0, $a1
	ORI $t0, $t0, 6		# PWM mode
	ORI $t0, $t0, 1 << 15	# Enable output compare module
	SW $t0, OC3CONSET    
	
	JR $ra
    .end setupOC3
    
    
    
#     .ent setupOC4
#     setupOC4:
# 	# Turn OC4 off while setting up
# 	SW $zero, OC4CON
# 
# 	# Duty Cycle of Zero (initially)
# 	SW $zero, OC4R
# 	SW $zero, OC4RS
# 
# 	# Setup OC4 for PWM and enable it
# 	MOVE $t0, $zero
# 	SLL $a0, $a0, 3		# Set Timer3 or Timer2
# 	OR $t0, $t0, $a0    
# 	SLL $a1, $a1, 5		# Set 32-Bit or 16-Bit
# 	OR $t0, $t0, $a1
# 	ORI $t0, $t0, 6		# PWM mode
# 	ORI $t0, $t0, 1 << 15	# Enable output compare module
# 	SW $t0, OC4CON
# 
# 	JR $ra
#     .end setupOC4

    
.endif
