// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Mux Memory Address

module MuxMemAddress(
	input [7:0]				ReadB,
	input	[3:0]				MemAddrControl,
	input [7:0]				ALU,
	
	output logic [7:0] 	DataAddress
);

	always_comb begin
			case (MemAddrControl)
			4'd0:
				DataAddress = ReadB;
			4'd1:
				DataAddress = 8'd42;
			4'd2:
				DataAddress = 8'd43;
			4'd3:
				DataAddress = 8'd0;
			4'd4:
				DataAddress = 8'd64;
			4'd5:
				DataAddress = 8'd128;
			4'd6:
				DataAddress = 8'd55;
			4'd7:
				DataAddress = 8'd56;
			4'd8:
				DataAddress = 8'd57;
			4'd9:
				DataAddress = 8'd58;
			4'd10:
				DataAddress = 8'd59;
			4'd11:
				DataAddress = 8'd60;
			4'd12:
				DataAddress = 8'd61;
			4'd13:
				DataAddress = 8'd62;
			4'd14:
				DataAddress = ALU;
			default:
				DataAddress = 0;
		endcase
	end

/*
	S-type 	1 			= 42
	S-type 	2 			= 43
				4 & 41 	= 0
				5 			= 64
				6 			= 128
				49			= 55
				50			= 56
				51			= 57
				52			= 58
				53			= 59
				54			= 60
				55			= 61
				56			= 62
				
*/
endmodule