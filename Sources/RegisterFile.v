//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer:  Edgar Barba & Jorge Velazquez
// Module: RegisterFile
// Description: 
// Set of 32 Register for multiple purposes with selector and write control.
// 
//////////////////////////////////////////////////////////////////////////////////
module RegisterFile #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)(
  clk,
  reset,
  write_enable,
  write_data,
  read_address0,
  read_data0,
  read_address1,
  read_data1
);

input clk;
input reset;
input [31:0] write_enable;
input [(DATA_WIDTH-1):0] write_data;
input [(ADDR_WIDTH-1):0] read_address0;
input [(ADDR_WIDTH-1):0] read_address1;
output [(DATA_WIDTH-1):0] read_data0;
output [(DATA_WIDTH-1):0] read_data1;
  
wire [DATA_WIDTH-1:0] Q [2**ADDR_WIDTH-1:0]; //Declaration for all the output wires of each Register.
//wire en [DATA_WIDTH-1:1]; //Declaration for all enable wires of each Register.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Registers declaration.
Registers Regs (
 .D(write_data),
 .clk(clk),
 .rst(reset),
 .en0(1'b0),
 .en1(write_enable[1]),
 .en2(write_enable[2]),
 .en3(write_enable[3]),
 .en4(write_enable[4]),
 .en5(write_enable[5]),
 .en6(write_enable[6]),
 .en7(write_enable[7]),
 .en8(write_enable[8]),
 .en9(write_enable[9]),
 .en10(write_enable[10]),
 .en11(write_enable[11]),
 .en12(write_enable[12]),
 .en13(write_enable[13]),
 .en14(write_enable[14]),
 .en15(write_enable[15]),
 .en16(write_enable[16]),
 .en17(write_enable[17]),
 .en18(write_enable[18]),
 .en19(write_enable[19]),
 .en20(write_enable[20]),
 .en21(write_enable[21]),
 .en22(write_enable[22]),
 .en23(write_enable[23]),
 .en24(write_enable[24]),
 .en25(write_enable[25]),
 .en26(write_enable[26]),
 .en27(write_enable[27]),
 .en28(write_enable[28]),
 .en29(write_enable[29]),
 .en30(write_enable[30]),
 .en31(write_enable[31]),
 .Q0(Q[0]),
 .Q1(Q[1]),
 .Q2(Q[2]),
 .Q3(Q[3]),
 .Q4(Q[4]),
 .Q5(Q[5]),
 .Q6(Q[6]),
 .Q7(Q[7]),
 .Q8(Q[8]),
 .Q9(Q[9]),
 .Q10(Q[10]),
 .Q11(Q[11]),
 .Q12(Q[12]),
 .Q13(Q[13]),
 .Q14(Q[14]),
 .Q15(Q[15]),
 .Q16(Q[16]),
 .Q17(Q[17]),
 .Q18(Q[18]),
 .Q19(Q[19]),
 .Q20(Q[20]),
 .Q21(Q[21]),
 .Q22(Q[22]),
 .Q23(Q[23]),
 .Q24(Q[24]),
 .Q25(Q[25]),
 .Q26(Q[26]),
 .Q27(Q[27]),
 .Q28(Q[28]),
 .Q29(Q[29]),
 .Q30(Q[30]),
 .Q31(Q[31])
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//32 to 1 Output MUX for RD1 selection.
MUX32input rd1Out(
  .sel(read_address0),
  .Q0(Q[0]),
  .Q1(Q[1]),
  .Q2(Q[2]),
  .Q3(Q[3]),
  .Q4(Q[4]),
  .Q5(Q[5]),
  .Q6(Q[6]),
  .Q7(Q[7]),
  .Q8(Q[8]),
  .Q9(Q[9]),
  .Q10(Q[10]),
  .Q11(Q[11]),
  .Q12(Q[12]),
  .Q13(Q[13]),
  .Q14(Q[14]),
  .Q15(Q[15]),
  .Q16(Q[16]),
  .Q17(Q[17]),
  .Q18(Q[18]),
  .Q19(Q[19]),
  .Q20(Q[20]),
  .Q21(Q[21]),
  .Q22(Q[22]),
  .Q23(Q[23]),
  .Q24(Q[24]),
  .Q25(Q[25]),
  .Q26(Q[26]),
  .Q27(Q[27]),
  .Q28(Q[28]),
  .Q29(Q[29]),
  .Q30(Q[30]),
  .Q31(Q[31]),
  .data(read_data0)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//32 to 1 Output MUX for RD2 selection.
MUX32input rd2Out(
  .sel(read_address1),
  .Q0(Q[0]),
  .Q1(Q[1]),
  .Q2(Q[2]),
  .Q3(Q[3]),
  .Q4(Q[4]),
  .Q5(Q[5]),
  .Q6(Q[6]),
  .Q7(Q[7]),
  .Q8(Q[8]),
  .Q9(Q[9]),
  .Q10(Q[10]),
  .Q11(Q[11]),
  .Q12(Q[12]),
  .Q13(Q[13]),
  .Q14(Q[14]),
  .Q15(Q[15]),
  .Q16(Q[16]),
  .Q17(Q[17]),
  .Q18(Q[18]),
  .Q19(Q[19]),
  .Q20(Q[20]),
  .Q21(Q[21]),
  .Q22(Q[22]),
  .Q23(Q[23]),
  .Q24(Q[24]),
  .Q25(Q[25]),
  .Q26(Q[26]),
  .Q27(Q[27]),
  .Q28(Q[28]),
  .Q29(Q[29]),
  .Q30(Q[30]),
  .Q31(Q[31]),
  .data(read_data1)
);

endmodule
