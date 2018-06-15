// Create Date:     2018.6.05
// Latest rev date: 2018.6.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     top_module

parameter PC_size = 16;
parameter InstSize = 9;

// Specify max width of bits in memory
parameter memSize = 8;
parameter dataSize = 8;
parameter regSize = 3;
	

module top_module (
	input clk, start,
	input [PC_size-1:0] startAddress,
	output halt
);

	// Variables for instruction fetch
	logic [PC_size-1:0]	PC;
	logic 					Branch;
	logic [PC_size-1:0]	BranchAddress;
	logic	[InstSize-1:0]	Instruction;
	
	// Variables for ALU
	logic [7:0]	ALU_SrcA;
	logic	[7:0]	ALU_SrcB;
	logic [2:0]	ALUOp;
	logic [7:0]	ALUResult;
	logic [2:0]	ALUSrcA_Control;
	logic [3:0] ALUSrcB_Control;
	logic 		Z;
	logic			N;
	
	// Variables for register module
	logic						RegWriteCtrl;
	logic[dataSize-1:0] 	WriteData;
	logic[dataSize-1:0]	ReadA;	// rs
	logic[dataSize-1:0]	ReadB;	// rt
	logic						LoadImmCtrl;
	logic [3:0]				srcA;
	logic [3:0]				srcB;
	logic [3:0]				writeReg;
	logic						RegInControl;
	
	// Variables for data memory
	logic								MemRead;			// Memory read controller
	logic 							MemWrite;		// Memory write controller
	logic [7:0] 					DataAddress;
	logic [memSize-1:0]			DataMemIn;
	logic [memSize-1:0] 			DataMemOut;
	logic [3:0]						MemAddrControl;
	logic	[3:0]						MemInControl;
	
	// Additional Variables for control module
	logic beq;
	logic bne;
	logic bgt;
	
	
	// Instruction fetch module
	InstructionFetch IF (
		.CLK 					(clk),				// Clock signal
		.Start 				(start),				// Start control signal
		.Halt					(halt),				// Halt control signal
		.Branch				(Branch),			// Branch control signal
		.BranchAddress		(BranchAddress),	// Branch distance signed value
		.StartAddress		(startAddress),	// Start address
		.PC					(PC)					// Output for next PC
	);

	// Instruction ROM module
	InstructionROM IR (
		.ReadAddress 	(PC),
		.Instruction 	(Instruction)
	);

	
	// Control module
	ControlDecoder ControlDecoder(
		.Instruction 	(Instruction[8:0]),
//		.start			(start),
		.halt				(halt),
		.WriteReg		(RegWriteCtrl),
		.ALUSrcA			(ALUSrcA_Control[2:0]),
		.ALUSrcB			(ALUSrcB_Control[3:0]),
		.ALUOp			(ALUOp[2:0]),
		.RegIn			(RegInControl),
		.MemAddr			(MemAddrControl),
		.MemIn			(MemInControl),
		.MemRead			(MemRead),
		.MemWrite		(MemWrite),
		.beq				(beq),
		.bne				(bne),
		.bgt				(bgt)
	);

	// Lookup table register module
	LUT_Reg LUT_reg(
		.lut_instruction	(Instruction[8:0]),
		.SrcA					(srcA),
		.SrcB					(srcB),
		.WriteReg			(writeReg)
	);	
	
	// MuxRegIn selector
	MuxRegWriteInput	MuxRegWriteInput(
		.ALUOut			(ALUResult),
		.DataMemOut		(DataMemOut),
		.RegInControl	(RegInControl),
		.RegIn_Out		(WriteData)
	);
	

	// Register module
	Register	Reg(
		.CLK				(clk),
		.srcA				(srcA),	// rs
		.srcB				(srcB),	// rt
		.WriteReg		(writeReg),	// write back to rs
		.RegWriteCtrl	(RegWriteCtrl),
		.WriteData		(WriteData),
		.ReadA			(ReadA),
		.ReadB			(ReadB)
	);
	

	// Mux ALU Src A module
	MuxALUSrcA  ALUSrcASelector (
		.ReadA				(ReadA),
		.ALUSrcAControl	(ALUSrcA_Control),	
		.ALUInputA			(ALU_SrcA)
	);
	
	// Mux ALU Src B module
	MuxALUSrcB	ALUSrcBSelector (
		.ReadB				(ReadB),
		.instShamt			(Instruction[2:1]),
		.instImmediate		(Instruction[2:0]),
		.ALUSrcBCtrl		(ALUSrcB_Control),
		.ALUInputB 			(ALU_SrcB)
	);
	
	
	// ALU module
	ALU	ALU1(
		.ALUOp		(ALUOp),
		.SrcA			(ALU_SrcA),
		.SrcB			(ALU_SrcB),
		.Result		(ALUResult),
		.Z				(Z),
		.N				(N)
	);

	
	
	
	// Memory Mux module
	MuxMemAddress	MuxMemAddress(
	.ReadB				(ReadB),
	.ALU					(ALUResult),
	.MemAddrControl 	(MemAddrControl),
	.DataAddress 		(DataAddress)
	);
	
	// Memory Mem Data Input module
	MuxMemDataIn	MuxMemDataIn(
	.ReadA				(ReadA),
	.MemInputControl	(MemInControl),
	.DataMemIn			(DataMemIn)
	);
	
	// Data memory module
	DataMemory DataMem(
		.CLK 				(clk),
		.MemRead			(MemRead),      
		.MemWrite		(MemWrite),     
		.DataMemIn		(DataMemIn),   
		.DataAddress	(DataAddress),      
		.DataMemOut 	(DataMemOut)
	);
	
	// Lookup table module
	Lut Lookup(
		.lut_address	(Instruction[8:0]),
		.lut_val			(BranchAddress)
	);
	


	always_comb begin
		Branch = (beq & Z) | (bne & ~Z) | (bgt & N);
	end

endmodule