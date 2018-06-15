// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Mux Register Write Input

module MuxRegWriteInput(
	input [7:0]				ALUOut,
	input	[7:0]				DataMemOut,
	input						RegInControl,
	
	output logic [7:0] 	RegIn_Out
);

always_comb	RegIn_Out <= RegInControl ? DataMemOut : ALUOut;

endmodule
