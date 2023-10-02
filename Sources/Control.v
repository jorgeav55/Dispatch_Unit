module Control (
	input [6:0]op_inst,
	output reg [2:0] InstType,
	output reg	Jump,
					JumpR,
					Branch,
					MemRead,
					MemWrite,
					ALUsrc,
					RegWrite,
					PCSave,
	output reg [1:0] 	ALU_Op
							//MemToReg
);

localparam R_Type = 7'h33;
localparam I_Logic_Type = 7'h13;
localparam I_Load_Type = 7'h03;
localparam S_Type = 7'h23;
localparam B_Type = 7'h63;
localparam J_Type = 7'h6F;
localparam I_Jump_Type = 7'h67;
localparam U_Load_Type = 7'h37;
localparam U_Add_Type = 7'h17;

always @ * begin
	case (op_inst)
		R_Type:
		begin
			InstType = 3'b111;
			ALU_Op = 2'b10;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b0;
		end
		I_Logic_Type:
		begin
			InstType = 3'b000;
			ALU_Op = 2'b10;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
			PCSave = 1'b0;
		end
		I_Load_Type:
		begin
			InstType = 3'b000;
			ALU_Op = 2'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b1;
			//MemToReg = 2'b01;
			MemWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
			PCSave = 1'b0;
		end
		S_Type:
		begin
			InstType = 3'b010;
			ALU_Op = 2'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b1;
			ALUsrc = 1'b1;
			RegWrite = 1'b0;
			PCSave = 1'b0;
		end
		B_Type:
		begin
			InstType = 3'b011;
			ALU_Op = 2'b01;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b1;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
			PCSave = 1'b0;
		end
		J_Type:
		begin
			InstType = 3'b100;
			ALU_Op = 2'b00;
			Jump = 1'b1;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b10;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b0;
		end
		I_Jump_Type:
		begin
			InstType = 3'b000;
			ALU_Op = 2'b00;
			Jump = 1'b0;
			JumpR = 1'b1;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b10;
			MemWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
			PCSave = 1'b0;
		end
		U_Load_Type:
		begin
			InstType = 3'b101;
			ALU_Op = 1'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b11;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b0;
		end
		U_Add_Type:
		begin
			InstType = 3'b101;
			ALU_Op = 1'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b10;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
			PCSave = 1'b1;
		end
		default:
		begin
			InstType = 3'b000;
			ALU_Op = 1'b00;
			Jump = 1'b0;
			JumpR = 1'b0;
			Branch = 1'b0;
			MemRead = 1'b0;
			//MemToReg = 2'b00;
			MemWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
			PCSave = 1'b0;
		end
	endcase
end

endmodule