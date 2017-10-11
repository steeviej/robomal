.ifndef UART
    UART:
    
    # Transmitting serial data to LCD screen
    
    # #######################################################################
    # 
    # a1 : 0bAB, A=1 --> Receive , B=1 --> Transmit
    # 
    
    .ent setupUART1
    setupUART1:
    
	# 1. Set the Baud Rate ~ 9600Hz
	LI $t0, 259
	SW $t0, U1BRG
	
	# 2. UART serial fram == 8 data bits, 1 stop bit, no parity
	SW $zero, U1MODE    # reset the UART and set-up frame
	SW $zero, U1STA	    # reset the status register
    
	# 3. Interrupts
	# none for now
	
	# 4. Set the UART TX mode (transmission)
	ANDI $t0, $a1, 1
	LI $t0, 1<<10
	SW $t0, U1STASET

	# 4. Set the UART TX mode (transmission)
	ANDI $t0, $a1, 2
	LI $t0, 1<<11
	SW $t0, U1STASET
	
	# 5. Enable the UART module
	LI $t0, 1<<15
	SW $t0, U1MODESET
	
	JR $ra
    .end setupUART1
    
    
    # #######################################################################
    
    # Transmitting serial data to LCD screen
    .ent setupUART2
    setupUART2:
    
	# 1. Set the Baud Rate ~ 9600Hz
	LI $t0, 259
	SW $t0, U2BRG
	
	# 2. UART serial fram == 8 data bits, 1 stop bit, no parity
	SW $zero, U2MODE    # reset the UART and set-up frame
	SW $zero, U2STA	    # reset the status register
    
	# 3. Interrupts
	# none for now
	
	# 4. Set the UART TX and RX modes (transmission/Reception)
	ANDI $t0, $a0, 1
	LI $t0, 1<<10
	SW $t0, U2STASET    # Set Transmit

	ANDI $t0, $a0, 2
	SLL $t0, $t0, 11
	SW $t0, U2STASET    # Set Receive

	# 5. Enable the UART module
	LI $t0, 1<<15
	SW $t0, U2MODESET
	
	JR $ra
    .end setupUART2
    
    
    # #######################################################################
    
    # Send a string of characters out through UART1 (until a 0 is seen)
    # a0 == Data to read (address)
    .ent sendUART1message
    sendUART1message:
	
	Move $t0, $a0
	startSend:
	    LB $t1, 0($t0)
	    ADDI $t0, $t0, 1
	    BEQZ $t1, endSend
	   
	waitToSend:
	    LW $t2, U1STA
	    ANDI $t2, $t2, 1<<9
	    BEQZ $t2, endWaitToSend
	    J waitToSend
	
	endWaitToSend:
	    SB $t1, U1TXREG
	    J startSend
	
	endSend:    
    
	JR $ra
    .end sendUART1message
    
    
    # #######################################################################
    
        .ent receiveUART1message
    receiveUART1message:
	
	Move $t0, $a0
	startReceive:
	    LB $t1, 0($t0)
	    ADDI $t0, $t0, 1
	    BEQZ $t1, endReceive
	   
	waitToReceive:
	    LW $t2, U1STA
	    ANDI $t2, $t2, 1<<9
	    BEQZ $t2, endWaitToReceive
	    J waitToSend
	
	endWaitToReceive:
	    SB $t1, U1RXREG
	    J startSend
	
	endReceive:    
    
	JR $ra
    .end receiveUART1message
    
    
    # #######################################################################
    
        .ent sendUART2message
    sendUART2message:
	
	Move $t0, $a0
	startSend2:
	    LB $t1, 0($t0)
	    ADDI $t0, $t0, 1
	    BEQZ $t1, endSend2
	   
	waitToSend2:
	    LW $t2, U2STA
	    ANDI $t2, $t2, 1<<9
	    BEQZ $t2, endWaitToSend2
	    J waitToSend2
	
	endWaitToSend2:
	    SB $t1, U2TXREG
	    J startSend2
	
	endSend2:    
    
	JR $ra
    .end sendUART2message
    
    
    # #######################################################################
    
        .ent receiveUART2Word
    receiveUART2Word:
	
# 	startReceive2:
# 	    LB $t0, 0($s1)
# 	    ADDI $s1, $s1, 1
# 	   
# 	waitToReceive2:
# 	    LW $t2, U2STA
# 	    ANDI $t2, $t2, 1<<9
# 	    BEQZ $t2, endWaitToReceive2
# 	    J waitToSend2
# 	
# 	endWaitToReceive2:
# 	    SB $t1, U2RXREG
# 	    J startSend2
	
# 	startReceive2:
# 	    MOVE $t0, $s1
	    
	UART2waitToReceive1:
	    LW $t2, U2STA
	    ANDI $t2, $t2, 1
	    BEQ $t2, 1, UART2storeXX00
	    j UART2waitToReceive1
	    
	UART2storeXX00:	    # Loads and Stores Most Significant Byte of Instruction
	    LB $t0, U2RXREG
	    BEQ $t0, 0x3F, UART2endReceive	# Exits if '?' is detected
	    # ANDI $t0, $t0, 0xF
	    SLL $t0, $t0, 8
	    
	UART2waitToReceive2:
	    LW $t2, U2STA
	    ANDI $t2, $t2, 1
	    BEQ $t2, 1, UART2store00X0
	    j UART2waitToReceive2
	
# 	UART2store0X00:	    # Loads and Stores Second Byte of Instruction
# 	    LB $t1, U2RXREG
# 	    ANDI $t1, $t1, 0xF
# 	    SLL $t1, $t1, 8
# 	    OR $t0, $t1, $t0
# 	    
# 	UART2waitToReceive3:
# 	    LW $t2, U2STA
# 	    ANDI $t2, $t2, 1
# 	    BEQ $t2, 1, UART2store00X0
# 	    j UART2waitToReceive3
	    
	UART2store00X0:    # Loads and Stores Third Byte of Instruction
	    LB $t1, U2RXREG
	    ANDI $t1, $t1, 0xF
	    SLL $t1, $t1, 4
	    OR $t0, $t1, $t0
	    
	UART2waitToReceive4:
	    LW $t2, U2STA
	    ANDI $t2, $t2, 1
	    BEQ $t2, 1, UART2store000X
	    j UART2waitToReceive4
	    
	UART2store000X:    # Loads and Stores Least Significant Byte of Instruction
	    LB $t1, U2RXREG
	    ANDI $t1, $t1, 0xF
	    OR $t0, $t1, $t0
	    
	UART2endReceive:    
	    MOVE $v0, $t0
	
	JR $ra
    .end receiveUART2Word   

.endif
