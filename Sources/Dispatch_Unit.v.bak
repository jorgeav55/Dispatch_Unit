module Dispatch_Unit
#(
parameter DATA_WIDTH = 32, 
parameter ADDRESS_WIDTH = 32)
(
//Inputs
	clk,
	reset,
	empty,
	instruction,
	PC_out,
//Outputs
	Read_enable,
	jump_branch_valid,
	jump_branch_address,


);

input 							clk;
input 							reset;
input								empty;
input	[DATA_WIDTH-1:0]		instruction;
input	[DATA_WIDTH-1:0]		PC_out;

output 							Read_enable;
output 							jump_branch_valid;
output 	[DATA_WIDTH-1:0]	jump_branch_address;

endmodule
