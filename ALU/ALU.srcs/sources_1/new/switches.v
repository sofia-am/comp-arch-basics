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
        output reg [DATA_SIZE-1:0] o_dato_a,
        output reg [DATA_SIZE-1:0] o_dato_b,
        output reg [OPCODE_SIZE-1:0] o_opcode,
        ///////////////////////////////////////////////////////////////////////////////////
        //output wire [DATA_SIZE-1:0] dato_a,
        //output wire [DATA_SIZE-1:0] dato_b,
        //output wire [OPCODE_SIZE-1:0] opcode
        output reg o_load_1,
        output reg o_load_2,
        output reg o_load_3,
        output reg o_load_4
    );

reg aux_dato_a;
reg aux_dato_b;
reg aux_opcode;

always @(posedge clock) begin
    
    o_load_1 = 1'b0;
    o_load_2 = 1'b0;
    o_load_3 = 1'b0;
    o_load_4 = 1'b0;
    
    if(load_1) begin
        //aux_dato_a = numero;
        o_dato_a = numero;
        o_load_1 = 1'b1;
    end
    else if(load_2) begin
        //aux_dato_b = numero;
        o_dato_b = numero;
        o_load_2 = 1'b1;
    end
    else if(load_3) begin
        //aux_opcode = numero;
        o_opcode = numero;
        o_load_3 = 1'b1;
    end
    else if(load_4) begin
        o_dato_a = 1'b0;
        o_dato_b = 1'b0;
        o_opcode = 1'b0;
        o_load_4 = 1'b1;
    end
end
  
    //assign o_dato_a = aux_dato_a;
    //assign o_dato_b = aux_dato_b;
    //assign o_opcode = aux_opcode;    
endmodule
