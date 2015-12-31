`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:40 02/23/2015 
// Design Name: 
// Module Name:    PackSum_y 
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
module PackSum_y(
	input [1:0] idle_NormaliseSum,
	input [31:0] sout_NormaliseSum,
	input [1:0] modeout_NormaliseSum,
	input operationout_NormaliseSum,
	input [27:0] sum_NormaliseSum,
	input [7:0] InsTag_NormaliseSum,
	input clock,
	output reg [31:0] sout_PackSum,
	output reg done = 1'b0
    );
	 
parameter mode_circular  =2'b01, 
			 mode_linear    =2'b00, 
			 mode_hyperbolic=2'b11;

parameter no_idle = 2'b00,
			 allign_idle = 2'b01,
			 put_idle = 2'b10;

wire s_sign;
wire [7:0] s_exponent;

assign s_sign = sout_NormaliseSum[31];
assign s_exponent = sout_NormaliseSum[30:23];

always @ (posedge clock)
begin
	
	if (modeout_NormaliseSum == mode_circular) begin
		done <= 1'b1;
	end		
	
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
end


endmodule
