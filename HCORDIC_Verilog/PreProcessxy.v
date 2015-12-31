`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:44 03/13/2015 
// Design Name: 
// Module Name:    PreProcessxy 
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
module PreProcessxy(
    input [107:0] InstructionPacket,				// Unprocessed square root is given an opcode that is not defined in fetch.
    input clock,
    output [107:0] InstructionPacketOut,
	 output InputReady
    );

wire [3:0] Opcode;
wire [31:0] x_processor;
wire [31:0] y_processor;
wire [31:0] z_processor;
wire [7:0] InsTagIn;

wire [31:0] x_new, y_new, z_newX, z_newY;
wire [3:0] OpcodeX, OpcodeY;
wire DoneX, DoneY;
wire [7:0] InsX,InsY;

assign InsTagIn = InstructionPacket[107:100];
assign Opcode = InstructionPacket[99:96];
assign x_processor = InstructionPacket[31:0];
assign y_processor = InstructionPacket[63:32];
assign z_processor = InstructionPacket[95:64];

assign InstructionPacketOut[31:0] = x_new;
assign InstructionPacketOut[63:32] = y_new;

assign InputReady = DoneX && DoneY;
assign InstructionPacketOut[95:64] = z_newX;
assign InstructionPacketOut[99:96] = OpcodeX;
assign InstructionPacketOut[107:100] = InsX;

PreProcessX X (
    .z_preprocess(z_processor), 
    .Opcode(Opcode), 
    .b_adder(x_processor),
    .InsTagIn(InsTagIn), 	 
    .clock(clock), 
    .FinalSum(x_new), 
    .Done(DoneX), 
    .z_postprocess(z_newX), 
    .Opcode_out(OpcodeX),
    .InsTagOut(InsX)
    );
	 
PreProcessY Y (
    .z_preprocess(z_processor), 
    .Opcode(Opcode), 
    .b_adder(y_processor), 
    .InsTagIn(InsTagIn), 	
    .clock(clock), 
    .FinalSum(y_new), 
    .Done(DoneY), 
    .z_postprocess(z_newY), 
    .Opcode_out(OpcodeY),
    .InsTagOut(InsY)
    );



endmodule
