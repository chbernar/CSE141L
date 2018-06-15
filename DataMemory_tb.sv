/* Filename: DataMemory_tb.sv
 * Authors: Moiz Qureshi, Ye Huang, Eduardo Rosales
 * Date: 11/17/16
 * Description: This file defines the test bench for the DataRam file module
 */

module DataMemory_tb;
  
  // DUT Input Drivers
  reg CLK;
  reg MemRead;
  reg MemWrite;
  
  reg [7:0] DataAddress;
  reg [7:0] DataMemIn;

  // DUT Output Drivers
  wire [7:0] DataMemOut;

  // Instantiate UUT (unit under test)
  DataMemory uut(.*);

  initial begin

  /*
    // Initialize Data Memory with data from text file
    $readmemb("ram_init.txt", uut.data_memory);
	  $display("DataRam data memory");
	  for (i = 0; i < 10; i = i + 1)
		  $display("%d:%b", i, uut.data_memory[i]);
	*/
	
    // Wait 100ns for global reset to finish
    #100ns;

    // Check if writing to DataRam works, writting value A(1) to address B(3)
    MemRead = 0;
    MemWrite = 1;
    DataAddress = 8'b00000001;
    DataMemIn = 8'b00000011;
    #20ns;

	 // Check if reading from DataRam works, getting the value store at A(1)
    MemRead = 1;
    MemWrite = 0;
    DataAddress = 8'b00000001;
    #20ns;
	 
	 MemRead = 1;
	 MemWrite = 0;
	 DataAddress = 8'b0;
	 #20ns;
	 
    // End the Test
    #20ns $stop;

  end

  always begin
    // Alternate clock for period of 20ns
   	#10ns CLK = 1;
   	#10ns CLK = 0;
  end

endmodule