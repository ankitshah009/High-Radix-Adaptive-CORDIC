`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:36 11/02/2014 
// Design Name: 
// Module Name:    LUTVector_linear 
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
module LUTVector_linear(
    input [7:0] address,	
    input clock,
	 input enable,
	 input operation,
	 output reg done,
    output reg [31:0] delta,
    output reg [31:0] theta
    );

reg [31:0] LUT_Delta [0:255];

initial
begin
	$readmemh("delta_vec_linear.txt",LUT_Delta,0,255);
end

always @ (posedge clock)
begin
	
	if (operation == 1'b0)
	begin
	
	if (enable == 1'b1)
	begin
		delta <= LUT_Delta[address];
		theta <= LUT_Delta[address];
	
		done <= 1'b1;
	end
	
	else if(enable == 1'b0)
	begin
		done <= 1'b0;
	end
	end
	
	else 
	begin
		done <= 1'b0;
	end

end
endmodule
