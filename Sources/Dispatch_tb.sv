
`timescale 1ns / 1ps
module Dispatch_tb;

wire empty;
wire [31:0] instruction;
wire [31:0] current_PC;

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
wire jb_en;
wire [31:0]	jb_address;


reg issueque_full_integer,
     issueque_full_ld_st,
     issueque_full_mul,
     issueque_full_div;

reg [5:0] CDB_tag;
reg CDB_valid;
reg [31:0] CDB_data;
reg CDB_branch;
reg CDB_branch_taken;

reg clk;
reg reset;
wire rd_en;

reg [5:0] CDB_tag_random [63:0];
integer i;

I_Fetch
#(
.DATA_WIDTH(32), 
.ADDRESS_WIDTH(32)) 
UUT0(
	.clk(clk),
	.reset(reset),
	.Read_enable(rd_en),
	.jump_branch_valid(jb_en),
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
	.CDB_valid(CDB_valid),
	.CDB_data(CDB_data),
	.CDB_branch(CDB_branch),
	.CDB_branch_taken(CDB_branch_taken),
	.issueque_full_integer(issueque_full_integer),
	.issueque_full_ld_st(issueque_full_ld_st),
	.issueque_full_mul(issueque_full_mul),
	.issueque_full_div(issueque_full_div),
//O.utputs
	.Read_enable(rd_en),
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
	i = 0;
	issueque_full_integer = 1'b0;
   issueque_full_ld_st = 1'b0;
   issueque_full_mul = 1'b0;
   issueque_full_div = 1'b0;
	CDB_tag = 6'b0;
	CDB_valid = 1'b0;
	CDB_data = 32'b0;
	CDB_branch = 1'b0;
	CDB_branch_taken = 1'b0;
	clk = 1'b0;
	reset = 1'b1;
	//rd_en = 1'b1;
	#2
	reset			= 1'b0;
end
always begin
	#1 
	clk = ~clk;
end

always begin 
	#9;
	@(posedge clk);
	random_CDB;

end

always begin
	capture_CDB;
	@(posedge clk);
end

/*

always begin
	#8
	CDB_tag = 6'h01;
	CDB_valid = 1'b1;
	CDB_data = 32'hAF01;
	#2;
	CDB_tag = 6'h00;
	CDB_valid = 1'b1;
	CDB_data = 32'hAF00;
	#2;
	CDB_tag = 6'h03;
	CDB_valid = 1'b1;
	CDB_data = 32'hAF03;
	#2;
	CDB_tag = 6'h04;
	CDB_valid = 1'b1;
	CDB_data = 32'hAF04;
	#2;
	CDB_tag = 6'h02;
	CDB_valid = 1'b1;
	CDB_data = 32'hAF02;
	#2;
	CDB_valid = 1'b0;
	issueque_full_integer = 1'b1;
	#4;
	issueque_full_integer = 1'b0;
	#2;
	issueque_full_mul = 1'b1;
	#4;
	issueque_full_mul = 1'b0;
	#20;
	issueque_full_div = 1'b1;
	#8;
	issueque_full_div = 1'b0;
	#16;
	CDB_branch = 1'b1;
	CDB_branch_taken = 1'b1;
	#2;
	CDB_branch = 1'b0;
	CDB_branch_taken = 1'b0;
end
*/

endmodule


task capture_CDB;
	if (Dispatch_tb.dispatch_en_integer || Dispatch_tb.dispatch_en_mul || Dispatch_tb.dispatch_en_div) begin
	Dispatch_tb.CDB_tag_random[Dispatch_tb.i] = Dispatch_tb.dispatch_rd_tag;
	Dispatch_tb.i = Dispatch_tb.i + 1;
	end
endtask

task random_CDB;

	Dispatch_tb.CDB_tag = Dispatch_tb.CDB_tag_random[$urandom_range(0,Dispatch_tb.i-1)];
	Dispatch_tb.CDB_valid = 1'b1;
	Dispatch_tb.CDB_data = $random;
	

endtask 