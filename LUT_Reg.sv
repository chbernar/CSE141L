// Create Date:     2018.11.05
// Latest rev date: 2018.11.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Lookup Table Registers


module LUT_Reg(
	input [8:0]				lut_instruction,
	output logic [3:0]	SrcA,
	output logic [3:0]	SrcB,
	output logic [3:0]	WriteReg
);

always_comb begin

	// Reset registers
	WriteReg <= 4'd0;
	SrcA <= 4'd0;
	SrcB <= 4'd0;

	// Case R-type and SR-type
	if (lut_instruction[8] == 1'b0 && 
		 lut_instruction[0] == 1'b0) begin
		
		// Take rs and zero-extend to 4-bit
		// SrcA <= { 2'd0, lut_instruction[4:3] };
		//SrcA <= 4'd0;
		SrcA[1] = lut_instruction[4];
		SrcA[0] = lut_instruction[3];
		SrcB[1] = lut_instruction[2];
		SrcB[0] = lut_instruction[1];
		
		// Load byte unsigned op
		if (lut_instruction[7:5] == 3'b011) begin
//			SrcA[1] <= lut_instruction[4];
//			SrcA[0] <= lut_instruction[3];
			
//			$display("loading byte srcA %d%d", SrcA[1], SrcA[0]);
//			$display("loading byte srcB %d%d", SrcB[1], SrcB[0]);
//			$display("lut_inst %d%d", lut_instruction[2], lut_instruction[1]);
			
			WriteReg[1:0] <= SrcA[1:0];
		end
		else
			// Write to reg overflow
			WriteReg <= 4'd4;
		
		// Override standard op for this opcode	
		if (lut_instruction[7:5] == 3'b100) begin
			// redirect SrcA as $s1
			SrcA <= lut_instruction[4:3];
			// Put zero since it's not used for this special op
			SrcB <= lut_instruction[2:1];
		end
		
		// Override standard op for this opcode	
		if (lut_instruction[7:5] == 3'b101) begin
			// redirect SrcA as $s1
			SrcA <= 4'd6;
			// Put zero since it's not used for this special op
			SrcB <= 0;
			// Write to $s1
			WriteReg <= 4'd6;
		end
		
		else if (lut_instruction[7:5] == 3'b110) begin
			// Put zero since it's not used for this special op
			SrcB <= 0;
			// Write to reg overflow
			WriteReg <= 4'd4;
		end
		
		else begin
			// Take rt and sign-extend to 4-bit
//			SrcB <= { 2'd0, lut_instruction[2:1] };
			SrcB <= 4'd0;
			SrcB[1] <= lut_instruction[2];
			SrcB[0] <= lut_instruction[1];
			
		end
		
	end
	
	// Case I-type
	else if (lut_instruction[8] == 1'b1) begin
				
		// If opcode == lov, immediate is unused
		if (lut_instruction[7:5] == 3'b010) begin
			
//			$display("in 3'b010");
//			$display("lut_inst: %d", lut_instruction[4:2]);
			// Point to overflow register
			SrcA <= 4'd4;
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			// Zero-extend by 1 bit and store to rs
//			WriteReg <= { 1'd0, lut_instruction[4:2] }; 
			WriteReg[3] <= 0;
			WriteReg[2] <= lut_instruction[4];
			WriteReg[1] <= lut_instruction[3];
			WriteReg[0] <= lut_instruction[2];
			
//			$display("lut_instruction[4]: %d",lut_instruction[4]);
//			$display("lut_instruction[3]: %d",lut_instruction[4]);
//			$display("lut_instruction[2]: %d",lut_instruction[4]);
//			
//			$display("Write to register: %d", WriteReg);
			
		end
		
		// Other I-type ops
		else begin
		
			// Zero-extend by 2 bit and store to SrcA
//			SrcA <= { 2'd0, lut_instruction[4:3] };
			SrcA <= lut_instruction[4:3];
			
			// Assign immediate val to SrcB
			SrcB <= lut_instruction[2:0];
			
			// Case where we load immediate
			if (lut_instruction[7:5] == 3'b001) begin
//				WriteReg <= SrcA;
				WriteReg <= 4'd0;
				WriteReg[1] <= lut_instruction[4];
				WriteReg[0] <= lut_instruction[3];
				// Debug
//				$display("lut instruction: %b", lut_instruction[4:3]);
//				$display("I'm in SrcA Write Reg");
//				$display("Instruction: %b", lut_instruction);
//				$display("WriteReg: %d", WriteReg);
			end
			else begin
				// Else write to overflow
				WriteReg <= 4'd4;
//				$display("I'm in Overflow");
			end
		
		end
	end
	
	// Case S-type
	else begin
		
		//init_pattern 
		if (lut_instruction == 9'b000000001) begin
			
			// Assigned as 0, since it's unused
			SrcA <= 0; 
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 4'd5; //s0 = 42
			
		end
		
		
		//init_seed 
		else if (lut_instruction == 9'b000000011) begin
			
			// Assigned as 0, since it's unused
			SrcA <= 0; 
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 4'd6; //s1 = 43
		end
		
		
		//init_string_length 
		else if (lut_instruction == 9'b 000000101) begin
		
			// Assigned as 0, since it's unused
			SrcA <= 0;
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 4'd7; //s2 = 0
			
		end
		
		
		//load_input_string 
		else if (lut_instruction == 9'b 000000111) begin
			// Assigned as 0, since it's unused
			SrcA <= 0; 
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 4'd4; //r0 = 0 (input string address)
		end
		
		
		//loadPreamble 
		else if (lut_instruction == 9'b000001001) begin
			// Assigned as 0, since it's unused
			SrcA <= 0; 
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 4'd4; //r0 = 64 (preambled address)
		
		end
		
		//Store_space 
		else if (lut_instruction == 9'b000001011) begin
			// Assigned as 0, since it's unused
			SrcA <= 0;
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 0; //unused
		
		end
		
		//Load_space
		else if (lut_instruction == 9'b000001101) begin
			// Assigned as 0, since it's unused
			SrcA <= 0; 
			
			// Assigned as 0, since it's unused
			SrcB <= 0;
			
			WriteReg <= 4'd4; //r0 = 0x20 (space char)
			
		end
		
		//Get_remaining_length 
		else if (lut_instruction == 9'b000001111) begin
			// Assigned as 0, since it's unused
			SrcA <= 0;
			
			SrcB <= 4'd7; //s2 
			
			WriteReg <= 4'd4; //r0 = 64- $s2
		
		end
		
		
		//And_pattern_seed 
		else if (lut_instruction == 9'b000010001) begin
		
			SrcA <= 4'd5; //s0 
			
			SrcB <= 4'd6; //s1 
			
			WriteReg <= 4'd4; //r0 = s0 & $s1
			
		end
		
		
		//Get_parity_bit 
		else if (lut_instruction == 9'b000010011) begin
		
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd0; //unused 
			
			WriteReg <= 4'd4; //r0 = t0 & 1
			
		end
		
		//Add_seed_tapped 
		else if (lut_instruction == 9'b000010101) begin
		
			SrcA <= 4'd6; //s1 
			
			SrcB <= 4'd0; //t0 
			
			WriteReg <= 4'd4; //r0 = s1 + t0
		
		end
		
		//And_seed_255 
		else if (lut_instruction == 9'b000010111) begin
		
			SrcA <= 4'd6; //s1 
			
			SrcB <= 4'd0; //unused
			
			WriteReg <= 4'd4; //r0 = s1 & 255
		
		
		end
		
		//Xor_seed_stringchar 
		else if (lut_instruction == 9'b000011001) begin
		
			SrcA <= 4'd6; //s1 
			
			SrcB <= 4'd0; //t0 
			
			WriteReg <= 4'd4; //r0 = s1 ^ t0
			
			
		end
		
		//bne $t2, 16, loop_space_filler (change to bne $t2, $r0, loop_space_filler)
		else if (lut_instruction == 9'b000011101) begin
			
			SrcA <= 4'd2; //t2 
			
			SrcB <= 4'd4; //r0 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
			
		end
		
		
		//beq $t2, 0, postamble (change to $t2, $r0, postamble)
		else if (lut_instruction == 9'b000011111) begin
			SrcA <= 4'd2; //t2 
			
			SrcB <= 4'd4; //r0 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
			
		end
		
		//beq $zero, $zero, end
		else if (lut_instruction == 9'b000100001) begin
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd0; //t0 (like a jump) 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		
		//beq $zero, $zero, loop_currPattern
		else if (lut_instruction == 9'b 001110111) begin
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd0; //t0 (like a jump) 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		//beq $zero, $zero, loop_prefix_detect
		else if (lut_instruction == 9'b000100011) begin
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd0; //t0 (like a jump) 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		
		//beq $t2, 0, copy_string_done
		else if (lut_instruction == 9'b000100101) begin
			SrcA <= 4'd2; //t2 
			
			SrcB <= 4'd0; //unused 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		
		end
		
		//beq $zero, $zero, loop_copy_string
		else if (lut_instruction == 9'b000100111) begin
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd0; //t0 (like a jump) 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		//beq $t2, 9, end
		else if (lut_instruction == 9'b000101001) begin
			SrcA <= 4'd2; //t2 
			
			SrcB <= 4'd0; //unused 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		
		end
		
		//bne $t3, 0x20, break_true
		else if (lut_instruction == 9'b 000101011) begin
			SrcA <= 4'd3; //t3 
			
			SrcB <= 4'd0; //unused 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		//bne $t0, $s2, loop_decrypt
		else if (lut_instruction == 9'b000101101) begin
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd7; //s2 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		//bne $t2, 0x20, loop_prefix_detect_done
		else if (lut_instruction == 9'b000000011) begin
			SrcA <= 4'd2; //t2 
			
			SrcB <= 4'd0; //unused 
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		end
		
		//bgt $t0, 8, increment
		else if (lut_instruction == 9'b 000110001) begin
			SrcA <= 4'd0; //t0 
			
			SrcB <= 4'd0; //unused
			
			WriteReg <= 4'd0; //unused (not writing to reg)
		
		end
		
		//and $t1, $s0, $s1
		else if (lut_instruction == 9'b000110011) begin
			SrcA <= 4'd5; //s0 
			
			SrcB <= 4'd6; //s1
			
			WriteReg <= 4'd1; //t1 = s0 & s1
		end
		
		//and $t1, $t1, 1
		else if (lut_instruction == 9'b000110101) begin
			SrcA <= 4'd1; //t1 
			
			SrcB <= 4'd0; //unused
			
			WriteReg <= 4'd1; //t1 = t1 & 1
		
		end
		
		//add $s1, $s1, $t1 --> write to r0
		else if (lut_instruction == 9'b000110111) begin
			SrcA <= 4'd6; //s1 
			
			SrcB <= 4'd1; //t1
			
			WriteReg <= 4'd4; //r0 = s1 + t1
		
		end
		
		
		//lbu $t1, $s4
		else if (lut_instruction == 9'b000111001) begin
			SrcA <= 4'd1; //t1 (unused?)
			
			SrcB <= 4'd9; //s4
			
			WriteReg <= 4'd1; //$t1 = Mem($s4)
		end
		
		//xor $t3, $s1, $t1
		else if (lut_instruction == 9'b000111011) begin
			SrcA <= 4'd6; //s1
			
			SrcB <= 4'd1; //t1	
			
			WriteReg <= 4'd3; //$t3 = s1 ^ t1
		end
		
		//sb  $t3, $s5
		else if (lut_instruction == 9'b000111101) begin
			SrcA <= 4'd3; //t3
			
			SrcB <= 4'd10; //s5	
			
			WriteReg <= 4'd0; //unused
			
		end
		
		//addi    $s4, $s4, 1
		else if (lut_instruction == 9'b000111111) begin
			SrcA <= 4'd9; //s4
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd9; //s4 = s4 + 1
		end
		
		//addi    $s5, $s5, 1
		else if (lut_instruction == 9'b001000001) begin
			SrcA <= 4'd10; //s5
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd10; //s5 = s5 + 1
		end
		
		
		
		//sb  $zero, $s5
		else if (lut_instruction == 9'b 001000011) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd9; //s5	
			
			WriteReg <= 4'd0; //unused		
		end
		
		//la  $t0, decrypted_string
		else if (lut_instruction == 9'b001000101) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //t0 = address decrypted_string (0) 
		end
		
		//la  $t1, decrypted_string
		else if (lut_instruction == 9'b001000111) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd1; //t1 = address decrypted_string (0) 
		end
		
		//sb  $zero, $t1
		else if (lut_instruction == 9'b001001001) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd1; //t1	
			
			WriteReg <= 4'd0; //unused 
		end
		
		//bne $t1, 54, copy_string_done
		else if (lut_instruction == 9'b001001011) begin
			SrcA <= 4'd1; //t1
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //unused 
		end
		
		
		//load_encrypt_s4
		else if (lut_instruction == 9'b001001101) begin
			SrcA <= 4'd1; //t1
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd9; //s4 = 64 (encrypt address) 
		end
		
		//la  $s5, decrypted_string
		else if (lut_instruction == 9'b001001111) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd10; //s5 = 0 (mem address) 
		end
		
		//lbu $t0, $s4
		else if (lut_instruction == 9'b001010001) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd9; //s4	
			
			WriteReg <= 4'd0; //t0 = mem(s4) 
		end
		
		//addi    $s4, 1
		else if (lut_instruction == 9'b001010011) begin
			SrcA <= 4'd9; //s4
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd9; //s4 = s4 + 1	
		end
		

		//addi    $s2, 1
		else if (lut_instruction == 9'b001111011) begin
			SrcA <= 4'd7; //s2
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd4; //r0 = s2 + 1
		end
		
		//addi    $s5, 1
		else if (lut_instruction == 9'b001010101) begin
		
			SrcA <= 4'd10; //s5
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd10; //s5 = s5 + 1	
		
		end
		
		
		//add $s3, $s3, $t2
		else if (lut_instruction == 9'b001010111) begin
			SrcA <= 4'd8; //s3
			
			SrcB <= 4'd2; //t2	
			
			WriteReg <= 4'd8; //s3 = s3 + t2	
		
		end
		
		//lbu $s0, ($s3)
		else if (lut_instruction == 9'b001011001) begin
			SrcA <= 4'd5; //s0
			
			SrcB <= 4'd8; //s3	
			
			WriteReg <= 4'd5; //s0 = mem[s3]	
		end
		
		//move    $t1, $s1
		else if (lut_instruction == 9'b 001011011) begin
			SrcA <= 4'd1; //t1 unused
			
			SrcB <= 4'd6; //s1	
			
			WriteReg <= 4'd1; //t1 = s1	
			
		end
		
		//sll $s1, $s1, 1
		else if (lut_instruction == 9'b001011101) begin
			SrcA <= 4'd6; //s1
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd6; //s1 = s1 << 1	
		end
		
		
		//store   0xe1, 55
		else if (lut_instruction == 9'b001011111) begin
		
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //unused	
		end
		
		
		//store   0xd4, 56
		else if (lut_instruction == 9'b001100001) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //unused	
		
		end
		
		
		//store   0xc6, 57
		else if (lut_instruction == 9'b001100011) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //unused	
		end
		
		//store   0xb8, 58		
		else if (lut_instruction == 9'b 001100101) begin
		
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //unused	
		end
		
		
		//store   0xb4, 59
		else if (lut_instruction == 9'b 001100111) begin
			SrcA <= 4'd0; //unused
			
			SrcB <= 4'd0; //unused	
			
			WriteReg <= 4'd0; //unused	
		end
		
		
		//store   0xb2, 60
		else if (lut_instruction == 9'b001101001) begin
			SrcA <= 4'd0; //unused
			SrcB <= 4'd0; //unused	
			WriteReg <= 4'd0; //unused	
		end
		
		
		//store   0xfa, 61
		else if (lut_instruction == 9'b 001101011) begin
			SrcA <= 4'd0; //unused
			SrcB <= 4'd0; //unused	
			WriteReg <= 4'd0; //unused	
		end
		
		//store   0xf3, 62
		else if (lut_instruction == 9'b001101101) begin
			SrcA <= 4'd0; //unused
			SrcB <= 4'd0; //unused	
			WriteReg <= 4'd0; //unused
		end
		
		
		//Init_pattern_dec 
		else if (lut_instruction == 9'b001101111) begin
			SrcA <= 4'd0; //unused
			SrcB <= 4'd0; //unused	
			WriteReg <= 4'd8; //s3 = 55
		end
		
		
		
		//bne $t2, $r0, loop_append (was $r0 -> $zero)
		else if (lut_instruction == 9'b001110001) begin
			SrcA <= 4'd2; //t2
			SrcB <= 4'd4; //r0	
			WriteReg <= 4'd0; //unused
		end
		
		//bne $t3, $t0, loop_postamble
		else if (lut_instruction == 9'b001110011) begin
			SrcA <= 4'd3; //t3
			SrcB <= 4'd0; //t0	
			WriteReg <= 4'd0; //unused
		end
		
		// load_41_r0
		else if (lut_instruction == 9'b001111101) begin
			SrcA <= 4'd0; // unused
			SrcB <= 4'd0; // unused
			WriteReg <= 4'd4; // r0 = 41
		end
		
		//xor_space_char_t0
		else if (lut_instruction == 9'b000011011) begin
			SrcA <= 4'd0; // t0
			SrcB <= 4'd0; // unused
			WriteReg <= 4'd6; // s1 = t0 ^ 0x20
		end
		
		
		//bne $t3, $s2, loop_encrypt
		else begin//(lut_instruction == 9'b001110101) begin
			SrcA <= 4'd3; //t3
			SrcB <= 4'd7; //s2	
			WriteReg <= 4'd0; //unused
		end
		
		
		
	end
end
	
endmodule