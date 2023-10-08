module Tag_FIFO
#(
	parameter TAG_WIDTH = 6)
(
//Inputs
	clk,
	reset,
	flush,
	cdb_tag_tf,
	cdb_tag_tf_valid,
	ren_tf,
//Outputs
	tagout_tf,
	//ff_tf,
	ef_tf

);

input 									clk;
input 									reset;
input 									flush;
input 									cdb_tag_tf_valid;
input	 		[TAG_WIDTH-1:0]		cdb_tag_tf;
input 									ren_tf;
output 		[TAG_WIDTH-1:0]		tagout_tf;
//output									ff_tf;
output 									ef_tf;

reg 	[6:0]		RP,
					WP;
wire 				enable [63:0];
wire [TAG_WIDTH-1:0] Data_out [63:0];
//Condition to know if the fifo is empty					
assign 	ef_tf = (WP == RP)? 1'b1 : 1'b0;
//Condition to know if the fifo is full
//assign	ff_tf = ((WP[5:0] == RP[5:0]) && (WP[6] != RP[6])) ? 1'b1 : 1'b0;

assign   tagout_tf = Data_out[RP[5:0]];

					
always @(posedge reset, posedge clk) begin
	if (reset == 1'b1)begin
		RP <= 7'b0000000;
		WP <= 7'b1000000;
		end
	else begin 
		if (ren_tf == 1'b1) begin
			RP <= RP + 1'b1;
		end
		else
			RP <= RP;
		if (cdb_tag_tf_valid == 1'b1) begin
			WP <= WP + 1'b1;
		end 
		else
			WP <= WP;
	end
end 


genvar i;
generate
	for (i=0;i<64;i=i+1) begin: Ins
		
		Register_df 
		#(
			.DATA_WIDTH(TAG_WIDTH)) R 
		(
			.data_in			(cdb_tag_tf),
			.dafault_data	(i[5:0]),
			.reset			(reset),
			.enable			(enable[i]),
			.flush			(flush),
			.clk				(clk),
			.data_out		(Data_out[i])
		);
		
		assign enable[i] = ((cdb_tag_tf_valid == 1'b1) && (WP[5:0] == i[5:0])) ? 1'b1: 1'b0;
	end
endgenerate






endmodule