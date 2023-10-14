
`timescale 1ns / 1ps
module Dispatch_tb;

wire empty;
wire [31:0] instruction;
wire [31:0] current_PC;

wire [3:0] dispatch_opcode;
wire dispatch_en_integer,
     dispatch_en_ld_st,
     dispatch_en_mul,
     dispatch_en_div,
	  dispatch_rs1_valid,
	  dispatch_rs2_valid;
wire [5:0] 	dispatch_rd_tag,
				dispatch_rs1_tag,
				dispatch_rs2_tag;
wire [31:0]	dispatch_rs1_data,
				dispatch_rs2_data;
wire jb_en;
wire [31:0]	jb_address;


reg 	issueque_full_integer;
reg	issueque_full_ld_st;
reg  	issueque_full_mul;
reg	issueque_full_div;

reg [5:0] CDB_tag;
reg CDB_valid;
reg [31:0] CDB_data;
reg CDB_branch;
reg CDB_branch_taken;

reg clk;
reg reset;
wire rd_en;

reg [5:0] CDB_tag_random [63:0];
reg [5:0]i, j, rand_alt, rand_delay, rand_delay_int, rand_delay_mul_div;
reg [1:0] rand_alt_exec;

I_Fetch
#(
.DATA_WIDTH(32), 
.ADDRESS_WIDTH(32)) 
UUT0(
	.clk(clk),
	.reset(reset),
	.Read_enable(rd_en),
	.jump_branch_valid(jb_en),
	.jump_branch_address(jb_address),
	.empty(empty),
	.instruction(instruction),
	.PC_out(current_PC)
);

Dispatch_Unit
#(
.DATA_WIDTH(32), 
.REGISTER_WIDTH(7))
UUT1(
//Inputs
	.clk(clk),
	.reset(reset),
//	.empty(empty),
	.Instruction(instruction),
	.PC_out(current_PC),
	.CDB_tag(CDB_tag),
	.CDB_valid(CDB_valid),
	.CDB_data(CDB_data),
	.CDB_branch(CDB_branch),
	.CDB_branch_taken(CDB_branch_taken),
	.issueque_full_integer(issueque_full_integer),
	.issueque_full_ld_st(issueque_full_ld_st),
	.issueque_full_mul(issueque_full_mul),
	.issueque_full_div(issueque_full_div),
//O.utputs
	.Read_enable(rd_en),
	.jump_branch_valid(jb_en),
	.jump_branch_address(jb_address),
	.dispatch_opcode(dispatch_opcode),
	.dispatch_en_integer(dispatch_en_integer),
	.dispatch_en_ld_st(dispatch_en_ld_st),
	.dispatch_en_mul(dispatch_en_mul),
	.dispatch_en_div(dispatch_en_div),
	.dispatch_rd_tag(dispatch_rd_tag),
	.dispatch_rs1_data(dispatch_rs1_data),
	.dispatch_rs1_tag(dispatch_rs1_tag),
	.dispatch_rs1_valid(dispatch_rs1_valid),
	.dispatch_rs2_data(dispatch_rs2_data),
	.dispatch_rs2_tag(dispatch_rs2_tag),
	.dispatch_rs2_valid(dispatch_rs2_valid)
);

initial begin
	rand_alt = 1'b0;
	i = 1'b0;
	j = 1'b0;
	issueque_full_integer = 1'b0;
   issueque_full_ld_st = 1'b0;
   issueque_full_mul = 1'b0;
   issueque_full_div = 1'b0;
	CDB_tag = 6'b0;
	CDB_valid = 1'b0;
	CDB_data = 32'b0;
	CDB_branch = 1'b0;
	CDB_branch_taken = 1'b0;
	clk = 1'b0;
	reset = 1'b1;
	//rd_en = 1'b1;
	#1
	reset			= 1'b0;
end
always begin
	#1 
	clk = ~clk;
end

always begin
	
	@(posedge clk);
	exe_unit_full;
	end
	
always begin
	#1
	branch;
	end

always begin 
	#(($urandom_range(0, 2))*2+1);
	@(posedge clk);
	random_CDB();

end

always begin
	capture_CDB();
	@(posedge clk);
end

always begin
	@(negedge clk);
	
	mul_unit_full;
	end
	


task capture_CDB(); begin
	if ((dispatch_en_integer || dispatch_en_mul || dispatch_en_div) && ~reset) begin
	CDB_tag_random[i] = dispatch_rd_tag;
	i = i + 1'b1;
	end
end
endtask

task random_CDB();
begin
	rand_alt = $urandom_range(0, i-1'b1);
	CDB_tag = CDB_tag_random[rand_alt];
	CDB_valid = 1'b1;
	CDB_data = $random;
	@(posedge clk);
	CDB_valid = 1'b0;
	for (j = rand_alt; j<i; j=j+1'b1)
		begin
			CDB_tag_random[j] = CDB_tag_random[j+1];
		end
		i = i - 1'b1;
end	
endtask 

task branch;
begin: bbc
	integer delay;
	rand_delay =  $urandom_range(2, 5);
	if (UUT1.branch == 1'b1)begin
	for (delay = 0; delay<rand_delay; delay=delay+1)
		begin
			 @(posedge clk);
		end
		CDB_branch = 1'b1;
		CDB_branch_taken = 1'b1;	
		@(posedge clk);
		CDB_branch = 1'b0;
		CDB_branch_taken = 1'b0;
	end
end
endtask


task exe_unit_full;
begin: full
	integer delay;	
	
	if (UUT1.Decoder.int_enabler == 1'b1 && ~reset )begin
	rand_alt_exec = $urandom_range(0, 3);
	rand_delay_int =  $urandom_range(0 , 2);
		if (rand_alt_exec == 2'b00)begin
		issueque_full_integer = 1'b1;
		for (delay = 0; delay<rand_delay_int; delay=delay+1)
			begin
				  @(posedge clk);
			end
			@(posedge clk);
			issueque_full_integer = 1'b0;

		end
		else if (rand_alt_exec == 2'b01) begin
			issueque_full_integer = 1'b0;
		end
		else if (rand_alt_exec == 2'b10) begin
			issueque_full_integer = 1'b0;
		end
		else if (rand_alt_exec == 2'b11) begin
			issueque_full_integer = 1'b0;
		end
	end

	
		
end
endtask

task mul_unit_full;
begin: mul_full
	integer delay;
	
	if (UUT1.Decoder.mul_enabler == 1'b1)begin
	rand_delay_mul_div =  $urandom_range(2, 4);
	issueque_full_mul = 1'b1; 	
		for (delay = 0; delay<rand_delay_mul_div; delay=delay+1)
			begin				
				 @(posedge clk);
					
			end
			issueque_full_mul = 1'b0;
			@(posedge clk);

	
	end
	else if (UUT1.Decoder.div_enabler == 1'b1)begin
	issueque_full_div = 1'b1;
	rand_delay_mul_div =  $urandom_range(2 , 3);
		for (delay = 0; delay<rand_delay_mul_div; delay=delay+1)
			begin
				 @(posedge clk);
				 
			end
			issueque_full_div = 1'b0;
			@(posedge clk);

	end
end
endtask


endmodule


