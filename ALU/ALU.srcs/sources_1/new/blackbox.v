`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2022 09:33:19 PM
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module black_box
    #(  parameter DATA_SIZE = 4,
        parameter OPCODE_SIZE = 6,
        parameter SWITCHES = 6,
        parameter OUTPUT_SIZE = 4
    )(
        input wire [SWITCHES-1:0] numero,
        input wire load_1, //dato a
        input wire load_2, //dato b
        input wire load_3, //opcode
        input wire clock,
        output wire [OUTPUT_SIZE-1:0] o_result,
        output wire o_carry,
        output wire o_zero,
        output wire o_signo
    );

wire [DATA_SIZE-1:0]dato_a;
wire [DATA_SIZE-1:0]dato_b;
wire [OPCODE_SIZE-1:0]opcode;

switches inputs( //instancio un modulo inputs con las mismas entradas que main
    .numero(numero),
    .clock(clock),
    .load_1(load_1),
    .load_2(load_2),
    .load_3(load_3),
    .o_dato_a(dato_a),
    .o_dato_b(dato_b),
    .o_opcode(opcode)
);

alu internal_alu( //instancio modulo alu con las mismas salidas
    .clock(clock),
    .data_a(dato_a),
    .data_b(dato_b),
    .opcode(opcode),
    .o_result(o_result),
    .o_carry(o_carry),
    .o_zero(o_zero),
    .o_signo(o_signo)
);

endmodule
