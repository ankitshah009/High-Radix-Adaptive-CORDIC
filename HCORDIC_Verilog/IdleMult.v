`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:54 02/22/2015 
// Design Name: 
// Module Name:    IdleMult 
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
module IdleMult(
	input [31:0] FinalProduct,
	input clock,
	output reg [31:0] FinalProductout
    );

always @ (posedge clock)
begin
	FinalProductout <= FinalProduct;
end

endmodule
