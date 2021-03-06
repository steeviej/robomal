    .include "Arithmetic.s"
    .include "Branches.s"
    .include "DATA.s"
    .include "LEDs.s"
    .include "RCI.s"   
    .include "timers.s"
    
    .ifndef ROBOMAL
    
    ROBOMAL:
    
    .data

    # ROBOMAL Program stored here
    ROBOMAL_INST_MEMORY: .space 1024

    # ROBOMAL data stored here
    ROBOMAL_DATA_MEMORY: .space 1024
        
    .text
    

    # a0 = Instruction Pointer
    # v0 = Instruction Code
    .ent fetch
    fetch:
	LW $v0, 0($a0)	    # Loads the word at the current instruction address	
	JR $ra
    .end fetch
    
    # int, int decode(int IR)
    # a0 = instruction register
    # v0 = opcode
    # v1 = operand
    .ent decode
    decode:
	ADDI $sp, $sp, -8
	SW $ra, 0($sp)
	SW $s0, 4($sp)
	
	SRL $s0, $a0, 8		# Places Instruction in $s0
	AND $v1, $a0, 0xFF	# Places Operand in $v1
	
	MOVE $a0, $v1
	jal hexToDecimal	# Convert operand from hex to binary
	
	MOVE $v1, $v0		# $v1 is operand
	MOVE $v0, $s0		# $v0 is instruction
	
	LW $s0, 4($sp)
	LW $ra, 0($sp)
	ADDI $sp, $sp, 8
	JR $ra
    .end decode
    
    # void decode(int opcode, int operand)
    # a0 = opcode
    # a1 = operand
    .ent execute
    execute:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	SRL $t0, $a0, 4	    # MSD of Operation Code
	ANDI $a0, $a0, 0xF  # LSD of Operation Code
	
	# Branching based on MSD of Operation Code
	BEQ $t0, 1, dataTransferInstruction

	BEQ $t0, 2, arithmeticInstruction
	
	BEQ $t0, 3, branchInstruction
	
	BEQ $t0, 4, rcinstruction4
	
	BEQ $t0, 5, rcinstruction5
	
	BEQ $t0, 6, rcinstruction6
	
	BEQ $t0, 7, rcinstruction7
	
	JAL Halt
	j endInstructionBranch	# Unrecognized instruction --> Halt
	
	dataTransferInstruction:
	    JAL DataInstruction
	    J endInstructionBranch
	
	arithmeticInstruction:
	    JAL ArithmeticInstruction
	    J endInstructionBranch
	
	branchInstruction:
	    LA $s1, ROBOMAL_INST_MEMORY
	    JAL BranchInstruction
	    J endInstructionBranch
	
	rcinstruction4:
	    JAL RCI4
	    J endInstructionBranch
	    
	rcinstruction5:
	    JAL RCI5
	    J endInstructionBranch
	    
	rcinstruction6:
	    JAL RCI6
	    J endInstructionBranch
	    
	rcinstruction7:
	    JAL RCI7
	    J endInstructionBranch
	
	endInstructionBranch:
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	JR $ra
    .end execute
    
    
     # void runClockCycle(void)
    .ent runClockCycle
    runClockCycle:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	MOVE $a0, $s1 # Setup inputs to fetch
	jal fetch
	MOVE $s2, $v0 # Store outputs from fetch
	
	MOVE $a0, $s2 # Setup inputs to decode
	jal decode
	MOVE $s3, $v0 # Store operation from decode
	MOVE $s4, $v1 # store operand from decode
	
	MOVE $a0, $s3 # Setup operation for decode
	MOVE $a1, $s4 # Setup operand for decode
	jal execute
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	
	JR $ra
    .end runClockCycle
    
.endif
    