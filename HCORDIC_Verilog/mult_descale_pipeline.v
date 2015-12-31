`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:56 02/23/2015 
// Design Name: 
// Module Name:    mult_descale_pipeline 
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
module mult_descale_pipeline(
    input [31:0] a_multiplicand,
    input [31:0] b_multiplier,
	 input [31:0] z_scale,
	 input [7:0] InsTagScaleOut,
	 input ScaleValid,
	 input NatLogFlagScaleOut,
	 input reset,
    input clock,
    output [31:0] FinalProduct,
	 output done,
	 output [7:0] InsTagDescale,
	 output [31:0] z_out
    );

wire idle_Special, idle_Multiply, idle_NormaliseProd;
wire [32:0] aout_Special,bout_Special;
wire [32:0] zout_Special,zout_Multiply,zout_NormaliseProd;
wire [49:0] productout_Multiply, productout_NormaliseProd;
wire [7:0] InsTagSpecial,InsTagMultiply,InsTagNormaliseProd;
wire ScaleValidSpecial,ScaleValidMultiply,ScaleValidNormaliseProd;
wire [31:0] z_Special,z_Multiply,z_NormaliseProd;

SpecialMultDescale Mult1 (
    .ain_Special(a_multiplicand), 
    .bin_Special(b_multiplier),
    .InsTagScaleOut(InsTagScaleOut), 
    .ScaleValid(ScaleValid),	
	 .NatLogFlagScaleOut(NatLogFlagScaleOut),
    .z_scale(z_scale), 	
	 .reset(reset),
    .clock(clock), 
    .idle_Special(idle_Special), 
    .aout_Special(aout_Special), 
    .bout_Special(bout_Special), 
    .zout_Special(zout_Special),
    .InsTagSpecial(InsTagSpecial),
    .ScaleValidSpecial(ScaleValidSpecial),
    .z_Special(z_Special)
    );

MultiplyMultDescale Mult2 (
    .aout_Special(aout_Special), 
    .bout_Special(bout_Special), 
    .zout_Special(zout_Special), 
    .idle_Special(idle_Special), 
    .InsTagSpecial(InsTagSpecial),
    .ScaleValidSpecial(ScaleValidSpecial),	
    .z_Special(z_Special),	 
    .clock(clock), 
    .idle_Multiply(idle_Multiply), 
    .zout_Multiply(zout_Multiply), 
    .productout_Multiply(productout_Multiply),
    .InsTagMultiply(InsTagMultiply),
    .ScaleValidMultiply(ScaleValidMultiply),
    .z_Multiply(z_Multiply)
    );

NormaliseProdMultDescale Mult3 (
    .zout_Multiply(zout_Multiply), 
    .productout_Multiply(productout_Multiply), 
    .InsTagMultiply(InsTagMultiply),
    .ScaleValidMultiply(ScaleValidMultiply),
    .z_Multiply(z_Multiply),
    .clock(clock), 
    .idle_Multiply(idle_Multiply), 
    .idle_NormaliseProd(idle_NormaliseProd), 
    .zout_NormaliseProd(zout_NormaliseProd), 
    .productout_NormaliseProd(productout_NormaliseProd),
    .InsTagNormaliseProd(InsTagNormaliseProd),
    .ScaleValidNormaliseProd(ScaleValidNormaliseProd),
    .z_NormaliseProd(z_NormaliseProd)
    );
	 
Pack_z_descale Mult4 (
    .idle_NormaliseProd(idle_NormaliseProd), 
    .zout_NormaliseProd(zout_NormaliseProd), 
    .productout_NormaliseProd(productout_NormaliseProd), 
    .InsTagNormaliseProd(InsTagNormaliseProd),
    .ScaleValidNormaliseProd(ScaleValidNormaliseProd),
    .z_NormaliseProd(z_NormaliseProd),
	 .reset(reset),
    .clock(clock), 
    .done(done), 
    .FinalProduct(FinalProduct),
    .InsTagPack(InsTagDescale),
    .z_Descale(z_out)
    );



endmodule
