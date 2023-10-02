module Dispatch_Unit
#(
parameter DATA_WIDTH = 32, 
parameter REGISTER_WIDTH = 7)
(
//Inputs
	clk,
	reset,
	empty,
	Instruction,
	PC_out,
	CDB_tag,
	CDB_valid,
	CDB_data,
	CDB_branch,
	CDB_branch_taken,
//Outputs
	Read_enable,
	jump_branch_valid,
	jump_branch_address,


);

input 							clk;
input 							reset;
input								empty;
input	[DATA_WIDTH-1:0]		Instruction;
input	[DATA_WIDTH-1:0]		PC_out;
input	[6:0]						CDB_tag;
input								CDB_valid;
input	[DATA_WIDTH-1:0]		CDB_data;
input								CDB_branch;
input								CDB_branch_taken;

output 							Read_enable;
output 							jump_branch_valid;
output 	[DATA_WIDTH-1:0]	jump_branch_address;

wire Jump, JumpR, MemRead, MemWrite, PCSave, RegWrite, BNEinst, BEQinst;
wire [1:0] /*MemToReg,*/ ALU_source;
wire [2:0] Ins_type;
wire [31:0] RF_write_enable;
wire [5:0] current_tag;

Control_unit_riscv Decode(
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
);

imm GenImm(
  .Datain(Instruction[31:7]),
  .Ins_type(Ins_type),
  .Imm(Inmediate_Data)
);

Tag_FIFO
#(
	.TAG_WIDTH(7))
Tags_Table (
//Inputs
	.clk(clk),
	.reset(reset),
	.flush(1'b0),
	.cdb_tag_tf(CDB_tag),
	.cdb_tag_tf_valid(CDB_valid),
	.ren_tf(RegWrite),
//Outputs
	.tagout_tf(current_tag),
	.ff_tf(),
	.ef_tf()
);

RegisterFile #(.DATA_WIDTH(32), .ADDR_WIDTH(5)) Reg_File(
  .clk(clk),
  .reset(reset),
  .write_enable(RF_write_enable),
  .write_data(CDB_data),
  .read_address0(Instruction[19:15]),
  .read_data0(),
  .read_address1(Instruction[24:20]),
  .read_data1()
);

Register_Status_Table RST(
	.clk(clk),
	.reset(reset),
	.write_data0(current_tag),
	.write_address0(Instruction[11:7]),
	.write_enable0(RegWrite),
	//.write_data1,
	//.write_enable1,
	.read_address0(Instruction[19:15]),
	.read_tag0(),
	.read_valid0(),
	.read_address1(Instruction[24:20]),
	.read_tag1(),
	.read_valid1(),
	.cdb_tag(CDB_tag),
	.cdb_valid(CDB_valid),
	.RF_write_enable(RF_write_enable)
);

endmodule
