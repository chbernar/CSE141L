// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     ALU

import definitions::*;

module ALU #(parameter regSize = 8)(
	input	[2:0]						ALUOp,		// 2 bits input for ALUOp
	input	[regSize-1:0]			SrcA,			// 8 bits data input SrcA
	input [regSize-1:0]			SrcB,			// 8 bits data input SrcB

	output logic [regSize-1:0]	Result,		// 8 bits result ALU output
	output logic Z,
	output logic N
);

	ALUOp_mne op_name;  // ALU Operation Menmonic

	always_comb begin
	
   // Initialize to 0
   Z = 0;
   N = 0;


   case(ALUOp)
      // ALU Add Operation (unsigned)
      kADD : begin
        Result = SrcA + SrcB;
//		  $display("add ALU");
//		  $display("srcA: %d", SrcA);
//		  $display("srcB: %d", SrcB);
      end

      // ALU Subtraction Operation (signed)
      kSUB : begin
//		  $display("sub ALU");
//		  $display("srcA: %d", SrcA);
//		  $display("srcB: %d", SrcB);
        Result = SrcA - SrcB;
      end

      // ALU Bitwise And Operation
      kAND : begin
        Result = SrcA & SrcB;
      end

      // ALU Shift left Logical Operation
      kSLL : begin
        Result = SrcA << SrcB;
      end

      // ALU Shift Right Logical Operation
      kSRL : begin
        Result = SrcA >> SrcB;
      end
		
		// ALU XOR Logical Operation
		kXOR : begin
	     Result = SrcA ^ SrcB;
//		  $display("xor ALU");
//		  $display("srcA: %d", SrcA);
//		  $display("srcB: %d", SrcB);
		  
		end
		
		default:
		  Result = 0;
  endcase

  if (Result == 0) begin
    Z = 1;
//	 $display("result zero");
  end
  else begin
    Z = 0;
//	 $display("result non zero");
  end

  if (Result < 0)
    N = 1;
  else
    N = 0;

  // Assign Mnemonic depending on current ALUOp
  op_name = ALUOp_mne'(ALUOp);	// debug

  end

endmodule