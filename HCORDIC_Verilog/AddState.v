`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:45:21 02/22/2015 
// Design Name: 
// Module Name:    AddState 
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
module AddState(
	input [1:0] idle_Allign2,
	input [35:0] cout_Allign2,
	input [35:0] zout_Allign2,
	input [31:0] sout_Allign2,
	input [1:0] modeout_Allign2,
	input operationout_Allign2,
	input NatLogFlagout_Allign2,
	input [7:0] InsTag_Allign2,
	input clock,
	output reg [1:0] idle_AddState,
	output reg [31:0] sout_AddState,
	output reg [1:0] modeout_AddState,
	output reg operationout_AddState,
	output reg NatLogFlagout_AddState,
	output reg [27:0] sum_AddState,
	output reg [7:0] InsTag_AddState
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

assign z_sign = zout_Allign2[35];
assign z_exponent = zout_Allign2[34:27] - 127;
assign z_mantissa = {zout_Allign2[26:0]};

assign c_sign = cout_Allign2[35];
assign c_exponent = cout_Allign2[34:27] - 127;
assign c_mantissa = {cout_Allign2[26:0]};

always @ (posedge clock)
begin
	
	InsTag_AddState <= InsTag_Allign2;
	idle_AddState <= idle_Allign2;
	modeout_AddState <= modeout_Allign2;
	operationout_AddState <= operationout_Allign2;
	NatLogFlagout_AddState <= NatLogFlagout_Allign2;
	
	if (idle_Allign2 != put_idle) begin
      sout_AddState[30:23] <= c_exponent;
		sout_AddState[22:0] <= 0;
      if (c_sign == z_sign) begin
         sum_AddState <= c_mantissa + z_mantissa;
         sout_AddState[31] <= c_sign;
      end else begin
			if (c_mantissa >= z_mantissa) begin
				sum_AddState <= c_mantissa - z_mantissa;
				sout_AddState[31] <= c_sign;
			end else begin
				sum_AddState <= z_mantissa - c_mantissa;
				sout_AddState[31] <= z_sign;
			end
      end		
	end
	
	else begin
		sout_AddState <= sout_Allign2;
		sum_AddState <= 0;
	end
end

endmodule
