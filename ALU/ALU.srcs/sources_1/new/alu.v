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
    #(  parameter number_bus_input = 5,
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
    (   input wire signed [number_bus_input-1:0] data_a, [number_bus_input-1:0] data_b,
        input wire [number_bus_operation-1:0] operation,
        output reg signed [number_bus_output-1:0] result,
        output reg signed carry,
        output reg signed zero
    );
    
reg [number_bus_output:0] result_aux;

always @(data_a or data_b or operation) begin
    case(operation)
        ADD: begin
            result_aux = data_a + data_b;
            result = result_aux[number_bus_output-1:0];
            carry = result_aux[number_bus_output];
            zero = (result_aux == 5'b0);
            end
        SUB: begin
            carry = 0;
            zero = 0;
            result_aux = data_a - data_b;
            result = result_aux[number_bus_output-1:0];
            zero = (result_aux == 5'b0);
            end
        AND: begin
            carry = 0;
            zero = 0;
            result = data_a & data_b;
            end
        OR: begin
            carry = 0;
            zero = 0;
            result = data_a | data_b;
            end
        XOR: begin
            carry = 0;
            zero = 0;
            result = data_a ^ data_b;
            end
        SRA: begin
            carry = 0;
            zero = 0;
            result = data_a >>> data_b;
            end
        SRL: begin
            carry = 0;
            zero = 0;
            result = data_a << data_b;
            end
        NOR: begin
            carry = 0;
            zero = 0;
            result =~(data_a | data_b);
            end
        default: begin
            result = 0;
            carry = 0;
            zero = 0;
            end
    endcase
end
endmodule
