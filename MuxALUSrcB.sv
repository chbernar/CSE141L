// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Mux ALU Src B

module MuxALUSrcB(
	
	input [7:0]				ReadB,
	input	[1:0]				instShamt,
	input	[2:0]				instImmediate,
	input	[3:0]				ALUSrcBCtrl,
	
	output logic [7:0] 	ALUInputB
);

	always_comb begin
		
		// Init the output logic
		ALUInputB = 0;
		
		case (ALUSrcBCtrl)
			4'd0:
				ALUInputB = ReadB;
			4'd1: begin
//				ALUInputB = { 6'd0, instShamt };
				if (instShamt == 2'b01) begin
					ALUInputB = 1;
//					$display("instShamt = 1");
				end
				
				else if (instShamt == 2'b10) begin
					ALUInputB = 2;
//					$display("instShamt = 2");
				end
				
				else if (instShamt == 2'b11) begin
					ALUInputB = 4;
//					$display("instShamt = 4");
				end
				
			end
			4'd2: begin
				//ALUInputB = { 5'd0, instImmediate };
				ALUInputB = 8'd0;
				ALUInputB[2] = instImmediate[2];
				ALUInputB[1] = instImmediate[1];
				ALUInputB[0] = instImmediate[0];
			end
			4'd3:
				ALUInputB = 8'd0;
			4'd4:
				ALUInputB = 8'd9;
			4'd5:
				ALUInputB = 8'h20;
			4'd6:
				ALUInputB = 8'd8;
			4'd7:
				ALUInputB = 8'd54;
			4'd8:
				ALUInputB = 8'd255;
			4'd9:
				ALUInputB = 8'd1;
			4'd10:
				ALUInputB = 8'd16;
			4'd11:
				ALUInputB = 8'd41;
			4'd12:
				ALUInputB = 8'd55;	
			default:
				ALUInputB = 8'd0;
		endcase
	end
endmodule

/* 
	SR-type 6 	= 1
	S-type 16 & 20 & 58 = 0
	S-type 22 = 9
	S-type 14 & 23 = 0x20
	S-type 26 = 8
	S-type 39 = 54 
	S-type 12 = 255
*/
