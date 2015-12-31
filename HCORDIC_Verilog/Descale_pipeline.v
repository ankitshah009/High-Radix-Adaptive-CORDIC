`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:04:44 02/23/2015 
// Design Name: 
// Module Name:    Descale_pipeline 
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
module Descale_pipeline(
    input [31:0] x_scale,
    input [31:0] y_scale,
    input [31:0] z_scale,
    input [31:0] k_in,
	 input [7:0] InsTagScaleOut,
	 input ScaleValid,
	 input NatLogFlagScaleOut,
	 input reset,
    input clock,
    output [31:0] x_out,
    output [31:0] y_out,
    output [31:0] z_out,
	 output done,
	 output [7:0] InsTagFinal
    );
	 
wire doneSpare;
wire [7:0] InsTagFinalSpare;
wire [31:0] z_outSpare;

mult_descale_pipeline DescalePipe_x (
    .a_multiplicand(x_scale), 
    .b_multiplier(k_in), 
    .z_scale(z_scale), 
    .InsTagScaleOut(InsTagScaleOut),
    .ScaleValid(ScaleValid),
	 .NatLogFlagScaleOut(NatLogFlagScaleOut),
	 .reset(reset),
    .clock(clock), 
    .FinalProduct(x_out),
	 .done(done),
    .InsTagDescale(InsTagFinal),
    .z_out(z_out)
    );
	 
mult_descale_pipeline DescalePipe_y (
    .a_multiplicand(y_scale), 
    .b_multiplier(k_in),
    .z_scale(z_scale), 
    .InsTagScaleOut(InsTagScaleOut),	 
    .ScaleValid(ScaleValid),
	 .NatLogFlagScaleOut(NatLogFlagScaleOut),
	 .reset(reset),
    .clock(clock), 
    .FinalProduct(y_out),
	 .done(doneSpare),
    .InsTagDescale(InsTagFinalSpare),
    .z_out(z_outSpare)
    );

endmodule
