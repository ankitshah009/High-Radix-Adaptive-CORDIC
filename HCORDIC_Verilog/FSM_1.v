`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:59 02/21/2015 
// Design Name: 
// Module Name:    FSM_1 
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
module FSM_1(
    input [31:0] x,					// x Input to FSM from Mux
    input [31:0] y,					// y Input to FSM from Mux
    input [31:0] z,					// z Input to FSM from Mux
    input [31:0] k,					// k Input to FSM from Mux
    input [1:0] mode,			// Linear: 00 Hyperbolic: 11 Circular: 01
    input operation,			// operation = 1 is rotation. operation = 0 is vectoring
	 input NatLogFlagout_Mux,
	 input reset,
    input clock,
	 input [7:0] InsTagMuxOut,
	 output reg [1:0] enable_LUT = 2'b00, // Enable bit set by FSM to enable LUT
	 output reg [7:0] address,		// Address field to LUT
	 output reg [3:0] state_FSM2, // next state of FSM
	 output reg [31:0] x_FSM1,		// x_FSM1 enters FSM2
	 output reg [31:0] y_FSM1,		// y_FSM1 enters FSM2
	 output reg [31:0] z_FSM1,		// z_FSM1 enters FSM2
	 output reg [31:0] k_FSM1,		// k_FSM1 enters FSM2
    output reg [31:0] theta_FSM1,	// theta Output to ALU
    output reg [31:0] kappa_FSM1,	// kappa Output to ALU
    output reg [31:0] delta_FSM1,	// delta Output to ALU
	 output reg [1:0] mode_FSM1,
	 output reg operation_FSM1,
	 output reg NatLogFlagout_FSM1,
	 output reg [7:0] InsTagFSM1Out
    );
	
reg [7:0] exponent, exponentbar;

parameter rotation  =1'b1, 
			 vectoring =1'b0;
			 
parameter mode_circular  =2'b01, 
			 mode_linear    =2'b00, 
			 mode_hyperbolic=2'b11;
			 
parameter Linear_Rotation                =  4'd0,
			 Hyperbolic_Rotation_by_1       =  4'd1,
			 Circular_Rotation_by_1         =  4'd2,
			 Rotation_with_small_theta      =  4'd3,
			 Circular_Rotation_with_table   =  4'd4,
          Hyperbolic_Rotation_with_table =  4'd5,
          Linear_Vectoring               =  4'd6,
          Hyperbolic_Vectoring_by_1      =  4'd7,
          Circular_Vectoring_by_1        =  4'd8,			 
          Vectoring_by_small_fraction    =  4'd9,
			 Circular_Vectoring_with_table  =  4'd10,
			 Hyperbolic_Vectoring_with_table=  4'd11,
			 Idle_state							  =  4'd12,
			 ConvergeRotation					  =  4'd13,
			 ConvergeVectoring				  =  4'd14;

parameter LUT_Disable   = 2'b00,
			 LUT_Rotation	= 2'b01,
			 LUT_Vectoring	= 2'b10,
			 LUT_LinVec		= 2'b11;
			 
reg [3:0] state_FSM1;

always @ (*)
begin

	case (operation)
	  rotation : exponent <= 8'b01111111 - z[30:23];
	  vectoring : exponent <= y[30:23] - x[30:23];
	  default : exponent <= y[30:23] - x[30:23];
	endcase
	
	exponentbar <= ~exponent + 8'b00000001;
end

always @ (posedge clock)
begin   
	////////////////////////////////////////////////////////////////////////////
	
	if (reset == 1'b1) begin
		enable_LUT <= 2'b00;
	end
	
	else begin
	x_FSM1				  <= x;
	y_FSM1				  <= y;
	z_FSM1				  <= z;
	k_FSM1				  <= k;
	mode_FSM1			  <= mode;
	operation_FSM1		  <= operation;
	InsTagFSM1Out		  <= InsTagMuxOut;
	NatLogFlagout_FSM1  <= NatLogFlagout_Mux;
	
	if(operation==rotation && mode==mode_linear) begin
		state_FSM1       <= Linear_Rotation;
      theta_FSM1[30:0] <= z[30:0];
	   delta_FSM1[30:0] <= z[30:0];
		theta_FSM1[31]   <= ~z[31];
	   delta_FSM1[31]	  <= ~z[31];
		kappa_FSM1       <= 32'h3F800000;
		enable_LUT       <= LUT_Disable;
		state_FSM2		  <= Idle_state;		
	end
	
	else if (operation==rotation && mode==mode_hyperbolic && z[30:23] >= 8'b01111111) begin
		state_FSM1 		  <= Hyperbolic_Rotation_by_1;
		theta_FSM1       <= 32'hBF800000;
		delta_FSM1       <= 32'hBF42F7D6;
		kappa_FSM1       <= 32'h3FC583AB;
		enable_LUT       <= LUT_Disable;
		state_FSM2		  <= Idle_state;
	end
	
	else if (operation==rotation && mode==mode_circular && z[30:23] >=8'b01111111) begin
		state_FSM1 		  <= Circular_Rotation_by_1;
		theta_FSM1       <= 32'hBF800000;
		delta_FSM1       <= 32'hBFC75923;
		kappa_FSM1       <= 32'h3F0A5142;
		enable_LUT       <= LUT_Disable;
		state_FSM2		  <= Idle_state;		
	end
	
	// Bring this back in pre decode in InputMux.v to avoid bringing it into FSM and passing a bubble through entire pipeline
	/*else if (operation==rotation && mode !=mode_linear && z[30:23] <= 8'b00000000) begin
		state_FSM1		 <= ConvergeRotation;		
	end*/
	
	else if (operation==rotation && mode !=mode_linear && z[30:23] <= 8'b01110011) begin
		state_FSM1 		  <= Rotation_with_small_theta;
		theta_FSM1[30:0] <= z[30:0];
		delta_FSM1[30:0] <= z[30:0];
		theta_FSM1[31]	  <= ~z[31];
		delta_FSM1[31]	  <= ~z[31];
		kappa_FSM1       <= 32'h3F800000;
		enable_LUT       <= LUT_Disable;
		state_FSM2		  <= Idle_state;		
	end
	
	else if (operation==rotation && mode==mode_circular && z[30:23]<8'b01111111 && z[30:23]>8'b01110011) begin
		state_FSM1		 <= Circular_Rotation_with_table;
		address[7:4]    <= exponent[3:0];
		address[3:0]    <= z[22:19];
		enable_LUT      <= LUT_Rotation;
		state_FSM2		 <= Circular_Rotation_with_table;
	end
	
	else if (operation==rotation && mode==mode_hyperbolic && z[30:23]<8'b01111111 && z[30:23]>8'b01110011) begin
		state_FSM1		 <= Hyperbolic_Rotation_with_table;
		address[7:4]    <= exponent[3:0];
		address[3:0]    <= z[22:19];
		enable_LUT      <= LUT_Rotation;
		state_FSM2		 <= Hyperbolic_Rotation_with_table;		
	end
	
   else if (operation==vectoring && mode==mode_linear && (exponentbar[7] == 1'b1 || exponentbar < 8'b00010101)) begin
		state_FSM1		 <= Linear_Vectoring;
		address[7:4]    <= y[22:19];
		address[3:0]    <= x[22:19];
		kappa_FSM1      <= 32'h3F800004;
	   enable_LUT      <= LUT_LinVec;
		state_FSM2		 <= Linear_Vectoring;			
	end
	
	else if (operation==vectoring && mode==mode_hyperbolic && exponent[7] != 1'b1 &&(exponent > 0 || (exponent == 0 && y[22:0]>=x[22:0]))) begin
		state_FSM1 		  <= Hyperbolic_Vectoring_by_1;
		theta_FSM1       <= 32'h3fea77cb;
		delta_FSM1       <= 32'h3F733333;
	   kappa_FSM1       <= 32'h3e9fdf38;
		enable_LUT       <= LUT_Disable;
		state_FSM2  	  <= Idle_state;								
	end
	
   else if (operation==vectoring && mode==mode_circular && exponent[7] != 1'b1 && (exponent > 0 || (exponent == 0 && y[22:0]>=x[22:0]))) begin
		state_FSM1		  <= Circular_Vectoring_by_1;
		theta_FSM1       <= 32'h3F490FDB;
		delta_FSM1       <= 32'h3F800000;
	   kappa_FSM1       <= 32'h3F3504F2;
		enable_LUT       <= LUT_Disable;
		state_FSM2  	  <= Idle_state;			
	end
	
	/*else if (operation==vectoring && exponentbar[7] == 1'b0 && exponentbar >= 8'b00001111) begin
		state<= ConvergeVectoring;
	end*/
	
	else if (operation==vectoring && mode!=mode_linear && exponentbar == 8'b00001110) begin
		state_FSM1		  <= Vectoring_by_small_fraction;
		address[7:4] 	  <= x[22:19];
		address[3:0]     <= y[22:19];
		kappa_FSM1       <= 32'h3F800000;
		enable_LUT       <= LUT_LinVec;
		state_FSM2		  <= Vectoring_by_small_fraction;
	end 
	
	else if (operation==vectoring && mode==mode_circular && exponentbar >= 8'b00000000 && exponentbar < 8'b00001110) begin
		state_FSM1 		 <= Circular_Vectoring_with_table;
		address[7:4]    <= ~exponent[3:0] + 4'b0001;
		address[3:2]    <= y[22:21];
		address[1:0]    <= x[22:21];
		enable_LUT      <= LUT_Vectoring;		
		state_FSM2 		 <= Circular_Vectoring_with_table;
	end
	
	else if (operation==vectoring && mode==mode_hyperbolic && exponentbar >= 8'b00000000 && exponentbar < 8'b00001110) begin
		state_FSM1 		 <= Hyperbolic_Vectoring_with_table;
		address[7:4]    <= ~exponent[3:0] + 4'b0001;
		address[3:2]    <= y[22:21];
		address[1:0]    <= x[22:21];
		enable_LUT      <= LUT_Vectoring;		
		state_FSM2 		 <= Hyperbolic_Vectoring_with_table;		
	end
	
	else begin
		state_FSM1		 <= Idle_state;
		enable_LUT      <= LUT_Disable;
		state_FSM2		 <= Idle_state;
	end	
	end
end

endmodule
