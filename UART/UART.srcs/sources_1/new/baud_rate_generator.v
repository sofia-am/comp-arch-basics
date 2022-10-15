`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: baud_rate_generator
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Counts clocks coming from internal clock signal to generate 
// a transmission/reception baud rate signal.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module baud_rate_generator
    #(  //valores de la filmina
        parameter BAUD_RATE = 19200,
        parameter CLOCK_RATE = 50000000 // 50 Mhz
    )
    (
        input wire in_clk,
        input wire in_reset,
        output wire out_tick
    );

integer max_count = (CLOCK_RATE/(BAUD_RATE*16)); // ~163
integer clk_count = 0;
reg tick = 1'b0; 

always @(posedge in_clk) begin
    if (in_reset) begin
        tick = 1'b0;
        clk_count = 0;
    end 
    else if (clk_count == max_count) begin
        tick = 1'b1;
        clk_count = 0;
    end
    else begin
        clk_count = clk_count + 1;
        tick = 1'b0;    
    end
end
        
assign out_tick = tick;

endmodule
