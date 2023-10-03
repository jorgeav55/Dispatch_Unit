module Branch_Stall_Logic (
	clk,
	reset,
	Branch,
	Issueque_full_int,
	cdb_branch,
	cdb_branch_taken,
	stall
	
);

input			clk,
				reset,
				Branch,
				Issueque_full_int,
				cdb_branch,
				cdb_branch_taken;
output reg 	stall;

localparam Not_STALL = 1'b0;
localparam STALL = 1'b1;

reg  state;

always @(posedge reset, posedge clk)
		begin
		if (reset) 
			state<= Not_STALL;
		else 
			case(state)
				Not_STALL: 	if ((Branch == 1'b1) && (Issueque_full_int == 1'b0))
									state <= STALL;
								else if (((Branch == 1'b1) && (Issueque_full_int == 1'b0))== 1'b0)
									state <= Not_STALL;
				STALL:		if  (cdb_branch == 1'b1)
									state <= Not_STALL;
								else if (cdb_branch == 1'b0)
									state <= STALL;
				default: 	state<= Not_STALL;
			endcase
		end
		
always @*
	begin
			case(state)
			Not_STALL: 	begin
							stall = 1'b0;
							end
			STALL: 		begin
							stall = 1'b1;
							end 
			default:		stall = 1'b0;
			endcase
	end
endmodule
		
			
				