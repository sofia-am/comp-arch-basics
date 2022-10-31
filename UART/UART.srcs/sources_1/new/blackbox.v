`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: blackbox
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Connects modules
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module blackbox(
        input wire  in_clk,
        input wire  in_reset,
        input wire  in_rx,
        output wire [1:0]out_interface_status,
        output wire [1:0]out_tx_status, 
        output wire tx_bit
    );
    
wire    tick;
wire    [7:0]rx_data;
wire    [7:0]tx_data;
wire    [7:0]result;
wire    alu_status;
wire    [7:0]dato_a;
wire    [7:0]dato_b;
wire    [7:0]opcode;
wire    tx_enable;
wire    [1:0]out_rx_status;

baud_rate_generator baud_generator(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .out_tick(tick)
);

rx_module receiver(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_rx(in_rx),
    .in_tick(tick),
    .out_rx_status(out_rx_status),
    .out_data(rx_data)
);

tx_module transmitter(
    .in_reset(in_reset),
    .in_clk(in_clk),
    .tx_enable(tx_enable),
    .data(tx_data),
    .out_tx_status(out_tx_status),
    .out_tx_bit(tx_bit)
);

interface interface_instance(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_rx_status(out_rx_status),
    .in_rx_data(rx_data),
    .out_interface_status(out_interface_status),
    .out_tx_enable(tx_enable),
    .out_tx_data(tx_data),
    .in_result(result),
    .in_alu_status(alu_status),
    .out_dato_a(dato_a),
    .out_dato_b(dato_b),
    .out_opcode(opcode)
);

alu alu_instance(
    .data_a(dato_a),
    .data_b(dato_b),
    .opcode(opcode),
    //.clock(in_clk),
    .o_result(result)
);

endmodule
