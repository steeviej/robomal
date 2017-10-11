.ifndef LEDs
    
    LEDs:
    
    .text
    
    .ent setupLEDs
    setupLEDs:
	ADDI $sp, $sp, -4
	SW $s0, 0($sp)
	
	
	LI $s0, 0x3C00	    # Port B, 10-13
	SW $s0, TRISBCLR    # Set LEDs as Outputs
	SW $s0, LATBCLR	    # Clearn the LEDs
    
	
	LW $s0, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end setupLEDs

    
    .ent invLEDs
    invLEDs:
	ADDI $sp, $sp, -4
	SW $s0, 0($sp)
	
	SLL $s0, $a0, 10
	SW $s0, LATBINV	    # Invert Selected LEDs
	
	LW $s0, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end invLEDs
    
    
        .ent setLEDs
    setLEDs:
	ADDI $sp, $sp, -4
	SW $s0, 0($sp)
	
	SLL $s0, $a0, 10
	LI $t0, 0xFFFF
	SW $t0, LATBCLR
	SW $s0, LATBSET	    # Set selected LEDs
	
	LW $s0, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end setLEDs
    
    .ent clearLEDs
        clearLEDs:
	ADDI $sp, $sp, -4
	SW $s0, 0($sp)
	
	SLL $t0, $a0, 10
	SW $t0, LATBCLR
	
	LW $s0, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end clearLEDs
    
.endif
    