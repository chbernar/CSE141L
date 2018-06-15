// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     ALU Testbench

import definitions::*;
module ALU_tb;

  // DUT Input Drivers
  reg [2:0] ALUOp;
  reg [7:0] SrcA;
  reg [7:0] SrcB;

  // DUT Output Drivers
  wire [7:0] Result;
  wire N;
  wire Z;

  // ALUOp Mnemonic
  ALUOp_mne op_name;

  // Instantiate UUT (Unit Under Test)
  ALU uut(.*);
  
  initial begin
  
		// Wait global reset 40ns
		#40ns;
		
		// Test Case 1:
		// A = 128(unsigned)/ -128(signed)
		// B = 127(unsigned)/ 127(signed)
		SrcA = 8'h80;
		SrcB = 8'h7F;
		
		#20ns ALUOp = kADD;
		#20ns ALUOp = kSUB;
		#20ns ALUOp = kAND;
		#20ns ALUOp = kSLL;
		#20ns ALUOp = kSRL;

		// End testbench
		#20ns $stop;
	end
	
	always_comb begin
		op_name = ALUOp_mne'(ALUOp);
	end
	
endmodule