`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:32:44 02/22/2015 
// Design Name: 
// Module Name:    FSM 
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
module FSM(
	input [31:0] x_FSM,
	input [31:0] y_FSM,
	input [31:0] z_FSM,
	input [31:0] k_FSM,
	input reset,
	input clock,
	input [1:0] mode_FSM,
	input operation_FSM,
	input NatLogFlagout_Mux,
	input [7:0] InsTagMuxOut,
	output [1:0] modeout_FSM,
	output operationout_FSM,
	output NatLogFlagout_FSM,
	output [31:0] xout_FSM,
	output [31:0] yout_FSM,
	output [31:0] zout_FSM,
	output [31:0] kout_FSM,
	output [31:0] thetaout_FSM,
	output [31:0] deltaout_FSM,
	output [31:0] kappaout_FSM,
	output [7:0] InsTagFSMOut
    );

wire [7:0] InsTagFSM1Out;
wire [1:0] enable_LUT;
wire [7:0] address;
wire [3:0] state_FSM2;
wire [1:0] mode_FSM1;
wire operation_FSM1;
wire [31:0] x_FSM1,y_FSM1,z_FSM1,k_FSM1,theta_FSM1,kappa_FSM1,delta_FSM1;
wire NatLogFlagout_FSM1;

FSM_1 FSM1 (
    .x(x_FSM), 
    .y(y_FSM), 
    .z(z_FSM), 
    .k(k_FSM), 
    .mode(mode_FSM), 
    .operation(operation_FSM), 
	 .NatLogFlagout_Mux(NatLogFlagout_Mux),
	 .reset(reset),
    .clock(clock), 
    .InsTagMuxOut(InsTagMuxOut), 
    .enable_LUT(enable_LUT), 
    .address(address), 
    .state_FSM2(state_FSM2), 
    .x_FSM1(x_FSM1), 
    .y_FSM1(y_FSM1), 
    .z_FSM1(z_FSM1), 
    .k_FSM1(k_FSM1), 
    .theta_FSM1(theta_FSM1), 
    .kappa_FSM1(kappa_FSM1), 
    .delta_FSM1(delta_FSM1), 
    .mode_FSM1(mode_FSM1), 
    .operation_FSM1(operation_FSM1),
	 .NatLogFlagout_FSM1(NatLogFlagout_FSM1),
    .InsTagFSM1Out(InsTagFSM1Out)
    );

FSM_2 FSM2 (
    .x_FSM1(x_FSM1), 
    .y_FSM1(y_FSM1), 
    .z_FSM1(z_FSM1), 
    .k_FSM1(k_FSM1), 
    .theta_FSM1(theta_FSM1), 
    .kappa_FSM1(kappa_FSM1), 
    .delta_FSM1(delta_FSM1), 
    .mode_FSM1(mode_FSM1), 
    .operation_FSM1(operation_FSM1), 
	 .NatLogFlagout_FSM1(NatLogFlagout_FSM1),
	 .reset(reset),
    .clock(clock), 
    .enable_LUT(enable_LUT), 
    .address(address), 
    .state_FSM2(state_FSM2),
    .InsTagFSM1Out(InsTagFSM1Out), 	 
    .x_FSM2(xout_FSM), 
    .y_FSM2(yout_FSM), 
    .z_FSM2(zout_FSM), 
    .k_FSM2(kout_FSM), 
    .theta_FSM2(thetaout_FSM), 
    .kappa_FSM2(kappaout_FSM), 
    .delta_FSM2(deltaout_FSM), 
    .mode_FSM2(modeout_FSM), 
    .operation_FSM2(operationout_FSM),
	 .NatLogFlagout_FSM(NatLogFlagout_FSM),
    .InsTagFSMOut(InsTagFSMOut)
    );
	
endmodule
