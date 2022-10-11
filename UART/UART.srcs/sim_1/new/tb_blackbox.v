`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_blackbox
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Blackbox module testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

/*
    El módulo baud_generator genera los ticks cada 163 clocks como corresponde, 
    y el módulo rx cuenta los bits y cambia de estado de manera exitosa,
    pero el testbench no funciona como esperaría. Cuenta menos ticks de los que debería.
    
    TODO: repensar como armar el testbench
*/

module tb_blackbox;
     
//inputs
reg in_clk, in_reset, in_rx;

//outputs
wire [1:0]out_rx_status;
wire [7:0]out_data;

reg i,j;

initial begin
    in_clk = 1'b1;
    in_rx = 1'b0;
    in_reset = 1'b1;
end

always begin
    #1
    in_clk = ~in_clk;
end

always @(in_clk) begin
    in_reset = 1'b0;

    for(j = 0; j<8; j=j+1)begin 
      for(i = 0; i<164; i=i+1) begin //tick
        #1 //si no le pongo esto explota
        in_rx = 1'b0;
      end  
    end
    
    in_rx = 1'b1;
    for(j = 0; j<16; j=j+1)begin 
      for(i = 0; i<164; i=i+1) begin //tick
        #1 
        in_rx = 1'b1;
      end  
    end
   
    $finish;
end

blackbox blackbox_instance(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_rx(in_rx),
    .out_rx_status(out_rx_status),
    .out_data(out_data) 
);

endmodule
