`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:36:52 02/22/2015 
// Design Name: 
// Module Name:    SpecialMult 
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
module SpecialMult(
	input [31:0] ain_Special,
	input [31:0] bin_Special,
	input reset,
	input clock,
	output reg idle_Special = 1'b0,
	output reg [32:0] aout_Special,
	output reg [32:0] bout_Special,
	output reg [32:0] zout_Special
   );

wire a_sign;
wire [7:0] a_exponent;
wire [23:0] a_mantissa;

wire b_sign;
wire [7:0] b_exponent;
wire [23:0] b_mantissa;

assign a_sign = ain_Special[31];
assign a_exponent = {ain_Special[30:23] - 127};
assign a_mantissa = {1'b0, ain_Special[22:0]};

assign b_sign = {bin_Special[31]};
assign b_exponent = {bin_Special[30:23] - 127};
assign b_mantissa = {1'b0, bin_Special[22:0]};

parameter no_idle = 1'b0,
			 put_idle = 1'b1;

always @ (posedge clock)
begin
	
	if(reset == 1'b1) begin
		idle_Special <= 1'b0;
	end
	
	else begin
	//if a is NaN or b is NaN return NaN 
   if ((a_exponent == 128 && a_mantissa != 0) || (b_exponent == 128 && b_mantissa != 0)) begin
		 idle_Special <= put_idle;
		 aout_Special <= {a_sign,a_exponent+127,a_mantissa};
		 bout_Special <= {b_sign,b_exponent+127,b_mantissa};
		 zout_Special <= {1'b1,8'd255,1'b1,23'd0};
   //if a is inf return inf
   end else if (a_exponent == 128) begin
		 idle_Special <= put_idle;
		 //if b is zero return NaN
       if ($signed(b_exponent == -127) && (b_mantissa == 0)) begin
			  idle_Special <= put_idle;
			  aout_Special <= {a_sign,a_exponent,a_mantissa};
		     bout_Special <= {b_sign,b_exponent,b_mantissa};
		     zout_Special <= {1'b1,8'd255,1'b1,23'd0};
       end
		 else begin
				aout_Special <= {a_sign,a_exponent,a_mantissa};
				bout_Special <= {b_sign,b_exponent,b_mantissa};
				zout_Special <= {a_sign ^ b_sign,8'd255,24'd0};
		 end
   //if b is inf return inf
   end else if (b_exponent == 128) begin
		 idle_Special <= put_idle;
		 aout_Special <= {a_sign,a_exponent,a_mantissa};
		 bout_Special <= {b_sign,b_exponent,b_mantissa};
		 zout_Special <= {a_sign ^ b_sign,8'd255,24'd0};
   //if a is zero return zero
   end else if (($signed(a_exponent) == -127) && (a_mantissa == 0)) begin
		 idle_Special <= put_idle;
		 aout_Special[32] <= a_sign; 
		 aout_Special[31:24] <= a_exponent+127;
		 aout_Special[23] <= 1'b1;
		 aout_Special[22:0] <= a_mantissa[22:0];
		 bout_Special[32] <= b_sign; 
		 bout_Special[31:24] <= b_exponent+127;
		 bout_Special[23] <= 1'b1;
		 bout_Special[22:0] <= b_mantissa[22:0];
		 zout_Special <= {1'b0,8'd0,24'd0};
   //if b is zero return zero
   end else if (($signed(b_exponent) == -127) && (b_mantissa == 0)) begin
		 aout_Special[32] <= a_sign; 
		 aout_Special[31:24] <= a_exponent+127;
		 aout_Special[23] <= 1'b1;
		 aout_Special[22:0] <= a_mantissa[22:0];
		 bout_Special[32] <= b_sign; 
		 bout_Special[31:24] <= b_exponent+127;
		 bout_Special[23] <= 1'b1;
		 bout_Special[22:0] <= b_mantissa[22:0];
		 zout_Special <= {1'b0,8'd0,24'd0};	 
		 idle_Special <= put_idle;
   end else begin
       //Denormalised Number
		 zout_Special <= 0;
		 idle_Special <= no_idle;
       if ($signed(a_exponent) == -127) begin
           aout_Special <= {a_sign,-126,a_mantissa};
       end else begin
			  aout_Special[32] <= a_sign; 
			  aout_Special[31:24] <= a_exponent+127;
			  aout_Special[23] <= 1'b1;
			  aout_Special[22:0] <= a_mantissa[22:0];
       end
       //Denormalised Number
       if ($signed(b_exponent) == -127) begin
           bout_Special <= {b_sign,-126,b_mantissa};
       end else begin
			  bout_Special[32] <= b_sign; 
			  bout_Special[31:24] <= b_exponent+127;
			  bout_Special[23] <= 1'b1;
			  bout_Special[22:0] <= b_mantissa[22:0];
       end
   end
	end
end

endmodule
