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

output 							Read_enable;
output 							jump_branch_valid;
output 	[DATA_WIDTH-1:0]	jump_branch_address;

wire Jump, JumpR, MemRead, MemWrite, PCSave, RegWrite, BNEinst, BEQinst;
wire [1:0] MemToReg, ALU_source;
wire [2:0] Ins_type;




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
	.PCSave(PCSave),
	.MemToReg(MemToReg),
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



endmodule
