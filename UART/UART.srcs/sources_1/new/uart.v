`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: uart
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Finite state machine based UART transmitter module
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module uart

    #(
        DBIT = 8, // data bits
        SB_TICK = 16, // ticks for stop bits
        FIFO_W = 2 // addr bits of FIFO
                   // wrods in FIFO = 2^FIFO_W
    )
    (
        input wire clk, reset,
        input wire rd_uart, wr_uart, rx,
        input wire [7:0] w_data,
        output wire tx_full, rx_empty, tx,
        output wire [7:0] r_data
    );

    wire tick, rx_done_tick, tx_done_tick;
    wire tx_empty, tx_fifo_not_empty;
    wire [7:0] tx_fifo_out, rx_data_out;

    baud_rate_generator baud_rate_instance 
    (
        .clk(clk), .reset(reset),
        .tick(tick)
    );
    
    rx_module # (.DBIT(DBIT), .SB_TICK(SB_TICK)) rxm 
    (
        .clk(clk), .reset(reset), .s_tick(tick),
        .rx(rx), .rx_done_tick(rx_done_tick),
        .dout(rx_data_out)
    );
    
    fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit
    (
        .clk(clk), .reset(reset),
        .rd(rd_uart), .wr(rx_done_bit),
        .w_data(rx_data_out),
        .empty(rx_empty), .full(),
        .r_data(r_data)
    );
    
    fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit
    (
        .clk(clk), .reset(reset),
        .rd(tx_done_unit), .wr(wr_uart),
        .w_data(w_data),
        .empty(tx_empty), .full(tx_full),
        .r_data(tx_fifo_out)
    );

    tx_module # (.DBIT(DBIT), .SB_TICK(SB_TICK)) txm 
    (
        .clk(clk), .reset(reset), tx_start(tx_fifo_not_empty),
        .s_tick(tick), .din(tx_fifo_out),
        .tx_done_tick(tx_done_tick), .tx(tx)
    );

    assign tx_fifo_not_empty = ~tx_empty;
        
endmodule