
`timescale 1ns / 1ps

module Control_unit_riscv(
		input [1:0] mod,
		input [6:0] opcode,
		input [2:0] funct3,
		output	Jump, 
					JumpR, 
					//Branch, 
					MemRead, 
					MemWrite, 
					ALUsrc, 
					RegWrite, 
					PCSave,
					BNEinst, 
					BEQinst,
		//output [1:0] MemToReg,
		output [2:0] InstType,
		output [4:0] ALU_control
); 

wire Branch;
wire [2:0] 	Inst_Type;
wire [1:0] 	ALU_option, 
				funct7_modifier_bits;


assign BNEinst = (funct3 == 3'b001) && (Branch == 1'b1)? 1'b1: 1'b0;
assign BEQinst = (funct3 == 3'b000) && (Branch == 1'b1)? 1'b1: 1'b0;
assign InstType = Inst_Type;
assign funct7_modifier_bits = (Inst_Type ==  3'b111)? mod: 2'b0;


Control ControlModule(
	.op_inst(opcode),
	.InstType(Inst_Type),
	.Jump(Jump),
	.JumpR(JumpR),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.ALUsrc(ALUsrc),
	.RegWrite(RegWrite),
	.PCSave(PCSave),
	.ALU_Op(ALU_option),
	//.MemToReg(MemToReg)
);
ALU_decoder ALU_controller(
.modifier(funct7_modifier_bits),
.funct3(funct3),
.ALU_option(ALU_option),
.ALU_control(ALU_control)
);



endmodule