module Register_tb;

	parameter numReg = 2;
	parameter dataSize = 8;
	
	// DUT Input driver
	reg						CLK;
	reg [numReg-1:0]		srcA;				// rs
	reg [numReg-1:0]		srcB;				// rt
	reg [numReg-1:0]		WriteReg;		// Write to reg: always to rs
	reg						RegWriteCtrl;	// Write control
	reg						LoadImm;			// Load imm control
	reg [dataSize-1:0]	WriteData;		// Data to be written
	
	// DUT Output driver
	wire [dataSize-1:0]	ReadA;		// ReadA data
	wire [dataSize-1:0]	ReadB;		// ReadB data
	
	
	// Create UUT (Unit Under Test)
	Register #(.dataSize(dataSize), .numReg(numReg)) uut(.*);
	
	initial begin
	
		// Create global delay
		#100ns;
		
		// Set register sources
		// SrcA = 2, SrcB = 3
		srcA = 3'b010;
		srcB = 3'b011;
		
		// Write Register B, to check ReadB
		uut.registers[3] = 8'd3;
		
		// Test write register
		WriteReg = 3'b010;
		WriteData = 8'd10;
		RegWriteCtrl = 1;
		LoadImm = 0;
		
		// Delay between test case
		#20ns
		
		// Test write register control
		WriteReg = 3'b010;
		WriteData = 8'd1;
		RegWriteCtrl = 0;
		LoadImm = 0;
		
		// End testbench
		#20ns $stop;
	
	end
	
	always begin
		#10ns CLK = 1;
		#10ns CLK = 0;
	end
	
endmodule