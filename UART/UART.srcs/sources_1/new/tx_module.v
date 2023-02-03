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
        parameter   DBIT = 8, // data bits
                    SB_TICK = 16 // ticks for stop bits
    )(
        input wire  clk, reset,
        input wire  tx_start, s_tick,   
        input wire  [7:0]din,
        output wire tx_done_tick_wire,
        output wire tx
    );
    
    localparam [1:0]
        IDLE    =   3'b000,
        START   =   3'b001,
        SEND    =   3'b010, //sending
        STOP    =   3'b011;

    reg tx_reg , tx_next, tx_done_tick;     
    reg [1:0]   state_reg, state_next;
    reg [2:0]   n_reg, n_next; 
    reg [3:0]   s_reg , s_next; 
    reg [7:0]   b_reg , b_next;     

    always @(posedge clk, posedge reset) begin
        if(reset)   
            begin   
                state_reg <= IDLE;
                s_reg <= 0;
                n_reg <= 0;
                b_reg <= 0;
                tx_reg <= 1'b1;
            end
        else
            begin
                state_reg <= state_next;
                s_reg <= s_next;
                n_reg <= n_next; 
                b_reg <= b_next;
                tx_reg <= tx_next;
            end
    end

    always @(*) begin
        state_next = state_reg;
        tx_done_tick = 1'b0;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        tx_next = tx_reg;

        case(state_reg)
            IDLE: begin
                tx_next = 1'b1;
                if(tx_start) begin
                    state_next = START;
                    s_next = 0;
                    b_next = din;
                end
            end
            
            START: begin
                tx_next = 1'b0;
                if(s_tick) begin
                    if(s_reg == 15) begin
                            state_next = DATA;
                            s_next = 0;
                            n_next = 0;
                        end
                    else begin
                        s_next = s_reg + 1;
                    end
                end
            end
            
            DATA: begin
                tx_next = b_reg[0];
                if(s_tick) begin
                    if(s_reg == 4'b1111) begin
                        s_next = 0;
                        b_next = b_reg >> 1;
                        if(n_reg == (DBIT - 1)) begin
                            state_next = STOP;
                        end
                        else begin
                            n_next = n_reg + 1;
                        end
                    end
                    else begin
                        s_next = s_reg + 1;
                    end
                end
            end

            STOP: begin
                tx_next = 1'b1;
                if(s_tick) begin
                    if(s_reg == SB_TICK) begin
                        state_next = IDLE;
                        tx_done_tick = 1'b1;
                    end
                    else begin
                        s_next = s_reg + 1;
                    end
                end
            end
            
        endcase
    
    end
    // salida
    assign tx = tx_reg;
    assign tx_done_tick_wire = tx_done_tick;

endmodule
