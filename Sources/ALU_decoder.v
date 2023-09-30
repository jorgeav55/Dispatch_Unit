`timescale 1ns / 1ps
module ALU_decoder(
	input [1:0]modifier,
	input [2:0]funct3,
	input [1:0]ALU_option,
	output reg [4:0]ALU_control
);
always @*
	begin
	  if (ALU_option==2'b00)
	  	ALU_control=5'b0000;
	  else if (ALU_option==2'b01)
	  	ALU_control=5'b1000;
	  else if (ALU_option==2'b10)
	  	ALU_control={modifier,funct3};	
	  else
	  	ALU_control=5'b0000;
	end	
endmodule