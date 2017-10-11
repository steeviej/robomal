# ***************************************************************************************************************************
# * Author: Jacob Murray                                                                                                                 *
# * Course: EE 234 Microprocessor Systems - Lab #                                                                           *
# * Project:                                                                                                                *
# * File: CodeTemplate.s                                                                                                    *
# * Description: Display's a PACMAN loop to the PMOD CLS through SPI2 on PIC32MX460512L                                                                                              *
# *                                                                                                                         *
# * Inputs:                                                                                                                 *
# * Outputs:                                                                                                                *
# * Computations:                                                                                                           *
# *                                                                                                                         *
# * Revision History:                                                                                                       *
# ***************************************************************************************************************************

.global main

.data
# The way that the sub-routine send() was developed, it looks for a 0 to stop
# sending characters. Everything will be sent to the LCD sequentially in
# memory until we see a zero (at end of prog_char_table)
all_data:
# PModCLS clear display instruction
clear_disp: .byte 0x1B, '[', 'j'
# PModCLS set display wrap instruction, we want 40 so we can scroll...
set_disp: .byte 0x1B, '[', '1', 'h'
# PModCLS set cursor instruction, for the scrolling screen no cursor...
set_curs: .byte 0x1B, '[', '0', 'c'

# Specialty characters, pacman: closed mouth right/left facing, open mouth
# right/left facing, ghost
pacman_cr: .byte 0x1B
                .ascii "[4;14;27;31;24;31;14;4;2d"
pacman_cl: .byte 0x1B
                .ascii "[4;14;27;31;3;31;14;4;3d"
pacman_or: .byte 0x1B
                .ascii "[6;15;26;28;24;28;15;6;4d"
pacman_ol: .byte 0x1B
                .ascii "[12;30;11;7;3;7;30;12;5d"
pacman_g: .byte 0x1B
                .ascii "[4;14;21;31;31;31;21;21;6d"

# PModCLS program character table instruction - adds our new characters to be
# displayed on LCD screen
prog_char_table: .byte 0x1B, '[', '3', 'p', 0x00

# For the scrolling left sequence...
# clear screen, set cursor position, print ghost x 3, pacman, put cursor
# on top of pacman so we can move his mouth
pac_stringLseq: .byte 0x1B, '[', 'j', 0x1B, '[', '0', ';', '0', 'H'
pac_stringL: .ascii "                "
        .byte 0x06, ' ', 0x06, ' ', 0x06, ' ', 0x05
        .byte 0x1B, '[', '0', ';', '2', '2', 'H', 0x00

# For the scrolling right sequence...
# clear screen, set cursor position, print pacman, ghost x 3, left shift
# characters off left edge of screen, put cursor on top of pacman so we
# can move his mouth
pac_stringRseq: .byte 0x1B, '[', 'j', 0x1B, '[', '1', ';', '1', '7', 'H'          
pac_stringR: .byte 0x04, ' ', 0x06, ' ', 0x06, ' ', 0x06
        .byte 0x1B, '[', '2', '4', '@'
        .byte 0x1B, '[', '1', ';', '1', '7', 'H', 0x00

# Perform the scroll left 1, but first update pacmans face (open->closed->open)
scroll_Left1: 
pacSpotL: .byte 0x05, 0x1B, '[', '0', ';', '2', '2', 'H'
                .byte 0x1B, '[', '1', '@', 0x00

# Perform the scroll right 1, but first update pacmans face (open->closed->open)
scroll_Right1: 
pacSpotR: .byte 0x04, 0x1B, '[', '1', ';', '1', '7', 'H'
                .byte 0x1B, '[', '1', 'A', 0x00

# Counter to keep track of how many times we have entered the timer ISR,
# each time we hit the ISR, increment count, which then causes the appropriate
# characters to be delivered to the LCD to update it.
count: .word 0

# start of instructions
.text

.ENT main
main:
DI

# Set multivectored mode
LI $t0, 1 << 12
SW $t0, INTCONSET

# setup timer 2 as our counter
jal setupTimer2

# Setup baud rate of SPI2 module, f_PBCLK/(2*(1+SPI2BRG)) = f_SPI2
LI $t0, 255
SW $t0, SPI2BRG

# Reset SPI2 control register
SW $zero, SPI2CON # Reset SPI2

# No interrupts right now

# Setup the slave select pin as an output.
# As we have only 1 slave (the LCD screen), force low, i.e. always send to LCD
LI $t0, 1 << 9
SW $t0, TRISGCLR
SW $t0, LATGCLR

# Set the MCU to master, turn on SPI2, and set correct mode for the LCD
# Mode: (1 << 8, 0 << 6)... Determined experimentally, until characters right...
LI $t0, 1 << 5
ORI $t0, 1 << 8
ORI $t0, 1 << 15
SW $t0, SPI2CON

# Setup the LCD screen. Load in all of the specialty characters
LA $a0, all_data
jal send

# Enable Timer 3 interrupt, ready to start counting.
LI $s4, 1 << 12
SW $s4, IEC0SET

EI

# Once the display sequence is complete, jump back up here to start it over.
reset:
SW $zero, count

loop:
    # If count == 0, just started sequence
    LW $s2, count
    BEQZ $s2, notstarted
    j started
    notstarted:
        #  just started, load up the left scrolling sequence
        LA $a0, pac_stringLseq
        j waitforCountInc
    started:
        # We started, check if we are supposed to be scrolling left,
        # start scrolling right, scroll right, or reset
        BLT $s2, 24, leftscroll
        BEQ $s2, 24, startright
        BEQ $s2, 50, reset
        J rightscroll
    leftscroll:
        # count > 0 and < 24, scroll left and alternate pacmans mouth
        LA $a0, scroll_Left1
        # load current mouth placement of pacman
        LB $s4, pacSpotL
        # If current mouth is closed, make open
        # 0x03 and 0x05 for closed and open respectively we chose when we
        # created the specialty characters!
        BEQ $s4, 0x03, add2
        ADDI $s4, $s4, -2
        J endadd
        add2:
            ADDI $s4, $s4, 2
        endadd:
            SB $s4, pacSpotL
        j waitforCountInc
    startright:
        # count == 24, start the scroll right sequence
        # values for count can be figured out mathematically (16 visible chars
        # on line 1, length of pacman seq..., etc) or just try it and see how
        # it runs. Found it quickly by testing values
        LA $a0, pac_stringRseq
        j waitforCountInc
    rightscroll:
        # count > 24 and < 50. Scroll right 1 and update mouth
        # at 50, pacman has disappeared from the bottom of the screen
        LA $a0, scroll_Right1
        # same thing as left. Need to alternate between open mouth right (0x04)
        # and closed mouth right (0x02)
        LB $s4, pacSpotR
        BEQ $s4, 0x02, add21
        ADDI $s4, $s4, -2
        J endadd1
        add21:
            ADDI $s4, $s4, 2
        endadd1:
            SB $s4, pacSpotR
   waitforCountInc:
        # After we have loaded the correct address to send to the LCD screen
        # Wait until the timer has triggered the ISR
        LW $s3, count
        BEQ $s2, $s3, waitforCountInc

        # Timer ISR was triggered, send next data sequence to LCD
        jal send 
j loop

.END main


.ENT send
send:
    MOVE $t0, $a0
    startSend:
    LB $t1, 0($t0)
    ADDI $t0, $t0, 1
    BEQZ $t1, endSend
    waitToSend:
        # Is the SPI2 Module busy? If so, wait to send the next char
        LW $t2, SPI2STAT
        ANDI $t2, $t2, 1 << 11
        BEQZ $t2, endWaitToSend
        J waitToSend
    endWaitToSend:
    # Even though we don't care about the data coming from the LCD
    # still want to read so a read buffer overflow doesn't happen
    LB $t3, SPI2BUF # Clear the read buffer
    SB $t1, SPI2BUF # send next char
    j startSend
    endSend:
        jr $ra
.END send

.ENT setupTimer2
setupTimer2:

	# Assuming PBCLK is set to 40MHz

	SW $zero, T2CON 	# stop Timer 2
	SW $zero, TMR2 	# reset Timer 2

    # Make T2/3 pair a 32-bit timer
    LI $t0, 1 << 3
    SW $t0, T2CON

	LI $t0, 125000	# Changing this will affect how fast Pacman moves!
	SW $t0, PR2		

    LI $t0, 0x8060 		
	SW $t0, T2CONSET		# set prescaler = 64 and start clock

    # IPC3<4:2> for Timer 3 interrupt priority
	LW $t0, IPC3
	ORI $t0, $t0, 6 << 2
	SW $t0, IPC3		# set T3 interrupt priority to 6

	JR $ra
.END setupTimer2

.SECTION .vector_12, code
    j timer3ISR

.TEXT

.ENT timer3ISR
timer3ISR:

    ADDI $sp, $sp, -8
    SW $s0, 0($sp)
    SW $s1, 4($sp)

    # Clear timer 3 interrupt flag
    LI $s0, 1 << 12
    SW $s0, IFS0CLR

    # increment count by 1
    LW $s1, count
    ADDI $s1, $s1, 1
    SW $s1, count

    LW $s0, 0($sp)
    LW $s1, 4($sp)
    ADDI $sp, $sp, 8
    ERET

.END timer3ISR



