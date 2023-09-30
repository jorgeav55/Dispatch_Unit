//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer:  Edgar Barba & Jorge Velazquez
// Module: SignExt
// Description: 
// Sing extension for Immideate data.
//////////////////////////////////////////////////////////////////////////////////
module imm(
  input [24:0]Datain,
  input [2:0]Ins_type,
  output reg [31:0]Imm
);

localparam I_type			= 3'b000;  //1
//localparam I_typeShift	= 3'b001;  //1
localparam S_type			= 3'b010;  //1
localparam B_type			= 3'b011;  //1
localparam J_type			= 3'b100;  //1
localparam U_type			= 3'b101;  //1

always @* begin
	case(Ins_type)
		I_type:		Imm= {{20{Datain[24]}},Datain[24:13]};
		//I_typeShift:Imm= {{27{Datain[24]}},Datain[17:13]};
		S_type: 		Imm= {{20{Datain[24]}},Datain[24:18],Datain[4:0]};
		B_type: 		Imm= {{19{Datain[24]}},Datain[24],Datain[0],Datain[23:18],Datain[4:1],1'b0};
		J_type: 		Imm= {{11{Datain[24]}},Datain[24],Datain[12:5],Datain[13],Datain[23:14],1'b0};
		U_type: 		Imm= {Datain[24:5],{12{1'b0}}};
		default: 	Imm=32'h00000000;
	endcase
end


endmodule