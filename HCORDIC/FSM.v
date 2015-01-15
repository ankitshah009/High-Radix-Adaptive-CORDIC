`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:58:11 11/03/2014 
// Design Name: 
// Module Name:    FSM 
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
module FSM(
    input [31:0] x,					// x Input to FSM from Mux
    input [31:0] y,					// y Input to FSM from Mux
    input [31:0] z,					// z Input to FSM from Mux
    input [31:0] k,					// k Input to FSM from Mux
	 input [31:0] kappa_LUTRot, 
	 input [31:0] theta_LUTRot, 
	 input [31:0] delta_LUTRot,
	 input [31:0] kappa_LUTVec, 
	 input [31:0] theta_LUTVec, 
	 input [31:0] delta_LUTVec,
    input [31:0] theta_LUT,		// theta Input to FSM from LUT
    input [31:0] kappa_LUT,		// kappa Input to FSM from LUT
    input [31:0] delta_LUT,		// delta Input to FSM from LUT
    input [1:0] mode,				// Linear: 00 Hyperbolic: 11 Circular: 01
    input operation,					// operation = 1 is rotation. operation = 0 is vectoring
    input clock,
	 input done_LUTRot,
	 input done_LUTVec,
	 input done_LUT,					// Done bit set by LUT after look up
	 output reg enable_LUT,			// Enable bit set by FSM to enable LUT
	 output reg [7:0] address,		// Address field to LUT
    output reg [31:0] theta_out,	// theta Output to ALU
    output reg [31:0] kappa_out,	// kappa Output to ALU
    output reg [31:0] delta_out,	// delta Output to ALU
	 output reg done_FSM,
	 output reg [31:0] x_final,
	 output reg [31:0] y_final,
	 output reg [31:0] z_final,
	 output reg [31:0] k_final,
	 //output reg converge,
	 input done_ALU
    );

// In rotation operation if this is from 0 to -12, a look up operation is performed (look up condition). 
// In vectoring operation, this is used to check look up conditions and to decide exponent of theta and delta.
reg [7:0] exponent;
reg converge;

always @ (*)
begin
	
	// If rotation operation, calculate exponent by subtracting 127 from Ze
	if (operation == 1'b1)	
	begin
		exponent <= 8'b01111111 - z[30:23];
	end
	
	// If vectoring operation, calculatr exponent by subtracting Xe and Ye
	else if (operation == 1'b0)
	begin
		exponent <= x[30:23] - y[30:23];
	end
	
/*	// If LUT was enabled and if LUT has performed its operation, store the LUT values into output registers.
	if ((done_LUT == 1'b1 || done_LUTRot == 1'b1 || done_LUTVec == 1'b1) && enable_LUT == 1'b1)
	begin
		
		// In vectoring operation, if it is linear mode or if the exponent value is less than -12,
		// replace the exponent of theta and delta.
		if ( (operation == 1'b0) && (mode == 2'b00 || (exponent <= 8'b11110011 && exponent > 8'b10000000)))
		begin
			delta_out <= delta_LUT;
			delta_out[30:23] <= exponent + 8'b01111111;
			theta_out <= theta_LUT;
			theta_out[30:23] <= exponent + 8'b01111111;
			enable_LUT <= 1'b0;
			done_FSM <= 1'b1;
		end
		
		else if (operation == 1'b1)
		begin
			theta_out[31] <= ~z[31];
			delta_out[31] <= ~z[31];
			theta_out[30:0] <= theta_LUTRot[30:0];
			delta_out[30:0] <= delta_LUTRot[30:0];
			kappa_out <= kappa_LUTRot;
			enable_LUT <= 1'b0;
			done_FSM <= 1'b1;
		end
		
		// In all other conditions just transfer. This means vectoring operation for circular and hyperbolic mode
		else
		begin
			theta_out <= theta_LUTVec;
			delta_out <= delta_LUTVec;
			kappa_out <= kappa_LUTVec;
			enable_LUT <= 1'b0;
			done_FSM <= 1'b1;
		end
		
	end*/
end

always @ (posedge clock)
begin
	
		// If LUT was enabled and if LUT has performed its operation, store the LUT values into output registers.
	if ((done_LUT == 1'b1 || done_LUTRot == 1'b1 || done_LUTVec == 1'b1) && enable_LUT == 1'b1)
	begin
		
		// In vectoring operation, if it is linear mode or if the exponent value is less than -12,
		// replace the exponent of theta and delta.
		if ((operation == 1'b0) && (mode == 2'b00 || (exponent <= 8'b11110011 && exponent > 8'b10000000)))
		begin
			delta_out <= delta_LUT;
			delta_out[30:23] <= exponent + 8'b01111111;
			theta_out <= theta_LUT;
			theta_out[30:23] <= exponent + 8'b01111111;
			enable_LUT <= 1'b0;
			done_FSM <= 1'b1;
		end
		
		else if (operation == 1'b1)
		begin
			theta_out[31] <= ~z[31];
			delta_out[31] <= ~z[31];
			theta_out[30:0] <= theta_LUTRot[30:0];
			delta_out[30:0] <= delta_LUTRot[30:0];
			kappa_out <= kappa_LUTRot;
			enable_LUT <= 1'b0;
			done_FSM <= 1'b1;
		end
		
		// In all other conditions just transfer. This means vectoring operation for circular and hyperbolic mode
		else
		begin
			theta_out <= theta_LUTVec;
			delta_out <= delta_LUTVec;
			kappa_out <= kappa_LUTVec;
			enable_LUT <= 1'b0;
			done_FSM <= 1'b1;
		end
		
	end
	
	// If ALU has finished work, disable it.
	if (done_ALU == 1'b1)
	begin
		done_FSM <= 1'b0;
	end
	
	// Rotation Operation
	if (operation == 1'b1)												
	begin
		
		if (z[30:23] <= 8'b01110000)
		begin
			converge <= 1'b1;
			x_final <= x;
			y_final <= y;
			z_final <= z;
			k_final <= k;
		end
		
		// Linear mode
		else if (mode == 2'b00)												
		begin
			theta_out[30:0] <= z[30:0];
			delta_out[30:0] <= z[30:0];
			theta_out[31]	<= ~z[31];
			delta_out[31]	<= ~z[31];
			kappa_out <= 32'h3F800000;
			done_FSM <= 1'b1;
		end
		
		// Hyperbolic mode and Ze > 127
		// No look up is required. 
		else if (mode == 2'b11 && z[30:23] >= 8'b01111111)
		begin
			theta_out <= 32'hBF800000;
			delta_out <= 32'hBF42F7D6;
			//kappa_out <= 32'h3F25E6E3;
			kappa_out <= 32'h3FC583AB;
			done_FSM <= 1'b1;
		end
		
		// Circular Rotation and Ze > 127
		// No look up is required. 
		else if (mode == 2'b01 && z[30:23] >= 8'b01111111)		
		begin
			theta_out <= 32'hBF800000;
			delta_out <= 32'hBFC75923;
			kappa_out <= 32'h3FECE788;
			done_FSM <= 1'b1;
		end
	
		// If Ze > 114 and Ze < 127 and not Linear mode
		// Here look up is needed. The address is generated by taking 4 bits of the exponent (0-12)
		// The next 4 bits are the first 4 bits of the mantissa.
		else if (mode != 2'b00 && z[30:23] < 8'b01111111 && z[30:23] > 8'b01110011) 			
		begin
			address[7:4] <= exponent[3:0];
			address[3:0] <= z[22:19];
			enable_LUT <= 1'b1;
		end	
		
		// If Ze < 114 and not in linear mode
		// No look up is needed. The negative value of z is fed as theta and delta.
		else if (mode != 2'b00 && z[30:23] <= 8'b01110011)												
		begin
			theta_out[30:0] <= z[30:0];
			delta_out[30:0] <= z[30:0];
			theta_out[31]	<= ~z[31];
			delta_out[31]	<= ~z[31];
			kappa_out <= 32'h3F800000;
			done_FSM <= 1'b1;
		end
		
	end
	
	// Vectoring operation
	else if (operation == 1'b0)					
	begin
		
		if (z[30:23] <= 8'b01110000)
		begin
			converge <= 1'b1;
		end
		
		// In linear mode the address is formed by 4 bits of Mx (mantissa of x) and 4 bits of My.
		// The exponent of the theta and delta is decided by the exponent reg value. ie Xe - Ye.
		else if (mode == 2'b00)
		begin
			address[7:4] <= x[22:19];
			address[3:0] <= y[22:19];
			kappa_out <= 32'h3F8;
			enable_LUT <= 1'b1;
		end
		
		// If it is not linear mode and exponent is between 0 and -12, LUT is performed.
		// The first 4 bits of exponent are to determine (0-12). The next 4 bits are 2 bits of Mx and 2 bits of My each
		else if (mode != 2'b00 && exponent > 8'b11110011 && exponent <= 8'b11111111) 	
		begin
			address[7:4] <= exponent[3:0];
			address[3:2] <= x[22:21];
			address[1:0] <= y[22:21];
			enable_LUT <= 1'b1;
		end	
		
		// If not linear and exponent is less than -12, then the look up is performed same as in linear mode. 
		// ie address has only 4 bits of My and 4 bits of Mx.
		else if (mode != 2'b00 && exponent <= 8'b11110011 && exponent > 8'b10000000)
		begin
			address[7:4] <= x[22:19];
			address[3:0] <= y[22:19];
			kappa_out <= 32'h3F8;
			enable_LUT <= 1'b1;
		end
		
		// In case of Hyperbolic and greater than 0 no look up table is needed.
		else if (mode == 2'b11 && exponent <= 8'b10000000)
		begin
			delta_out <= 32'h3F733333;
			theta_out <= 32'h3FEA77CB;
			kappa_out <= 32'h3E9FDF38;				// wrong value. Redo
			done_FSM <= 1'b1;
		end
				
		// In case of Circular and greater than 0 no look up table is needed.
		else if (mode == 2'b01 && exponent <= 8'b10000000)
		begin
			delta_out <= 32'h3F8;					//wrong value. Redo
			theta_out <= 32'h3F490FDB;
			kappa_out <= 32'h3FB504F4;
			done_FSM <= 1'b1;
		end
		
	end
	
end
endmodule
