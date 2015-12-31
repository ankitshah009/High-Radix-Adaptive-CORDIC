`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:45 02/22/2015 
// Design Name: 
// Module Name:    NormaliseAdder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NormaliseAdderProcess(
	input [31:0] z_postAddState,
	input [3:0] Opcode_AddState,
	input idle_AddState,
	input [31:0] sout_AddState,
	input [27:0] sum_AddState,
	input [7:0] InsTagAdder,
	input clock,
	output reg idle_NormaliseSum,
	output reg [31:0] sout_NormaliseSum,
	output reg [27:0] sum_NormaliseSum,
	output reg [3:0] Opcode_NormaliseSum,
	output reg [31:0] z_postNormaliseSum,
	output reg [7:0] InsTagNormaliseAdder
    );

parameter no_idle = 1'b0,
			 put_idle = 1'b1;

wire [7:0] s_exponent;

assign s_exponent = sout_AddState[30:23];

parameter sin_cos		= 4'd0,
			 sinh_cosh	= 4'd1,
			 arctan		= 4'd2,
			 arctanh		= 4'd3,
			 exp			= 4'd4,
			 sqr_root   = 4'd5,			// Pre processed input is given 4'd11
												// This requires pre processing. x = (a+1)/2 and y = (a-1)/2
			 division	= 4'd6,
			 tan			= 4'd7,			// This is iterative. sin_cos followed by division.
			 tanh			= 4'd8,			// This is iterative. sinh_cosh followed by division.
			 nat_log		= 4'd9,			// This requires pre processing. x = (a+1) and y = (a-1)
			 hypotenuse = 4'd10,
			 PreProcess = 4'd11;

always @ (posedge clock)
begin
	
	InsTagNormaliseAdder <= InsTagAdder;
	z_postNormaliseSum <= z_postAddState;
	Opcode_NormaliseSum <= Opcode_AddState;
	
	//if(Opcode_AddState == PreProcess) begin
	
	idle_NormaliseSum <= idle_AddState;
	
	if (idle_AddState != put_idle) begin
			
			sout_NormaliseSum[31] <= sout_AddState[31];
			sout_NormaliseSum[22:0] <= sout_AddState[22:0];
			
			if (sum_AddState[27] == 1'b1) begin
				sout_NormaliseSum[30:23] <= s_exponent + 1;
				sum_NormaliseSum <= sum_AddState >> 1;
			end

			else if(sum_AddState[26:3] == 24'h000000) begin
				sout_NormaliseSum[30:23] <= 10'h382;
			end
			
			else if (sum_AddState[26:4] == 23'h000000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 23;
				sum_NormaliseSum <= sum_AddState << 23;
			end
			
			else if (sum_AddState[26:5] == 22'h000000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 22;
				sum_NormaliseSum <= sum_AddState << 22;			
			end
			
			else if (sum_AddState[26:6] == 21'h000000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 21;
				sum_NormaliseSum <= sum_AddState << 21;			
			end
			
			else if (sum_AddState[26:7] == 20'h00000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 20;
				sum_NormaliseSum <= sum_AddState << 20;			
			end
			
			else if (sum_AddState[26:8] == 19'h00000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 19;
				sum_NormaliseSum <= sum_AddState << 19;			
			end

			else if (sum_AddState[26:9] == 18'h00000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 18;
				sum_NormaliseSum <= sum_AddState << 18;			
			end

			else if (sum_AddState[26:10] == 17'h00000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 17;
				sum_NormaliseSum <= sum_AddState << 17;			
			end

			else if (sum_AddState[26:11] == 16'h0000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 16;
				sum_NormaliseSum <= sum_AddState << 16;			
			end

			else if (sum_AddState[26:12] == 15'h0000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 15;
				sum_NormaliseSum <= sum_AddState << 15;			
			end

			else if (sum_AddState[26:13] == 14'h0000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 14;
				sum_NormaliseSum <= sum_AddState << 14;			
			end

			else if (sum_AddState[26:14] == 13'h0000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 13;
				sum_NormaliseSum <= sum_AddState << 13;			
			end

			else if (sum_AddState[26:15] == 12'h000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 12;
				sum_NormaliseSum <= sum_AddState << 12;			
			end

			else if (sum_AddState[26:16] == 11'h000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 11;
				sum_NormaliseSum <= sum_AddState << 11;			
			end

			else if (sum_AddState[26:17] == 10'h000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 10;
				sum_NormaliseSum <= sum_AddState << 10;			
			end

			else if (sum_AddState[26:18] == 9'h0000) begin
				sout_NormaliseSum[30:23] <= s_exponent - 9;
				sum_NormaliseSum <= sum_AddState << 9;			
			end

			else if (sum_AddState[26:19] == 8'h00) begin
				sout_NormaliseSum[30:23] <= s_exponent - 8;
				sum_NormaliseSum <= sum_AddState << 8;			
			end

			else if (sum_AddState[26:20] == 7'h00) begin
				sout_NormaliseSum[30:23] <= s_exponent - 7;
				sum_NormaliseSum <= sum_AddState << 7;			
			end

			else if (sum_AddState[26:21] == 6'h00) begin
				sout_NormaliseSum[30:23] <= s_exponent - 6;
				sum_NormaliseSum <= sum_AddState << 6;			
			end

			else if (sum_AddState[26:22] == 5'h00) begin
				sout_NormaliseSum[30:23] <= s_exponent - 5;
				sum_NormaliseSum <= sum_AddState << 5;			
			end

			else if (sum_AddState[26:23] == 4'h0) begin
				sout_NormaliseSum[30:23] <= s_exponent - 4;
				sum_NormaliseSum <= sum_AddState << 4;			
			end

			else if (sum_AddState[26:24] == 3'h0) begin
				sout_NormaliseSum[30:23] <= s_exponent - 3;
				sum_NormaliseSum <= sum_AddState << 3;			
			end

			else if (sum_AddState[26:25] == 2'h0) begin
				sout_NormaliseSum[30:23] <= s_exponent - 2;
				sum_NormaliseSum <= sum_AddState << 2;			
			end

			else if (sum_AddState[26] == 1'h0) begin
				sout_NormaliseSum[30:23] <= s_exponent - 1;
				sum_NormaliseSum <= sum_AddState << 1;			
			end
				
			else begin
				sout_NormaliseSum[30:23] <= s_exponent;
				sum_NormaliseSum <= sum_AddState;
			end
	end
	
	else begin
		sout_NormaliseSum <= sout_AddState;
		sum_NormaliseSum <= 0;
	end
	
	//end
end

endmodule
