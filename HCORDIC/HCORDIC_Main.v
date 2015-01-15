`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:06:14 11/04/2014 
// Design Name: 
// Module Name:    HCORDIC-Main 
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
module HCORDIC_Main(
    input [31:0] x_input,
    input [31:0] y_input,
    input [31:0] z_input,
    input clock,
    input [1:0] mode,
    input operation,
    output [31:0] x_out,
    output [31:0] y_out,
    output [31:0] z_out,
	 output [31:0] k_out,
    input load,
    input next
    );

wire [31:0] k_input;

wire [31:0] x_iter;
wire [31:0] y_iter;
wire [31:0] z_iter;
wire [31:0] k_iter;

wire [31:0] x_FSM;
wire [31:0] y_FSM;
wire [31:0] z_FSM;
wire [31:0] k_FSM;

wire [31:0] theta_LUTRot;
wire [31:0] kappa_LUTRot;
wire [31:0] delta_LUTRot;
wire [7:0] address;

wire [31:0] theta_LUTVec;
wire [31:0] kappa_LUTVec;
wire [31:0] delta_LUTVec;

wire [31:0] theta_LUT;
wire [31:0] kappa_LUT;
wire [31:0] delta_LUT;

//wire [31:0] x_ALU;
//wire [31:0] y_ALU;
//wire [31:0] z_ALU;
//wire [31:0] k_ALU;

wire [31:0] theta_ALU;
wire [31:0] delta_ALU;
wire [31:0] kappa_ALU;

wire done_LUTRot;
wire done_LUTVec;

wire done_LUT;
wire enable_LUT;
wire done_FSM;
wire done_ALU;
wire converge;

/*InputMux u0 (x_input, y_input, z_input, k_input, x_iter, y_iter, z_iter, k_iter, next, 
				load, done_ALU, clock, x_FSM, y_FSM, z_FSM, k_FSM);*/
				
// Instantiate the module
InputMux InputMux (
    .x_in(x_input), 
    .y_in(y_input), 
    .z_in(z_input), 
    /*.k_in(k_input),*/ 
    .x_iter(x_iter), 
    .y_iter(y_iter), 
    .z_iter(z_iter), 
    .k_iter(k_iter), 
    .next(next), 
    .load(load), 
    .ALU_done(done_ALU), 
    .clock(clock), 
    .x_out(x_FSM), 
    .y_out(y_FSM), 
    .z_out(z_FSM), 
    .k_out(k_FSM)
    );


/*FSM u1 (x_FSM, y_FSM, z_FSM, k_FSM, kappa_LUTRot, theta_LUTRot, delta_LUTRot, theta_LUTVec, kappa_LUTVec, delta_LUTVec, theta_LUT, kappa_LUT, delta_LUT, mode, operation, 
		  clock, done_LUT, done_LUTVec, done_LUTRot, enable_LUT, address, theta_ALU, kappa_ALU, delta_ALU, done_FSM, converge, done_ALU  );*/
		  
		  // Instantiate the module
FSM FSM (
    .x(x_FSM), 
    .y(y_FSM), 
    .z(z_FSM), 
    .k(k_FSM), 
    .kappa_LUTRot(kappa_LUTRot), 
    .theta_LUTRot(theta_LUTRot), 
    .delta_LUTRot(delta_LUTRot), 
    .kappa_LUTVec(kappa_LUTVec), 
    .theta_LUTVec(theta_LUTVec), 
    .delta_LUTVec(delta_LUTVec), 
    .theta_LUT(theta_LUT), 
    .kappa_LUT(kappa_LUT), 
    .delta_LUT(delta_LUT), 
    .mode(mode), 
    .operation(operation), 
    .clock(clock), 
    .done_LUTRot(done_LUTRot), 
    .done_LUTVec(done_LUTVec), 
    .done_LUT(done_LUT), 
    .enable_LUT(enable_LUT), 
    .address(address), 
    .theta_out(theta_ALU), 
    .kappa_out(kappa_ALU), 
    .delta_out(delta_ALU), 
    .done_FSM(done_FSM), 
	 .x_final(x_out), 
    .y_final(y_out), 
    .z_final(z_out), 
    .k_final(k_out), 
    /*.converge(converge),*/ 
    .done_ALU(done_ALU)
    );

LUTRotation u2 (mode, address, clock, enable_LUT, operation, done_LUTRot, kappa_LUTRot, theta_LUTRot, delta_LUTRot );

LUTVector u3 (mode, address, clock, enable_LUT, operation, done_LUTVec, kappa_LUTVec, theta_LUTVec, delta_LUTVec);

LUTVector_linear u4 (address, clock, enable_LUT, operation, done_LUT, delta_LUT, theta_LUT );

alu u5 (x_FSM, y_FSM, delta_ALU, k_FSM, kappa_ALU, mode, clock, z_FSM, theta_ALU, x_iter, y_iter, z_iter, k_iter, done_FSM, done_ALU );

endmodule
