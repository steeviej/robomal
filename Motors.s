# .ifndef Motors
#     
#     Motors:
#     
#     .ent setupMotorPins
# 	setupMotorPins:	    # Sets Plugs for JD as outputs
# 	addi $sp, -4
# 	sw $ra, 0($sp)
#     
# 	    LI $t0, 0b11000110
# 	    SW $t0, TRISDCLR
# 	
# 	lw $ra, 0($sp)
# 	addi $sp, 4
# 	JR $ra
#     .end setupMotorPins

    
    
    # ########################################################################
    # 
    # a0: Motor Direction
    # a1: Duty Cycle
    # 
    # ########################################################################
#     .ent setMotorRight
#     setMotorRight:
#     
#     di
# 	li $t0, 0b10000010
# 	SW $t0, LATDCLR # Disable Motor, Clear Direction
# 	
# 	SLL $t1, $a0, 7 # Motor Direction
# 	SW $t1, LATDSET
#     
# 	SW $a1, OC2RS	# Duty Cycle
# 	
#     ei
# 	JR $ra
#     .end setMotorRight
#     
#     
#     # #######################################################################
#     # 
#     # a0: Motor Direction
#     # a1: Duty Cycle
#     # 
#     # #######################################################################
#     .ent setMotorLeft
#     setMotorLeft:
#     di
# 	li $t0, 0b1000100
# 	SW $t0, LATDCLR # Disable Motor, Clear Direction
# 	
# 	SLL $t1, $a0, 6	# Motor Direction
# 	SW $t1, LATDSET
# 	
# 	SW $a1, OC3RS	# Duty Cycle
# 	
#     ei
# 	JR $ra
#     .end setMotorLeft

    
    # This subtroutine turns off all motors and disables interrupts
    # Accepts no input, returns no output
#     .ent disableMotors
#     disableMotors:
#     di
# 	li $t0, 0b11000000
# 	SW $t0, LATDCLR
#     
#     JR $ra
#     .end disableMotors
#     
# .endif
