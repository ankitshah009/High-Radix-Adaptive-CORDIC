`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:52:13 02/22/2015 
// Design Name: 
// Module Name:    Pack_z 
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
module Pack_z(
	input idle_NormaliseProd,
	input [32:0] zout_NormaliseProd,
	input [49:0] productout_NormaliseProd,
	input clock,
	output reg [31:0] FinalProduct
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

endmodule
