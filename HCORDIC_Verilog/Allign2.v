`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:21:30 02/22/2015 
// Design Name: 
// Module Name:    Allign2 
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
module Allign2(
	input [1:0] idle_Allign,
	input [35:0] cout_Allign,
	input [35:0] zout_Allign,
	input [31:0] sout_Allign,
	input [1:0] modeout_Allign,
	input operationout_Allign,
	input NatLogFlagout_Allign,
	input [7:0] difference_Allign,
	input [7:0] InsTag_Allign,
	input clock,
	output reg [1:0] idle_Allign2,
	output reg [35:0] cout_Allign2,
	output reg [35:0] zout_Allign2,
	output reg [31:0] sout_Allign2,
	output reg [1:0] modeout_Allign2,
	output reg operationout_Allign2,
	output reg NatLogFlagout_Allign2,
	output reg [7:0] InsTag_Allign2
    );
	 
parameter mode_circular  =2'b01, 
			 mode_linear    =2'b00, 
			 mode_hyperbolic=2'b11;

parameter no_idle = 2'b00,
			 allign_idle = 2'b01,
			 put_idle = 2'b10;

wire z_sign;
wire [7:0] z_exponent;
wire [26:0] z_mantissa;

wire c_sign;
wire [7:0] c_exponent;
wire [26:0] c_mantissa;

assign z_sign = zout_Allign[35];
assign z_exponent = zout_Allign[34:27] - 127;
assign z_mantissa = {zout_Allign[26:0]};

assign c_sign = cout_Allign[35];
assign c_exponent = cout_Allign[34:27] - 127;
assign c_mantissa = {cout_Allign[26:0]};

always @ (posedge clock)
begin
	
	InsTag_Allign2 <= InsTag_Allign;
	idle_Allign2 <= idle_Allign;
	modeout_Allign2 <= modeout_Allign;
	operationout_Allign2 <= operationout_Allign;
	sout_Allign2 <= sout_Allign;
	
	if (idle_Allign != put_idle) begin
		if ($signed(c_exponent) > $signed(z_exponent)) begin
			zout_Allign2[35] <= zout_Allign[35];
			zout_Allign2[34:27] <= z_exponent + difference_Allign + 127;
			zout_Allign2[26:0] <= z_mantissa >> difference_Allign;
			zout_Allign2[0] <= z_mantissa[0] | z_mantissa[1];
			cout_Allign2 <= cout_Allign;
		end else if ($signed(c_exponent) <= $signed(z_exponent)) begin
			cout_Allign2[35] <= cout_Allign[35];
			cout_Allign2[34:27] <= c_exponent + difference_Allign + 127;
			cout_Allign2[26:0] <= c_mantissa >> difference_Allign;
			cout_Allign2[0] <= c_mantissa[0] | c_mantissa[1];
			zout_Allign2 <= zout_Allign;
		 end		
	end
	
	else begin
		zout_Allign2 <= zout_Allign;
		cout_Allign2 <= cout_Allign;
	end
end

endmodule
