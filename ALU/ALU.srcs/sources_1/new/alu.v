`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu
// Project Name: TP1 ALU - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya, Matias
// Target Devices: Basys2/3
// Description: 
// Implementaciï¿½n de una ALU bï¿½sica con un testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
/*
module inputs
    #(  parameter DATA_SIZE = 4,
        parameter OPCODE_SIZE = 6,
        parameter SWITCHES = 6
    )(
        input wire [SWITCHES-1:0] numero,
        input wire load_1, //dato a
        input wire load_2, //dato b
        input wire load_3, //opcode
        input wire clock,
        output wire [DATA_SIZE-1:0] o_dato_a,
        output wire [DATA_SIZE-1:0] o_dato_b,
        output wire [OPCODE_SIZE-1:0] o_opcode
    );

reg dato_a;
reg dato_b;
reg opcode;

always @(posedge clock) begin
    if(load_1) begin
        dato_a = numero;
    end
    else if(load_2) begin
        dato_b = numero;
    end
    else if(load_3) begin
        opcode = numero;
    end
end
    assign o_dato_a = dato_a;
    assign o_dato_b = dato_b;
    assign o_opcode = opcode;    
endmodule*/

module alu
    #(  parameter INPUT_SIZE = 4,
        parameter OUTPUT_SIZE = 5,
        parameter OPCODE_SIZE = 6    
     )
    (   //input wire [INPUT_SIZE-1:0] data_a, [INPUT_SIZE-1:0] data_b,
        //input wire [OPCODE_SIZE-1:0] operation,
        input wire [OPCODE_SIZE-1:0] numeros,
        input wire load_1, //dato a
        input wire load_2, //dato b
        input wire load_3, //opcode
        input wire clock,
        output wire [OUTPUT_SIZE-1:0] o_result,
        output wire o_carry,
        output wire o_zero,
        output wire o_signo
    );
/*
    inputs entradas(
        .clock(clock),
        .o_dato_a(data_a),
        .o_dato_b(data_b),
        .o_opcode(operation)
    );*/

//parámetros para facilitar la comprensión de los switch cases
localparam ADD = 6'b100000;
localparam SUB = 6'b100010;
localparam AND = 6'b100100;
localparam OR  = 6'b100101;
localparam XOR = 6'b100110;
localparam SRA = 6'b000011;
localparam SRL = 6'b000010;
localparam NOR = 6'b100111;

reg [OPCODE_SIZE-1:0] opcode = {OPCODE_SIZE{1'b0}};
reg [INPUT_SIZE-1:0] data_a = {INPUT_SIZE{1'b0}};
reg [INPUT_SIZE-1:0] data_b = {INPUT_SIZE{1'b0}};
reg [OUTPUT_SIZE-1:0] result = {OUTPUT_SIZE{1'b0}};
reg carry; //si no se define nada, es de 1 bit
reg zero;
reg signo;

always @(posedge clock) begin
    if(load_1) begin
        data_a = numeros;
    end
    else if(load_2) begin
        data_b = numeros;
    end
    else if(load_3) begin
        opcode = numeros;
    end
end

always @(posedge clock) begin
    case(opcode)
        ADD: begin
            carry = 1'b0;
            zero = 1'b0;
            signo = 1'b0;
            result = data_a + data_b;
            carry = (result[OUTPUT_SIZE-1] == 1'b1);
            zero = (result == {OUTPUT_SIZE{1'b0}});
            result = result[OUTPUT_SIZE-1:0];
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
               result = {INPUT_SIZE{1'b0}};
            end
            zero = (result == 5'b0);
            result = result[OUTPUT_SIZE-1:0];
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
