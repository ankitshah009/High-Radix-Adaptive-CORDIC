`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:56 11/02/2014 
// Design Name: 
// Module Name:    LUTRotation 
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
module LUTRotation(
	 input [1:0] mode,
    input [7:0] address,
	 input clock,
	 input enable,
	 input operation,
	 output reg done,
    output reg [31:0] kappa,
    output reg [31:0] theta,
    output reg [31:0] delta
    );

reg [31:0] LUT_Theta [0:255];
reg [31:0] LUT_Delta_Cir [0:255];
reg [31:0] LUT_Delta_Hyper [0:255];
reg [31:0] LUT_Kappa_Cir [0:255];
reg [31:0] LUT_Kappa_Hyper [0:255];


initial
begin
	$readmemh("theta_rot.txt",LUT_Theta,0,255);
	$readmemh("DeltaCir_rot.txt",LUT_Delta_Cir,0,255);
	$readmemh("DeltaHyper_rot.txt",LUT_Delta_Hyper,0,255);
	$readmemh("KappaCir_rot.txt",LUT_Kappa_Cir,0,255);
	$readmemh("KappaHyper_rot.txt",LUT_Kappa_Hyper,0,255);
end


always @ (posedge clock)
begin
	
	if (operation == 1'b1)
	begin
		
		if (enable == 1'b1)
		begin
			theta <= LUT_Theta[address];
	
			if (mode == 2'b01)
			begin
				delta <= LUT_Delta_Cir[address];
				kappa <= LUT_Kappa_Cir[address];
			end
	
			else if (mode == 2'b11)
			begin
				delta <= LUT_Delta_Hyper[address];
				kappa <= LUT_Kappa_Hyper[address];
			end
	
			done <= 1'b1;
		end
	
		else if(enable == 1'b0)
		begin
			done <= 1'b0;
		end
	end
end
endmodule
