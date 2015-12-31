`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:09 02/22/2015 
// Design Name: 
// Module Name:    PackAdder 
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
module PackAdderProcess(
	input [31:0] z_postNormaliseSum,
	input [3:0] Opcode_NormaliseSum,
	input idle_NormaliseSum,
	input [31:0] sout_NormaliseSum,
	input [27:0] sum_NormaliseSum,
	input [7:0] InsTagNormaliseAdder,
	input clock,
	output reg [31:0] sout_PackSum,
	output reg Done = 1'b0,
	output reg [31:0] z_postPack,
	output reg [3:0] Opcode_Pack,
	output reg [7:0] InsTagPack
   );

parameter no_idle = 1'b0,
			 put_idle = 1'b1;
			 
wire s_sign;
wire [7:0] s_exponent;

assign s_sign = sout_NormaliseSum[31];
assign s_exponent = sout_NormaliseSum[30:23];

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
	
	InsTagPack <= InsTagNormaliseAdder;
	Opcode_Pack <= Opcode_NormaliseSum;
	z_postPack <= z_postNormaliseSum;
	
	//if (Opcode_NormaliseSum == PreProcess) begin
	
	Done <= 1'b0;
	
	if (idle_NormaliseSum != put_idle) begin
		sout_PackSum[22:0] <= sum_NormaliseSum[25:3];
		sout_PackSum[30:23] <= s_exponent + 127;
		sout_PackSum[31] <= s_sign;
      if ($signed(s_exponent) == -126 && sum_NormaliseSum[22] == 0) begin
         sout_PackSum[30 : 23] <= 0;
      end
		  
		if ($signed(s_exponent) <= -126) begin
			sout_PackSum[30 : 23] <= 0;
			sout_PackSum[22:0] <= 0;
		end
		  
        //if overflow occurs, return inf
      if ($signed(s_exponent) > 127) begin
         sout_PackSum[22 : 0] <= 0;
         sout_PackSum[30 : 23] <= 255;
         sout_PackSum[31] <= s_sign;
      end		
	end
	
	else begin
		sout_PackSum <= sout_NormaliseSum;
	end
	
	//end
	
	if (Opcode_NormaliseSum == sqr_root || Opcode_NormaliseSum == nat_log) begin
		Done <= 1'b1;
	end
end

endmodule
