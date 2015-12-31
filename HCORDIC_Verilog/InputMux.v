`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:40:25 11/02/2014 
// Design Name: 
// Module Name:    InputMux 
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
module InputMux(
    input [31:0] x_in,
    input [31:0] y_in,
    input [31:0] z_in,
    input [31:0] x_iter,
    input [31:0] y_iter,
    input [31:0] z_iter,
	 input [31:0] k_iter,
    input load,
	 input ALU_done,
	 input reset,
    input clock,
	 input [1:0] mode_in,
	 input operation_in,
	 input NatLogFlag,
	 input [1:0] mode_iter,
	 input operation_iter,
	 input NatLogFlag_iter,
	 input [7:0] InsTagFetchOut,
	 input [7:0] InsTag_iter,
    output reg [31:0] x_out,
    output reg [31:0] y_out,
    output reg [31:0] z_out,
    output reg [31:0] k_out,
    output reg [31:0] x_scale,
    output reg [31:0] y_scale,
    output reg [31:0] z_scale,
    output reg [31:0] k_scale,
	 output reg [1:0] modeout_Mux,
	 output reg operationout_Mux,
	 output reg NatLogFlagout_Mux = 1'b0,
	 output reg converge,
	 output reg stall = 1'b0,
	 output reg [7:0] InsTagMuxOut,
	 output reg [7:0] InsTagScaleOut,
	 output reg NatLogFlagScaleOut,
	 output reg ScaleValid = 1'b0
    );

reg [7:0] exponent, exponentbar;
	 
parameter rotation  = 1'b1, 
			 vectoring = 1'b0;
			 
parameter mode_circular    = 2'b01, 
			 mode_linear      = 2'b00, 
			 mode_hyperbolic  = 2'b11;
			 
always @ (*)
begin
	case (operation_iter)
	  rotation : exponent <= 8'b01111111 - z_iter[30:23];
	  vectoring : exponent <= y_iter[30:23] - x_iter[30:23];
	  default : exponent <= y_iter[30:23] - x_iter[30:23];
	endcase	
	exponentbar <= ~exponent + 8'b00000001 ;//Change Ankit
end

always @ ( posedge clock)
begin
	
	if (reset == 1'b1) begin
		stall <= 1'b0;
		ScaleValid <= 1'b0;
		NatLogFlagout_Mux <= 1'b0;
	end
	
	else begin
	if((ALU_done == 1'b1))
	begin
	    if (!((operation_iter==rotation && mode_iter !=mode_linear && z_iter[30:23] <= 8'b00000000)||(operation_iter==vectoring && ((exponentbar[7] == 1'b0 && exponentbar >= 8'b00001110 && ((mode_iter == 2'b11)|| (mode_iter==2'b01)))||(exponentbar[7] == 1'b0 && exponentbar >= 8'b00001111) || y_iter[30:23] == 8'b0))))
		//if (!((operation_iter==rotation && mode_iter !=mode_linear && z_iter[30:23] <= 8'b00000000)||(operation_iter==vectoring && ((exponentbar[7] == 1'b0 && exponentbar >= 8'b00001111) || y_iter[30:23] == 8'b0))))        // Change Ankit - 31-March
		//if (!((operation_iter==rotation && mode_iter !=mode_linear && z_iter[30:23] <= 8'b00000000)||(operation_iter==vectoring && exponentbar[7] == 1'b0 && exponentbar >= 8'b00001111)))
		begin
			x_out <= x_iter;
			y_out <= y_iter;
			z_out <= z_iter;
			k_out <= k_iter;
			stall <= 1'b1;
			modeout_Mux <= mode_iter;
			operationout_Mux <= operation_iter;
			InsTagMuxOut <= InsTag_iter;
			ScaleValid <= 1'b0;
			NatLogFlagout_Mux <= NatLogFlag_iter;
		end
		else
		begin
			x_scale <= x_iter;
			y_scale <= y_iter;
			z_scale <= z_iter;
			k_scale <= k_iter;
			InsTagScaleOut <= InsTag_iter;
			ScaleValid <= 1'b1;
			converge <= 1'b1;
			stall <= 1'b0;
			NatLogFlagScaleOut <= NatLogFlag;
			
			x_out <= x_in;
			y_out <= y_in;
			z_out <= z_in;
			k_out <= 32'h3f800000;
			modeout_Mux <= mode_in;
			operationout_Mux <= operation_in;
			InsTagMuxOut <= InsTagFetchOut;
			NatLogFlagout_Mux <= NatLogFlag;
		end
	end
	
	else if ((load == 1'b1))
	begin
		x_out <= x_in;
		y_out <= y_in;
		z_out <= z_in;
		k_out <= 32'h3f800000;
		modeout_Mux <= mode_in;
		operationout_Mux <= operation_in;
		InsTagMuxOut <= InsTagFetchOut;
		ScaleValid <= 1'b0;
		NatLogFlagout_Mux <= NatLogFlag;
	end
	
	end
		
end

endmodule
