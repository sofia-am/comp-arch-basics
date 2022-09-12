`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu
// Project Name: TP1 ALU - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya, Matias
// Target Devices: Basys2/3
// Description: 
// Implementaci�n de una ALU b�sica con un testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module alu_tb( );
parameter number_bus_input = 4;
parameter number_bus_output = 5;
parameter number_bus_operation = 6;

reg [number_bus_input-1:0] data_a, data_b;
reg [number_bus_operation-1:0] operation;
wire [number_bus_output-1:0] result;
wire carry;
wire zero;
wire signo;

initial
begin
    data_a=1;
    data_b=8'b1111;
    operation=32;
    #10
    data_a=5;
    data_b=8'b0011;
    operation=32;
    #10
    data_a=3;
    data_b=8;
    operation=34;
    #10
    data_a=10;
    data_b=4;
    operation=34;
    #10
    data_a=5;
    data_b=3;
    operation=36;
    #10
    data_a=5;
    data_b=3;
    operation=37;
    #10
    data_a=5;
    data_b=3;
    operation=38;
    #10
    data_a=5;
    data_b=3;
    operation=3;
    #10
    data_a=5;
    data_b=3;
    operation=2;
    #10
    data_a=5;
    data_b=3;
    operation=39;
    #10
    $finish;
end

alu alu0(
    .data_a(data_a),
    .data_b(data_b),
    .operation(operation),
    .result(result),
    .carry(carry),
    .zero(zero),
    .signo(signo)
);
endmodule
