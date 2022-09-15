`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu
// Project Name: TP1 ALU - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya, Matias
// Target Devices: Basys2/3
// Description: 
// Implementacion de una ALU basica con un testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module alu
    #(  parameter INPUT_SIZE = 4,
        parameter OUTPUT_SIZE = 4,
        parameter OPCODE_SIZE = 6    
     )
    (   
        input wire [INPUT_SIZE-1:0] data_a,
        input wire [INPUT_SIZE-1:0] data_b,
        input wire [OPCODE_SIZE-1:0] opcode,
        input wire clock,
        output wire [OUTPUT_SIZE-1:0] o_result,
        output wire o_carry,
        output wire o_zero,
        output wire o_signo
    );

//parámetros para facilitar la comprensión de los switch cases
localparam ADD = 6'b100000;
localparam SUB = 6'b100010;
localparam AND = 6'b100100;
localparam OR  = 6'b100101;
localparam XOR = 6'b100110;
localparam SRA = 6'b000011;
localparam SRL = 6'b000010;
localparam NOR = 6'b100111;

reg [OUTPUT_SIZE-1:0] result = {OUTPUT_SIZE{1'b0}};
reg carry; //si no se define nada, es de 1 bit
reg zero;
reg signo;
 
//always @(posedge clock) begin
always @(data_a or data_b or opcode) begin   

    carry = 1'b0;
    zero = 1'b0;
    signo = 1'b0;
    
    case(opcode)
        ADD: begin
            result = data_a + data_b;
            carry = (result[OUTPUT_SIZE-1] == 1'b1);
            zero = (result == {OUTPUT_SIZE{1'b0}});
            result = result[OUTPUT_SIZE-1:0];
            end
        SUB: begin
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
                result = {INPUT_SIZE{1'b0}};
            end
            zero = (result == 5'b0);
            result = result[OUTPUT_SIZE-1:0];
            end
        AND: begin
            result = data_a & data_b;
            end
        OR: begin
            result = data_a | data_b;
            end
        XOR: begin
            result = data_a ^ data_b;
            end
        SRA: begin
            result = data_a >>> data_b;
            end
        SRL: begin
            result = data_a << data_b;
            end
        NOR: begin
            result =~(data_a | data_b);
            end
        default: begin
            result = {INPUT_SIZE{1'b0}};
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            end
    endcase
end
    assign o_result = result;
    assign o_carry = carry;
    assign o_zero = zero;
    assign o_signo = signo;
endmodule
