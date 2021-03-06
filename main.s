.include "Arithmetic.s"
.include "Bluetooth.s"
.include "Branches.s"
.include "config.c"
.include "Data.s"
.include "InputCapture.s"
.include "LEDs.s"
.include "Motors.s"
.include "OutputCompare.s"
.include "RCI.s"
.include "ROBOMAL.s"
.include "Timers.s"
.include "UART.s"


.global main
    
    
    .text
        
    .ent main
    main:
    
	# Basic Initializations ###############################################
	jal setupLEDs
	jal setupBluetooth  # Bluetooth plugged in to Port JH
	
	MOVE $s0, $zero	    # Clear the Accumulator
	MOVE $s1, $zero	    # Clear the Instruction Address
	MOVE $s2, $zero	    # Clear the Instruction
	MOVE $s3, $zero	    # Clear the Operation
	MOVE $s4, $zero	    # Clear the Operand
	MOVE $s5, $zero	    # Clear the Accumulator
	MOVE $s7, $zero	    # Clear Input Compare
	
	# Set interrupts for multivectored mode
	LI $t0, 1<<12
	SW $t0, INTCONSET

	# Setup Output Pins of JD
	jal setupMotorPins	
	
	# jal setupIC2


	# Setup Timers ########################################################

	# Setup Timer 2 For 1:8 with PR2 = 999 (50kHz)
	li $a0, 0b011
	li $a1, 999
	jal setupTimer2
	
	# Setup Timer 3 For 1:2 with PR3 = 20,000,000 
	li $a0, 0b101
	li $a1, 0b1111111111111111
	jal setupTimer3
	
	# Setup Timer 45
	li $a0, 0b011
	li $a1, 32000  # ADJUST THIS VALUE FOR CALIBRATION!
	jal setupTimer45
	# Note: Timer45 is NOT enabled after calling this subroutine##########
	
	
	# Setup Output Compare #################################################
	LI $a0, 0	# OC2 & OC3 --> Timer 2
	LI $a1, 0	# OC2 & OC3 --> 16-Bit
	jal setupOC2    # Initialize OC2
	jal setupOC3	# Initialize OC3
	# #####################################################################
	
	# Setup Input Capture #################################################
	 jal setupIC2
	 jal setupIC3
	# #####################################################################
	
	
	mainLoop:
	LA $s1, ROBOMAL_INST_MEMORY # 
	jal clearInstructionMemory
	
	getData:
	jal receiveUART2Word
	SW $v0, 0($s1)
	BEQ $v0, 0x3F, executeInstructions   # A '?' starts the program
	ADDI $s1, 4
	j getData
	
	executeInstructions:
	LA $s1, ROBOMAL_INST_MEMORY
	
	runClockCycleLoop:
	ei
	JAL runClockCycle
	ADDI $s1, $s1, 4    # Increments to next instruction
	LW $t0, 0($s1)
	
	jal inputCaptureCycle
	
	BEQ $t0, 0x3F, endMain   # Checks to see if Instructions have ended
	j runClockCycleLoop
	endMain:
	di
	LA $t0, Input_Capture_Memory
	
	LW $t1, 0($t0)
	LW $t2, 4($t0)
	LW $t3, 8($t0)
	LW $t4, 12($t0)
	LW $t5, 16($t0)
	LW $t6, 20($t0)
	LW $t7, 24($t0)
	LW $t8, 28($t0)
	LW $t9, 32($t0)
	
	j mainLoop
    
    .end main
    
    .section .vector_9, code
    j InputCapture2Handler
    
    .section .vector_13, code
    j InputCapture3Handler
    
    .section .vector_20, code
    j Timer45Handler   
    