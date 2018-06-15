module Lut(
	input[8:0] lut_address,
	output logic[15:0] lut_val
);

always_comb case(lut_address)
	9'b000011101:		lut_val = 16'd10;		// bne $t2, 16, loop_space_filler 
	9'b000011111: 		lut_val = 16'd33;		// beq $t2, 0, postamble (was 30)
	9'b000100001: 		lut_val = 16'd58;		// beq $zero, $zero, end
	9'b000101001: 		lut_val = 16'd58;		// beq $t2, 9, end
	9'b000100001: 		lut_val = 16'd10;		// beq $zero, $zero, loop_currPattern
	9'b000100011: 		lut_val = 16'd60;		// beq $zero, $zero, loop_prefix_detect
	9'b000100101: 		lut_val = 16'd76;		// beq $t2, 0, copy_string_done
	9'b001001011:		lut_val = 16'd76;		// bne $t1, 54, copy_string_done
	9'b000100111: 		lut_val = 16'd68;		// beq $zero, $zero, loop_copy_string
	9'b000101011:	 	lut_val = 16'd55;		// bne $t3, 0x20, break_true
	9'b000101101: 		lut_val = 16'd22;		// bne $t0, $s2, loop_decrypt
	9'b000101111: 		lut_val = 16'd67;		// bne $t2, 0x20, loop_prefix_detect_done
	9'b000110001: 		lut_val = 16'd48;		// bgt $t0, 8, increment
	9'b001110001:		lut_val = 16'd21;		// bne $t2, $r0, loop_append (was 20)
	9'b001110011: 		lut_val = 16'd36;		// bne $t3, $t0, loop_postamble (was 33)
	9'b001110101: 		lut_val = 16'd51;		// bne $t3, $s2, loop_encrypt (was 48)
	default: 			lut_val = 16'd0;	// unused (just for error/warning handling)
endcase



endmodule