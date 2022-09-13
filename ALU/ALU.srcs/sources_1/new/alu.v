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

module alu
    #(  parameter number_bus_input = 4,
        parameter number_bus_output = 5,
        parameter number_bus_operation = 6,
        
        parameter ADD = 6'b100000,
        parameter SUB = 6'b100010,
        parameter AND = 6'b100100,
        parameter OR  = 6'b100101,
        parameter XOR = 6'b100110,
        parameter SRA = 6'b000011,
        parameter SRL = 6'b000010,
        parameter NOR = 6'b100111
     )
    (   input wire [number_bus_input-1:0] data_a, [number_bus_input-1:0] data_b,
        input wire [number_bus_operation-1:0] operation,
        output reg [number_bus_output-1:0] result,
        output reg carry, //si no se define nada, es de 1 bit
        output reg zero,
        output reg signo,
        output wire [number_bus_output-1:0] o_result,
        output wire o_carry,
        output wire o_zero,
        output wire o_signo
    );
    
reg [number_bus_output:0] result_aux;

always @(data_a or data_b or operation) begin
    case(operation)
        ADD: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a + data_b;
            carry = (result[number_bus_output-1] == 1'b1);
            zero = (result == {number_bus_output{1'b0}});
            result = result[number_bus_output-1:0];
            end
        SUB: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            if(data_b > data_a) begin
               signo = 1;
               result = data_b - data_a;
            end
            else if(data_b < data_a) begin
                signo = 1'b0;
                result = data_a - data_b;
            end
            else if(data_b == data_a) begin
               signo = 1'b0;
               result = {number_bus_input{1'b0}};
            end
            zero = (result == 5'b0);
            result = result[number_bus_output-1:0];
            end
        AND: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a & data_b;
            end
        OR: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a | data_b;
            end
        XOR: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a ^ data_b;
            end
        SRA: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a >>> data_b;
            end
        SRL: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a << data_b;
            end
        NOR: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result =~(data_a | data_b);
            end
        default: begin
            result = {number_bus_input{1'b0}};
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            end
    endcase
    /*
    assign result = o_result;
    assign carry = o_carry;
    assign zero = o_zero;
    assign signo = o_signo;
    */
end
endmodule
