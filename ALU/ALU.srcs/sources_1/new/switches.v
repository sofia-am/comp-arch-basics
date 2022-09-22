`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: switches
// Project Name: TP1 ALU - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya, Matias
// Target Devices: Basys2/3
// Description: 
// Implementacion de una ALU basica con un testbench
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
        input wire load_4, //reset
        input wire clock,
        ///////////////////////////////////////////////////////////////////////////////////
        //output reg [DATA_SIZE-1:0] o_dato_a,
        //output reg [DATA_SIZE-1:0] o_dato_b,
        //output reg [OPCODE_SIZE-1:0] o_opcode,
        ///////////////////////////////////////////////////////////////////////////////////
        output wire [DATA_SIZE-1:0] o_dato_a,
        output wire [DATA_SIZE-1:0] o_dato_b,
        output wire [OPCODE_SIZE-1:0] o_opcode,
        output wire o_load_1,
        output wire o_load_2,
        output wire o_load_3,
        output wire o_load_4
    );

reg [DATA_SIZE-1:0]aux_dato_a;
reg [DATA_SIZE-1:0]aux_dato_b;
reg [OPCODE_SIZE-1:0] aux_opcode;
reg aux_load_1;
reg aux_load_2;
reg aux_load_3;
reg aux_load_4;

always @(posedge clock) begin

    if(load_4) begin
        aux_dato_a <= 1'b0;
        aux_dato_b <= 1'b0;
        aux_opcode <= 1'b0;
        aux_load_4 <= 1'b1;
    end
    else if(load_1) begin
        //aux_dato_a = numero;
        aux_dato_a <= numero;
        aux_load_1 <= 1'b1;
    end
    else if(load_2) begin
        //aux_dato_b = numero;
        aux_dato_b <= numero;
        aux_load_2 <= 1'b1;
    end
    else if(load_3) begin
        //aux_opcode = numero;
        aux_opcode <= numero;
        aux_load_3 <= 1'b1;
    end 
end

    assign o_load_1 = aux_load_1;
    assign o_load_2 = aux_load_2;
    assign o_load_3 = aux_load_3;
    assign o_load_4 = aux_load_4;
    assign o_dato_a = aux_dato_a;
    assign o_dato_b = aux_dato_b;
    assign o_opcode = aux_opcode;    
    
endmodule
