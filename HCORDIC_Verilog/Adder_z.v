`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:11 02/22/2015 
// Design Name: 
// Module Name:    Adder_z 
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
module Adder_z(
    input [31:0] a_adder,
    input [31:0] b_adder,
	 input reset,
    input clock,
    output [31:0] FinalSum
    );

wire idle_Special,idle_Allign,idle_AddState,idle_NormaliseSum;
wire [31:0] sout_Special,sout_Allign,sout_AddState,sout_NormaliseSum;
wire [35:0] cout_Special,cout_Allign;
wire [35:0] zout_Special,zout_Allign;
wire [7:0] difference_Special;
wire [27:0] sum_AddState,sum_NormaliseSum;
wire [31:0] FinalSum_Idle1,FinalSum_Idle2,FinalSum_Idle3;

SpecialAdd Add1 (
    .cin_Special(a_adder), 
    .zin_Special(b_adder),
	 .reset(reset),
    .clock(clock), 
    .idle_Special(idle_Special), 
    .difference_Special(difference_Special), 
    .cout_Special(cout_Special), 
    .zout_Special(zout_Special), 
    .sout_Special(sout_Special)
    );

AllignAdder Add2 (
    .idle_Special(idle_Special), 
    .cout_Special(cout_Special), 
    .zout_Special(zout_Special), 
    .sout_Special(sout_Special), 
    .difference_Special(difference_Special), 
    .clock(clock), 
    .idle_Allign(idle_Allign), 
    .cout_Allign(cout_Allign), 
    .zout_Allign(zout_Allign), 
    .sout_Allign(sout_Allign)
    );

Add Add3 (
    .idle_Allign(idle_Allign), 
    .cout_Allign(cout_Allign), 
    .zout_Allign(zout_Allign), 
    .sout_Allign(sout_Allign), 
    .clock(clock), 
    .idle_AddState(idle_AddState), 
    .sout_AddState(sout_AddState), 
    .sum_AddState(sum_AddState)
    );

NormaliseAdder Add4 (
    .idle_AddState(idle_AddState), 
    .sout_AddState(sout_AddState), 
    .sum_AddState(sum_AddState), 
    .clock(clock), 
    .idle_NormaliseSum(idle_NormaliseSum), 
    .sout_NormaliseSum(sout_NormaliseSum), 
    .sum_NormaliseSum(sum_NormaliseSum)
    );
	 
PackAdder Add5 (
    .idle_NormaliseSum(idle_NormaliseSum), 
    .sout_NormaliseSum(sout_NormaliseSum), 
    .sum_NormaliseSum(sum_NormaliseSum), 
    .clock(clock), 
    .sout_PackSum(FinalSum_Idle1)
    );	
	 
IdleMult Add6 (
    .FinalProduct(FinalSum_Idle1), 
    .clock(clock), 
    .FinalProductout(FinalSum_Idle2)
    );

IdleMult Add7 (
    .FinalProduct(FinalSum_Idle2), 
    .clock(clock), 
    .FinalProductout(FinalSum_Idle3)
    );

IdleMult Add8 (
    .FinalProduct(FinalSum_Idle3), 
    .clock(clock), 
    .FinalProductout(FinalSum)
    );
	 
endmodule
