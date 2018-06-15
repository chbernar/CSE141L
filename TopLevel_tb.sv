/* Filename: TopLevel.sv
 * Authors: Christhoper Bernard, Darell Hoei
 * Date: 6/7/2018
 * Description: This file defines the testbench for the TopLevel module
*/

import definitions::*;
module TopLevel_tb;

	reg 			CLK, Start;
	reg[15:0]	StartAddress;
	wire			Halt;
	
	reg[7:0]		LFSR_ptrn[8],		// 8 possible maximal-length 8-bit LFSR tap ptrns
					lfsr_ptrn[4],		// one of 8 maximal length 8-tap shift reg. ptrns
					lfsr1[64]      ,
					lfsr2[64]      ,  // states of program 2 decrypting LFSR
					lfsr3[64]      ,  // states of program 3 encrypting LFSR
					LFSR_init[4]   ,  // four of 255 possible NONZERO starting states
					pre_length[4]  , 	// bytes before first character in message
					msg_crypto1[64],  // encrypted message according to the DUT
					msg_crypto2[64],  // encrypted message according to the DUT
					msg_crypto3[64],  // encrypted message according to the DUT
					msg_padded1[64],  // original message, plus pre- and post-padding;  // 8 possible maximal-length 8-bit LFSR tap ptrns
					msg_padded2[64],  // original message, plus pre- and post-padding
					msg_padded3[64],  // original message, plus pre- and post-padding
					tapped,
					tapPattern,
					seed,
					tempTapped;
	
  // the 8 possible maximal-length feedback tap patterns from which to choose
  assign LFSR_ptrn[0] = 8'he1;
  assign LFSR_ptrn[1] = 8'hd4;
  assign LFSR_ptrn[2] = 8'hc6;
  assign LFSR_ptrn[3] = 8'hb8;
  assign LFSR_ptrn[4] = 8'hb4;
  assign LFSR_ptrn[5] = 8'hb2;
  assign LFSR_ptrn[6] = 8'hfa;
  assign LFSR_ptrn[7] = 8'hf3;
  
  
  
  // 1st program 1 input
  string str1 = "Mr. Watson, come here. I want to see you.";  
  // 2nd program 1 input
  string     str3  = "  01234546789abcdefghijklmnopqrstuvwxyz. ";  
  
  
  string     str2  = "Knowledge comes, but wisdom lingers.     ";  // program 2 output
  
  // displayed encrypted string will go here:
  string str_enc1[64];
  string     str_enc2[64];  // program 2 input
  string     str_enc3[64];  // second program 1 output
//  string     str_enc4[64];  // program 3 input
  
  
  
  string ourEncoder[64];

  //assign lfsr for program 1 randomly
  assign LFSR_init[0] = $random | 8'h40;
  assign LFSR_init[1] = $random | 8'h20;  // for program 2 run
  assign LFSR_init[2] = $random | 8'h10;  // for 2nd program 1 run
//  assign LFSR_init[3] = $random | 8'h08;  // for program 3 run
  //assign LFSR_init[0] = 8'h11;

  
  //assign pre amble length for program 1
  assign pre_length[0] = 9 ;  // 1st program 1 run
  assign pre_length[1] = 9 ;  // program 2 run
  assign pre_length[2] = 11;  // 2nd program 1 run
  
  
  // ***** instantiate your own top level design here *****
  top_module dut(
    .clk     		(CLK),	   // use your own port names, if different
	 .startAddress	(StartAddress),
    .start    		(Start),   // some prefer to call this ".reset" (INIT IS DIFFERENT)
    .halt    		(Halt)
  );
  
  initial begin
	//***** pre-load your instruction ROM here	*****
	// you may also pre-load desired constants, etc. into
	//   your data_mem here -- the upper half is reserved for your use
	//    $readmemb("encoder.bin", dut.instr_rom.rom);
		 $readmemb("C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab3/out.txt", dut.IR.inst_rom);
	//    dut.data_mem.DM[128]=8'hfe;   //whatever constants you want	
	//    for(lk = 0; lk<42; lk++) begin
	//      if(str4[lk]==8'h20)
	//        continue;
	//      else
	//        break;
	  
	  
		CLK = 0;  // initialize clock
		Start = 1;  // activate reset (START)
		StartAddress = 0;
		
		// program 1 -- precompute encrypted message
		lfsr_ptrn[0] = LFSR_ptrn[4];  // select one of 8 permitted
		lfsr1[0]     = LFSR_init[0];  // any nonzero value (zero may be helpful for debug)
		$display("run program 1 for the first time");
		$display("%s",str1);          // print original message in transcript window
		$display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[0],lfsr1[0]);

		for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
		  msg_padded1[j] = 8'h20;

		for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
		  msg_padded1[pre_length[0]+l] = str1[l];

		
//		for (int ii=0;ii<63;ii++)
//		  lfsr1[ii+1] = (lfsr1[ii]<<1)+(^(lfsr1[ii]&lfsr_ptrn[0]));
//		  
//		
//		// encrypt the message, testbench will change on falling clocks
//		for (int i=0; i<64; i++) begin
//		  msg_crypto1[i] = msg_padded1[i] ^ lfsr1[i];
//		  str_enc1[i] = string'(msg_crypto1[i]);
//		end
	// compute lfsr sequence for program 1 (1st input)
		
		tapPattern = lfsr_ptrn[0];
		seed = lfsr1[0];
		
		// compute the LFSR sequence
		for (int i = 0; i < 64; i++) begin
			tapped = tapPattern & seed;
			seed = seed << 8'd1;
			
			tempTapped = tapped >> 8'd4;
			tapped = tapped ^ tempTapped;

			tempTapped = tapped >> 8'd2;
			tapped = tapped ^ tempTapped;

			tempTapped = tapped >> 8'd1;
			tapped = tapped ^ tempTapped;
			
			tapped = tapped & 8'd1;
			seed = seed + tapped;
			seed = seed & 8'd255;

			msg_crypto1[i] = seed ^ msg_padded1[i];
			
		end
		

		// program 1 (2nd input) -- precompute encrypted message
    lfsr_ptrn[2] = LFSR_ptrn[5];  // select one of 8 permitted
    lfsr3[0]     = LFSR_init[2];  // any nonzero value (zero may be helpful for debug)
    $display("run program 1 for the second time");
    $display("%s",str3);          // print original message in transcript window
    $display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[2],lfsr3[0]);

    for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
      msg_padded3[j] = 8'h20;

    for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
      msg_padded3[pre_length[2]+l] = str3[l];

//    // compute the LFSR sequence
//    for (int ii=0;ii<63;ii++)
//      lfsr3[ii+1] = (lfsr3[ii]<<1)+(^(lfsr3[ii]&lfsr_ptrn[2]));  // {LFSR[6:0],(^LFSR[5:3]^LFSR[7])};           // roll the rolling code
//
//    // encrypt the message, testbench will change on falling clocks
//    for (int i=0; i<64; i++) begin
//      msg_crypto3[i]        = msg_padded3[i] ^ lfsr3[i];  //{1'b0,LFSR[6:0]};       // encrypt 7 LSBs
//      str_enc3[i]           = string'(msg_crypto3[i]);
//    end

		tapPattern = lfsr_ptrn[2];
		seed = lfsr3[0];
		
		// compute the LFSR sequence
		for (int i = 0; i < 64; i++) begin
			tapped = tapPattern & seed;
			seed = seed << 8'd1;
			
			tempTapped = tapped >> 8'd4;
			tapped = tapped ^ tempTapped;

			tempTapped = tapped >> 8'd2;
			tapped = tapped ^ tempTapped;

			tempTapped = tapped >> 8'd1;
			tapped = tapped ^ tempTapped;
			
			tapped = tapped & 8'd1;
			seed = seed + tapped;
			seed = seed & 8'd255;

			msg_crypto3[i] = seed ^ msg_padded3[i];
			
		end

      // program 2 -- precompute encrypted message
		 lfsr_ptrn[1] = LFSR_ptrn[4];  // select one of 8 permitted
		 lfsr2[0]     = LFSR_init[1];  // any nonzero value (zero may be helpful for debug)
		 $display("run program 2");
		 $display("%s",str2);          // print original message in transcript window
		 $display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[1],lfsr2[0]);

		 for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
			msg_padded2[j] = 8'h20;

		 for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
			msg_padded2[pre_length[1]+l] = str2[l];
			
		//encrypt message
		tapPattern = lfsr_ptrn[1];
		seed = lfsr2[0];
		
		// compute the LFSR sequence
		for (int i = 0; i < 64; i++) begin
			tapped = tapPattern & seed;
			seed = seed << 8'd1;
			
			tempTapped = tapped >> 8'd4;
			tapped = tapped ^ tempTapped;

			tempTapped = tapped >> 8'd2;
			tapped = tapped ^ tempTapped;

			tempTapped = tapped >> 8'd1;
			tapped = tapped ^ tempTapped;
			
			tapped = tapped & 8'd1;
			seed = seed + tapped;
			seed = seed & 8'd255;

			msg_crypto2[i] = seed ^ msg_padded2[i];
			
		end
	 
	 
	
		 // run program 1
// ***** load operands into your data memory *****
// ***** use your instance name for data memory and its internal core *****
    for(int m=0; m<41; m++)
		 dut.DataMem.my_memory[m] = str1[m];       // copy original string into device's data memory[0:40]
	 
	 dut.DataMem.my_memory[41] = pre_length[0];  // number of bytes preceding message
	 dut.DataMem.my_memory[42] = lfsr_ptrn[0];   // LFSR feedback tap positions (8 possible ptrns)
	 dut.DataMem.my_memory[43] = LFSR_init[0];   // LFSR starting state (nonzero)
//	$display("Data mem 43 (compare to s1: %d", dut.DataMem.my_memory[43]);

	 // load constants, including LUTs, for program 1 here
//    $display("lfsr_init[0]=%h,dut.data_mem.DM[43]=%h",LFSR_init[0],dut.DataMem.my_memory[43]);
	 
    //string ourEncoder[64];
    for (int i = 0; i < 64; i++) begin
	$cast(ourEncoder[i], dut.DataMem.my_memory[i]);
    end
	 // $display("%d  %h  %h  %h  %s",i,message[i],msg_padded[i],msg_crypto[i],str[i]);
    #20ns Start = 0;
    #60ns;       		                       // wait for 6 clock cycles of nominal 10ns each
    wait(Halt);                           // wait for DUT's done flag to go high

    #10ns $display();
    $display("program 1:");

	// ***** reads your results and compares to test bench
	// ***** use your instance name for data memory and its internal core *****
      for(int n=0; n<64; n++)
			if(msg_crypto1[n]!=dut.DataMem.my_memory[n+64])
          $display("%d bench msg: %s %d dut msg: %d  OOPS!",
            n, msg_crypto1[n], msg_crypto1[n], dut.DataMem.my_memory[n+64]);
        else
          $display("%d bench msg: %s %d dut msg: %d",
            n, msg_crypto1[n], msg_crypto1[n], dut.DataMem.my_memory[n+64]);
	
	//for (int i = 0; i < 64; i++) begin
	  //$display("lfsr1[i]: %h", lfsr1[i]);
	//end
	
	 // run program 1
    Start = 1;
// ***** load operands into your data memory *****
// ***** use your instance name for data memory and its internal core *****
    for(int m=0; m<41; m++)
      dut.DataMem.my_memory[m] = str3[m];       // copy original string into device's data memory[0:40]
    dut.DataMem.my_memory[41] = pre_length[2];  // number of bytes preceding message
    dut.DataMem.my_memory[42] = lfsr_ptrn[2];   // LFSR feedback tap positions (8 possible ptrns)
    dut.DataMem.my_memory[43] = LFSR_init[2];   // LFSR starting state (nonzero)
    // $display("%d  %h  %h  %h  %s",i,message[i],msg_padded[i],msg_crypto[i],str[i]);
	 //string ourEncoder[64];
    for (int i = 0; i < 64; i++) begin
	$cast(ourEncoder[i], dut.DataMem.my_memory[i]);
    end
	 
    #20ns Start = 0;
    #60ns;                                // wait for 6 clock cycles of nominal 10ns each
    wait(Halt);                           // wait for DUT's done flag to go high
    #10ns $display();
    $display("program 1:");
// ***** reads your results and compares to test bench
// ***** use your instance name for data memory and its internal core *****
    for(int n=0; n<64; n++)
	  if(msg_crypto3[n]!=dut.DataMem.my_memory[n+64])
        $display("%d bench msg: %s  %h dut msg: %h   OOPS!",
          n, msg_crypto3[n], msg_crypto3[n], dut.DataMem.my_memory[n+64]);
	  else
        $display("%d bench msg: %s  %h dut msg: %h",
          n, msg_crypto3[n], msg_crypto3[n], dut.DataMem.my_memory[n+64]);
	
	
	
	//run program 2 (MUST UPDATE INSTRUCTION ROM)
//	$readmemb("C:/Users/Christhoper Bernard/Desktop/CSE141L/Lab3/decrypter_machine_code.txt", dut.IR.inst_rom);
//	 // run program 2
//    Start = 1;                          // activate reset
//// ***** load operands into your data memory *****
//// ***** use your instance name for data memory and its internal core *****
//    for(int n=64; n<128; n++)
//      dut.DataMem.my_memory[n] = msg_crypto2[n - 64];
//// load new constants into data_mem for program 2 here
//    #20ns Start = 0;
//    #60ns;                             // wait for 6 clock cycles of nominal 10ns each
//    wait(Halt);                        // wait for DUT's done flag to go high
//    #10ns $display();
//    $display("program 2:");
//// ***** reads your results and compares to test bench
//// ***** use your instance name for data memory and its internal core *****
//    for(int n=0; n<41; n++)
//      if(str2[n]!=dut.DataMem.my_memory[n])
//        $display("%d bench msg: %s  %h dut msg: %h  OOPS!",
//          n, str2[n], str2[n], dut.DataMem.my_memory[n]);
//      else
//        $display("%d bench msg: %s  %h dut msg: %h",
//          n, str2[n], str2[n], dut.DataMem.my_memory[n]);
	
	
	
		
	$stop;
			 		 
  end
	
	integer counter = 0;

	always begin
		#5ns CLK = 1;


//		$display("PC: %d Instruction: %b", dut.PC, dut.Instruction);
//		$display("Reg t0: %b", dut.Reg.registers[0]);
//		$display("Reg t1: %b", dut.Reg.registers[1]);
//		$display("Reg t2: %b", dut.Reg.registers[2]);
//		$display("Reg t3: %b", dut.Reg.registers[3]);
//		$display("Reg r0: %b", dut.Reg.registers[4]);
//		$display("Reg s0: %b", dut.Reg.registers[5]);
//		$display("Reg s1: %b", dut.Reg.registers[6]);
//		$display("Reg s2: %b", dut.Reg.registers[7]);
//		$display("Reg s3: %b", dut.Reg.registers[8]);
//		$display("Reg s4: %b", dut.Reg.registers[9]);
//		$display("Reg s5: %b", dut.Reg.registers[10]);
//		
//		if (dut.PC == 46) begin
//			for (int i = 0; i < 150; i++)
//				$display("Mem: %d %h", i, dut.DataMem.my_memory[i]);
//		end
//	  
//		if (dut.PC == 57)
//			$stop;


		#5ns CLK = 0;
			
	end

  
  
endmodule