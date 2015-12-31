`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:32:54 02/22/2015 
// Design Name: 
// Module Name:    ExecutePipeline 
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
module ExecutePipeline(
    input [31:0] X_in,
    input [31:0] Y_in,
    input [31:0] Z_in,
    input [31:0] K_in,
    input [31:0] kappa_in,
    input [31:0] theta_in,
    input [31:0] delta_in,
	 input reset,
    input clock,
	 input operation,
	 input NatLogFlag_Execute,
	 input [1:0] mode,
	 input [7:0] InsTagFSMOut,
    output [31:0] X_next,
    output [31:0] Y_next,
    output [31:0] Z_next,
    output [31:0] K_next,
	 output [1:0] mode_out,
	 output operation_out,
	 output NatLogFlag_iter,
	 output ALU_done,
	 output [7:0] InsTag_iter
    );

alu_x_pipelined alu_x (
    .a_multiplicand(Y_in), 
    .b_multiplier(delta_in), 
    .c_addition(X_in), 
    .mode(mode), 
    .operation(operation), 
	 .NatLogFlag_Execute(NatLogFlag_Execute),
    .InsTagFSMOut(InsTagFSMOut), 
	 .reset(reset),
    .clock(clock), 
    .accumulate(X_next), 
    .mode_out(mode_out), 
    .operation_out(operation_out),
	 .NatLogFlag_iter(NatLogFlag_iter),
    .InsTagXOut(InsTag_iter)
    );

alu_y_pipelined alu_y (
    .a_multiplicand(X_in), 
    .b_multiplier(delta_in), 
    .c_addition(Y_in), 
    .mode(mode), 
    .operation(operation),
	 .NatLogFlag_Execute(NatLogFlag_Execute),
    .InsTagFSMOut(InsTagFSMOut), 
	 .reset(reset),
    .clock(clock), 
    .accumulate(Y_next),
	 .done(ALU_done)
    );

mult_k mul_k (
    .a_multiplicand(K_in), 
    .b_multiplier(kappa_in), 
	 .reset(reset),
    .clock(clock), 
    .FinalProduct(K_next)
    );
	 
Adder_z add_z (
    .a_adder(Z_in), 
    .b_adder(theta_in), 
	 .reset(reset),
    .clock(clock), 
    .FinalSum(Z_next)
    );
endmodule
