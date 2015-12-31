`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:45:59 02/22/2015 
// Design Name: 
// Module Name:    Allign 
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
module Allign(
	input [1:0] idle_NormaliseProd,
	input [35:0] cout_NormaliseProd,
	input [35:0] zout_NormaliseProd,
	input [31:0] sout_NormaliseProd,
	input [1:0]  modeout_NormaliseProd,
	input operationout_NormaliseProd,
	input NatLogFlagout_NormaliseProd,
	input [49:0] productout_NormaliseProd,
	input [7:0] InsTag_NormaliseProd,
	input clock,
	output reg [1:0] idle_Allign,
	output reg [35:0] cout_Allign,
	output reg [35:0] zout_Allign,
	output reg [31:0] sout_Allign,
	output reg [1:0] modeout_Allign,
	output reg operationout_Allign,
	output reg NatLogFlagout_Allign,
	output reg [7:0] difference_Allign,
	output reg [7:0] InsTag_Allign
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

assign z_sign = zout_NormaliseProd[35];
assign z_exponent = zout_NormaliseProd[34:27];
assign z_mantissa = {zout_NormaliseProd[26:0]};

assign c_sign = cout_NormaliseProd[35];
assign c_exponent = cout_NormaliseProd[34:27] - 127;
assign c_mantissa = {cout_NormaliseProd[26:0]};

always @ (posedge clock)
begin
	
	InsTag_Allign <= InsTag_NormaliseProd;
	idle_Allign <= idle_NormaliseProd;
	modeout_Allign <= modeout_NormaliseProd;
	operationout_Allign <= operationout_NormaliseProd;
	NatLogFlagout_Allign <= NatLogFlagout_NormaliseProd; 
	
	if (idle_NormaliseProd == no_idle || idle_NormaliseProd == allign_idle) begin
		  if ($signed(z_exponent) > $signed(c_exponent)) begin
			    difference_Allign <= z_exponent - c_exponent;
		  end
		  else if ($signed(z_exponent) <= $signed(c_exponent)) begin
			    difference_Allign <= c_exponent - z_exponent;
		  end	


		  // Most of the special cases will never occur except the case where one input is zero.
		  // The HCORDIC module will not receive NaN and inf at input stage.
		  //if c is NaN or z is NaN return NaN 
        if ((c_exponent == 128 && c_mantissa != 0) || (z_exponent == 128 && z_mantissa != 0)) begin
          sout_Allign[31] <= 1;
          sout_Allign[30:23] <= 255;
          sout_Allign[22] <= 1;
          sout_Allign[21:0] <= 0;
			 zout_Allign <= zout_NormaliseProd;
			 cout_Allign <= cout_NormaliseProd;
			 idle_Allign <= put_idle;
        //if c is inf return inf
        end else if (c_exponent == 128) begin
          sout_Allign[31] <= c_sign;
          sout_Allign[30:23] <= 255;
          sout_Allign[22:0] <= 0;
			 zout_Allign <= zout_NormaliseProd;
			 cout_Allign <= cout_NormaliseProd;
          idle_Allign <= put_idle;							
        //if z is inf return inf
        end else if (z_exponent == 128) begin
          sout_Allign[31] <= z_sign;
          sout_Allign[30:23] <= 255;
          sout_Allign[22:0] <= 0;
			 zout_Allign <= zout_NormaliseProd;
			 cout_Allign <= cout_NormaliseProd;
          idle_Allign <= put_idle;							
        //if c is zero return z
        end else if ((($signed(c_exponent) == -127) && (c_mantissa == 0)) && (($signed(z_exponent) == -127) && (z_mantissa == 0))) begin
          sout_Allign[31] <= c_sign & z_sign;
          sout_Allign[30:23] <= z_exponent[7:0] + 127;
          sout_Allign[22:0] <= z_mantissa[26:3];
			 zout_Allign <= zout_NormaliseProd;
			 cout_Allign <= cout_NormaliseProd;
          idle_Allign <= put_idle;							
        //if c is zero return z
        end else if (($signed(c_exponent) == -127) && (c_mantissa == 0)) begin
          sout_Allign[31] <= z_sign;
          sout_Allign[30:23] <= z_exponent[7:0] + 127;
          sout_Allign[22:0] <= z_mantissa[26:3];
			 zout_Allign <= zout_NormaliseProd;
			 cout_Allign <= cout_NormaliseProd;
          idle_Allign <= put_idle;								
        //if z is zero return c
        end else if (($signed(z_exponent) == -127) && (z_mantissa == 0)) begin
          sout_Allign[31] <= c_sign;
          sout_Allign[30:23] <= c_exponent[7:0] + 127;
          sout_Allign[22:0] <= c_mantissa[26:3];
			 zout_Allign <= zout_NormaliseProd;
			 cout_Allign <= cout_NormaliseProd;
          idle_Allign <= put_idle;							
        end else begin
			 sout_Allign <= sout_NormaliseProd;
          //Denormalised Number
          if ($signed(c_exponent) == -127) begin
            cout_Allign[34:27] <= -126;
				cout_Allign[35] <= c_sign;
				cout_Allign[26:0] <= c_mantissa;
          end else begin
			   cout_Allign[34:27] <= c_exponent + 127;
				cout_Allign[35] <= c_sign;
            cout_Allign[26] <= 1;
				cout_Allign[25:0] <= c_mantissa[25:0];
          end
          //Denormalised Number
          if ($signed(z_exponent) == -127) begin
				zout_Allign[35] <= z_sign;
            zout_Allign[34:27] <= -126;
				zout_Allign[26:0] <= z_mantissa;
          end else begin
			 	zout_Allign[35] <= z_sign;
            zout_Allign[34:27] <= z_exponent + 127;
				zout_Allign[25:0] <= z_mantissa[25:0];
            zout_Allign[26] <= 1;
          end
		  end
	end
	
	else begin
		sout_Allign <= sout_NormaliseProd;
		zout_Allign <= zout_NormaliseProd;
		cout_Allign <= cout_NormaliseProd;
	end
end


endmodule
