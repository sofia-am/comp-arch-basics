`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2022 08:01:21 PM
// Design Name: 
// Module Name: tb_rx_module
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
module tb_rx_module();
     
parameter   WORD_SIZE = 8, STOP_SIZE = 1, TICK_WAIT = 16;

localparam  [2:0]
    IDLE        =   3'b000,
    START       =   3'b001,
    RECV        =   3'b010, 
    STOP        =   3'b011,
    ERROR       =   3'b100;  

//inputs
reg in_clk, in_reset, in_tick, in_rx;

//outputs
wire [1:0]out_rx_status;
wire [7:0]out_data;

reg i,j;

initial begin
    in_clk = 1'b1;
    in_reset = 1'b1;
    in_tick = 1'b1;
end


always begin
    #1
    in_clk = ~in_clk;
end

always begin
    in_reset = 1'b1;
    #2
    in_reset = 1'b0;
    //sección para bit de start
    in_rx = 1'b0;
    for(i = 0; i < 7; i = i+1) begin
        #10
        in_tick = 1'b1;
        #5
        in_tick = 1'b0;
    end
    
    for(j = 0; j < 7; j = j+1) begin
        in_rx = ~in_rx; // 1 0 1 0 1 0 1 0
        for(i = 0; i < 15; i = i+1)begin
            #10
            in_tick = 1'b1;
            #5
            in_tick = 1'b0;
        end
    end
    
    in_rx = 1'b1; //bit stop
    for(i = 0; i < 15; i = i+1)begin
        #10
        in_tick = 1'b1;
        #5
        in_tick = 1'b0;
    end
      
    $finish;
end

rx_module receptor(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_rx(in_rx),
    .in_tick(in_tick),
    .out_rx_status(out_rx_status),
    .out_data(out_data) 
);

endmodule
