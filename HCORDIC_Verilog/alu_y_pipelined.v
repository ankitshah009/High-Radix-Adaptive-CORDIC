`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:24:17 02/22/2015 
// Design Name: 
// Module Name:    alu_y_pipelined 
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
module alu_y_pipelined(
    input [31:0] a_multiplicand,
    input [31:0] b_multiplier,
    input [31:0] c_addition,
    input [1:0] mode,
	 input operation,
	 input NatLogFlag_Execute,
	 input [7:0] InsTagFSMOut,
	 input reset,
    input clock,
    output [31:0] accumulate,
	 output done
    );

wire [1:0] idle_Special,idle_Multiply,idle_NormaliseProd,idle_Allign,idle_Allign2,idle_AddState,idle_NormaliseSum;
wire [32:0] aout_Special,bout_Special;
wire [31:0] sout_Special,sout_Multiply,sout_NormaliseProd,sout_Allign,sout_Allign2,sout_AddState,sout_NormaliseSum;
wire [35:0] cout_Special,cout_Multiply,cout_NormaliseProd,cout_Allign,cout_Allign2;
wire [35:0] zout_Special,zout_Multiply,zout_NormaliseProd,zout_Allign,zout_Allign2;
wire [1:0] modeout_Special,modeout_Multiply, modeout_NormaliseProd,modeout_Allign,modeout_Allign2,modeout_AddState,modeout_NormaliseSum,modeout_PackSum; 
wire operationout_Special,operationout_Multiply, operationout_NormaliseProd,operationout_Allign,operationout_Allign2,operationout_AddState,operationout_NormaliseSum,operationout_PackSum; 
wire [49:0]  productout_Multiply, productout_NormaliseProd;
wire [7:0] difference_Allign;
wire [27:0] sum_AddState,sum_NormaliseSum;
wire [7:0] InsTag_Special,InsTag_Multiply,InsTag_NormaliseProd,InsTag_Allign,InsTag_Allign2,InsTag_AddState,InsTag_NormaliseSum,InsTagYOut;
wire NatLogFlag_Special,NatLogFlagout_Special,NatLogFlagout_Multiply,NatLogFlagout_NormaliseProd,NatLogFlagout_Allign,NatLogFlagout_Allign2,NatLogFlagout_AddState,NatLogFlagout_NormaliseSum;

SpecialCases ALU_Y1 (
    .ain_Special(a_multiplicand), 
    .bin_Special(b_multiplier), 
    .cin_Special(c_addition), 
    .mode_Special(mode), 
    .operation_Special(operation),
	 .NatLogFlag_Special(NatLogFlag_Special),	 
    .InsTagFSMOut(InsTagFSMOut), 
	 .reset(reset),
    .clock(clock), 
    .idle_Special(idle_Special), 
    .aout_Special(aout_Special), 
    .bout_Special(bout_Special), 
    .cout_Special(cout_Special), 
    .zout_Special(zout_Special), 
    .sout_Special(sout_Special), 
    .modeout_Special(modeout_Special), 
    .operationout_Special(operationout_Special),
	 .NatLogFlagout_Special(NatLogFlagout_Special),
    .InsTag_Special(InsTag_Special)
    );

MultiplyState_Y ALU_Y2 (
    .aout_Special(aout_Special), 
    .bout_Special(bout_Special), 
    .cout_Special(cout_Special), 
    .zout_Special(zout_Special), 
    .sout_Special(sout_Special), 
    .modeout_Special(modeout_Special), 
    .operationout_Special(operationout_Special), 
	 .NatLogFlagout_Special(NatLogFlagout_Special),
    .InsTag_Special(InsTag_Special), 
    .clock(clock), 
    .idle_Special(idle_Special), 
    .idle_Multiply(idle_Multiply), 
    .cout_Multiply(cout_Multiply), 
    .zout_Multiply(zout_Multiply), 
    .sout_Multiply(sout_Multiply), 
    .modeout_Multiply(modeout_Multiply), 
    .operationout_Multiply(operationout_Multiply), 
	 .NatLogFlagout_Multiply(NatLogFlagout_Multiply),
    .productout_Multiply(productout_Multiply),
    .InsTag_Multiply(InsTag_Multiply)
    );

NormaliseProd ALU_Y3 (
    .cout_Multiply(cout_Multiply), 
    .zout_Multiply(zout_Multiply), 
    .sout_Multiply(sout_Multiply), 
    .productout_Multiply(productout_Multiply), 
    .modeout_Multiply(modeout_Multiply), 
    .operationout_Multiply(operationout_Multiply),
	 .NatLogFlagout_Multiply(NatLogFlagout_Multiply),	 
    .InsTag_Multiply(InsTag_Multiply),
    .clock(clock), 
    .idle_Multiply(idle_Multiply),
    .idle_NormaliseProd(idle_NormaliseProd), 
    .cout_NormaliseProd(cout_NormaliseProd), 
    .zout_NormaliseProd(zout_NormaliseProd), 
    .sout_NormaliseProd(sout_NormaliseProd), 
    .modeout_NormaliseProd(modeout_NormaliseProd), 
    .operationout_NormaliseProd(operationout_NormaliseProd), 
	 .NatLogFlagout_NormaliseProd(NatLogFlagout_NormaliseProd),
    .productout_NormaliseProd(productout_NormaliseProd),
    .InsTag_NormaliseProd(InsTag_NormaliseProd)
    );
	 
Allign ALU_Y4 (
    .idle_NormaliseProd(idle_NormaliseProd), 
    .cout_NormaliseProd(cout_NormaliseProd), 
    .zout_NormaliseProd(zout_NormaliseProd), 
    .sout_NormaliseProd(sout_NormaliseProd), 
    .modeout_NormaliseProd(modeout_NormaliseProd), 
    .operationout_NormaliseProd(operationout_NormaliseProd), 
	 .NatLogFlagout_NormaliseProd(NatLogFlagout_NormaliseProd),
    .productout_NormaliseProd(productout_NormaliseProd), 
    .InsTag_NormaliseProd(InsTag_NormaliseProd), 
    .clock(clock), 
    .idle_Allign(idle_Allign), 
    .cout_Allign(cout_Allign), 
    .zout_Allign(zout_Allign), 
    .sout_Allign(sout_Allign), 
    .modeout_Allign(modeout_Allign), 
    .operationout_Allign(operationout_Allign),
	 .NatLogFlagout_Allign(NatLogFlagout_Allign),	 
    .difference_Allign(difference_Allign),
    .InsTag_Allign(InsTag_Allign)
    );
	 
Allign2 ALU_Y5 (
    .idle_Allign(idle_Allign), 
    .cout_Allign(cout_Allign), 
    .zout_Allign(zout_Allign), 
    .sout_Allign(sout_Allign), 
    .modeout_Allign(modeout_Allign), 
    .operationout_Allign(operationout_Allign), 
	 .NatLogFlagout_Allign(NatLogFlagout_Allign),
    .difference_Allign(difference_Allign), 
    .InsTag_Allign(InsTag_Allign), 
    .clock(clock), 
    .idle_Allign2(idle_Allign2), 
    .cout_Allign2(cout_Allign2), 
    .zout_Allign2(zout_Allign2), 
    .sout_Allign2(sout_Allign2), 
    .modeout_Allign2(modeout_Allign2), 
    .operationout_Allign2(operationout_Allign2),
	 .NatLogFlagout_Allign2(NatLogFlagout_Allign2),
    .InsTag_Allign2(InsTag_Allign2)
    );

AddState ALU_Y6 (
    .idle_Allign2(idle_Allign2), 
    .cout_Allign2(cout_Allign2), 
    .zout_Allign2(zout_Allign2), 
    .sout_Allign2(sout_Allign2), 
    .modeout_Allign2(modeout_Allign2), 
    .operationout_Allign2(operationout_Allign2), 
	 .NatLogFlagout_Allign2(NatLogFlagout_Allign2),
    .InsTag_Allign2(InsTag_Allign2), 
    .clock(clock), 
    .idle_AddState(idle_AddState), 
    .sout_AddState(sout_AddState), 
    .modeout_AddState(modeout_AddState), 
    .operationout_AddState(operationout_AddState), 
	 .NatLogFlagout_AddState(NatLogFlagout_AddState),	 
    .sum_AddState(sum_AddState),
    .InsTag_AddState(InsTag_AddState)
    );
	 
NormaliseSum ALU_Y7 (
    .idle_AddState(idle_AddState), 
    .sout_AddState(sout_AddState), 
    .modeout_AddState(modeout_AddState), 
    .operationout_AddState(operationout_AddState), 
	 .NatLogFlagout_AddState(NatLogFlagout_AddState),
    .sum_AddState(sum_AddState), 
    .InsTag_AddState(InsTag_AddState),
    .clock(clock), 
    .idle_NormaliseSum(idle_NormaliseSum), 
    .sout_NormaliseSum(sout_NormaliseSum), 
    .modeout_NormaliseSum(modeout_NormaliseSum), 
    .operationout_NormaliseSum(operationout_NormaliseSum),
	 .NatLogFlagout_NormaliseSum(NatLogFlagout_NormaliseSum),
    .sum_NormaliseSum(sum_NormaliseSum),
    .InsTag_NormaliseSum(InsTag_NormaliseSum)
    );
	 
PackSum_y ALU_Y8 (
    .idle_NormaliseSum(idle_NormaliseSum), 
    .sout_NormaliseSum(sout_NormaliseSum), 
    .modeout_NormaliseSum(modeout_NormaliseSum), 
    .operationout_NormaliseSum(operationout_NormaliseSum), 	
    .sum_NormaliseSum(sum_NormaliseSum), 
    .InsTag_NormaliseSum(InsTag_NormaliseSum), 
    .clock(clock), 
    .sout_PackSum(accumulate),
	 .done(done)
    );

endmodule
