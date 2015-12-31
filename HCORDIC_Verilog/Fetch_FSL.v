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
module Fetch_FSL(
    input [107:0] InstructionPacket,
	 input [107:0] InstructionPacket_Processed,
	 input ProcessInputReady,
	 input reset,
    input clock,
	 input stall,
    output reg [31:0] x_input = 32'h00000000,
    output reg [31:0] y_input = 32'h00000000,
    output reg [31:0] z_input = 32'h00000000,
    output reg [1:0] mode,
    output reg operation,
	 output reg [7:0] InsTagFetchOut,
    output reg load = 1'b0,
	 output reg NatLogFlag = 1'b0
    );

wire [3:0] Opcode;
wire [31:0] x_processor;
wire [31:0] y_processor;
wire [31:0] z_processor;
wire [7:0] InstructionTag;

wire [3:0] Opcode_processed;
wire [31:0] x_processor_processed;
wire [31:0] y_processor_processed;
wire [31:0] z_processor_processed;
wire [7:0] InstructionTag_processed;

assign InstructionTag = InstructionPacket[107:100];
assign Opcode = InstructionPacket[99:96];
assign x_processor = InstructionPacket[31:0];
assign y_processor = InstructionPacket[63:32];
assign z_processor = InstructionPacket[95:64];

assign InstructionTag_processed = InstructionPacket_Processed[107:100];
assign Opcode_processed = InstructionPacket_Processed[99:96];
assign x_processor_processed = InstructionPacket_Processed[31:0];
assign y_processor_processed = InstructionPacket_Processed[63:32];
assign z_processor_processed = InstructionPacket_Processed[95:64];

parameter sin_cos		= 4'd0,
			 sinh_cosh	= 4'd1,
			 arctan		= 4'd2,
			 arctanh		= 4'd3,
			 exp			= 4'd4,
			 sqr_root   = 4'd5,			// Pre processed input is given 4'd11
												// This requires pre processing. x = (a+1)/2 and y = (a-1)/2
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

if (reset == 1'b1) begin
	x_input <= 32'h00000000;
   y_input <= 32'h00000000;
   z_input <= 32'h00000000;
	load <= 1'b0;
	NatLogFlag <= 1'b0;
end
	
else begin
	
	if (ProcessInputReady == 1'b0) begin
		
		InsTagFetchOut <= InstructionTag;
		
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
		
		InsTagFetchOut <= InstructionTag_processed;
		
		case(Opcode_processed)
		
		sqr_root:
		begin
			mode <= hyperbolic;
			operation <= vectoring;
			x_input[31] <= x_processor_processed[31];
			x_input[30:23] <= x_processor_processed[30:23] - 8'h01;
			x_input[22:0] <= x_processor_processed[22:0];
			y_input[31] <= 1'b0;
			y_input[30:23] <= y_processor_processed[30:23] - 8'h01;
			y_input[22:0] <= y_processor_processed[22:0];
			z_input <= 32'h00000000;
			load <= 1'b1;
		end
		
		nat_log:
		begin
			mode <= hyperbolic;
			operation <= vectoring;
			x_input <= x_processor_processed;
			y_input[30:0] <= y_processor_processed[30:0];
			y_input[31] <= 1'b0;
			z_input <= 32'h00000000;
			load <= 1'b1;	
			NatLogFlag <= 1'b1;
		end
		
		endcase
		
	end
		
	if (stall == 1'b1) begin
		load <= 1'b0;
	end
	
	
end
end
endmodule
