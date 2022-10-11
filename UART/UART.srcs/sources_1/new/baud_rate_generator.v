`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2022 08:57:27 AM
// Design Name: 
// Module Name: baud_rate_generator
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

/*
 * Baud rate generator to divide {CLOCK_RATE} (internal board clock) into
 * a rx/tx {BAUD_RATE} pair with rx oversamples by 16x.
 */
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

always @(posedge in_clk, posedge in_reset) begin
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
