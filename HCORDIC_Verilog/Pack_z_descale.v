`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:30 02/23/2015 
// Design Name: 
// Module Name:    Pack_z_descale 
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
module Pack_z_descale(
	input idle_NormaliseProd,
	input [32:0] zout_NormaliseProd,
	input [49:0] productout_NormaliseProd,
	input [7:0] InsTagNormaliseProd,
	input ScaleValidNormaliseProd,
	input [31:0] z_NormaliseProd,
	input reset,
	input clock,
	output reg done = 1'b0,
	output reg [31:0] FinalProduct,
	output reg [7:0] InsTagPack,
	output reg [31:0] z_Descale
    );

parameter no_idle = 1'b0,
			 put_idle = 1'b1;

wire z_sign;
wire [7:0] z_exponent;
wire [26:0] z_mantissa;

assign z_sign = zout_NormaliseProd[32];
assign z_exponent = zout_NormaliseProd[31:24];
assign z_mantissa = {zout_NormaliseProd[23:0]};

always @ (posedge clock)
begin
	
	if(reset == 1'b1) begin
		done <= 1'b0;
	end
	
	else begin
	z_Descale <= z_NormaliseProd;
	InsTagPack <= InsTagNormaliseProd;
	
	if(ScaleValidNormaliseProd == 1'b1) begin
		done <= 1'b1;
	end
	else begin
		done <= 1'b0;
	end
	
	if (idle_NormaliseProd == no_idle)
	begin
        FinalProduct[22 : 0] <= z_mantissa[22:0];
        FinalProduct[30 : 23] <= z_exponent[7:0] + 127;
        FinalProduct[31] <= z_sign;
        if ($signed(z_exponent) == -126 && z_mantissa[23] == 0) begin
          FinalProduct[30 : 23] <= 0;
        end
        //if overflow occurs, return inf
        if ($signed(z_exponent) > 127) begin
          FinalProduct[22 : 0] <= 0;
          FinalProduct[30 : 23] <= 255;
          FinalProduct[31] <= z_sign;
        end
	end
	
	else begin
		FinalProduct <= zout_NormaliseProd[32:1];
	end
	
	end
end

endmodule
