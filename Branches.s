.ifndef Branches
   Branches: 
.include "ROBOMAL.s"  

    .text
    
# branchInstruction is a Function Called for use in ROBOMAL
.ent BranchInstruction
    BranchInstruction:
    
    	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	BEQZ $a0, branchJump	    # Instruction = 0 --> Branch
	BEQ $a0, 1, brancheqJump    # Instruction = 1 --> Branch Equal
	BEQ $a0, 2, branchneJump    # Instruction = 2 --> Branch Not Equal
	jal haltJump		    # Any other value --> Halt program/robot
	
	# Branch to a specific address in data memory
	branchJump:
	MOVE $a0, $a1
	jal Branch
	j endBranchInstruction
	
	# Branch to a specific data address in data memory if s0 is zero
	brancheqJump:
	MOVE $a0, $a1
	jal Brancheq
	j endBranchInstruction
	
	# Branch to a specific data address in data memory if s0 is not zero
	branchneJump:
	MOVE $a0, $a1
	jal Branchne
	j endBranchInstruction
	
	haltJump:
	MOVE $a0, $a1
	jal Halt
	j endBranchInstruction
	
	endBranchInstruction:
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
    .end BranchInstruction
    
    
    .ent Branch
    Branch:
    
    	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	LA $s1, ROBOMAL_INST_MEMORY # Resets Robomal Instruction
	SLL $t0, $t0, 2	    # Multiplies input by 4
	ADD $s1, $t0, $s1   # Moves instruction counter forward by input

	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	J $ra
    .end Branch
    
    
    .ent Brancheq
    Brancheq:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)

	BNEZ $s0, endBrancheqCheck
	
	LA $s1, ROBOMAL_INST_MEMORY # Resets Robomal Instruction
	SLL $a0, $a0, 2	    # Multiplies input by 4
	ADD $s1, $a0, $s1   # Moves instruction counter forward by input

	endBrancheqCheck:
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
    	J $ra
    .end Brancheq
    
    
    .ent Branchne
    Branchne:
 	ADDI $sp, $sp, -4
	SW $ra, 0($sp)

	BEQZ $s0, endBrancheqCheck
	
	LA $s1, ROBOMAL_INST_MEMORY # Resets Robomal Instruction
	SLL $a0, $a0, 2	    # Multiplies input by 4
	ADD $s1, $a0, $s1   # Moves instruction counter forward by input

	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
    	J $ra
    .end Branchne
    
    .ent Halt
    Halt:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	LI $t0, 0x3F
	SW $t0, 4($s1)
	# j endMain
	# MOVE $s1, $s5	    # Sets instruction counter equal to data memory
# 
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
    	J $ra
    .end Halt
    
.endif
