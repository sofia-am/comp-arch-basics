`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: switches
// Project Name: TP1 ALU - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya, Matias
// Target Devices: Basys2/3
// Description: 
// Implementaci?n de una ALU b?sica con un testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module switches
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

reg aux_dato_a;
reg aux_dato_b;
reg aux_opcode;

always @(posedge clock) begin
    if(load_1) begin
        aux_dato_a = numero;
    end
    else if(load_2) begin
        aux_dato_b = numero;
    end
    else if(load_3) begin
        aux_opcode = numero;
    end
end
  
    assign o_dato_a = aux_dato_a;
    assign o_dato_b = aux_dato_b;
    assign o_opcode = aux_opcode;    
endmodule
