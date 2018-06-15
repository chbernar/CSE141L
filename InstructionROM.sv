// Create Date:     2018.6.05
// Latest rev date: 2018.6.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     InstructionROM

module InstructionROM #(parameter PC_size = 16, DW = 9)(
	input[15:0] ReadAddress,			// width of PC
	output logic[8:0] Instruction			// width of instruction
);

	logic[DW-1:0] inst_rom [2**PC_size];		// 2 ^ PC_Size elts, DW bits each

//	// load machine code program into instruction ROM
//	initial begin
//		$readmemb("C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab2/EncrypterMachineCode.txt", inst_rom);
//	end

	// change the pointer (from PC) ==> change the output
	assign Instruction = inst_rom[ReadAddress];


endmodule