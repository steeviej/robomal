
    .ifndef Data
    Data:
    .include "Branches.s"
    
    
    .text
    
    
    # This subroutine functions as a branch for various Data Transfer Instructions
    # a0 = Data Instruction
    # a1 = Operand
    .ent DataInstruction
    DataInstruction:
	addi $sp, $sp, 4
	sw $ra, 0($sp)

	MOVE $t1, $a0		# Moves Operation Branching out of a0
	MOVE $a0, $a1		# Sets Up a0 Input for Jump Subroutines
	BEQZ $t1, readJump	# Instruction = 0 --> Read
	# LI $t0, 1
	BEQ $t1, 1, writeJump	# Instruction = 1 --> Write
	# LI $t0, 2
	BEQ $t1, 2, loadJump	# Instruction = 2 --> Load
	# LI $t0, 3
	BEQ $t1, 3, storeJump	# Instruction = 3 --> Store
	jal Halt		# Unrecognized instruction --> Halt
	j endDataJump

	# Reads PORTE 7:0 and stores it into a specific data memory cell
	readJump:
	    MOVE $a0, $a1
	    jal read
	    j endDataJump

	# Writes to PORTE 7:0 from a specific data memory cell
	writeJump:
	    MOVE $a0, $a1
	    jal write
	    j endDataJump

	# Loads a word from a specific data memory cell into s0
	loadJump:
	    MOVE $a0, $a1
	    jal load
	    j endDataJump

	# Stores a word from s0 into a specific data memory cell
	storeJump:
	    MOVE $a0, $a1
	    jal store
	    j endDataJump

	endDataJump:

	lw $ra, 0($sp)
	addi $sp, $sp, 4
    
	JR $ra
    .end DataInstruction
    
    .ent read
    read:
	ADDI $sp, $sp, -8
	SW $ra, 0($sp)
	SW $s1, 4($sp)
	
	LI $t1, 4	    # Multiplier for Indexing
	MUL $a0, $a0, $t1   # Multiplies input Operand by 4
	MOVE $s1, $s5	    # Uses $s1 as data pointer
	ADD $s1, $s1, $a0   # Shifts temporary data pointer to desired data cell

	LW $t0, PORTE	    # Reads state of PORTE
	SW $t0, 0($s1)	    # Stores PORTE into desired data cell
	
	LW $s1, 4($sp)
	LW $ra, 0($sp)
	ADDI $sp, $sp, 8

	JR $ra
    .end read
    
    
    .ent write
    write:
	ADDI $sp, $sp, -8
	SW $ra, 0($sp)
	SW $s1, 4($sp)
	
	LI $t1, 4	    # Multiplier for Indexing
	MUL $a0, $a0, $t1   # Multiplies input Operand by 4
	MOVE $s1, $s5	    # Uses $s1 as data pointer
	ADD $s1, $s1, $a0   # Shifts temporary data pointer to desired data cell

	LW $t0, 0($s1)	    # Stores data cell into desired data cell
	SW $t0, LATE	    # Writes data cell to PORTE

	
	LW $s1, 4($sp)
	LW $ra, 0($sp)
	ADDI $sp, $sp, 8

	JR $ra
    .end write
    
    
    .ent load
     load:
	ADDI $sp, $sp, -8
	SW $ra, 0($sp)
	SW $s1, 4($sp)
	
	LI $t1, 4	    # Multiplier for Indexing
	MUL $a0, $a0, $t1   # Multiplies input Operand by 4
	MOVE $s1, $s5	    # Uses $s1 as data pointer
	ADD $s1, $s1, $a0   # Shifts temporary data pointer to desired data cell

	LW $t0, 0($s1)	    # Stores data cell into desired data cell
	SW $t0, 0($s0)	    # Writes data cell to $s0

	
	LW $s1, 4($sp)
	LW $ra, 0($sp)
	ADDI $sp, $sp, 8
	JR $ra
    .end load
    
    
    
    .ent store
     store:
	ADDI $sp, $sp, -8
	SW $ra, 0($sp)
	SW $s1, 4($sp)
	
	LI $t1, 4	    # Multiplier for Indexing
	MUL $a0, $a0, $t1   # Multiplies input Operand by 4
	MOVE $s1, $s5	    # Uses $s1 as data pointer
	ADD $s1, $s1, $a0   # Shifts temporary data pointer to desired data cell

	SW $s0, 0($s1)	    # Stores PORTE into desired data cell
	
	LW $s1, 4($sp)
	LW $ra, 0($sp)
	ADDI $sp, $sp, 8

	JR $ra
    .end store
    
    
    .ent clearInstructionMemory
    clearInstructionMemory:
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    
	LA $t0, ROBOMAL_INST_MEMORY
	LA $t1, ROBOMAL_DATA_MEMORY
    
	clearInstructionsLoop:
	BEQ $t0, $t1, clearInstructionsComplete
	SW $zero, 0($t0)
	ADDI $t0, 4
	j clearInstructionsLoop
    
	clearInstructionsComplete:
    
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    JR $ra
    .end clearInstructionMemory
    
.endif
    