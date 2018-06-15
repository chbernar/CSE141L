// Create Date:     2018.10.05
// Latest rev date: 2018.10.05
// Created by:      Christhoper Bernard, Darell Hoei
// Design Name:     CSE141L
// Module Name:     Mux ALU Src A

module MuxALUSrcA (
	input [7:0]				ReadA,
	input	[2:0]				ALUSrcAControl,
	
	output logic [7:0] 	ALUInputA
);

	always_comb begin
		case (ALUSrcAControl)
			3'd0:
				ALUInputA <= ReadA;
			3'd1:
				ALUInputA <= 8'd64;
			3'd2:
				ALUInputA <= 0;
			default:
				ALUInputA <= 0;
		endcase
	end


endmodule