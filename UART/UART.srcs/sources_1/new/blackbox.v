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
        output wire [1:0]out_rx_status, 
        output wire [7:0]out_data 
    );
    
wire tick;

baud_rate_generator baud_generator(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .out_tick(tick)
);

rx_module receptor(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_rx(in_rx),
    .in_tick(tick),
    .out_rx_status(out_rx_status),
    .out_data(out_data)
);

endmodule
