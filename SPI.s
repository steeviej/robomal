.ifndef SPI
    SPI:
    
    .ent setupSPI1
    setupSPI1:
    
    
    jr $ra
    .end setupSPI1
    
    
    .ent setupSPI2
    setupSPI2:
    
    SW $zero, SPI2CON	# Clear the SPI2CON Register
    SW $zero, SPI2BRG	# Clear the SPI2 Baud Rate Generator
    SW $zero, SPI2BUF	# Clear the SPI2 Buffer
        
    LI $t0, 0b10
    SW $t0, SPI2CONSET	# SPI Receive Buffer Interrupt when half full or more
    
    LI $t0, 1<<5
    SW $t0, SPI2CONSET	# Set as Master Mode
    
#     LI $t0, 1<<11	# ????????????
#     SW $t0, SPI2CONSET	# 32-Bit Data, 32-Bit Fifo, 32-Bit Channel/64-Bit Frame
    
    LI $t0, 1<<23
    SW $t0, SPI2CONCLR	# Set for use with PBCLK
        
    LI $t0, 20
    SW $t0, SPI2BRG	# Set Baud Rate just under 1MHz
    
    LI $t0, 0b11100000
    SW $t0, IFS1CLR	# Clear the interrupt flags for SPI2
    
    LI $t0, 7<<26
    SW $t0, IPC7CLR
    LI $t0, 3<<26
    SW $t0, IPC7SET	# Set SPI2 Priority
    
    LI $t0, 7<<5
    SW $t0, IEC1SET	# Enable Fault, Transfer, and Receive Interrupts
    
    LI $t0, 1<< 15
    SW $t0, SPI2CONSET	# Enable SPI
    
    jr $ra
    .end setupSPI2
    
    
    .ent readSPI2
    readSPI2:
    
    LW $v0, SPI2RXB
    
    jr $ra
    .end readSPI2
    
.endif
