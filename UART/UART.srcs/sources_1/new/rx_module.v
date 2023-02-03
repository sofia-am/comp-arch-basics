`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: rx_module
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: Finite state machine based UART receiver module
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module rx_module
    #(
        parameter   DBIT = 8, // data bits
                    SB_TICK = 16 // ticks for stop bits
    )
    (
        input wire  clk, reset,
        input wire  rx, s_tick,
        output wire rx_done_tick_wire,
        output wire [DBIT-1:0]dout
    );
    

// declaramos los distintos estados simbolicos
localparam  [1:0]
    IDLE    = 2'b00, 
    START   = 2'b01, 
    DATA    = 2'b10, 
    STOP    = 2'b11;
      
    
//declaramos los registros que vamos a utilizar
reg [1:0]   state_reg, state_next;
reg [3:0]   s_reg, s_next; // s register keeps track of the number of sampling ticks and counts to 7 in the start state
reg [2:0]   n_reg, n_next; // n register keeps track of the number of data bits received in the data state
reg [7:0]   b_reg, b_next; // the retrieved bits are shifted into and reassembled in the b register
reg         rx_done_tick;

//circuito secuencial
always @(posedge clk, posedge reset) begin
//en este bloque se actualiza el estado/se realiza un reset.
    if(reset)   
        begin   
            state_reg <= IDLE;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;    
        end
    else
        begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next; 
            b_reg <= b_next;
        end
end

//circuito combinacional
always @* begin //cualquier cambio en alguna de las entradas del modulo, se ejecuta el bloque de codigo

    state_next = state_reg;
    rx_done_tick = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;

    case(state_reg)
        IDLE: begin
            if(~rx) begin
                state_next = START;
                s_next = 0;
            end
        end
        START: begin
            if(s_tick) begin
                if(s_reg == 4'b1111) begin
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
            if(s_tick) begin
                if(s_reg == SB_TICK-1) begin
                    s_next = 0;
                    b_next = {rx, b_reg[7:1]};
                    if(n_reg == DBIT-1) begin
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
            if(s_tick) begin
                if(s_reg == (SB_TICK-1)) begin
                    state_next = IDLE;
                    rx_done_tick = 1'b1;
                end
                else begin
                    s_next = s_reg + 1;
                end
            end
        end
    endcase  
    end
    
    // salida
    assign dout = b_reg;
    assign rx_done_tick_wire = rx_done_tick;

endmodule
