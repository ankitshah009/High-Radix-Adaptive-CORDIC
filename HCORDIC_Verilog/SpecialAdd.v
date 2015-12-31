`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:09 02/22/2015 
// Design Name: 
// Module Name:    SpecialAdd 
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
module SpecialAdd(
	input [31:0] cin_Special,
	input [31:0] zin_Special,
	input reset,
	input clock,
	output reg idle_Special = 1'b0,
	output reg [7:0] difference_Special,
	output reg [35:0] cout_Special,
	output reg [35:0] zout_Special,
	output reg [31:0] sout_Special
   );
	
wire z_sign;
wire [7:0] z_exponent;
wire [26:0] z_mantissa;

wire c_sign;
wire [7:0] c_exponent;
wire [26:0] c_mantissa;

assign c_sign = cin_Special[31];
assign c_exponent = {cin_Special[30:23] - 127};
assign c_mantissa = {cin_Special[22:0],3'd0};

assign z_sign = {zin_Special[31]};
assign z_exponent = {zin_Special[30:23] - 127};
assign z_mantissa = {zin_Special[22:0],3'd0};

parameter no_idle = 1'b0,
			 put_idle = 1'b1;

always @ (posedge clock)
begin

	if (reset == 1'b1) begin
		idle_Special <= 1'b0;
	end
	
	else begin
	if ($signed(z_exponent) > $signed(c_exponent)) begin
		difference_Special <= z_exponent - c_exponent;
	end
	else if ($signed(z_exponent) <= $signed(c_exponent)) begin
		difference_Special <= c_exponent - z_exponent;
	end	
	
	// Most of the special cases will never occur except the case where one input is zero.
	// The HCORDIC module will not receive NaN and inf at input stage.
	//if c is NaN or z is NaN return NaN 
   if ((c_exponent == 128 && c_mantissa != 0) || (z_exponent == 128 && z_mantissa != 0)) begin
      sout_Special[31] <= 1;
      sout_Special[30:23] <= 255;
      sout_Special[22] <= 1;
      sout_Special[21:0] <= 0;
		zout_Special <= zin_Special;
		cout_Special <= cin_Special;
		idle_Special <= put_idle;
    //if c is inf return inf
    end else if (c_exponent == 128) begin
      sout_Special[31] <= c_sign;
      sout_Special[30:23] <= 255;
      sout_Special[22:0] <= 0;
		zout_Special <= zin_Special;
		cout_Special <= cin_Special;
		idle_Special <= put_idle;		
    //if z is inf return inf
    end else if (z_exponent == 128) begin
      sout_Special[31] <= z_sign;
      sout_Special[30:23] <= 255;
      sout_Special[22:0] <= 0;
		zout_Special <= zin_Special;
		cout_Special <= cin_Special;
		idle_Special <= put_idle;		
    //if c is zero return z
    end else if ((($signed(c_exponent) == -127) && (c_mantissa == 0)) && (($signed(z_exponent) == -127) && (z_mantissa == 0))) begin
      sout_Special[31] <= c_sign & z_sign;
      sout_Special[30:23] <= z_exponent[7:0] + 127;
      sout_Special[22:0] <= z_mantissa[26:3];
		zout_Special <= zin_Special;
		cout_Special <= cin_Special;
      idle_Special <= put_idle;							
    //if c is zero return z
    end else if (($signed(c_exponent) == -127) && (c_mantissa == 0)) begin
      sout_Special[31] <= z_sign;
      sout_Special[30:23] <= z_exponent[7:0] + 127;
      sout_Special[22:0] <= z_mantissa[26:3];
		zout_Special <= zin_Special;
		cout_Special <= cin_Special;
      idle_Special <= put_idle;								
    //if z is zero return c
    end else if (($signed(z_exponent) == -127) && (z_mantissa == 0)) begin
      sout_Special[31] <= c_sign;
      sout_Special[30:23] <= c_exponent[7:0] + 127;
      sout_Special[22:0] <= c_mantissa[26:3];
		zout_Special <= zin_Special;
		cout_Special <= cin_Special;
      idle_Special <= put_idle;							
    end else begin
		sout_Special <= 0;
      //Denormalised Number
      if ($signed(c_exponent) == -127) begin
         cout_Special[34:27] <= -126;
			cout_Special[35] <= c_sign;
			cout_Special[26:0] <= c_mantissa;
      end else begin
			cout_Special[34:27] <= c_exponent + 127;
			cout_Special[35] <= c_sign;
         cout_Special[26] <= 1;
			cout_Special[25:0] <= c_mantissa[25:0];
			idle_Special <= no_idle;
      end
      //Denormalised Number
      if ($signed(z_exponent) == -127) begin
			zout_Special[35] <= z_sign;
         zout_Special[34:27] <= -126;
			zout_Special[26:0] <= z_mantissa;
      end else begin
			zout_Special[35] <= z_sign;
         zout_Special[34:27] <= z_exponent + 127;
			zout_Special[25:0] <= z_mantissa[25:0];
         zout_Special[26] <= 1;
			idle_Special <= no_idle;
      end
	end
	end
end

endmodule
