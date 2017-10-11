.ifndef LCD
    LCD:
    
    .ent setupLCD
    setupLCD:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	LI $a0, 0b10	# Set bluetooth to TX<1> and RX<0>
    
	jal setupUART1
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    J $ra
    .end setupLCD
    
    

.endif


