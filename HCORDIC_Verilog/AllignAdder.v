`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:24 02/22/2015 
// Design Name: 
// Module Name:    AllignAdder 
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
module AllignAdder(
	input idle_Special,
	input [35:0] cout_Special,
	input [35:0] zout_Special,
	input [31:0] sout_Special,
	input [7:0] difference_Special,
	input clock,
	output reg idle_Allign,
	output reg [35:0] cout_Allign,
	output reg [35:0] zout_Allign,
	output reg [31:0] sout_Allign
   );

parameter no_idle = 1'b01,
			 put_idle = 1'b1;

wire z_sign;
wire [7:0] z_exponent;
wire [26:0] z_mantissa;

wire c_sign;
wire [7:0] c_exponent;
wire [26:0] c_mantissa;

assign z_sign = zout_Special[35];
assign z_exponent = zout_Special[34:27] - 127;
assign z_mantissa = {zout_Special[26:0]};

assign c_sign = cout_Special[35];
assign c_exponent = cout_Special[34:27] - 127;
assign c_mantissa = {cout_Special[26:0]};

always @ (posedge clock)
begin
	
	idle_Allign <= idle_Special;
	sout_Allign <= sout_Special;
	
	if (idle_Special != put_idle) begin
		if ($signed(c_exponent) > $signed(z_exponent)) begin
			zout_Allign[35] <= zout_Special[35];
			zout_Allign[34:27] <= z_exponent + difference_Special + 127;
			zout_Allign[26:0] <= z_mantissa >> difference_Special;
			zout_Allign[0] <= z_mantissa[0] | z_mantissa[1];
			cout_Allign <= cout_Special;
		end else if ($signed(c_exponent) <= $signed(z_exponent)) begin
			cout_Allign[35] <= cout_Special[35];
			cout_Allign[34:27] <= c_exponent + difference_Special + 127;
			cout_Allign[26:0] <= c_mantissa >> difference_Special;
			cout_Allign[0] <= c_mantissa[0] | c_mantissa[1];
			zout_Allign <= zout_Special;
		 end		
	end
	
	else begin
		zout_Allign <= zout_Special;
		cout_Allign <= cout_Special;
	end
end

endmodule
