import definitions::*;

module ControlDecoder(
	input [8:0]				Instruction,
	
//	output logic			start,
	output logic			halt,
	
	output logic			beq,
	output logic			bne,
	output logic			bgt,
	
	output logic			WriteReg,
	output logic [2:0]	ALUSrcA,
	output logic [3:0]	ALUSrcB,
	output logic 			RegIn,
	output logic [3:0]	MemAddr,
	output logic [3:0]	MemIn,
	output logic			MemRead,
	output logic			MemWrite,
	output logic [2:0]	ALUOp
);


always_comb begin

	logic [2:0]	op_code;
	op_code = Instruction[7:5];
	
	// Initialize all output to zero
	// start = 0;
	halt = 0;
	beq = 0;
	bne = 0;
	bgt = 0;
	WriteReg = 0;
	ALUSrcA = 0;
	ALUSrcB = 0;
	RegIn = 0;
	MemAddr = 0;
	MemIn = 0;
	MemRead = 0;
	MemWrite = 0;
	ALUOp = 0;

	// Case R-type and SR-type
	if (Instruction[8] == 1'b0 && 
		 Instruction[0] == 1'b0) begin
		 
		case (op_code)
			// Add register
			3'b000: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				RegIn = 0;
				ALUSrcA = 0;
				ALUSrcB = 0;
				ALUOp = kADD;
			end
			
			// Sub register
			3'b001: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				RegIn = 0;
				ALUSrcA = 0;
				ALUSrcB = 0;
				ALUOp = kSUB;
			end
			
			// Xor register
			3'b010: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				RegIn = 0;
				ALUSrcA = 0;
				ALUSrcB = 0;
				ALUOp = kXOR;
			end
			
			// Load into register
			3'b011: begin
				MemWrite = 0;
				MemRead = 1;
				RegIn = 1;
				WriteReg = 1;
				MemAddr = 0;
				// start = 0;
				beq = 0;
				halt = 0;
				ALUSrcA = 0;
				ALUSrcB = 0;
			end
			
			// Store byte to memory
			3'b100: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 0;
				MemRead = 0;
				MemWrite = 1;
				ALUSrcA = 0;
				ALUSrcB = 0;
				MemAddr = 0;
				MemIn = 0;
			end
			
			// Sll $s1, $s1, 1
			3'b101: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 0;
				ALUSrcB = 4'd9;	// contains 8'd1
				RegIn = 0;
				ALUOp = kSLL;
			end
			
			// srl reg1, shamt
			3'b110: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 0;
				ALUSrcB = 4'd1;	// instShamt
				RegIn = 0;
				ALUOp = kSRL;
			end
			
			// Default instruction
			default: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				RegIn = 0;
			end
			
		endcase
		
	end

	// Case I-type
	else if (Instruction[8] == 1'b1) begin
		case (op_code)
			
			// addi reg1, imm
			3'b000: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 0;		// rs
				ALUSrcB = 4'd2;	// instImmed
				ALUOp = kADD;
				RegIn = 0;
			end
			
			// li rs, imm
			3'b001: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 3'd2;	// 8'd0
				ALUSrcB = 4'd2;	// instImmed
				ALUOp = kADD;
				RegIn = 0;
			end
			
			// lov
			3'b010: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 0;		// rs
				ALUSrcB = 4'd3;	// 8'd0
				ALUOp = kADD;
				RegIn = 0;
			end
			
			// AND
			3'b101: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 0;		// rs
				ALUSrcB = 4'd2;	// instImmed
				ALUOp = kAND;
				RegIn = 0;
			end
			
			default: begin
				// start = 0;
				beq = 0;
				halt = 0;
				WriteReg = 1;
				MemRead = 0;
				MemWrite = 0;
				ALUSrcA = 0;		// rs
				ALUSrcB = 4'd2;	// instImmediate
				ALUOp = kADD;
				RegIn = 0;
			end
			
		endcase
	end
	
	// Case S-type
	else begin

		// 1. Case init_pattern
		if (Instruction == 9'b000000001) begin
			// start = 0;
			halt = 0;
			beq = 0;
			WriteReg = 1;
			ALUSrcA = 0;
			ALUSrcB = 0;
			RegIn = 1;
			MemAddr = 4'd1;
			MemIn = 0;
			MemRead = 1;
			MemWrite = 0;
			ALUOp = kADD;
		end

		// 2. init_seed
		else if (Instruction == 9'b000000011) begin
			RegIn = 1;
			MemAddr = 4'd2;
			WriteReg = 1;

			// start = 0;
			halt = 0;
			beq = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			MemIn = 0;
			MemRead = 1;
			MemWrite = 0;
			ALUOp = kADD;
		end

		// 3. init_string_length
		else if (Instruction == 9'b000000101) begin
			WriteReg = 1;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;

			// start = 0;
			halt = 0;
			beq = 0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kADD;
		end

		// 4. load_input_string
		else if (Instruction == 9'b000000111) begin
			WriteReg = 1;
			MemRead = 0;
			RegIn = 0;
			MemAddr = 4'd0;

			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			
			// start = 0;
			halt = 0;
			beq = 0;
			MemIn = 0;
			MemWrite = 0;
			ALUOp = kADD;
		end

		// 5. loadPreamble
		else if (Instruction == 9'b000001001) begin
			WriteReg = 1;
			MemRead = 0;
			RegIn = 0;
			
			ALUSrcA = 3'd1;
			ALUSrcB = 4'd3;

			// start = 0;
			halt = 0;
			beq = 0;
			MemIn = 0;
			MemWrite = 0;
			ALUOp = kADD;
			MemAddr = 4'd0;
		end

		// 6. Store_space
		else if (Instruction == 9'b000001011) begin
			MemWrite = 1;
			MemIn = 4'd1;
			MemAddr = 4'd5;

			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			RegIn = 0;
			WriteReg = 0;
			ALUOp = kADD;
			ALUSrcA = 0;
			ALUSrcB = 0;
		end

		// 7. Load_space
		else if (Instruction == 9'b000001101) begin
			WriteReg = 1;
			MemIn = 1;
			RegIn = 1;
			MemAddr = 4'd5;
			MemRead = 1;

			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			ALUOp = kADD;
			ALUSrcA = 0;
			ALUSrcB = 0;
		end

		// 8. Get_remaining_length
		else if (Instruction == 9'b000001111) begin
			WriteReg = 1;
			ALUOp = kSUB;
			ALUSrcA = 3'd1;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
			
		end

		// 9. And_pattern_seed
		else if (Instruction == 9'b000010001) begin
			WriteReg = 1;
			ALUOp = kAND;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 10. Get_parity_bit
		else if (Instruction == 9'b000010011) begin
			WriteReg = 1;
			ALUOp = kAND;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 11. Add_seed_tapped
		else if (Instruction == 9'b000010101) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 12. And_seed_255
		else if (Instruction == 9'b000010111) begin
			WriteReg = 1;
			ALUOp = kAND;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd8;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 13. Xor_seed_stringchar
		else if (Instruction == 9'b000011001) begin
			WriteReg = 1;
			ALUOp = kXOR;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 14. Xor_space_char_t0
		else if (Instruction == 9'b000011011) begin
			WriteReg = 1;
			ALUOp = kXOR;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd5;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 15. bne $t2, 16, loop_space_filler (change to bne $t2, $r0, loop_space_filler)
		else if (Instruction == 9'b000011101) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 16. beq $t2, 0, postamble (change to $t2, $r0, postamble)
		else if (Instruction == 9'b000011111) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 17. beq $zero, $zero, end
		else if (Instruction == 9'b000100001) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 18. beq $zero, $zero, loop_currPattern
		else if (Instruction == 9'b001110111) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 19. beq $zero, $zero, loop_prefix_detect
		else if (Instruction == 9'b000100011) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 20. beq $t2, 0, copy_string_done
		else if (Instruction == 9'b000100101) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd3;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 21. beq $zero, $zero, loop_copy_string
		else if (Instruction == 9'b000100111) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end		

		// 22. beq $t2, 9, end
		else if (Instruction == 9'b000101001) begin
			// start = 0;
			halt = 0;
			beq = 1;
			bne = 0;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd4;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end	

		// 23. bne $t3, 0x20, break_true
		else if (Instruction == 9'b000101011) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd5;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end	

		// 24. bne $t0, $s2, loop_decrypt (machine code )
		else if (Instruction == 9'b000101101) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end	

		// 25. bne $t2, 0x20, loop_prefix_detect_done (machine code )
		else if (Instruction == 9'b000101111) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd5;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end	

		// 26. bgt $t0, 8, increment (machine code )
		else if (Instruction == 9'b000110001) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 0;
			bgt = 1;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd6;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end	

		// 27. and $t1, $s0, $s1 (machine code )
		else if (Instruction == 9'b000110011) begin
			WriteReg = 1;
			ALUOp = kAND;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end	

		// 28. and $t1, $t1, 1 (machine code ) 
		else if (Instruction == 9'b000110101) begin
			WriteReg = 1;
			ALUOp = kAND;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end	

		// 29. add $s1, $s1, $t1 (machine code ) → write to r0
		else if (Instruction == 9'b000110111) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end	

		// 30. lbu $t1, $s4 (machine code )
		else if (Instruction == 9'b000111001) begin
			WriteReg = 1;
			MemRead = 1;
			MemAddr = 4'd0;
			RegIn = 1;

			ALUSrcA = 0;
			ALUSrcB = 0;
			MemIn = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			ALUOp = kADD;
		end	

		// 31. xor $t3, $s1, $t1 (machine code )
		else if (Instruction == 9'b000111011) begin
			WriteReg = 1;
			ALUOp = kXOR;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end	

		// 32. sb  $t3, $s5 (machine code )
		else if (Instruction == 9'b000111101) begin
			MemWrite = 1;

			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end	

		// 33. addi    $s4, $s4, 1  (machine code )
		else if (Instruction == 9'b000111111) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end	

		// 34. addi    $s5, $s5, 1  (machine code )
		else if (Instruction == 9'b001000001) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end	

		// 35. sb  $zero, $s5 (machine code )
		else if (Instruction == 9'b001000011) begin
			MemWrite = 1;
			MemIn = 4'd2;
			MemAddr = 4'd0;
			
			ALUSrcB = 4'd0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			RegIn = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end	

		// TODO: Double check if this is correct
		// 36. la  $t0, decrypted_string (machine code )
		else if (Instruction == 9'b001000101) begin
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			WriteReg = 1;
			RegIn = 0;
			
			MemIn = 0;
			MemAddr = 0;
			MemWrite = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end	

		// 37. la  $t1, decrypted_string (machine code )
		else if (Instruction == 9'b001000111) begin
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			WriteReg = 1;
			RegIn = 0;
			
			MemIn = 0;
			MemAddr = 0;
			MemWrite = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end	

		// 38. sb  $zero, $t1  (machine code )
		else if (Instruction == 9'b001001001) begin
			MemWrite = 1;
			MemIn = 4'd2;
			MemAddr = 4'd0;
			
			ALUSrcB = 0;
			WriteReg = 0;
			ALUSrcA = 0;
			RegIn = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end

		// 39. bne $t1, 54, copy_string_done (machine code )
		else if (Instruction == 9'b001001011) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd7;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 40. load_encrypt_s4  (machine code )
		else if (Instruction == 9'b001001101) begin
			WriteReg = 1;
			MemRead = 0;
			MemAddr = 4'd0;
			
			ALUSrcA = 1;
			ALUSrcB = 4'd3;
			RegIn = 0;
			MemIn = 0;
			MemWrite = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			ALUOp = kADD;
		end

		// 41. la  $s5, decrypted_string (machine code )
		else if (Instruction == 9'b001001111) begin
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd3;
			WriteReg = 1;
			RegIn = 0;
			
			MemIn = 0;
			MemAddr = 0;
			MemWrite = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end

		// 42. lbu $t0, $s4 (machine code )
		else if (Instruction == 9'b001010001) begin
			WriteReg = 1;
			MemRead = 1;
			MemAddr = 4'd0;
			RegIn = 1;

			ALUSrcA = 0;
			ALUSrcB = 0;
			MemIn = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			ALUOp = kADD;
		end

		// 43. addi    $s4, 1 (machine code )
		else if (Instruction == 9'b001010011) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 44. addi    $s5, 1 (machine code )
		else if (Instruction == 9'b001010101) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 45. add $s3, $s3, $t2 (machine code )
		else if (Instruction == 9'b001010111) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 46. lbu $s0, ($s3) (machine code )
		else if (Instruction == 9'b001011001) begin
			WriteReg = 1;
			MemRead = 1;
			MemAddr = 4'd0;
			RegIn = 1;

			ALUSrcA = 0;
			ALUSrcB = 0;
			MemIn = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			ALUOp = kADD;
		end

		// 47. move    $t1, $s1 (machine code )
		else if (Instruction == 9'b001011011) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd0;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 48. sll $s1, $s1, 1 (machine code )
		else if (Instruction == 9'b001011101) begin
			WriteReg = 1;
			ALUOp = kSLL;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		// 49. store   0xe1, 55 (machine code )
		else if (Instruction == 9'b001011111) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd4;
			MemAddr = 4'd6;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
			$display("storing to memory 55");
			
		end

		// 50. store   0xd4, 56 (machine code )
		else if (Instruction == 9'b001100001) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd5;
			MemAddr = 4'd7;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 51. store   0xc6, 57 (machine code )
		else if (Instruction == 9'b001100011) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd6;
			MemAddr = 4'd8;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 52. store   0xb8, 58 (machine code )
		else if (Instruction == 9'b001100101) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd7;
			MemAddr = 4'd9;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 53. store   0xb4, 59 (machine code )
		else if (Instruction == 9'b001100111) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd8;
			MemAddr = 4'd10;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 54. store   0xb2, 60 (machine code )
		else if (Instruction == 9'b001101001) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd9;
			MemAddr = 4'd11;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 55. store   0xfa, 61  (machine code )
		else if (Instruction == 9'b001101011) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd10;
			MemAddr = 4'd12;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 56. store   0xf3, 62 (machine code )
		else if (Instruction == 9'b001101101) begin
			WriteReg = 0;
			ALUOp = kADD;
			MemIn = 4'd11;
			MemAddr = 4'd13;

			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 1;
			MemRead = 0;
		end

		// 57. Init_pattern_dec (machine code )
		else if (Instruction == 9'b001101111) begin
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd12;
			WriteReg = 1;
			RegIn = 0;
			
			MemIn = 0;
			MemAddr = 0;
			MemWrite = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemRead = 0;
			ALUOp = kADD;
		end

		// 58. bne $t2, $r0, loop_append (machine code ) (was $zero)
		else if (Instruction == 9'b001110001) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 59. bne $t3, $t0, loop_postamble (machine code )
		else if (Instruction == 9'b001110011) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 60. bne $t3, $s2, loop_encrypt (machine code )
		else if (Instruction == 9'b001110101) begin
			// start = 0;
			halt = 0;
			beq = 0;
			bne = 1;
			bgt = 0;
			WriteReg = 0;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd0;
			RegIn = 0;
			MemAddr = 0;
			MemIn = 0;
			MemRead = 0;
			MemWrite = 0;
			ALUOp = kSUB;
		end

		// 61. Halt (machine code ) --skip(*)
		else if (Instruction == 9'b001111001) begin
			// start = 0;
			beq = 0;
			halt = 1;
			WriteReg = 0;
			MemRead = 0;
			MemWrite = 0;
			RegIn = 0;
			ALUSrcA = 0;
			ALUSrcB = 0;
			ALUOp = kADD;
		end

		// 62. addi $s2, 1 (machine code )
		else if (Instruction == 9'b001111011) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd0;
			ALUSrcB = 4'd9;
			
			MemIn = 0;
			RegIn = 0;
			MemAddr = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			MemRead = 0;
		end

		/*
		// 63. Start machine
		else if (Instruction == 9'b011111111) begin
				start = 1;
				beq = 0;
				halt = 0;
				WriteReg = 0;
				MemRead = 0;
				MemWrite = 0;
				RegIn = 0;
				ALUSrcA = 0;
				ALUSrcB = 0;
				ALUOp = kADD;
		end
		*/
		
		// 64. load_41_r0 (machine code ) 
		else if (Instruction == 9'b001111101) begin
			WriteReg = 1;
			ALUOp = kADD;
			ALUSrcA = 3'd2;
			ALUSrcB = 4'd11;
			MemRead = 1;
			RegIn = 1;
			MemAddr = 4'd14;
			
			MemIn = 0;
			// start = 0;
			halt = 0;
			beq = 0;
			MemWrite = 0;
			
			
		end
		// Default
		else begin
		end
	end
	
end


endmodule