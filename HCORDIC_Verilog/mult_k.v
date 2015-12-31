`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:10 02/22/2015 
// Design Name: 
// Module Name:    mult_k 
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
module mult_k(
    input [31:0] a_multiplicand,
    input [31:0] b_multiplier,
	 input reset,
    input clock,
    output [31:0] FinalProduct
    );

wire idle_Special, idle_Multiply, idle_NormaliseProd;
wire [32:0] aout_Special,bout_Special;
wire [32:0] zout_Special,zout_Multiply,zout_NormaliseProd;
wire [49:0] productout_Multiply, productout_NormaliseProd;
wire [31:0] FinalProduct_Idle1,FinalProduct_Idle2,FinalProduct_Idle3,FinalProduct_Idle4;
 	 
SpecialMult Mult1 (
    .ain_Special(a_multiplicand), 
    .bin_Special(b_multiplier), 
	 .reset(reset),
    .clock(clock), 
    .idle_Special(idle_Special), 
    .aout_Special(aout_Special), 
    .bout_Special(bout_Special), 
    .zout_Special(zout_Special)
    );

MultiplyMult Mult2 (
    .aout_Special(aout_Special), 
    .bout_Special(bout_Special), 
    .zout_Special(zout_Special), 
    .idle_Special(idle_Special), 
    .clock(clock), 
    .idle_Multiply(idle_Multiply), 
    .zout_Multiply(zout_Multiply), 
    .productout_Multiply(productout_Multiply)
    );

NormaliseProdMult Mult3 (
    .zout_Multiply(zout_Multiply), 
    .productout_Multiply(productout_Multiply), 
    .clock(clock), 
    .idle_Multiply(idle_Multiply), 
    .idle_NormaliseProd(idle_NormaliseProd), 
    .zout_NormaliseProd(zout_NormaliseProd), 
    .productout_NormaliseProd(productout_NormaliseProd)
    );
	 
Pack_z Mult4 (
    .idle_NormaliseProd(idle_NormaliseProd), 
    .zout_NormaliseProd(zout_NormaliseProd), 
    .productout_NormaliseProd(productout_NormaliseProd), 
    .clock(clock), 
    .FinalProduct(FinalProduct_Idle1)
    );

IdleMult Mult5 (
    .FinalProduct(FinalProduct_Idle1), 
    .clock(clock), 
    .FinalProductout(FinalProduct_Idle2)
    );

IdleMult Mult6 (
    .FinalProduct(FinalProduct_Idle2), 
    .clock(clock), 
    .FinalProductout(FinalProduct_Idle3)
    );

IdleMult Mult7 (
    .FinalProduct(FinalProduct_Idle3), 
    .clock(clock), 
    .FinalProductout(FinalProduct_Idle4)
    );

IdleMult Mult8 (
    .FinalProduct(FinalProduct_Idle4), 
    .clock(clock), 
    .FinalProductout(FinalProduct)
    );

endmodule
