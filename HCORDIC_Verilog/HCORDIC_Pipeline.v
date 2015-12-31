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
module HCORDIC_Pipeline(
    input [15:0] InstructionPacket,
    input clock,
    output [31:0] x_out,
    output [31:0] y_out,
    output [31:0] z_out,
	 output done
    );

wire stall,load,ALU_done,converge;
wire operation_Fetch,operation_iter,operation_FSM,operation_Execute;
wire [1:0] mode_Fetch,mode_iter,mode_FSM,mode_Execute;	
wire [31:0] x_input, x_iter, xout_Mux, x_scale, xout_FSM;
wire [31:0] y_input, y_iter, yout_Mux, y_scale, yout_FSM;
wire [31:0] z_input, z_iter, zout_Mux, z_scale, zout_FSM;
wire [31:0] k_iter, kout_Mux, k_scale, kout_FSM;
wire [31:0] thetaout_FSM;
wire [31:0] deltaout_FSM;
wire [31:0] kappaout_FSM;
 
Fetch v0 (
    .InstructionPacket(InstructionPacket), 
    .clock(clock), 
	 .stall(stall),
    .x_input(x_input), 
    .y_input(y_input), 
    .z_input(z_input), 
    .mode(mode_Fetch), 
    .operation(operation_Fetch), 
    .load(load)
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
    .clock(clock), 
    .mode_in(mode_Fetch), 
    .operation_in(operation_Fetch),
	 .mode_iter(mode_iter),
	 .operation_iter(operation_iter),
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
    .converge(converge),
	 .stall(stall)
    );

FSM v3 (
    .x_FSM(xout_Mux), 
    .y_FSM(yout_Mux), 
    .z_FSM(zout_Mux), 
    .k_FSM(kout_Mux), 
    .clock(clock), 
    .mode_FSM(mode_FSM), 
    .operation_FSM(operation_FSM), 
    .modeout_FSM(mode_Execute), 
    .operationout_FSM(operation_Execute), 
    .xout_FSM(xout_FSM), 
    .yout_FSM(yout_FSM), 
    .zout_FSM(zout_FSM), 
    .kout_FSM(kout_FSM), 
    .thetaout_FSM(thetaout_FSM), 
    .deltaout_FSM(deltaout_FSM), 
    .kappaout_FSM(kappaout_FSM)
    );

ExecutePipeline v4 (
    .X_in(xout_FSM), 
    .Y_in(yout_FSM), 
    .Z_in(zout_FSM), 
    .K_in(kout_FSM), 
    .kappa_in(kappaout_FSM), 
    .theta_in(thetaout_FSM), 
    .delta_in(deltaout_FSM), 
    .clock(clock), 
    .operation(operation_Execute), 
    .mode(mode_Execute), 
    .X_next(x_iter), 
    .Y_next(y_iter), 
    .Z_next(z_iter), 
    .K_next(k_iter), 
    .mode_out(mode_iter), 
    .operation_out(operation_iter), 
    .ALU_done(ALU_done)
    );

Descale_pipeline v5 (
    .x_scale(x_scale), 
    .y_scale(y_scale), 
    .z_scale(z_scale), 
    .k_in(k_scale), 
    .clock(clock), 
    .x_out(x_out), 
    .y_out(y_out), 
    .z_out(z_out), 
    .done(done)
    );

endmodule
