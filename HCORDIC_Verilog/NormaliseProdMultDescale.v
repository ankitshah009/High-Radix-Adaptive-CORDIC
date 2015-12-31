`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:08 02/22/2015 
// Design Name: 
// Module Name:    NormaliseProdMult 
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
module NormaliseProdMultDescale(
	input [32:0] zout_Multiply,
	input [49:0] productout_Multiply,
   input [7:0] InsTagMultiply,
	input ScaleValidMultiply,
	input [31:0] z_Multiply,
	input clock,
	input idle_Multiply,
	output reg idle_NormaliseProd,
	output reg [32:0] zout_NormaliseProd,
	output reg [49:0] productout_NormaliseProd,
	output reg [7:0] InsTagNormaliseProd,
	output reg ScaleValidNormaliseProd,
	output reg [31:0] z_NormaliseProd
   );

parameter no_idle = 1'b0,
			 put_idle = 1'b1;

wire z_sign;
wire [7:0] z_exponent;
wire [26:0] z_mantissa;

assign z_sign = zout_Multiply[32];
assign z_exponent = zout_Multiply[31:24];
assign z_mantissa = {zout_Multiply[23:0]};

always @ (posedge clock) begin
	
	z_NormaliseProd <= z_Multiply;
	ScaleValidNormaliseProd <= ScaleValidMultiply;
	InsTagNormaliseProd <= InsTagMultiply;
	idle_NormaliseProd <= idle_Multiply;
	
	if (idle_Multiply == no_idle) begin
	
		// This case will never arise. This is because for input with exponent less than -12 multiply isn't used.
		if ($signed(z_exponent) < -126) begin
			zout_NormaliseProd[32] <= z_sign;
         zout_NormaliseProd[31:24] <= z_exponent + 1;
			zout_NormaliseProd[23:0]  <= z_mantissa;
         productout_NormaliseProd <= productout_Multiply >> 1;
		end
			
		// This could be problematic. Will have to test for average number of cycles
		// Current solution is to hard code for all cases like normalisation in addition.
		else if (productout_Multiply[49] == 0) begin
			zout_NormaliseProd[32] <= z_sign;
			zout_NormaliseProd[31:24] <= z_exponent - 1;
			zout_NormaliseProd[23:0] <= {productout_Multiply[48:25]};
			productout_NormaliseProd <= productout_Multiply << 1;
		end
		
		else begin
			zout_NormaliseProd[32] <= z_sign;
			zout_NormaliseProd[31:24] <= z_exponent;
			zout_NormaliseProd[23:0] <= {productout_Multiply[49:26]};
			productout_NormaliseProd <= productout_Multiply;
		end	
	end
	
	else begin
		zout_NormaliseProd <= zout_Multiply;
	end
	
end

endmodule
