`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:16:18 11/04/2014 
// Design Name: 
// Module Name:    alu 
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
module alu(
Xi,
Yi,
deltai,
Ki,
ki,
mode,
clock,
Zi,
thetai,
X_next,
Y_next,
Z_next,
K_next,
ALU_enable,
ALU_done
);

input wire   [31:0]Xi;
input wire	 [31:0]Yi;
input wire	 [31:0]Zi;
input wire	 [31:0]Ki;
input wire   [31:0]ki;
input wire	 [31:0]deltai;
input wire	 [1:0] mode;
input wire	 clock;
input wire	 [31:0]thetai;
input wire 	 ALU_enable;
	  
output wire  [31:0]X_next;
output wire	 [31:0]Y_next;
output wire	 [31:0]Z_next;
output wire  [31:0]K_next;
output reg   ALU_done;

reg          [31:0]X_in;
reg	       [31:0]Y_in;
reg			 [31:0]Z_in;
reg			 [31:0]K_in;
reg			 [31:0]k_in;
reg			 [31:0]delta_in;
reg			 clk;
reg			 [31:0]theta_in;
reg			 [31:0]ydelta_in;
reg			 [31:0]xdelta_in;
wire 			 output_z1;
wire			 output_z2;
wire			 output_z3;
wire			 output_z4;
wire			 output_z5;
wire			 output_z6;
wire			 output_a1;
wire			 output_b1;
wire			 output_a2;
wire			 output_b2;
wire			 output_a3;
wire			 output_b3;
wire			 output_a4;
wire			 output_b4;
wire			 output_a5;
wire			 output_b5;
wire			 output_a6;
wire			 output_b6;
wire			 [31:0] X_nxt;
wire			 [31:0] Y_nxt;
wire			 [31:0] Z_nxt;
wire			 [31:0] K_nxt;
wire 			 [31:0] xdelta_in1;
wire			 [31:0] ydelta_in1;
reg 			 [3:0]  z_state;
reg 			 rst = 1'b0;
reg			 rst1 = 1'b0;
reg 			 rst2 = 1'b0;
reg 			 rst3 = 1'b0;
reg 			 rst4 = 1'b0;
reg 			 rst5 = 1'b0;
reg 			 rst6 = 1'b0;
reg 			 r_z2;
reg 			 r_z4;
reg 			 r_z5;
reg 			 r_z6;


// always block to take care of the mode as the sign for substraction needs to be changed



always@(*)
begin
X_in = Xi;
Y_in = Yi;
Z_in = Zi;
delta_in = deltai;
theta_in = thetai;
K_in = Ki;
k_in = ki;
xdelta_in = {~xdelta_in1[31],xdelta_in1[30:0]};
clk = clock;

	
	if(mode==2'b01)
	begin
		ydelta_in = ydelta_in1;
	end
	
	else if(mode==2'b11)
	begin
		ydelta_in = {~ydelta_in1[31],ydelta_in1[30:0]};
	end
	
	else if(mode==2'b00)
	begin
		ydelta_in = 32'h00000000;
	end

	else
	begin
	ydelta_in = ydelta_in1;
	end
	
end

// This state machine synchronises the x y z and k output. ie. move to mux only if all outputs are available.
always @ (posedge clk)
begin
	
	if (rst == 1'b1)
	begin
		ALU_done <= 1'b0;
		rst1 <= 1'b0;
		rst2 <= 1'b0;
		rst3 <= 1'b0;
		rst4 <= 1'b0;
		rst5 <= 1'b0;
		rst6 <= 1'b0;
	end
	
	if (output_z2 == 1'b0 && output_z4 == 1'b0 && output_z5 == 1'b0 && output_z6 == 1'b0)
	begin
		rst <= 1'b0;
	end
	
	else if(output_z2 == 1'b1 && output_z4 == 1'b1 && output_z5 == 1'b1 && output_z6 == 1'b1)
	begin
		ALU_done <= 1'b1;
		rst1 <= 1'b0;
		rst2 <= 1'b0;
		rst3 <= 1'b0;
		rst4 <= 1'b0;
		rst5 <= 1'b0;
		rst6 <= 1'b0;
		rst <= 1'b1;
	end
	
	else 
	begin
		if (output_z1 == 1'b1)
		begin
		rst1 <= 1'b1;
		ALU_done <= 1'b0;
		end
		
		if (output_z2 == 1'b1)
		begin
		rst2 <= 1'b1;
		ALU_done <= 1'b0;
		end

		if (output_z3 == 1'b1)
		begin
		rst3 <= 1'b1;
		ALU_done <= 1'b0;
		end

		if (output_z4 == 1'b1)
		begin
		rst4 <= 1'b1;
		ALU_done <= 1'b0;
		end

	
		if (output_z5 == 1'b1)
		begin
		rst5 <= 1'b1;
		ALU_done <= 1'b0;
		end
	
		if (output_z6 == 1'b1)
		begin
		rst6 <= 1'b1;
		ALU_done <= 1'b0;
		end
	end
	
end

multiplier multiplier_x(
        .input_a(Y_in),
        .input_b(delta_in),
        .input_a_stb(ALU_enable),
        .input_b_stb(ALU_enable),
        .output_z_ack(1'b1),
		  .input_idle(w_rst1),
        .clk(clk),
        .rst(rst),
        .output_z(ydelta_in1),
        .output_z_stb(output_z1),
        .input_a_ack(output_a1),
        .input_b_ack(output_b1));
	

adder adder_x(
        .input_a(ydelta_in),
        .input_b(X_in),
        .input_a_stb(output_z1),
        .input_b_stb(1'b1),
        .output_z_ack(1'b1),
		  .input_idle(w_rst2),
        .clk(clk),
        .rst(rst),
        .output_z(X_nxt),
        .output_z_stb(output_z2),
        .input_a_ack(output_a2),
        .input_b_ack(output_b2));

multiplier multiplier_y(
        .input_a(X_in),
        .input_b(delta_in),
        .input_a_stb(ALU_enable),
        .input_b_stb(ALU_enable),
        .output_z_ack(1'b1),
		  .input_idle(w_rst3),
        .clk(clk),
        .rst(rst),
        .output_z(xdelta_in1),
        .output_z_stb(output_z3),
        .input_a_ack(output_a3),
        .input_b_ack(output_b3));


adder adder_y(
        .input_a(xdelta_in),
        .input_b(Y_in),
        .input_a_stb(output_z3),
        .input_b_stb(1'b1),
        .output_z_ack(1'b1),
		  .input_idle(w_rst4),
        .clk(clk),
        .rst(rst),
        .output_z(Y_nxt),
        .output_z_stb(output_z4),
        .input_a_ack(output_a4),
        .input_b_ack(output_b4));



adder adder_z(
        .input_a(Z_in),
        .input_b(theta_in),
        .input_a_stb(ALU_enable),
        .input_b_stb(ALU_enable),
        .output_z_ack(1'b1),
		  .input_idle(w_rst5),
        .clk(clk),
        .rst(rst),
        .output_z(Z_nxt),
        .output_z_stb(output_z5),
        .input_a_ack(output_a5),
        .input_b_ack(output_b5));

multiplier multiplier_k(
        .input_a(K_in),
        .input_b(k_in),
        .input_a_stb(ALU_enable),
        .input_b_stb(ALU_enable),
        .output_z_ack(1'b1),
		  .input_idle(w_rst6),
        .clk(clk),
        .rst(rst),
        .output_z(K_nxt),
        .output_z_stb(output_z6),
        .input_a_ack(output_a6),
        .input_b_ack(output_b6));
 
assign X_next = X_nxt;
assign Y_next = Y_nxt;
assign Z_next = Z_nxt;
assign K_next = K_nxt;

assign w_rst1 = rst1;
assign w_rst2 = rst2;
assign w_rst3 = rst3;
assign w_rst4 = rst4;
assign w_rst5 = rst5;
assign w_rst6 = rst6;

/*assign output_z2 = r_z2;
assign output_z4 = r_z4;
assign output_z5 = r_z5;
assign output_z6 = r_z6;
*/
endmodule
