
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
	
/*tast encargada de capturar un tag registro del RST para cada rd.
Cada que el dispatcher de enteros, multiplicaciones, y division
se hace una captura del registro en un arreglo de 64 lugares,
por lo tanto, el inidice i va aumentando cada que un CDB es publicado
*/

task capture_CDB(); begin
	if ((dispatch_en_integer || dispatch_en_mul || dispatch_en_div) && ~reset) begin
	//Arreglo para guradar registros rd con tag publicados en el CDB  que aun no son validos
	CDB_tag_random[i] = dispatch_rd_tag;
	i = i + 1'b1;
	end
end
endtask
/*
Task para publicar Tags validos en el CDB, de forma aleatoria usando urandom_range(), del arreglo donde
han sido guardados en la task anterior, al sacar un Tag  y publicarlo de forma aleatoria, 
-Con esto comprobamos que la BFM responda a tags validos de instrucciones que ya han sido despachadas.
-Ademas evitar debbugear escenarios invalidos.
-Se valida que la respuesta de los tags este fuera de orden a como se despacharon las instrucciones.
Por ultimo se hace un reordenamiento del arreglo, para evitar publicar tags que ya han sido publicados
*/
task random_CDB();
begin
	//Random del la longitud del arreglo con tags despachados
	rand_alt = $urandom_range(0, i-1'b1);
	//Publicacion del tag del CDB
	CDB_tag = CDB_tag_random[rand_alt];
	CDB_valid = 1'b1;
	CDB_data = $random;
	@(posedge clk);
	CDB_valid = 1'b0;
	//reordenamiento del arreglo desde la posicion aleatoria del tag que se publico
	for (j = rand_alt; j<i; j=j+1'b1)
		begin
			CDB_tag_random[j] = CDB_tag_random[j+1];
		end
		i = i - 1'b1;
end	
endtask 

/* 
Task para validar cuando una instruccion branch llega el dispatch.
Se sabe que llego la instruccion, entonces la task agrega una cantidad 
random del ciclos de reloj, mientras el stall esta prensente, hata que 
el resultado del branch es publicado
-Con esto estamos validando una vez que la instruccion de branch sea despachada
un tiempo despues sea publicado el resultado.*/
task branch;
begin: bbc
	integer delay;
	rand_delay =  $urandom_range(2, 5);
	//Condicion para validar que una intruccion branch llego al dispatch
	if (UUT1.branch == 1'b1)begin
	//For para agregar unos ciclos de reloj aleatorios, hasta que se publica el resultado
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

/* 
Task para validar los casos en que las colas de ejecucion de entero estan llenas
-Se hace el test bench de tal forma que cada que un despacho de enteros es valido
-Se hace una evaluacion aleatoria, para casos en los que la variable random es cero
-Se hace un issueque_full_integer = 1'b1; por lo tanto el dispatch deberia hacer stall
el tiempo que lo determine la variable urandom_range entre 1 y 3 ciclos.*/
task exe_unit_full;
begin: full
	integer delay;	
	//evaluacion del dispatch de enteros
	if (UUT1.Decoder.int_enabler == 1'b1 && ~reset )begin
	rand_alt_exec = $urandom_range(0, 3);
	rand_delay_int =  $urandom_range(0 , 1);
	//Si la variable random es cero, manda un tiempo randon de full_issueque
		if (rand_alt_exec == 2'b00)begin
		issueque_full_integer = 1'b1;
		for (delay = 0; delay<rand_delay_int; delay=delay+1)
			begin
				  @(posedge clk);
			end
			@(posedge clk);
			issueque_full_integer = 1'b0;
	//De lo contrario full_issueque es cero y siegue mandando instrucciones
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

/* 
Task para validar los casos en que las colas de ejecucion de multiplicacion y division
estan llenas
-Se hace el test bench de tal forma que cada que un despacho de multiplicacion o division
-Se manda un full de las unidades por un tiempo aleatorio dado por una variable random
-Se hace un issueque_full_ = 1'b1; por lo tanto el dispatch deberia hacer stall
el tiempo que lo determine la variable urandom_range entre 2 y 4 ciclos.*/
task mul_unit_full;
begin: mul_full
	integer delay;
	//Condicion cuando se despacha una multiplicacion
	if (UUT1.Decoder.mul_enabler == 1'b1)begin
	rand_delay_mul_div =  $urandom_range(2, 4);
	issueque_full_mul = 1'b1; 	
	//Ciclo de reloj aleatorios
		for (delay = 0; delay<rand_delay_mul_div; delay=delay+1)
			begin				
				 @(posedge clk);
					
			end
			issueque_full_mul = 1'b0;
			@(posedge clk);

	end
	//Condicion cuando se despacha una division
	else if (UUT1.Decoder.div_enabler == 1'b1)begin
	issueque_full_div = 1'b1;
	rand_delay_mul_div =  $urandom_range(2 , 3);
	//Ciclo de reloj aleatorios
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


