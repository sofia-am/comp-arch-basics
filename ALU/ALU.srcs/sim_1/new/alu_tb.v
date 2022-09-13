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

//inputs
reg [number_bus_input-1:0] data_a, data_b;
reg [number_bus_operation-1:0] operation;
reg clock;
//outputs
//wire [number_bus_output-1:0] result;
wire [number_bus_output-1:0]o_result;
wire o_carry;
wire o_zero;
wire o_signo;

initial
begin
    clock = 1'b1;
    data_a=1;
    data_b=8'b1111;
    operation=32;
end
always begin
#1
    clock = ~clock;
end
always begin
    #2
    data_a=5;
    data_b=8'b0011;
    operation=32;
    #2
    data_a=3;
    data_b=8;
    operation=34;
    #2
    data_a=10;
    data_b=4;
    operation=34;
    #2
    data_a=5;
    data_b=3;
    operation=36;
    #2
    data_a=5;
    data_b=3;
    operation=37;
    #2
    data_a=5;
    data_b=3;
    operation=38;
    #2
    data_a=5;
    data_b=3;
    operation=3;
    #2
    data_a=5;
    data_b=3;
    operation=2;
    #2
    data_a=5;
    data_b=3;
    operation=39;
    #2
    $finish;
end

alu alu0(
    .data_a(data_a),
    .data_b(data_b),
    .operation(operation),
    .clock(clock),
    .o_result(o_result),
    .o_carry(o_carry),
    .o_zero(o_zero),
    .o_signo(o_signo)/*
    .result(result),
    .carry(carry),
    .zero(zero),
    .signo(signo)*/
);
endmodule
