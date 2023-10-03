module Control (
	op_inst,
	InstType,
	func3,
	func7,
	Branch,
	RegWrite,
	//Jump,
	//JumpR,
	dispatch_opcode,
	dispatch_en_integer,
	dispatch_en-ld_st,
	dispatch_en_mul,
	dispatch_en_div,
	issueque_full_integer,
	issueque_full_ld_st,
	issueque_full_mul,
	issueque_full_div	
);
input [6:0] op_inst;
output [2:0] InstType;
input [2:0] func3;
input [6:0] func7;
output Branch;
output RegWrite;
//Jump,
//JumpR,
output [3:0] dispatch_opcode;
output dispatch_en_integer;
output dispatch_en-ld_st;
output dispatch_en_mul;
output dispatch_en_div;
input issueque_full_integer;
input issueque_full_ld_st;
input issueque_full_mul;
input issueque_full_div;

localparam R_Type = 7'h33;
localparam I_Logic_Type = 7'h13;
localparam I_Load_Type = 7'h03;
localparam S_Type = 7'h23;
localparam B_Type = 7'h63;
localparam J_Type = 7'h6F;
localparam I_Jump_Type = 7'h67;
localparam U_Load_Type = 7'h37;
localparam U_Add_Type = 7'h17;

wire int_enabler;
assign int_enabler = (func7 == 7'h00) || (func7 == 7'h20) ? 1'b1: 1'b0;

wire mul_enabler;
assign mul_enabler = (func7 == 7'h01) && (funct3 == 3'b000) ? 1'b1: 1'b0;

wire div_enabler;
assign div_enabler = (func7 == 7'h01) && (funct3 == 3'b100) ? 1'b1: 1'b0;


always @ * begin
	case (op_inst)
		R_Type:
		begin
			InstType = 3'b111;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = {func7[5],func3};
			dispatch_en_integer = (~issueque_full_integer) & (int_enabler);
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = (~issueque_full_mul) & (mul_enabler);
			dispatch_en_div = (~issueque_full_div) & (div_enabler);
			/*InstType = 3'b111;
			//ALU_Op = 2'b10;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			//PCSave = 1'b0;*/
		end
		I_Logic_Type:
		begin
			InstType = 3'b000;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = {1'b0,func3};
			dispatch_en_integer = ~issueque_full_integer;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b000;
			ALU_Op = 2'b10;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
			PCSave = 1'b0;*/
		end
		I_Load_Type:
		begin
			InstType = 3'b000;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0001;
			dispatch_en_integer = 1'b0;
			dispatch_en-ld_st = ~issueque_full_ld_st;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b000;
			ALU_Op = 2'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b1;
			//MemToReg = 2'b01;
			MemWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
			PCSave = 1'b0;*/
		end
		S_Type:
		begin
			InstType = 3'b010;
			Branch = 1'b0;
			RegWrite = 1'b0;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0010;
			dispatch_en_integer = 1'b0;
			dispatch_en-ld_st = ~issueque_full_ld_st;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b010;
			ALU_Op = 2'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b1;
			ALUsrc = 1'b1;
			RegWrite = 1'b0;
			PCSave = 1'b0;*/
		end
		B_Type:
		begin
			InstType = 3'b011;
			Branch = 1'b1;
			RegWrite = 1'b0;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0000;
			dispatch_en_integer = 1'b0;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b011;
			ALU_Op = 2'b01;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b1;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
			PCSave = 1'b0;*/
		end
		J_Type:
		begin
			InstType = 3'b100;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0000;
			dispatch_en_integer = 1'b0;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b100;
			ALU_Op = 2'b00;
			Jump = 1'b1;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b10;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b0;*/
		end
		I_Jump_Type:
		begin
			InstType = 3'b000;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0000;
			dispatch_en_integer = 1'b0;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b000;
			ALU_Op = 2'b00;
			Jump = 1'b0;
			JumpR = 1'b1;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b10;
			MemWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
			PCSave = 1'b0;*/
		end
		U_Load_Type:
		begin
			InstType = 3'b101'b01;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0000;
			dispatch_en_integer = ~issueque_full_integer;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b101;
			ALU_Op = 1'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b11;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b0;*/
		end
		U_Add_Type:
		begin
			InstType = 3'b111;
			Branch = 1'b0;
			RegWrite = 1'b1;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0000;
			dispatch_en_integer = ~issueque_full_integer;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b101;
			ALU_Op = 1'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b10;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b1;*/
		end
		default:
		begin
			InstType = 3'b000;
			Branch = 1'b0;
			RegWrite = 1'b0;
			//Jump,
			//JumpR,
			dispatch_opcode = 4'b0000;
			dispatch_en_integer = 1'b0;
			dispatch_en-ld_st = 1'b0;
			dispatch_en_mul = 1'b0;
			dispatch_en_div = 1'b0;
			/*InstType = 3'b000;
			ALU_Op = 1'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
			PCSave = 1'b0;*/
		end
	endcase
end

endmodule