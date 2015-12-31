`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:04:15 03/13/2015 
// Design Name: 
// Module Name:    PreProcessX 
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
module PreProcessY(
	input [31:0] z_preprocess,
	input [3:0] Opcode,
	input [31:0] b_adder,
	input [7:0] InsTagIn,
	input clock,
	output [31:0] FinalSum,
	output Done,
	output [31:0] z_postprocess,
	output [3:0] Opcode_out,
	output [7:0] InsTagOut
    );

reg [31:0] a_adder_reg = 32'hbf800000;
wire [31:0] a_adder;

assign a_adder = a_adder_reg;

wire idle_Special,idle_Allign,idle_AddState,idle_NormaliseSum;
wire [3:0] Opcode_Special,Opcode_Allign,Opcode_AddState,Opcode_NormaliseSum;
wire [31:0] z_postSpecial,z_postAllign,z_postAddState,z_postNormaliseSum;
wire [31:0] sout_Special,sout_Allign,sout_AddState,sout_NormaliseSum;
wire [35:0] cout_Special,cout_Allign;
wire [35:0] zout_Special,zout_Allign;
wire [7:0] difference_Special;
wire [27:0] sum_AddState,sum_NormaliseSum;
wire [31:0] FinalSum_Idle1,FinalSum_Idle2,FinalSum_Idle3;
wire [7:0] InsTagSpecial,InsTagAllign,InsTagAdder,InsTagNormaliseAdder;

SpecialAddProcess Add1 (
    .z_preSpecial(z_preprocess), 
    .Opcode(Opcode), 
    .cin_Special(a_adder), 
    .zin_Special(b_adder),
    .InsTagIn(InsTagIn), 	 
    .clock(clock), 
    .idle_Special(idle_Special), 
    .difference_Special(difference_Special), 
    .cout_Special(cout_Special), 
    .zout_Special(zout_Special), 
    .sout_Special(sout_Special),
    .Opcode_Special(Opcode_Special),
    .z_postSpecial(z_postSpecial),
    .InsTagSpecial(InsTagSpecial)
    );

AllignAdderProcess Add2 (
    .z_postSpecial(z_postSpecial),
    .Opcode_Special(Opcode_Special), 
    .idle_Special(idle_Special), 
    .cout_Special(cout_Special), 
    .zout_Special(zout_Special), 
    .sout_Special(sout_Special), 
    .difference_Special(difference_Special),
    .InsTagSpecial(InsTagSpecial), 	 
    .clock(clock), 
    .idle_Allign(idle_Allign), 
    .cout_Allign(cout_Allign), 
    .zout_Allign(zout_Allign), 
    .sout_Allign(sout_Allign),
    .Opcode_Allign(Opcode_Allign),
    .z_postAllign(z_postAllign),
    .InsTagAllign(InsTagAllign)
    );

AddProcess Add3 (
    .z_postAllign(z_postAllign), 
    .Opcode_Allign(Opcode_Allign),
    .idle_Allign(idle_Allign), 
    .cout_Allign(cout_Allign), 
    .zout_Allign(zout_Allign), 
    .sout_Allign(sout_Allign),
    .InsTagAllign(InsTagAllign),	 
    .clock(clock), 
    .idle_AddState(idle_AddState), 
    .sout_AddState(sout_AddState), 
    .sum_AddState(sum_AddState),
    .Opcode_AddState(Opcode_AddState),
    .z_postAddState(z_postAddState),
    .InsTagAdder(InsTagAdder)
    );

NormaliseAdderProcess Add4 (
    .z_postAddState(z_postAddState), 
    .Opcode_AddState(Opcode_AddState), 
    .idle_AddState(idle_AddState), 
    .sout_AddState(sout_AddState), 
    .sum_AddState(sum_AddState),
    .InsTagAdder(InsTagAdder), 	 
    .clock(clock), 
    .idle_NormaliseSum(idle_NormaliseSum), 
    .sout_NormaliseSum(sout_NormaliseSum), 
    .sum_NormaliseSum(sum_NormaliseSum),
    .Opcode_NormaliseSum(Opcode_NormaliseSum),
    .z_postNormaliseSum(z_postNormaliseSum),
    .InsTagNormaliseAdder(InsTagNormaliseAdder)
    );
	 
PackAdderProcess Add5 (
    .z_postNormaliseSum(z_postNormaliseSum), 
    .Opcode_NormaliseSum(Opcode_NormaliseSum), 
    .idle_NormaliseSum(idle_NormaliseSum), 
    .sout_NormaliseSum(sout_NormaliseSum), 
    .sum_NormaliseSum(sum_NormaliseSum), 
    .InsTagNormaliseAdder(InsTagNormaliseAdder), 
    .clock(clock), 
    .sout_PackSum(FinalSum),
    .Done(Done),
    .z_postPack(z_postprocess), 
    .Opcode_Pack(Opcode_out),
    .InsTagPack(InsTagOut)
    );	

endmodule