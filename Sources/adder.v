module adder #(parameter LENGTH = 32)(
//Inputs
 input signed [LENGTH-1:0] A,
 input signed [LENGTH-1:0] B,
 output signed [LENGTH-1:0] suma
);

//Set All the ALU logic into wires outside the Always statement.
assign suma = A+B;     //Current assignment for sum of two signed numbers (a, b)

endmodule