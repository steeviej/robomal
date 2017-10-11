.ifndef InputCompare
    InputCompare:

    # #########################################################################
    
    .ent setupIC1
    setupIC1:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    .end setupIC1
    
    # #########################################################################
    
    .ent setupIC2
    setupIC2:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	SW $zero, IC2CON    # Clear IC2CON
	
	LI $t0, 0b001
	SW $t0, IC2CONSET   # Setup for Hall Sensor Mode (Edge Detect Mode)
	
	LI $t0, 1<<7
	SW $t0, IC2CONCLR   # Operates with Timer 2
	
	
	
	LI $t0, 1<<15	    # Enable IC2
	SW $t0, IC2CONSET
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
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
	
	
	LI $t0, 1<<15	    # Enable IC3
	SW $t0, IC3CONSET
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    .end setupIC3
    
    # #########################################################################
    
    .ent setupIC4
    setupIC4:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    .end setupIC4
    
    # #########################################################################
    
    .ent setupIC5
    setupIC5:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    .end setupIC5
    
    # #########################################################################
    
    
.endif


