`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: interface
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Interface module to communicate UART and ALU
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module interface
    #(  parameter   WORD_SIZE = 8
    )(
        input wire  in_reset, in_clk,
        //UART
        input wire  [1:0]in_rx_status,
        input wire  [7:0]in_rx_data,
        input wire  [1:0]in_tx_status,
        output wire [1:0]out_interface_status,
        output wire [7:0]out_tx_data,
        //ALU
        input wire  [7:0]in_result,
        input wire  in_alu_status,
        output wire [7:0]out_dato_a,
        output wire [7:0]out_dato_b,
        output wire [7:0]out_opcode
    );
    
localparam
    DATO_A  =   0,
    DATO_B  =   1,
    OP_CODE =   2;   

reg [1:0]interface_status;
reg [7:0]tx_data;
reg [7:0]dato_a;
reg [7:0]dato_b;
reg [7:0]opcode;    
integer contador; 

always @(posedge in_clk) begin
    if(in_reset) begin
        interface_status = 2'b0;
        tx_data = 8'b0;
        dato_a = 8'b0;
        dato_b = 8'b0;
        opcode = 8'b0;
        contador = 0;
    end
    //necesito una máquina de estados para esto? creo que no.
end

/*  si se modifica cualquier entrada, siempre y cuando el bit de status de la alu esté en 0
    siempre voy a transmitir el último resultado, independientemente de si corresponde al
    resultado de los últimos operandos.    
*/
always @* begin
    //in_rx_status == 0 cuando recibió los 8 bits de datos + el stop bit sin errores
    if(!in_rx_status)begin
        case(contador)
            DATO_A: begin
                dato_a = in_rx_data; 
                contador = contador + 1;
            end
            DATO_B: begin
                dato_b = in_rx_data; 
                contador = contador + 1;
            end
            OP_CODE: begin
                opcode = in_rx_data; 
                contador = 0;
            end
        endcase
        //in_alu_status == 0 cuando termina la operación sin errores
    end
    if(!in_alu_status)begin
        tx_data = in_result;
    end 
end

endmodule
