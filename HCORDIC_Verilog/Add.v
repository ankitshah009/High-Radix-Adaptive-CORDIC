`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:24 02/22/2015 
// Design Name: 
// Module Name:    Add 
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
module Add(
	input idle_Allign,
	input [35:0] cout_Allign,
	input [35:0] zout_Allign,
	input [31:0] sout_Allign,
	input clock,
	output reg idle_AddState,
	output reg [31:0] sout_AddState,
	output reg [27:0] sum_AddState
    );
parameter no_idle = 1'b0,
			 put_idle = 1'b1;

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

	idle_AddState <= idle_Allign;
	
	if (idle_Allign != put_idle) begin
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
		sout_AddState <= sout_Allign;
		sum_AddState <= 0;
	end
end

endmodule
