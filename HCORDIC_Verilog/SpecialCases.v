`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:39:17 02/21/2015 
// Design Name: 
// Module Name:    SpecialCases 
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
module SpecialCases(
	input [31:0] ain_Special,
	input [31:0] bin_Special,
	input [31:0] cin_Special,
	input [1:0] mode_Special,
	input operation_Special,
	input NatLogFlag_Special,
	input [7:0] InsTagFSMOut,
	input reset,
	input clock,
	output reg [1:0] idle_Special = 1'b00,
	output reg [32:0] aout_Special,
	output reg [32:0] bout_Special,
	output reg [35:0] cout_Special,
	output reg [35:0] zout_Special,
	output reg [31:0] sout_Special,
	output reg [1:0]  modeout_Special,
	output reg operationout_Special,
	output reg NatLogFlagout_Special,
	output reg [7:0] InsTag_Special
   );

wire a_sign;
wire [7:0] a_exponent;
wire [23:0] a_mantissa;

wire b_sign;
wire [7:0] b_exponent;
wire [23:0] b_mantissa;

wire c_sign;
wire [7:0] c_exponent;
wire [26:0] c_mantissa;

assign a_sign = ain_Special[31];
assign a_exponent = {ain_Special[30:23] - 127};
assign a_mantissa = {1'b0, ain_Special[22:0]};

assign b_sign = {bin_Special[31]};
assign b_exponent = {bin_Special[30:23] - 127};
assign b_mantissa = {1'b0, bin_Special[22:0]};

assign c_sign = {cin_Special[31]};
assign c_exponent = {cin_Special[30:23] - 127};
assign c_mantissa = {cin_Special[22:0],3'd0};

parameter no_idle = 2'b00,
			 allign_idle = 2'b01,
			 put_idle = 2'b10;

always @ (posedge clock)
begin
   
	if(reset == 1'b1) begin
		idle_Special <= 1'b00;
	end
	
	else begin
	InsTag_Special <= InsTagFSMOut;
	modeout_Special <= mode_Special;
	operationout_Special <= operation_Special;
	NatLogFlagout_Special <= NatLogFlag_Special;
	
	//if a is NaN or b is NaN return NaN 
   if ((a_exponent == 128 && a_mantissa != 0) || (b_exponent == 128 && b_mantissa != 0)) begin
		 idle_Special <= allign_idle;
		 aout_Special <= {a_sign,a_exponent+127,a_mantissa};
		 bout_Special <= {b_sign,b_exponent+127,b_mantissa};
		 cout_Special <= {c_sign,c_exponent+127,c_mantissa};
		 zout_Special <= {1'b1,8'd255,1'b1,26'd0};
		 sout_Special <= 0;
   //if a is inf return inf
   end else if (a_exponent == 128) begin
		 idle_Special <= allign_idle;
		 //if b is zero return NaN
       if ($signed(b_exponent == -127) && (b_mantissa == 0)) begin
			  idle_Special <= allign_idle;
			  aout_Special <= {a_sign,a_exponent,a_mantissa};
		     bout_Special <= {b_sign,b_exponent,b_mantissa};
		     cout_Special <= {c_sign,c_exponent,c_mantissa};
		     zout_Special <= {1'b1,8'd255,1'b1,26'd0};
		     sout_Special <= 0;
       end
		 else begin
				aout_Special <= {a_sign,a_exponent,a_mantissa};
				bout_Special <= {b_sign,b_exponent,b_mantissa};
				cout_Special <= {c_sign,c_exponent,c_mantissa};
				zout_Special <= {a_sign ^ b_sign,8'd255,27'd0};
				sout_Special <= 0;
		 end
   //if b is inf return inf
   end else if (b_exponent == 128) begin
		 idle_Special <= allign_idle;
		 aout_Special <= {a_sign,a_exponent,a_mantissa};
		 bout_Special <= {b_sign,b_exponent,b_mantissa};
		 cout_Special <= {c_sign,c_exponent,c_mantissa};
		 zout_Special <= {a_sign ^ b_sign,8'd255,27'd0};
		 sout_Special <= 0;
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
		 cout_Special[35] <= c_sign; 
		 cout_Special[34:27] <= c_exponent+127;
		 cout_Special[26:0] <= c_mantissa[26:0];
		 zout_Special <= {a_sign ^ b_sign,8'd0,27'd0};
		 sout_Special <= {c_sign,c_exponent + 127,c_mantissa[25:3]};
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
		 cout_Special[35] <= c_sign; 
		 cout_Special[35] <= c_sign; 
		 cout_Special[34:27] <= c_exponent+127;
		 cout_Special[26:0] <= c_mantissa[26:0];
		 zout_Special <= {a_sign ^ b_sign,8'd0,27'd0};
		 sout_Special <= {c_sign,c_exponent + 127,c_mantissa[25:3]};		 
		 idle_Special <= put_idle;
   // If mode is linear, return 0 for product
	end else if (mode_Special == 2'b00) begin
		 idle_Special <= put_idle;
		 aout_Special[32] <= a_sign; 
		 aout_Special[31:24] <= a_exponent+127;
		 aout_Special[23] <= 1'b1;
		 aout_Special[22:0] <= a_mantissa[22:0];
		 bout_Special[32] <= b_sign; 
		 bout_Special[31:24] <= b_exponent+127;
		 bout_Special[23] <= 1'b1;
		 bout_Special[22:0] <= b_mantissa[22:0];
		 cout_Special[35] <= c_sign; 
		 cout_Special[34:27] <= c_exponent+127;
		 cout_Special[26:0] <= c_mantissa[26:0];
		 zout_Special <= {a_sign ^ b_sign,8'd0,27'd0};
		 sout_Special <= {c_sign,c_exponent + 127,c_mantissa[25:3]};
   end else begin
       //Denormalised Number
		 cout_Special[35] <= c_sign; 
		 cout_Special[34:27] <= c_exponent+127;
		 cout_Special[26:0] <= c_mantissa[26:0];
		 zout_Special <= 0;
		 sout_Special <= 0;
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
