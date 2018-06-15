// Create Date:     2018.6.05
// Latest rev date: 2018.6.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Control Decoder Testbench

/*
module ControlDecoder_tb;
	
	// Control Decode DUT Input Drivers	
	reg [8:0]	Instruction;
		
	// Control Decode DUT Output Drivers	
	wire			halt;
	wire			beq;
	wire			bne;
	wire			bgt;
	
	wire			WriteReg;
	wire [2:0]	ALUSrcA;
	wire [3:0]	ALUSrcB;
	wire 			RegIn;
	wire [3:0]	MemAddr;
	wire [3:0]	MemIn;
	wire			MemRead;
	wire			MemWrite;
	wire [2:0]	ALUOp;
	
	
	// Instantiate uut control unit
	ControlDecoder Control_uut(.*);
	
	initial begin
		// Wait 100ns for global reset to finish
		#100ns
		
		// Halt Test case
		#20ns;
		Instruction = 9'b001111001;
		
		// End testbench
		#20ns $stop;
	end
	
	// Clock: alternate every 20ns period;
	always begin
		#10ns	CLK = 1;
		#10ns CLK = 0;
	end
	
	
endmodule
*/