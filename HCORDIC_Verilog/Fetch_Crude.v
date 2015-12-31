`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:45 02/20/2015 
// Design Name: 
// Module Name:    Fetch 
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
module Fetch_Crude(
    input [98:0] InstructionPacket,
    input clock,
	 input stall,
    output reg [31:0] x_input = 32'h00000000,
    output reg [31:0] y_input = 32'h00000000,
    output reg [31:0] z_input = 32'h00000000,
    output reg [1:0] mode,
    output reg operation,
    output reg load = 1'b0
    );

wire [3:0] Opcode;
wire [31:0] x_processor;
wire [31:0] y_processor;
wire [31:0] z_processor;

assign Opcode = InstructionPacket[98:96];
assign x_processor = InstructionPacket[31:0];
assign y_processor = InstructionPacket[63:32];
assign z_processor = InstructionPacket[95:64];

parameter sin_cos		= 4'd0,
			 sinh_cosh	= 4'd1,
			 arctan		= 4'd2,
			 arctanh		= 4'd3,
			 exp			= 4'd4,
			 sqr_root   = 4'd5,			// This requires pre processing. x = (a+1)/4 and y = (a-1)/4
			 division	= 4'd6,
			 tan			= 4'd7,			// This is iterative. sin_cos followed by division.
			 tanh			= 4'd8,			// This is iterative. sinh_cosh followed by division.
			 nat_log		= 4'd9,			// This requires pre processing. x = (a+1) and y = (a-1)
			 hypotenuse = 4'd10;
			 
parameter vectoring = 1'b0,
			 rotation  = 1'b1;
			 			 
parameter circular   = 2'b01,
			 linear     = 2'b00,
			 hyperbolic = 2'b11;

always @ (posedge clock)
begin
	
	if (stall == 1'b0) begin
		
		case(Opcode)
	
		sin_cos:
		begin
			mode <= circular;
			operation <= rotation;
			x_input <= 32'h3F800000;
			y_input <= 32'h00000000;
			z_input <= z_processor;	
			load <= 1'b1;
		end
		
		sinh_cosh:
		begin
			mode <= hyperbolic;
			operation <= rotation;
			x_input <= 32'h3F800000;
			y_input <= 32'h00000000;
			z_input <= z_processor;
			load <= 1'b1;
		end
		
		arctan:
		begin
			mode <= circular;
			operation <= vectoring;
			x_input <= 32'h3F800000;
			y_input <= y_processor;
			z_input <= 32'h00000000;
			load <= 1'b1;
		end
		
		arctanh:
		begin
			mode <= hyperbolic;
			operation <= vectoring;
			x_input <= 32'h3F800000;
			y_input <= y_processor;
			z_input <= 32'h00000000;
			load <= 1'b1;
		end
		
		exp:
		begin
			mode <= hyperbolic;
			operation <= rotation;
			x_input <= 32'h3F800000;
			y_input <= 32'h3F800000;
			z_input <= z_processor;
			load <= 1'b1;		
		end
		
		sqr_root:
		begin
			mode <= hyperbolic;
			operation <= vectoring;
			x_input <= Register_File[x_address];
			y_input <= Register_File[y_address];
			z_input <= 32'h00000000;
			load <= 1'b1;
		end
		
		division:
		begin
			mode <= linear;
			operation <= vectoring;
			x_input <= x_processor;
			y_input <= y_processor;
			z_input <= 32'h00000000;
			load <= 1'b1;
		end
		
		hypotenuse:
		begin
			mode <= circular;
			operation <= vectoring;
			x_input <= x_processor;
			y_input <= y_processor;
			z_input <= 32'h00000000;
			load <= 1'b1;
		end
		
		endcase
		
	end
		
	else begin
		load <= 1'b0;
	end
	
	
end


endmodule
