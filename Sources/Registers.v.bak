module Registers #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)(
 input [(DATA_WIDTH-1):0] D,
 input clk,
 input rst,
 input en0,
 input en1,
 input en2,
 input en3,
 input en4,
 input en5,
 input en6,
 input en7,
 input en8,
 input en9,
 input en10,
 input en11,
 input en12,
 input en13,
 input en14,
 input en15,
 input en16,
 input en17,
 input en18,
 input en19,
 input en20,
 input en21,
 input en22,
 input en23,
 input en24,
 input en25,
 input en26,
 input en27,
 input en28,
 input en29,
 input en30,
 input en31,
 output [(DATA_WIDTH-1):0] Q0,
 output [(DATA_WIDTH-1):0] Q1,
 output [(DATA_WIDTH-1):0] Q2,
 output [(DATA_WIDTH-1):0] Q3,
 output [(DATA_WIDTH-1):0] Q4,
 output [(DATA_WIDTH-1):0] Q5,
 output [(DATA_WIDTH-1):0] Q6,
 output [(DATA_WIDTH-1):0] Q7,
 output [(DATA_WIDTH-1):0] Q8,
 output [(DATA_WIDTH-1):0] Q9,
 output [(DATA_WIDTH-1):0] Q10,
 output [(DATA_WIDTH-1):0] Q11,
 output [(DATA_WIDTH-1):0] Q12,
 output [(DATA_WIDTH-1):0] Q13,
 output [(DATA_WIDTH-1):0] Q14,
 output [(DATA_WIDTH-1):0] Q15,
 output [(DATA_WIDTH-1):0] Q16,
 output [(DATA_WIDTH-1):0] Q17,
 output [(DATA_WIDTH-1):0] Q18,
 output [(DATA_WIDTH-1):0] Q19,
 output [(DATA_WIDTH-1):0] Q20,
 output [(DATA_WIDTH-1):0] Q21,
 output [(DATA_WIDTH-1):0] Q22,
 output [(DATA_WIDTH-1):0] Q23,
 output [(DATA_WIDTH-1):0] Q24,
 output [(DATA_WIDTH-1):0] Q25,
 output [(DATA_WIDTH-1):0] Q26,
 output [(DATA_WIDTH-1):0] Q27,
 output [(DATA_WIDTH-1):0] Q28,
 output [(DATA_WIDTH-1):0] Q29,
 output [(DATA_WIDTH-1):0] Q30,
 output [(DATA_WIDTH-1):0] Q31
);

wire enable [DATA_WIDTH-1:0];
wire [DATA_WIDTH-1:0] Qout [DATA_WIDTH-1:0];

assign enable[0] = en0;
assign enable[1] = en1;
assign enable[2] = en2;
assign enable[3] = en3;
assign enable[4] = en4;
assign enable[5] = en5;
assign enable[6] = en6;
assign enable[7] = en7;
assign enable[8] = en8;
assign enable[9] = en9;
assign enable[10] = en10;
assign enable[11] = en11;
assign enable[12] = en12;
assign enable[13] = en13;
assign enable[14] = en14;
assign enable[15] = en15;
assign enable[16] = en16;
assign enable[17] = en17;
assign enable[18] = en18;
assign enable[19] = en19;
assign enable[20] = en20;
assign enable[21] = en21;
assign enable[22] = en22;
assign enable[23] = en23;
assign enable[24] = en24;
assign enable[25] = en25;
assign enable[26] = en26;
assign enable[27] = en27;
assign enable[28] = en28;
assign enable[29] = en29;
assign enable[30] = en30;
assign enable[31] = en31;

assign Q0 = Qout[0];
assign Q1 = Qout[1];
assign Q2 = Qout[2];
assign Q3 = Qout[3];
assign Q4 = Qout[4];
assign Q5 = Qout[5];
assign Q6 = Qout[6];
assign Q7 = Qout[7];
assign Q8 = Qout[8];
assign Q9 = Qout[9];
assign Q10 = Qout[10];
assign Q11 = Qout[11];
assign Q12 = Qout[12];
assign Q13 = Qout[13];
assign Q14 = Qout[14];
assign Q15 = Qout[15];
assign Q16 = Qout[16];
assign Q17 = Qout[17];
assign Q18 = Qout[18];
assign Q19 = Qout[19];
assign Q20 = Qout[20];
assign Q21 = Qout[21];
assign Q22 = Qout[22];
assign Q23 = Qout[23];
assign Q24 = Qout[24];
assign Q25 = Qout[25];
assign Q26 = Qout[26];
assign Q27 = Qout[27];
assign Q28 = Qout[28];
assign Q29 = Qout[29];
assign Q30 = Qout[30];
assign Q31 = Qout[31];

genvar i;
generate
	for (i=0;i<2;i=i+1) begin: R0_1
		Register_RF R (
			.D(D),
			.dafault_D(32'h0000_0000),
			.rst(rst),
			.en(enable[i]),
			.clk(clk),
			.Q(Qout[i])
		);
	end
	for (i=3;i<32;i=i+1) begin: R3_31
		Register_RF R (
			.D(D),
			.dafault_D(32'h0000_0000),
			.rst(rst),
			.en(enable[i]),
			.clk(clk),
			.Q(Qout[i])
		);
	end
endgenerate
Register_RF SP (
			.D(D),
			.dafault_D(32'h7FFF_EFFC), //0x7fffeffc
			.rst(rst),
			.en(enable[2]),
			.clk(clk),
			.Q(Qout[2])
		);
endmodule