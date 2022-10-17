`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tx_module
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Finite state machine based UART transmitter module
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module tx_module
    #( 
        parameter   WORD_SIZE = 8,
                    STOP_SIZE = 1,
                    TICK_WAIT = 16
    )(
        input wire  tx_enable, in_reset, in_clk,
        input wire  in_tx, in_tick,
        input wire  [7:0]data,
        output wire [1:0]out_tx_status,
        output wire out_tx_bit
    );
    
localparam [2:0]
    IDLE    =   3'b000,
    START   =   3'b001,
    SEND    =   3'b010, //sending
    STOP    =   3'b011;
    //ERROR   =   3'b100;  
    
reg [1:0]   tx_status;
reg [2:0]   current_state, next_state;
reg [3:0]   tick_count, next_tick_count; //con este registro contamos la cantidad de ticks que recibimos del baud rate generator
reg [2:0]   bit_count = 3'b0, next_bit_count = 3'b0; //cant de bits que enviamos (max 8)
reg         tx_bit, next_tx_bit;

always @(posedge in_clk) begin
    if(in_reset)
        begin
            current_state <= IDLE;
            tx_bit = 1'b1;
            tick_count <= 4'b0;
            bit_count <= 3'b0;
        end
    else if(tx_enable)   
        begin
            current_state <= next_state;
            tick_count <= next_tick_count;
            bit_count <= next_bit_count;
            tx_bit <= next_tx_bit;
        end
end

always @* begin
    case(current_state)

        IDLE: begin
            next_tick_count = 4'b0;
            next_bit_count = 3'b0;
            if(tx_enable) next_state = START;
            else next_state = IDLE;
        end

        START: begin
            if(in_tick) begin
                next_tx_bit = 1'b0; //envio un 0 como bit de start
                if(tick_count == (TICK_WAIT - 1)) begin
                    next_state = SEND;
                    next_tick_count = 4'b0;           
                end
                else next_tick_count = tick_count + 1;
            end
        end

        SEND: begin
            if(in_tick) begin
                next_tx_bit = data[bit_count];
                if(tick_count == (TICK_WAIT - 1)) begin
                    next_tick_count = 4'b0;
                    if(bit_count == (WORD_SIZE -1)) begin
                        next_state = STOP;
                        next_bit_count = 3'b0;
                    end
                    else next_bit_count = bit_count + 1;
                end
                else next_tick_count = tick_count + 1;
            end
        end

        STOP: begin
            if(in_tick) begin
                next_tx_bit = 1'b1;
                if(tick_count == (TICK_WAIT - 1)) begin
                    next_tick_count = 4'b0;
                    if(bit_count == (STOP - 1)) begin
                        next_state = IDLE;
                        tx_status = 3'b0;
                    end
                    else next_bit_count = bit_count + 1;
                end
                else next_tick_count = tick_count + 1;
            end
        end

        default: begin
            next_state = IDLE;
            next_bit_count = 3'b0;
            next_tick_count = 4'b0;
            tx_bit = 1'b1;
        end
    endcase
end

assign out_tx_bit = tx_bit;
assign out_tx_status = tx_status;

endmodule
