.ifndef Timers
    
    # For all setupTimerx
    # a0 --> prescale
    # a1 --> period register
    Timers:

    # #########################################################################
#     .ent setupTimer1
#     setupTimer1:
#     ADDI $sp, -4
#     SW $ra, 0($sp)
#     
# 	# Clear ON bit  <15>
# 	# Set PBCLK	<1> = 0
# 	LI $t0, 0b1000000000000010
# 	SW $t0, T1CONCLR
# 	
# 	# Clears The Prescale Value
# 	LI $t0, 0b1110000
# 	SW $t0, T1CONCLR
# 
# 
# 	SLL $a0, $a0, 4	    # Use input a0 as Prescale <7:4>
# 	SW $a0, T1CONSET    # Set T1 with prescale 1:8
# 
# 	# Clear Timer Registers
# 	SW $zero, TMR1
# 	
# 	# Set Period Register
# 	SW $a1, PR1
# 	
# 	# Clear Interrupt Flag of T1
# 	LI $t0, 1<<4
# 	SW $t0, IFS0CLR
# 
# 	# Set Timer Priority
# 	LI $t0, 6<<2
# 	SW $t0, IPC1SET
#            
# 	# Enable the Interrupt
# 	LI $t0, 1<<4
# 	SW $t0, IEC0SET
# 	
# 	# Enable the Timer
# 	LI $t0, 1<<15
# 	SW $t0, T2CONSET
# 	
#     LW $ra, 0($sp)
#     ADDI $sp, -4
#     JR $ra
#     .end setupTimer1
    
    # #########################################################################
    .ent setupTimer2
    setupTimer2:
    ADDI $sp, -4
    SW $ra, 0($sp)
    
	# Clear ON bit  <15>
	# Set PBCLK	<1> = 0
	LI $t0, 0b1000000000000010
	SW $t0, T2CONCLR
	
	# Clears The Prescale Value
	LI $t0, 0b1110000
	SW $t0, T2CONCLR


	SLL $a0, $a0, 4	    # Use input a0 as Prescale <6:4>
	SW $a0, T2CONSET    # Set T2 with prescale 1:8

	# Clear Timer Registers
	SW $zero, TMR2
	
	# Set Period Register
	SW $a1, PR2
	
# 	# Clear Interrupt Flag of T2
# 	LI $t0, 1<<8
# 	SW $t0, IFS0CLR
# 
# 	# Set Timer Priority
# 	LI $t0, 6<<2
# 	SW $t0, IPC2SET
           
	# Enable the Interrupt
# 	LI $t0, 1<<8
# 	SW $t0, IEC0SET
	
	# Enable the Timer
	LI $t0, 1<<15
	SW $t0, T2CONSET
	
    LW $ra, 0($sp)
    ADDI $sp, -4
    JR $ra
    
    .end setupTimer2
    
    # ########################################################################
    .ent setupTimer3
    setupTimer3:
    ADDI $sp, -4
    SW $ra, 0($sp)
    
	# Clear ON bit  <15>
	# Set PBCLK	<1> = 0
	LI $t0, 0b1000000000000010
	SW $t0, T3CONCLR
	
	# Clears The Prescale Value
	LI $t0, 0b1110000
	SW $t0, T3CONCLR


	SLL $a0, $a0, 4	    # Use input a0 as Prescale <7:4>
	SW $a0, T3CONSET    # Set T3 with prescale 1:8

	# Clear Timer Registers
	SW $zero, TMR3
	
	# Set Period Register
	SW $a1, PR3
	
# 	# Clear Interrupt Flag of T3
# 	LI $t0, 1<<12
# 	SW $t0, IFS0CLR
# 
# 	# Set Timer Priority
# 	LI $t0, 6<<2
# 	SW $t0, IPC3SET
#            
# 	# Enable the Interrupt
# 	LI $t0, 1<<12
# 	SW $t0, IEC0SET
	
	# Enable the Timer
	LI $t0, 1<<15
	SW $t0, T3CONSET
	
    LW $ra, 0($sp)
    ADDI $sp, -4
    JR $ra
    .end setupTimer3
    
    
    
    # #########################################################################
#      .ent setupTimer23
#     # a0 sets timer prescaler
#     # a1 COULD be flag value
#     setupTimer23:
#     ADDI $sp, -4
#     SW $ra, 0($sp)
#     
# 	# Clear ON bit  <15>
# 	# Set PBCLK	<1> = 0
# 	LI $t0, 0b1000000000000010
# 	SW $t0, T2CONCLR
# 	
# 	# Clears The Prescale Value
# 	LI $t0, 0b1110000
# 	SW $t0, T2CONCLR
# 
# 	# Setup for 32 Bit Timer
# 	# TxCon<3> =1
# 	LI $t0, 0b1000
# 	SLL $a0, $a0, 4	    # Use input a0 as Prescale <7:4>
# 	OR $t0, $t0, $a0    # Combine with 32 bit set
# 	SW $t0, T2CONSET    # Set T2 as 23 with prescale 1:8
# 
# 	# Clear Timer Registers
# 	SW $zero, TMR2
# 	
# 	# Set Period Register
# 	SW $a1, PR2
# 	
# 	# Clear Interrupt Flag of T3
# 	LI $t0, 1<<12
# 	SW $t0, IFS0CLR
# 
# 	# Set Timer Priority
# 	LI $t0, 6<<2
# 	SW $t0, IPC3SET
#            
# 	# Enable the Interrupt
# 	LI $t0, 1<<12
# 	SW $t0, IEC0SET
# 	
# 	# Enable the Timer
# 	LI $t0, 1<<15
# 	SW $t0, T2CONSET
# 	
#     LW $ra, 0($sp)
#     ADDI $sp, -4
#     JR $ra
#     .end setupTimer23
    
    
    
    # ########################################################################
#     .ent setupTimer4
#     setupTimer4:
#     ADDI $sp, -4
#     SW $ra, 0($sp)
#     
# 	# Clear ON bit  <15>
# 	# Set PBCLK	<1> = 0
# 	LI $t0, 0b1000000000000010
# 	SW $t0, T4CONCLR
# 	
# 	# Clears The Prescale Value
# 	LI $t0, 0b1110000
# 	SW $t0, T4CONCLR
# 
# 
# 	SLL $a0, $a0, 4	    # Use input a0 as Prescale <7:4>
# 	SW $a0, T4CONSET    # Set T4 with prescale 1:8
# 
# 	# Clear Timer Registers
# 	SW $zero, TMR4
# 	
# 	# Set Period Register
# 	SW $a1, PR4
# 	
# 	# Clear Interrupt Flag of T4
# 	LI $t0, 1<<16
# 	SW $t0, IFS0CLR
# 
# 	# Set Timer Priority
# 	LI $t0, 6<<2
# 	SW $t0, IPC4SET
#            
# 	# Enable the Interrupt
# 	LI $t0, 1<<16
# 	SW $t0, IEC0SET
# 	
# 	# Enable the Timer
# 	LI $t0, 1<<15
# 	SW $t0, T4CONSET
# 	
#     LW $ra, 0($sp)
#     ADDI $sp, -4
#     JR $ra
#     .end setupTimer4
    
    
    
    # ########################################################################
#     .ent setupTimer5
#     setupTimer5:
#     ADDI $sp, -4
#     SW $ra, 0($sp)
#     
# 	# Clear ON bit  <15>
# 	# Set PBCLK	<1> = 0
# 	LI $t0, 0b1000000000000010
# 	SW $t0, T5CONCLR
# 	
# 	# Clears The Prescale Value
# 	LI $t0, 0b1110000
# 	SW $t0, T5CONCLR
# 
# 
# 	SLL $a0, $a0, 4	    # Use input a0 as Prescale <7:4>
# 	SW $a0, T5CONSET    # Set T2 with prescale 1:8
# 
# 	# Clear Timer Registers
# 	SW $zero, TMR5
# 	
# 	# Set Period Register
# 	SW $a1, PR5
# 	
# 	# Clear Interrupt Flag of T5
# 	LI $t0, 1<<20
# 	SW $t0, IFS0CLR
# 
# 	# Set Timer Priority
# 	LI $t0, 6<<2
# 	SW $t0, IPC5SET
#            
# 	# Enable the Interrupt
# 	LI $t0, 1<<20
# 	SW $t0, IEC0SET
# 	
# 	# Enable the Timer
# 	LI $t0, 1<<15
# 	SW $t0, T5CONSET
# 	
#     LW $ra, 0($sp)
#     ADDI $sp, -4
#     JR $ra
#     .end setupTimer5
  
    
    
    
    # ########################################################################
    .ent setupTimer45
    setupTimer45:
     ADDI $sp, -4
    SW $ra, 0($sp)
    
	# Clear ON bit  <15>
	# Set PBCLK	<1> = 0
	LI $t0, 0b1000000000000010
	SW $t0, T4CONCLR
	
	# Clears The Prescale Value
	LI $t0, 0b1110000
	SW $t0, T4CONCLR

	# Setup for 32 Bit Timer
	# TxCon<3> =1
	LI $t0, 0b1000
	SLL $a0, $a0, 4	    # Use input a0 as Prescale <7:4>
	OR $t0, $t0, $a0    # Combine with 32 bit set
	SW $t0, T4CONSET    # Set T4 as 45 with prescale 1:8

	# Clear Timer Registers
	SW $zero, TMR4
	
	# Set Period Register
	SW $a1, PR4
	
	# Clear Interrupt Flag of T5
	LI $t0, 1<<20
	SW $t0, IFS0CLR

	# Set Timer Priority
	LI $t0, 6<<2
	SW $t0, IPC5SET
           
	# Enable the Interrupt
	LI $t0, 1<<20
	SW $t0, IEC0SET
	

	
    LW $ra, 0($sp)
    ADDI $sp, 4
    JR $ra
    
    .end setupTimer45
    
       
# ###########################################################################
# .section .vector_4, code
# j Timer1Handler
# 
# .text
# # ISR for External Interrupt 4
# .ent Timer1Handler
# Timer1Handler:
#     
#     eret
# .end Timer1Handler

    
# ###########################################################################
# .section .vector_8, code
# j Timer2Handler

# .text
# # ISR for External Interrupt 4
# .ent Timer2Handler
# Timer2Handler:
#     di
#     addi $sp, -4
#     sw $t0, 0($sp)
#     
# 	# Clear the interrupt flag
# 	LI $t0, 1 << 8
# 	SW $t0, IFS0CLR
#     
#     sw $t0, 0($sp)    
#     addi $sp, 4
#     ei
#     eret
# .end Timer2Handler

    
# ###########################################################################
# .section .vector_12, code
# j Timer3Handler

# .text
# # ISR for External Interrupt 4
# .ent Timer3Handler
# Timer3Handler:
#     di
#     addi $sp, -4
#     sw $t0, 0($sp)
#     
# 	# Clear the interrupt flag
# 	LI $t0, 1 << 12
# 	SW $t0, IFS0CLR
#     
#     sw $t0, 0($sp)    
#     addi $sp, 4
#     ei
#     eret
# .end Timer3Handler

    
# ###########################################################################
# .section .vector_12, code
# j Timer23Handler

# .text
# # ISR for External Interrupt 4
# .ent Timer23Handler
# Timer23Handler:
# 
#     di	# Disable Interrupts
#     addi $sp, $sp, -4
#     sw $t0, 0($sp)
#     
#     li $t0, 1 << 12 # Clear timer 3 flag
#     sw $t0, IFS0CLR
#     
#     lw $t0, 0($sp)
#     addi $sp, $sp, 4
#     
#     ei
#     eret
# .end Timer23Handler
    

    
# ###########################################################################
# .section .vector_16, code
# j Timer4Handler
# 
# .text
# # ISR for External Interrupt 4
# .ent Timer4Handler
# Timer4Handler:
#     
#     eret
# .end Timer4Handler


	
# ###########################################################################
# .section .vector_20, code
# j Timer5Handler

# .text
# # ISR for External Interrupt 4
# .ent Timer5Handler
# Timer5Handler:
#     
#     eret
# .end Timer5Handler

 
	
# ###########################################################################
#         .section .vector_20, code
# j Timer45Handler

.text
# ISR for External Interrupt 4
.ent Timer45Handler
Timer45Handler:
   di	# Disable Interrupts
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    
    
    li $t0, 1 << 20 # Clear Timer 5 flag
    sw $t0, IFS0CLR
    
    addi $s4, $s4, -1
    
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    
    ei
    eret  
    
.end Timer45Handler

    
    .ent delay
delay:

    delayLoop:
    BEQZ $a0, endDelayLoop
    ADDI $a0, $a0, -1
    J delayLoop

    endDelayLoop:

    JR $ra
.end delay
    
       
.endif

   