
# .include "Motors.s"
    
.ifndef RCI
       RCI:
.include "Branches.s"    
.include "InputCapture.s"
.include "LEDs.s"
    
    
    .ent RCInstruction
    RCInstruction:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	RCI4:
	# Updated for use with ASCII
	BEQ $a0, 0xC, leftJump		# L --> Left
	BEQ $a0, 6, forwardJump	    	# F --> Forward
	BEQ $a0, 2, backwardJump	# B --> Backward
	j Halt			# Unrecognized instruction --> Halt
	
	RCI5:
	BEQ $a0, 2, rightJump		# R --> Right
	BEQ $a0, 3, brakeJump		# S --> Brake
	j Halt			# Unrecognized instruction --> Halt
	
	RCI6:
	BEQ $a0, 0xC, bankLeftJump	# l --> Bank Left
	j Halt
	
	RCI7:
	BEQ $a0, 2, bankRightJump	# r --> Bank Right
	j Halt
	
	# 
	leftJump:
	MOVE $a0, $a1
	jal Left
	j endRCI
	
	# 
	rightJump:
	MOVE $a0, $a1
	jal Right
	j endRCI
	
	# 
	forwardJump:
	MOVE $a0, $a1
	jal Forward
	j endRCI
	
	# 
	backwardJump:
	MOVE $a0, $a1
	jal Backward
	j endRCI
	
	# 
	brakeJump:
	MOVE $a0, $a1
	jal Brake
	j endRCI
	
	bankRightJump:
	MOVE $a0, $a1
	jal BankRight
	j endRCI
	
	bankLeftJump:
	MOVE $a0, $a1
	jal BankLeft
	j endRCI
	
	endRCI:

	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	JR $ra
	
    .end RCInstruction
    
    .ent Forward
    Forward:
	ADDI $sp, $sp, -8
	SW $ra, 0($sp)
	SW $t0, 4($sp)
	
	    # MOVE $a1, $s4   
	    LI $t0, 10
	    MUL $a1, $s4, $t0
	    # MOVE $a1, $s4   # Set Right Motor Duty Cycle Input
	    
	    LI $a0, 0	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    LI $a0, 0b0110
	    jal setLEDs
	    	    

	LW $t0, 4($sp)
	LW $ra, 0($sp)
	ADDI $sp, $sp, 8
	JR $ra
    .end Forward
    
    .ent Backward
    Backward:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	    MOVE $a1, $s4   # Set Right Motor Duty Cycle Input
	    
	    LI $a0, 1	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 0	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    LI $a0, 0b1001
	    jal setLEDs
	    
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end Backward
    
    .ent Right    
        Right:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
		
	    LI $a1, 800	    # Set Right Motor Duty Cycle Input
	    
	    LI $a0, 1	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    LI $a0, 0b1000
	    jal setLEDs
	    
	
	    
	    # Enable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONSET
	    
	    turnRightLoop:  # Count Down from Operand Using Timer45
	
	    BGE $s4, 1, turnRightLoop
	    
	    # Disable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONCLR
	    
	    MOVE $a1, $zero   # Set Right Motor Duty Cycle Input
	    LI $a0, 0	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    li $a0, 0xF
	    jal clearLEDs
	    
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end Right
    
    .ent Left    
        Left:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	    # MOVE $a1, $s4   # Set Right Motor Duty Cycle Input
	    LI $a1, 800
	    
	    LI $a0, 0	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 0	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    LI $a0, 0b0001
	    jal setLEDs
	    


	    # Enable Timer 45
 	    LI $t0, 1<<15
	    SW $t0, T4CONSET
	    
	    turnLeftLoop:  # Count Down from Operand Using Timer45
	
	    BGE $s4, 1, turnLeftLoop
	    
	    MOVE $a1, $zero	# Set Right Motor Duty Cycle Input
	    LI $a0, 0		# Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    # Disable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONCLR	   
	    
	    li $a0, 0xF
	    jal clearLEDs
	
	    
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end Left
    
    
    .ent Brake    
	Brake:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)

	    # Enable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONSET
	    SLL $s4, $s4, 2
	    
	    brakeLoop:  # Count Down from Operand Using Timer45
 	    # jal inputCaptureUpdate
	    BGE $s4, 1, brakeLoop
	    
	    # Disable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONCLR
	
	    MOVE $a1, $zero   # Set Right Motor Duty Cycle Input

	    LI $a0, 0	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	
	    li $a0, 0xF
	    jal clearLEDs
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4

	JR $ra
    .end Brake
    
    
    .ent BankRight    
	BankRight:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)

	    SLL $s4, $s4, 1
	
	    LI $a0, 0b0011
	    jal setLEDs
	
	    LI $a0, 0	    # Set Right Motor Direction
	    LI $a1, 80   # Set Right Motor Duty Cycle Input
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    LI $a1, 91
	    jal setMotorLeft

	    # Enable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONSET
	    
	    bankRightLoop:  # Count Down from Operand Using Timer45
	
	    BGE $s4, 1, bankRightLoop
	    
	    # Disable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONCLR
	    
	    MOVE $a1, $zero   # Set Right Motor Duty Cycle Input
	    LI $a0, 0	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    li $a0, 0xF
	    jal clearLEDs

	LW $ra, 0($sp)
	ADDI $sp, $sp, 4

	JR $ra
    .end BankRight
    
    
    .ent BankLeft    
	BankLeft:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	    
	    SLL $s4, $s4, 1
	
	    LI $a0, 0b1100
	    jal setLEDs
	
	    LI $a0, 0	    # Set Right Motor Direction
	    LI $a1, 95   # Set Right Motor Duty Cycle Input
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    LI $a1, 80
	    jal setMotorLeft
	    
	    # Enable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONSET
	    
	    bankLeftLoop:  # Count Down from Operand Using Timer45
	
	    BGE $s4, 1, bankLeftLoop
	    
	    # Disable Timer 45
	    LI $t0, 1<<15
	    SW $t0, T4CONCLR

	    MOVE $a1, $zero   # Set Right Motor Duty Cycle Input
	    LI $a0, 0	    # Set Right Motor Direction
	    jal setMotorRight

	    LI $a0, 1	    # Set Left Motor Direction
	    jal setMotorLeft
	    
	    li $a0, 0xF
	    jal clearLEDs
	    
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4

	JR $ra
    .end BankLeft
    
    
    .ent setupMotorPins
	setupMotorPins:	    # Sets Plugs for JD as outputs
	addi $sp, -4
	sw $ra, 0($sp)
    
	    LI $t0, 0b11000110
	    SW $t0, TRISDCLR
	
	lw $ra, 0($sp)
	addi $sp, 4
	JR $ra
    .end setupMotorPins

    
    
    # ########################################################################
    # Set Motor Right
    # 
    # a0: Motor Direction
    # a1: Duty Cycle
    # 
    # ########################################################################
    .ent setMotorRight
    setMotorRight:
    
    di
	li $t0, 0b10000010
	SW $t0, LATDCLR # Disable Motor, Clear Direction
	
	SLL $t1, $a0, 7 # Motor Direction
	SW $t1, LATDSET
	
	MOVE $s5, $a1	# Save Right Motor Duty Cycle
	
	LA $t0, Input_Capture_Memory
	LW $t1, 32($t0)
	ADD $a1, $a1, $t1
	SW $a1, OC2RS	# Duty Cycle

	
    ei
	JR $ra
    .end setMotorRight
    
    
    # #######################################################################
    # Set Motor Left
    # 
    # a0: Motor Direction
    # a1: Duty Cycle
    # 
    # #######################################################################
    .ent setMotorLeft
    setMotorLeft:
    di
	li $t0, 0b1000100
	SW $t0, LATDCLR # Disable Motor, Clear Direction
	
	MOVE $s6, $a1	# Save Left Motor Duty Cycle
	
	SLL $t1, $a0, 6	# Motor Direction
	SW $t1, LATDSET
	
	SW $a1, OC3RS	# Duty Cycle
	
	
    ei
	JR $ra
    .end setMotorLeft

    
    
    # #######################################################################
    # Set Motor Left
    # 
    # a0: Motor Direction
    # a1: Duty Cycle
    # 
    # #######################################################################
    .ent ICRightMotorUpdate
    ICRightMotorUpdate:
    
    di
	li $t0, 0b10
	SW $t0, LATDCLR # Disable Motor, Clear Direction
	
	LA $t0, Input_Capture_Memory
	LW $t1, 32($t0)
	ADD $a0, $a0, $t1
	SW $a0, OC2RS	# Duty Cycle

	
    ei
	JR $ra
    .end ICRightMotorUpdate
    
    
    # This subtroutine turns off all motors and disables interrupts
    # Accepts no input, returns no output
    .ent disableMotors
    disableMotors:
    di
	li $t0, 0b11000000
	SW $t0, LATDCLR
    
    
    JR $ra
    .end disableMotors
    
    
.endif
    