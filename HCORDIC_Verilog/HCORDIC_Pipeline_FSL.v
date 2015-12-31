`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:51 02/23/2015 
// Design Name: 
// Module Name:    HCORDIC_Pipeline 
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
module HCORDIC_Pipeline_FSL(
    input [107:0] InstructionPacket,
	 input reset,
    input clock,
	 output [103:0] InstructionPacketOut,
	 output InstructionAck,
	 output OutputReady
    );

wire stall,load,ALU_done,converge;
wire operation_Fetch,operation_iter,operation_FSM,operation_Execute;
wire [107:0] InstructionPacket_Processed;
wire [7:0] InsTagFetchOut,InsTagMuxOut,InsTagFSMOut,InsTag_iter,InsTagScaleOut,InsTagFinal;
wire [1:0] mode_Fetch,mode_iter,mode_FSM,mode_Execute;	
wire [31:0] x_input, x_iter, xout_Mux, x_scale, xout_FSM;
wire [31:0] y_input, y_iter, yout_Mux, y_scale, yout_FSM;
wire [31:0] z_input, z_iter, zout_Mux, z_scale, zout_FSM;
wire [31:0] k_iter, kout_Mux, k_scale, kout_FSM;
wire [31:0] thetaout_FSM;
wire [31:0] deltaout_FSM;
wire [31:0] kappaout_FSM;
wire ScaleValid;
wire ProcessInputReady;
wire [31:0] x_out, y_out, z_out;
wire NatLogFlag, NatLogFlag_iter, NatLogFlagout_Mux, NatLogFlagScaleOut, NatLogFlag_Execute;

assign InstructionAck = stall;
assign InstructionPacketOut[31:0] = x_out;
assign InstructionPacketOut[63:32] = y_out;
assign InstructionPacketOut[95:64] = z_out;
assign InstructionPacketOut[103:96] = InsTagFinal;

Fetch_FSL v0 (
    .InstructionPacket(InstructionPacket), 
    .InstructionPacket_Processed(InstructionPacket_Processed), 
    .ProcessInputReady(ProcessInputReady), 
	 .reset(reset),
    .clock(clock), 
	 .stall(stall),
    .x_input(x_input), 
    .y_input(y_input), 
    .z_input(z_input), 
    .mode(mode_Fetch), 
    .operation(operation_Fetch),
    .InsTagFetchOut(InsTagFetchOut),	 
    .load(load),
	 .NatLogFlag(NatLogFlag)
    );
	 
PreProcessxy v6 (
    .InstructionPacket(InstructionPacket), 
    .clock(clock), 
    .InstructionPacketOut(InstructionPacket_Processed), 
    .InputReady(ProcessInputReady)
    );
	 
InputMux v1 (
    .x_in(x_input), 
    .y_in(y_input), 
    .z_in(z_input), 
    .x_iter(x_iter), 
    .y_iter(y_iter), 
    .z_iter(z_iter), 
    .k_iter(k_iter), 
    .load(load), 
    .ALU_done(ALU_done),
	 .reset(reset),
    .clock(clock), 
    .mode_in(mode_Fetch), 
    .operation_in(operation_Fetch),
	 .NatLogFlag(NatLogFlag), 
	 .mode_iter(mode_iter),
	 .operation_iter(operation_iter),
    .NatLogFlag_iter(NatLogFlag_iter), 
    .InsTagFetchOut(InsTagFetchOut), 
    .InsTag_iter(InsTag_iter), 
    .x_out(xout_Mux), 
    .y_out(yout_Mux), 
    .z_out(zout_Mux), 
    .k_out(kout_Mux), 
    .x_scale(x_scale), 
    .y_scale(y_scale), 
    .z_scale(z_scale), 
    .k_scale(k_scale),
	 .modeout_Mux(mode_FSM),
	 .operationout_Mux(operation_FSM),
    .NatLogFlagout_Mux(NatLogFlagout_Mux), 
    .converge(converge),
	 .stall(stall),
    .InsTagMuxOut(InsTagMuxOut),
    .InsTagScaleOut(InsTagScaleOut),
    .NatLogFlagScaleOut(NatLogFlagScaleOut), 
    .ScaleValid(ScaleValid)
    );

FSM v3 (
    .x_FSM(xout_Mux), 
    .y_FSM(yout_Mux), 
    .z_FSM(zout_Mux), 
    .k_FSM(kout_Mux), 
	 .reset(reset),
    .clock(clock), 
    .mode_FSM(mode_FSM), 
    .operation_FSM(operation_FSM), 
    .NatLogFlagout_Mux(NatLogFlagout_Mux), 
    .InsTagMuxOut(InsTagMuxOut), 
    .modeout_FSM(mode_Execute), 
    .operationout_FSM(operation_Execute), 
    .NatLogFlagout_FSM(NatLogFlag_Execute), 
    .xout_FSM(xout_FSM), 
    .yout_FSM(yout_FSM), 
    .zout_FSM(zout_FSM), 
    .kout_FSM(kout_FSM), 
    .thetaout_FSM(thetaout_FSM), 
    .deltaout_FSM(deltaout_FSM), 
    .kappaout_FSM(kappaout_FSM),
    .InsTagFSMOut(InsTagFSMOut)
    );

ExecutePipeline v4 (
    .X_in(xout_FSM), 
    .Y_in(yout_FSM), 
    .Z_in(zout_FSM), 
    .K_in(kout_FSM), 
    .kappa_in(kappaout_FSM), 
    .theta_in(thetaout_FSM), 
    .delta_in(deltaout_FSM), 
	 .reset(reset),
    .clock(clock), 
    .operation(operation_Execute),
    .NatLogFlag_Execute(NatLogFlag_Execute), 	 
    .mode(mode_Execute), 
    .InsTagFSMOut(InsTagFSMOut),
    .X_next(x_iter), 
    .Y_next(y_iter), 
    .Z_next(z_iter), 
    .K_next(k_iter), 
    .mode_out(mode_iter), 
    .operation_out(operation_iter), 
    .NatLogFlag_iter(NatLogFlag_iter),
    .ALU_done(ALU_done),
    .InsTag_iter(InsTag_iter)
    );

Descale_pipeline v5 (
    .x_scale(x_scale), 
    .y_scale(y_scale), 
    .z_scale(z_scale), 
    .k_in(k_scale),
    .InsTagScaleOut(InsTagScaleOut), 
    .ScaleValid(ScaleValid), 	
    .NatLogFlagScaleOut(NatLogFlagScaleOut),
	 .reset(reset),
    .clock(clock), 
    .x_out(x_out), 
    .y_out(y_out), 
    .z_out(z_out), 
    .done(OutputReady),
    .InsTagFinal(InsTagFinal)
    );

endmodule
