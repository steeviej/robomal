
    .ifndef Arithmetic
    Arithmetic:
    .include "Branches.s"
        
    .text
        
    # ArithmeticInstruction is a Function Called for use in ROBOMAL
    .ent ArithmeticInstruction
    ArithmeticInstruction:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	BEQZ $a0, additionJump		# Instruction = 0 --> Addition
	BEQ $a0, 1, subtractionJump	# Instruction = 1 --> Subtraction
	BEQ $a0, 2, multiplicationJump	# Instruction = 2 --> Multiplication
	jal Halt			# Unrecognized instruction --> Halt
	j endArithmeticInstruction
	
	# Adds a word from a cell in data memory to s0.
	 # The result is stored in s0
	additionJump:
	MOVE $a0, $a1
	jal addition
	j endArithmeticInstruction
	
	# Subtracts a word from a cell in data memory from s0.
	# The result is stored in s0
	subtractionJump:
	MOVE $a0, $a1
	jal subtraction
	j endArithmeticInstruction
	
	# Multiplies the word in s0 by a word in a specific memory cell.
	# The resilt is stored in s0
	multiplicationJump:
	MOVE $a0, $a1
	jal multiplication
	j endArithmeticInstruction
	
	endArithmeticInstruction:
	MOVE $s0, $v0	
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
    .end ArithmeticInstruction
    
    
    # Addition is called from arithematicInstruction:
    # Adds a word from a cell in data memory to s0.
    # The result is stored in s0
        .ent addition
    addition:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	MOVE $s6, $s5	    # Loads address from a cell in data memory
	LI $t0, 4	    # Temp for multiplying instruction by 4
	MUL $a0, $a0, $t0   # Multiplies input argument by 4 for indexing
	ADD $s6, $a0, $s6   # Adds input operand to data pointer
	LW $t1, 0($s6)	    # Loads word from data memory cell
	ADD $s0, $s0, $t1   # Adds data to s0 and stores sum in s0
		    
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4

	JR $ra
    .end addition
    
    
        .ent subtraction
    subtraction:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	MOVE $s6, $s5	    # Loads address from a cell in data memory
	LI $t0, 4	    # Temp for multiplying instruction by 4
	MUL $a0, $a0, $t0   # Multiplies input argument by 4 for indexing
	ADD $s6, $a0, $s6   # Adds input operand to data pointer
	LW $t1, 0($s6)	    # Loads word from data memory cell
	SUB $s0, $s0, $t1   # Subtracts data from s0 and stores difference in s0
	    
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4

	JR $ra
    .end subtraction
    
    
    
        .ent multiplication
    multiplication:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)
	
	MOVE $s6, $s5	    # Loads address from a cell in data memory
	LI $t0, 4	    # Temp for multiplying instruction by 4
	MUL $a0, $a0, $t0   # Multiplies input argument by 4 for indexing
	ADD $s6, $a0, $s6   # Adds input operand to data pointer
	LW $t1, 0($s6)	    # Loads word from data memory cell
	MULT $s0, $t1	    # Multiplies data from s0 and stores product in s0
	MFLO $s0	    # Low stored in s0
	MFHI $s6	    # High stored in s6
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4

	JR $ra
    .end multiplication
    
    
    
    # This subrouting converts 2-digit Hex values to their equivalent 
    # decimal value
    # Input	a0 = 2 Digit Hex value Representing a 2 Digit Decimal Value
    # Output	v0 = 2 Digit Hex Value corresponding to Decimal Input
    # 
    # Example: If input is 0x45, output will be 0x2D, which in decimal is 45.
    .ent hexToDecimal
    hexToDecimal:
	ADDI $sp, $sp, -4
	SW $ra, 0($sp)

	
	andi $t0, $a0, 0xF0  # 16's Place
	andi $t1, $a0, 0x0F  # 1's Place
	
	# Multiplies 16's place by 10/16
	li $t2, 10
	MULT $t0, $t2
	MFLO $v0
	srl $v0, $v0, 4
	# Adds 16's and 1's back together
	ADD $v0, $v0, $t1
	
	LW $ra, 0($sp)
	ADDI $sp, $sp, 4
	JR $ra
    .end hexToDecimal
    
.endif
    