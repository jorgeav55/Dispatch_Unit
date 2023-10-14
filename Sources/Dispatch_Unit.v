module Dispatch_Unit
#(
parameter DATA_WIDTH = 32, 
parameter REGISTER_WIDTH = 7)
(
//Inputs
	clk,
	reset,
//	empty,
	Instruction,
	PC_out,
	CDB_tag,
	CDB_valid,
	CDB_data,
	CDB_branch,
	CDB_branch_taken,
	issueque_full_integer,
	issueque_full_ld_st,
	issueque_full_mul,
	issueque_full_div,
//Outputs
	Read_enable,
	jump_branch_valid,
	jump_branch_address,
	dispatch_opcode,
	dispatch_en_integer,
	dispatch_en_ld_st,
	dispatch_en_mul,
	dispatch_en_div,
	dispatch_rd_tag,
	dispatch_rs1_data,
	dispatch_rs1_tag,
	dispatch_rs1_valid,
	dispatch_rs2_data,
	dispatch_rs2_tag,
	dispatch_rs2_valid
);

input 							clk;
input 							reset;
//input								empty;
input	[DATA_WIDTH-1:0]		Instruction;
input	[DATA_WIDTH-1:0]		PC_out;
input	[5:0]						CDB_tag;
input								CDB_valid;
input	[DATA_WIDTH-1:0]		CDB_data;
input								CDB_branch;
input								CDB_branch_taken;
input								issueque_full_integer;
input								issueque_full_ld_st;
input								issueque_full_mul;
input								issueque_full_div;

output 							Read_enable;
output 							jump_branch_valid;
output 	[DATA_WIDTH-1:0]	jump_branch_address;
output	[3:0]					dispatch_opcode;
output							dispatch_en_integer;
output							dispatch_en_ld_st;
output							dispatch_en_mul;
output							dispatch_en_div;
output	[5:0]					dispatch_rd_tag;
output	[31:0]				dispatch_rs1_data;
output	[5:0]					dispatch_rs1_tag;
output							dispatch_rs1_valid;
output	[31:0]				dispatch_rs2_data;
output	[5:0]					dispatch_rs2_tag;
output							dispatch_rs2_valid;

//wire Jump, JumpR, MemRead, MemWrite, PCSave, RegWrite, BNEinst, BEQinst;
//wire [1:0] /*MemToReg,*/ ALU_source;
wire branch;
wire jump;
wire RegWrite;
wire stall;
wire tag_fifo_empty;
wire branch_stall;
wire rs2_imm_data;
wire queue_stall;
wire [2:0] Ins_type;
wire [5:0] current_tag;
wire [31:0] RF_write_enable;
wire [31:0] RF_rs2_data;
wire [31:0] Inmediate_Data;
wire [31:0] PC_plus_imm;
wire [31:0] branch_address;

assign stall = tag_fifo_empty | branch_stall | queue_stall;
assign Read_enable = ~stall;
assign dispatch_rd_tag = current_tag;
assign jump_branch_valid = CDB_branch_taken | jump;
assign dispatch_rs2_data = (rs2_imm_data == 1'b1) ? Inmediate_Data : RF_rs2_data;
assign jump_branch_address = (branch_stall == 1'b1) ? branch_address: PC_plus_imm;
/*Control_unit_riscv Decode(
	.mod({Instruction[25],Instruction[30]}),
	.opcode(Instruction[6:0]),
	.funct3(Instruction[14:12]),
	.Jump(Jump), 
	.JumpR(JumpR), 
	.MemRead(MemRead), 
	.MemWrite(MemWrite), 
	.ALUsrc(ALU_source), 
	.RegWrite(RegWrite), 
	//.PCSave(PCSave),
	//.MemToReg(MemToReg),
	//.Branch(Branch), 
	.BNEinst(BNEinst), 
	.BEQinst(BEQinst),
	.InstType(Ins_type),
);*/
Control_decoder Decoder(
.op_inst(Instruction[6:0]),
.InstType(Ins_type),
.funct3(Instruction[14:12]),
.funct7(Instruction[31:25]),
.Branch(branch),
.RegWrite(RegWrite),
.rs2_immediate(rs2_imm_data),
.queue_stall(queue_stall),
.Jump(jump),
//JumpR,
.dispatch_opcode(dispatch_opcode),
.dispatch_en_integer(dispatch_en_integer),
.dispatch_en_ld_st(dispatch_en_ld_st),
.dispatch_en_mul(dispatch_en_mul),
.dispatch_en_div(dispatch_en_div),
.issueque_full_integer(issueque_full_integer),
.issueque_full_ld_st(issueque_full_ld_st),
.issueque_full_mul(issueque_full_mul),
.issueque_full_div(issueque_full_div)
);

imm GenImm(
  .Datain(Instruction[31:7]),
  .Ins_type(Ins_type),
  .Imm(Inmediate_Data)
);

Tag_FIFO
#(
	.TAG_WIDTH(6))
Tags_Table (
//Inputs
	.clk(clk),
	.reset(reset),
	.flush(1'b0),
	.cdb_tag_tf(CDB_tag),
	.cdb_tag_tf_valid(CDB_valid),
	.ren_tf((RegWrite & ~stall)),
//Outputs
	.tagout_tf(current_tag),
	//.ff_tf(),
	.ef_tf(tag_fifo_empty)
);

RegisterFile #(.DATA_WIDTH(32), .ADDR_WIDTH(5)) Reg_File(
  .clk(clk),
  .reset(reset),
  .write_enable(RF_write_enable),
  .write_data(CDB_data),
  .read_address0(Instruction[19:15]),
  .read_data0(dispatch_rs1_data),
  .read_address1(Instruction[24:20]),
  .read_data1(RF_rs2_data)
);

Register_Status_Table RST(
	.clk(clk),
	.reset(reset),
	.write_data0({1'b1,current_tag}),
	.write_address0(Instruction[11:7]),
	.write_enable0((RegWrite & ~stall)),
	//.write_data1,
	//.write_enable1,
	.read_address0(Instruction[19:15]),
	.read_tag0(dispatch_rs1_tag),
	.read_valid0(dispatch_rs1_valid),
	.read_address1(Instruction[24:20]),
	.read_tag1(dispatch_rs2_tag),
	.read_valid1(dispatch_rs2_valid),
	.cdb_tag(CDB_tag),
	.cdb_valid(CDB_valid),
	.RF_write_enable(RF_write_enable)
);


////////////////////////////////////////////////////////
//adder pc + branch address
////////////////////////////////////////////////////////
adder PC_adder(
//Inputs
.A(PC_out),
.B(Inmediate_Data),
.suma(PC_plus_imm)
);

Branch_Stall_Logic Branch_Logic(
	.clk(clk),
	.reset(reset),
	.Branch(branch),
	.Issueque_full_int(issueque_full_integer),
	.cdb_branch(CDB_branch),
	.cdb_branch_taken(CDB_branch_taken),
	.stall(branch_stall)
	
);

Register
#(
	.DATA_WIDTH(DATA_WIDTH)) Branch_Address
(
	.data_in			(PC_plus_imm),
	.dafault_data	({(DATA_WIDTH){1'b0}}),
	.reset			(reset),
	.enable			(branch),
	.flush			(1'b0),
	.clk				(clk),
	.data_out		(branch_address)
);


endmodule
