// Create Date:     2018.6.05
// Latest rev date: 2018.6.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Data Memory


module DataMemory(
	input 					CLK,           // Clock Input
	input 					MemRead,       // Control signal to allow read from memory
	input 					MemWrite,      // Control signal to allow write to memory
	input [7:0] 			DataAddress,   // Pointer to address in memory
	input [7:0]				DataMemIn,		// Data to store in memory
	
	output logic [7:0] 	DataMemOut		// 8 bits data output read from memory
);

	// Data Memory: 8 bits wide by 256 deep
	logic [7:0] my_memory[256];

	// Check MemReadm, if asserted then read out data from memory
	always_comb begin
		if(MemRead) begin
			DataMemOut = my_memory[DataAddress]; 
			
			// Debug: Print out memory read
			//$display("Memory read M[%d] = %d", DataAddress, DataMemOut);
		end
		
		else
			DataMemOut = 8'bZ;
	end
	
  // If MemWrite and posedge CLK, then write data to memory
  always_ff @ (posedge CLK) begin
		if(MemWrite) begin
			my_memory[DataAddress] = DataMemIn;
		
			// Debug: Print out memory write
			//$display("Memory write M[%d] = %d", DataAddress, DataMemIn);
		end
	end

endmodule
