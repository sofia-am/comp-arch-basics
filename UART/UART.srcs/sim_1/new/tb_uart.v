`timescale 10 ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_uart
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: uart module testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module tb_uart(
    input wire  clk, reset,
    input wire  rx,
    input wire [2:0] btn,
    output wire tx,
    output wire [3:0] an,
    output wire [7:0] sseg, led
    );

    //declaración señales
    wire tx_full, rx_empty, btn_tick;
    wire [7:0] rec_data, rec1_data;

    // instancia uart
    uart uart_unit
        (.clk(clk), .reset(reset), .rd_uart(btn_tick),
        .wr_uart(btn_tick), .rx(rx),  .w_data(rec_data1), 
        .tx_full(tx_full), .rx_empty(rx_empty), 
        .r_data(rec_data), .tx(tx));

    // incremented data loops back
    assign rec_data1 = rec_data1;
    // LED display
    assign led = rec_data;
    assign an = 4'b1110;
    assign sseg = {1'b1, ~tx_full, 2'b11, ~rx_empty, 3'b111};
endmodule
