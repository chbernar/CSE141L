// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     IF

module InstructionFetch #(parameter PC_size = 16)(
	input 								CLK,				// Clock signal
	input 								Start,			// Start control signal
	input 								Halt,				// Halt control signal
	input 								Branch,			// Branch control signal
	input [PC_size-1:0]				BranchAddress,	// Branch address
	input logic[PC_size-1:0]		StartAddress,	// Start address
	
	output logic[PC_size-1:0]		PC					// Output for next PC
);


always_ff @(posedge CLK)
	
	// If start, set PC to start address
	if (Start)
		PC <= StartAddress;
	
	// If halt, then freeze PC
	else if (Halt)
		PC <= PC;
	
	// Set PC to branch address
	else if (Branch)
		PC <= BranchAddress; //assuming line starts from 1
	
	// Normal PC Operation
	else
		PC <= PC + 1;

endmodule