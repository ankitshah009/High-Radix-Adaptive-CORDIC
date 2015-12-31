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
module AddProcess(
	input [31:0] z_postAllign,
	input [3:0] Opcode_Allign,
	input idle_Allign,
	input [35:0] cout_Allign,
	input [35:0] zout_Allign,
	input [31:0] sout_Allign,
	input [7:0] InsTagAllign,
	input clock,
	output reg idle_AddState,
	output reg [31:0] sout_AddState,
	output reg [27:0] sum_AddState,
	output reg [3:0] Opcode_AddState,
	output reg [31:0] z_postAddState,
	output reg [7:0] InsTagAdder
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

parameter sin_cos		= 4'd0,
			 sinh_cosh	= 4'd1,
			 arctan		= 4'd2,
			 arctanh		= 4'd3,
			 exp			= 4'd4,
			 sqr_root   = 4'd5,			// Pre processed input is given 4'd11
												// This requires pre processing. x = (a+1)/2 and y = (a-1)/2
			 division	= 4'd6,
			 tan			= 4'd7,			// This is iterative. sin_cos followed by division.
			 tanh			= 4'd8,			// This is iterative. sinh_cosh followed by division.
			 nat_log		= 4'd9,			// This requires pre processing. x = (a+1) and y = (a-1)
			 hypotenuse = 4'd10,
			 PreProcess = 4'd11;


always @ (posedge clock)
begin
	
	InsTagAdder <= InsTagAllign;
	z_postAddState <= z_postAllign;
	Opcode_AddState <= Opcode_Allign;
	
	//if(Opcode_Allign == PreProcess) begin
	
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
	
	//end
end

endmodule
