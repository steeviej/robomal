.ifndef InputCapture
    InputCapture:
    .include "RCI.s"
    .include "Timers.s"
    
    .data
    Input_Capture_Memory: .space 1024
       # 0 --> Left Motor Duty Cycle
       # 4 --> Previous Left Motor Read 
       # 8 --> Current Left Motor Read    
       # 12 -> Left Motor Read Difference
       
       # 16 -> Right Motor Duty Cycle
       # 20 -> Previous Right Motor Read
       # 24 -> Current Right Motor Read
       # 28 -> Right Motor Read Difference
       
       # 32 -> Right Motor Duty Cycle Correct
    
       .text

    # #########################################################################
    
#     .ent setupIC1
#     setupIC1:
#     addi $sp, $sp, -4
#     sw $ra, 0($sp)
#     
#     
#     
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     .end setupIC1
#     
    # #########################################################################
    
    .ent setupIC2
    setupIC2:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	SW $zero, IC2CON    # Clear IC2CON
	
	LA $t0, Input_Capture_Memory
	SW $zero, 0($t0)
	SW $zero, 4($t0)
	SW $zero, 8($t0)
	SW $zero, 12($t0)
	SW $zero, 16($t0)
	SW $zero, 20($t0)
	SW $zero, 24($t0)
	SW $zero, 28($t0)
	SW $zero, 32($t0)
	
	
	LI $t0, 0b001
	SW $t0, IC2CONSET   # Setup for Hall Sensor Mode (Edge Detect Mode)
	
	LI $t0, 1<<7
	SW $t0, IC2CONSET   # Operates with Timer 3
	
	LI $t0, 1<<9
	SW $t0, IEC0SET
	
	LI $t0, 3<<10
	SW $t0, IPC2SET
	
# 	LI $t0, 1<<15	    # Enable IC2
# 	SW $t0, IC2CONSET
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    JR $ra
    .end setupIC2
    
    # #########################################################################
    
    .ent setupIC3
    setupIC3:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	SW $zero, IC3CON    # Clear IC3CON
	
	LI $t0, 0b001
	SW $t0, IC3CONSET   # Setup for Hall Sensor Mode (Edge Detect Mode)
	
	LI $t0, 1<<7
	SW $t0, IC3CONSET   # Operates with Timer 3
	
	LI $t0, 1<<13
	SW $t0, IEC0SET
	
	LI $t0, 3<<10
	SW $t0, IPC3SET
	
# 	LI $t0, 1<<15	    # Enable IC3
# 	SW $t0, IC3CONSET
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    JR $ra
    .end setupIC3
    
    # #########################################################################
    
#     .ent setupIC4
#     setupIC4:
#     addi $sp, $sp, -4
#     sw $ra, 0($sp)
#     
#     
#     
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     .end setupIC4
    
    # #########################################################################
    
#     .ent setupIC5
#     setupIC5:
#     addi $sp, $sp, -4
#     sw $ra, 0($sp)
#     
#     
#     
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     .end setupIC5
    
    # #########################################################################
    
    
    .text
    # ISR for Input Capture 2
    .ent InputCapture2Handler
    InputCapture2Handler:
        di	# Disable Interrupts
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	    li $t0, 1 << 9	    # Clear IC2 flag
	    sw $t0, IFS0CLR

	    LA $t0, Input_Capture_Memory
	    LW $t1, 24($t0)	    # Load The Previous Right Motor Read
	    LW $t2, IC2BUF	    # Load the Current Right Motor Read
	    SW $t1, 20($t0)	    # Move Current Read to Previous Read
	    SW $t2, 24($t0)	    # Move Buffer Read into Current Read
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 12
	ei
	eret  

    .end InputCapture2Handler
    
    # #########################################################################
    
    .text
    # ISR for External Interrupt 4
    .ent InputCapture3Handler
    InputCapture3Handler:
       di	# Disable Interrupts
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	    li $t0, 1 << 13	    # Clear IC3 flag
	    sw $t0, IFS0CLR

	    LA $t0, Input_Capture_Memory
	    LW $t1, 8($t0)	    # Load The Previous Left Motor Read
	    LW $t2, IC3BUF	    # Load the Current Left Motor Read
	    SW $t1, 4($t0)	    # Move Current Read to Previous Read
	    SW $t2, 8($t0)	    # Move Buffer Read into Current Read
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 12
	ei
	eret  
    .end InputCapture3Handler

    # #########################################################################
#     This function is used in the subroutine inputCaptureUpdate to read the 
#     relative speed of the RIGHT motor. If the difference between input capture
#     times is less than zero, then then no update is made
    .ent calculateRightMotorSpeed
    calculateRightMotorSpeed:
	LA $t0, Input_Capture_Memory
	LW $t1, 20($t0)	    # Load Previous Right Motor
	LW $t2, 24($t0)	    # Load Current Right Motor
	SUB $t3, $t2, $t1   # Right Motor Difference
	
	BLEZ $t3, endCalculateRightMotorSpeed	# If right motor difference is negative
	SW $t3, 28($t0)
	
	endCalculateRightMotorSpeed:
    
    JR $ra
    .end calculateRightMotorSpeed
    
    
    # #########################################################################
#     This function is used in the subroutine inputCaptureUpdate to read the 
#     relative speed of the LEFT motor. If the difference between input capture
#     times is less than zero, then then no update is made
    .ent calculateLeftMotorSpeed
    calculateLeftMotorSpeed:
	LA $t0, Input_Capture_Memory
	LW $t1, 4($t0)	    # Load Previous Right Motor
	LW $t2, 8($t0)	    # Load Current Right Motor
	SUB $t3, $t2, $t1   # Right Motor Difference
	
	BLEZ $t3, endCalculateLeftMotorSpeed	# If right motor difference is negative
	SW $t3, 12($t0)
	
	endCalculateLeftMotorSpeed:
    
    JR $ra
    .end calculateLeftMotorSpeed
    
    # #########################################################################
#     This function reads the RIGHT and LEFT motor relative speeds by calling
#     updateRightMotorSpeed and updateLeftMotorSpeed. If the RIGHT motor is
#     spinning slower, 1 is added to the Right Motor Speed. If the RIGHT motor 
#     is spinning slower, 1 is subtracted from the Right Motor Speed.
    .ent inputCaptureUpdate
    inputCaptureUpdate:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	jal calculateRightMotorSpeed
	jal calculateLeftMotorSpeed
    
	LA $t0, Input_Capture_Memory
	LW $t1, 12($t0)	    # Left Motor Speed
	LW $t2, 28($t0)	    # Right Motor Speed
	SUB $t3, $t1, $t2   # LM-RM = t3
	
	LW $t4, 32($t1)	    # Load the Right Motor Duty Correct
	BLEZ $t3, decreaseRightDuty # If t3 is negative, decrease RM Duty
	
	ADDI $t4, $t4, 1	    # Else, increase
	j endInputCaptureUpdate
	
	decreaseRightDuty:
	ADDI $t4, $t4, -1   # Decrease Right Duty Cycle
	
	endInputCaptureUpdate:
	SW $t4, 32($t0)	    # Store Value Back to IC Memory
	
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    JR $ra
    .end inputCaptureUpdate
    
    
    .ent inputCaptureCycle
    inputCaptureCycle:
    
	LI $t0, 1<<15	    
	SW $t0, IC2CONSET   # Enable IC2
	SW $t0, IC3CONSET   # Enable IC3
		
	LI $t1, 20
	
	inputCaptureCycleLoop:
	LI $a0, 1000
	jal delay
	
	jal inputCaptureUpdate
	addi $t1, $t1, -1
	BEQZ $t0, endInputCaptureCycleLoop
	j inputCaptureCycleLoop
	
	endInputCaptureCycleLoop:
		
	LI $t0, 1<<15	    
	SW $t0, IC2CONCLR   # Disable IC2
	SW $t0, IC3CONCLR   # Disable IC3
	
	jr $ra
    .end inputCaptureCycle
    
.endif

# #########################################################################
