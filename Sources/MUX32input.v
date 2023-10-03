//////////////////////////////////////////////////////////////////////////////////
// Company: ITESO
// Engineer:  Edgar Barba & Jorge Velazquez
// Module: MUX32input
// Desciption: 
// Data Multiplexer.
// There are 32 input and one output.
// sel value will define de output
//
//////////////////////////////////////////////////////////////////////////////////
module MUX32input 
#(
parameter DATA_WIDTH = 32)(
  input [4:0]sel,
  input [DATA_WIDTH-1:0] Q0,
  input [DATA_WIDTH-1:0] Q1,
  input [DATA_WIDTH-1:0] Q2,
  input [DATA_WIDTH-1:0] Q3,
  input [DATA_WIDTH-1:0] Q4,
  input [DATA_WIDTH-1:0] Q5,
  input [DATA_WIDTH-1:0] Q6,
  input [DATA_WIDTH-1:0] Q7,
  input [DATA_WIDTH-1:0] Q8,
  input [DATA_WIDTH-1:0] Q9,
  input [DATA_WIDTH-1:0] Q10,
  input [DATA_WIDTH-1:0] Q11,
  input [DATA_WIDTH-1:0] Q12,
  input [DATA_WIDTH-1:0] Q13,
  input [DATA_WIDTH-1:0] Q14,
  input [DATA_WIDTH-1:0] Q15,
  input [DATA_WIDTH-1:0] Q16,
  input [DATA_WIDTH-1:0] Q17,
  input [DATA_WIDTH-1:0] Q18,
  input [DATA_WIDTH-1:0] Q19,
  input [DATA_WIDTH-1:0] Q20,
  input [DATA_WIDTH-1:0] Q21,
  input [DATA_WIDTH-1:0] Q22,
  input [DATA_WIDTH-1:0] Q23,
  input [DATA_WIDTH-1:0] Q24,
  input [DATA_WIDTH-1:0] Q25,
  input [DATA_WIDTH-1:0] Q26,
  input [DATA_WIDTH-1:0] Q27,
  input [DATA_WIDTH-1:0] Q28,
  input [DATA_WIDTH-1:0] Q29,
  input [DATA_WIDTH-1:0] Q30,
  input [DATA_WIDTH-1:0] Q31,
  output [DATA_WIDTH-1:0] data
);

reg [DATA_WIDTH-1:0] Dout;
assign data = Dout;
always @ * begin
  case (sel)
    5'd0: Dout = Q0;
    5'd1: Dout = Q1;
    5'd2: Dout = Q2;
    5'd3: Dout = Q3;
    5'd4: Dout = Q4;
    5'd5: Dout = Q5;
    5'd6: Dout = Q6;
    5'd7: Dout = Q7;
    5'd8: Dout = Q8;
    5'd9: Dout = Q9;
    5'd10: Dout = Q10;
    5'd11: Dout = Q11;
    5'd12: Dout = Q12;
    5'd13: Dout = Q13;
    5'd14: Dout = Q14;
    5'd15: Dout = Q15;
    5'd16: Dout = Q16;
    5'd17: Dout = Q17;
    5'd18: Dout = Q18;
    5'd19: Dout = Q19;
    5'd20: Dout = Q20;
    5'd21: Dout = Q21;
    5'd22: Dout = Q22;
    5'd23: Dout = Q23;
    5'd24: Dout = Q24;
    5'd25: Dout = Q25;
    5'd26: Dout = Q26;
    5'd27: Dout = Q27;
    5'd28: Dout = Q28;
    5'd29: Dout = Q29;
    5'd30: Dout = Q30;
    5'd31: Dout = Q31;
	 default: Dout = Dout;
  endcase
end
endmodule  