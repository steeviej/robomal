.ifndef Bluetooth
    Bluetooth:
    .include "UART.s"
    
    .ent setupBluetooth
    setupBluetooth:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
	LI $a0, 0b11	# Set bluetooth to TX and RX
    
	jal setupUART2
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    J $ra
    .end setupBluetooth
    
    

.endif



