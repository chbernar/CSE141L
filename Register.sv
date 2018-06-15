// Create Date:     2018.6.05
// Latest rev date: 2018.6.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Register


module Register #(parameter dataSize = 8, numReg = 4)(
	input						CLK,
	input [numReg-1:0]	srcA,				// rs
	input [numReg-1:0]	srcB,				// rt
	input [numReg-1:0]	WriteReg,		// Write to reg: always to rs
	input						RegWriteCtrl,	// Write control
	input [dataSize-1:0]	WriteData,		// Data to be written
	
	
	output logic [dataSize-1:0]	ReadA,		// Data dat
	output logic [dataSize-1:0]	ReadB			// Data2 read
);

	// Register with size 8 and 2 regs deep
	logic [dataSize-1:0] registers[2**numReg];
	
	/* Used to initialize registers
	initial begin
		$readmemb("reg_init.txt", registers);
	end
	*/

	// Read the register
	always_comb ReadA = registers[srcA];
	always_comb ReadB = registers[srcB];
	
	// Writing when clock is positive
	always_ff @(posedge CLK)
	
		// Normal write operation
		if (RegWriteCtrl)
			registers[WriteReg] <= WriteData;
		
	
endmodule