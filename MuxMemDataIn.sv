// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Mux Memory Data Input

module MuxMemDataIn(
	input [7:0]				ReadA,
	input	[3:0]				MemInputControl,
	
	output logic [7:0] 	DataMemIn
);

	always_comb begin
		case (MemInputControl)
			4'd0:
				DataMemIn = ReadA;
			4'd1:
				DataMemIn = 8'h20;
			4'd2:
				DataMemIn = 8'd0;
			4'd3:
				DataMemIn = 8'd64;
			4'd4:
				DataMemIn = 8'he1;
			4'd5:
				DataMemIn = 8'hd4;
			4'd6:
				DataMemIn = 8'hc6;
			4'd7:
				DataMemIn = 8'hb8;
			4'd8:
				DataMemIn = 8'hb4;
			4'd9:
				DataMemIn = 8'hb2;
			4'd10:
				DataMemIn = 8'hfa;
			4'd11:
				DataMemIn = 8'hf3;
			default:
				DataMemIn = 0;
		endcase
	end

endmodule
/*
	S-type	6 			= 0x20
				35 & 38	= 0
				40 		= 64
				49			= 0xe1
				50			= 0xd4
				51			= 0xc6
				52			= 0xb8
				53			= 0xb4
				54			= 0xb2
				55			= 0xfa
				56			= 0xf3				
*/