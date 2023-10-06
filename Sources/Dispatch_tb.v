
`timescale 1ns / 1ps
module Dispatch_tb;

wire empty;
wire [31:0] instruction;
wire [31:0] current_PC;
wire [5:0] CDB_tag;
wire [3:0] dispatch_opcode;
wire dispatch_en_integer,
     dispatch_en_ld_st,
     dispatch_en_mul,
     dispatch_en_div,
	  dispatch_rs1_valid,
	  dispatch_rs2_valid;
wire [5:0] 	dispatch_rd_tag,
				dispatch_rs1_tag,
				dispatch_rs2_tag;
wire [31:0]	dispatch_rs1_data,
				dispatch_rs2_data;
reg issueque_full_integer,
     issueque_full_ld_st,
     issueque_full_mul,
     issueque_full_div;
wire jb_en;
wire [31:0]	jb_address;


reg clk;
reg reset;
reg rd_en;


I_Fetch
#(
.DATA_WIDTH(32), 
.ADDRESS_WIDTH(32)) 
UUT(
	.clk(clk),
	.reset(reset),
	.Read_enable(rd_en),
	.jump_branch_valid(1'b0),
	.jump_branch_address(jb_address),
	.empty(empty),
	.instruction(instruction),
	.PC_out(current_PC)
);

Dispatch_Unit
#(
.DATA_WIDTH(32), 
.REGISTER_WIDTH(7))
UUT1(
//Inputs
	.clk(clk),
	.reset(reset),
	.empty(empty),
	.Instruction(instruction),
	.PC_out(current_PC),
	.CDB_tag(CDB_tag),
	.CDB_valid(),
	.CDB_data(),
	.CDB_branch(),
	.CDB_branch_taken(),
	.issueque_full_integer(issueque_full_integer),
	.issueque_full_ld_st(issueque_full_ld_st),
	.issueque_full_mul(issueque_full_mul),
	.issueque_full_div(issueque_full_div),
//O.utputs
	.Read_enable(),
	.jump_branch_valid(jb_en),
	.jump_branch_address(jb_address),
	.dispatch_opcode(dispatch_opcode),
	.dispatch_en_integer(dispatch_en_integer),
	.dispatch_en_ld_st(dispatch_en_ld_st),
	.dispatch_en_mul(dispatch_en_mul),
	.dispatch_en_div(dispatch_en_div),
	.dispatch_rd_tag(dispatch_rd_tag),
	.dispatch_rs1_data(dispatch_rs1_data),
	.dispatch_rs1_tag(dispatch_rs1_tag),
	.dispatch_rs1_valid(dispatch_rs1_valid),
	.dispatch_rs2_data(dispatch_rs2_data),
	.dispatch_rs2_tag(dispatch_rs2_tag),
	.dispatch_rs2_valid(dispatch_rs2_valid)
);

initial begin
	issueque_full_integer = 1'b0;
   issueque_full_ld_st = 1'b0;
   issueque_full_mul = 1'b0;
   issueque_full_div = 1'b0;
	clk			= 1'b1;
	reset			= 1'b0;
	reset			= 1'b1;
	rd_en			= 1'b1;
	#3
	reset			= 1'b0;
end
always begin
	#1 
	clk = ~clk;
end

endmodule