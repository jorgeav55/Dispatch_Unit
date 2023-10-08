module Register_Status_Table (
	clk,
	reset,
	write_data0,
	write_address0,
	write_enable0,
	//write_data1,
	//write_enable1,
	read_address0,
	read_tag0,
	read_valid0,
	read_address1,
	read_tag1,
	read_valid1,
	cdb_tag,
	cdb_valid,
	RF_write_enable
);

input clk;
input reset;
input [6:0] write_data0;
input [4:0] write_address0;
input write_enable0;
//input [6:0] write_data1;
//input [31:0] write_enable1;
input [4:0] read_address0;
output [5:0] read_tag0;
output read_valid0;
input [4:0] read_address1;
output [5:0] read_tag1;
output read_valid1;
input [5:0] cdb_tag;
input cdb_valid;
output [31:0] RF_write_enable;

wire [6:0] rst_out [31:0];
wire [6:0] rst_in  [31:0];
//wire rst_sync_reset [31:0];
wire rst_enable [31:0];


genvar i;
generate
	for (i=0;i<32;i=i+1) begin: Ins
		Register 
		#(
			.DATA_WIDTH(7)) R 
		(
			.data_in			(rst_in[i]),
			.dafault_data	(7'b0),
			.reset			(reset),
			.enable			(rst_enable[i]),
			.flush			(1'b0),
			.clk				(clk),
			.data_out		(rst_out[i])
		);
	end
endgenerate

MUX32input 
#(
.DATA_WIDTH(7))
RsTag0(
  .sel(read_address0),
  .Q0(rst_out[0]),
  .Q1(rst_out[1]),
  .Q2(rst_out[2]),
  .Q3(rst_out[3]),
  .Q4(rst_out[4]),
  .Q5(rst_out[5]),
  .Q6(rst_out[6]),
  .Q7(rst_out[7]),
  .Q8(rst_out[8]),
  .Q9(rst_out[9]),
  .Q10(rst_out[10]),
  .Q11(rst_out[11]),
  .Q12(rst_out[12]),
  .Q13(rst_out[13]),
  .Q14(rst_out[14]),
  .Q15(rst_out[15]),
  .Q16(rst_out[16]),
  .Q17(rst_out[17]),
  .Q18(rst_out[18]),
  .Q19(rst_out[19]),
  .Q20(rst_out[20]),
  .Q21(rst_out[21]),
  .Q22(rst_out[22]),
  .Q23(rst_out[23]),
  .Q24(rst_out[24]),
  .Q25(rst_out[25]),
  .Q26(rst_out[26]),
  .Q27(rst_out[27]),
  .Q28(rst_out[28]),
  .Q29(rst_out[29]),
  .Q30(rst_out[30]),
  .Q31(rst_out[31]),
  .data({read_valid0,read_tag0})
);
MUX32input 
#(
.DATA_WIDTH(7))
RsTag1(
  .sel(read_address1),
  .Q0(rst_out[0]),
  .Q1(rst_out[1]),
  .Q2(rst_out[2]),
  .Q3(rst_out[3]),
  .Q4(rst_out[4]),
  .Q5(rst_out[5]),
  .Q6(rst_out[6]),
  .Q7(rst_out[7]),
  .Q8(rst_out[8]),
  .Q9(rst_out[9]),
  .Q10(rst_out[10]),
  .Q11(rst_out[11]),
  .Q12(rst_out[12]),
  .Q13(rst_out[13]),
  .Q14(rst_out[14]),
  .Q15(rst_out[15]),
  .Q16(rst_out[16]),
  .Q17(rst_out[17]),
  .Q18(rst_out[18]),
  .Q19(rst_out[19]),
  .Q20(rst_out[20]),
  .Q21(rst_out[21]),
  .Q22(rst_out[22]),
  .Q23(rst_out[23]),
  .Q24(rst_out[24]),
  .Q25(rst_out[25]),
  .Q26(rst_out[26]),
  .Q27(rst_out[27]),
  .Q28(rst_out[28]),
  .Q29(rst_out[29]),
  .Q30(rst_out[30]),
  .Q31(rst_out[31]),
  .data({read_valid1,read_tag1})
);

generate
	for (i=0;i<32;i=i+1) begin : en_
		assign rst_enable[i] = ((((rst_out[i] == {1'b1,cdb_tag}) && (cdb_valid == 1'b1)) || (write_address0 == i)) && (write_enable0))? 1'b1: 1'b0;
		assign RF_write_enable[i] = ((rst_out[i] == {1'b1,cdb_tag}) && (cdb_valid == 1'b1)) ? 1'b1 : 1'b0;
		assign rst_in[i] = (write_address0 == i) ? write_data0 : 7'b0;
	end
endgenerate
endmodule