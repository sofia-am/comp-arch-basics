`timescale 10 ns / 10ps
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

always begin
    in_reset = 1'b0;
    
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
    in_rx = 1'b0;
    #326
 
    // DatoA + Stop
    in_rx = 1'b1;
    #31296
     // 326 * 16 * 9
    /*
    // Start
    in_rx = 1'b0;
    #2282 // 326 * 7
*/
    // DatoB + Stop
    in_rx = 1'b0;
    #31296 // 326 * 16 * 6
    in_rx = 1'b1;
    #5216 // 326 * 16
    in_rx = 1'b0;
    #10432 // 326 * 16 * 2
    /*
    // Start
    in_rx = 1'b0;
    #2282 // 326 * 7
    
    // Opcode + Stop
    in_rx = 1'b1;
    #5216 // 326 * 16
    in_rx = 1'b0;
    #36512 // 326 * 16 * 7
    in_rx = 1'b1;
    #5216 // 326 * 16
    */
    
    $finish;

end


blackbox blackbox_instance(
    .in_clk(in_clk),
    .in_reset(in_reset),
    .in_rx(in_rx),
    .out_tx_status(out_tx_status),
    .tx_bit(tx_bit) 
);

endmodule
