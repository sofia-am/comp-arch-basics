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
        parameter   WORD_SIZE = 8,
                    STOP_SIZE = 1,
                    TICK_WAIT = 16
    )
    (
        input wire  in_clk, in_reset,
        input wire  in_rx, in_tick, 
        output wire [1:0]out_rx_status, 
        /* out_rx_status:
            00 -> OK
            01 -> RUIDO
            10 -> STOP
            11 -> UNKNOWN
        */
        output wire [7:0]out_data 
    );
    

// declaramos los distintos estados
localparam  [2:0]
    IDLE        =   3'b000,
    START       =   3'b001,
    RECV        =   3'b010, //recieving
    STOP        =   3'b011,
    ERROR       =   3'b100;  
    
//declaramos los registros que vamos a utilizar
reg [1:0]   rx_status;
reg [2:0]   current_state, next_state;
reg [3:0]   tick_count, next_tick_count; //con este registro contamos la cantidad de ticks que recibimos del baud rate generator
reg [2:0]   bit_count = 3'b0, next_bit_count = 3'b0; //cant de bits que recibimos (max 8)
reg [7:0]   current_buffer, next_buffer;

//circuito secuencial
always @(posedge in_clk) begin
//en este bloque se actualiza el estado/se realiza un reset.
    if(in_reset)   
        begin   
            current_state <= IDLE;
            tick_count <= 4'b0;
            bit_count <= 3'b0;
            current_buffer <= 8'b0;    
        end
    else
        begin
            current_state <= next_state;
            tick_count <= next_tick_count;
            bit_count <= next_bit_count;
            current_buffer <= next_buffer;
        end
end

//circuito combinacional
always @* begin //cualquier cambio en alguna de las entradas
/*
// valuamos las variables para evitar la indeterminación, con el case default no hacen falta
    next_state = current_state;
    next_bit_count = bit_count;
    next_buffer = current_buffer;
    next_tick_count = tick_count;
*/
    case(current_state)

        IDLE: begin 
            next_tick_count = 0;
            rx_status = 2'b11;
            if(in_rx) begin
                next_state = IDLE; //mientras no me llegue un 0, me quedo en IDLE
                //un poco redundante igual porque si no cambia el estado entonces next_state == current_state
            end
            else begin 
                next_state = START; 
                //no se cambia de estado hasta que no haya un flanco de clock
            end 
        end
        
        START: begin
            if(in_tick) begin
                rx_status = 2'b11;
                if(tick_count == 4'd7) begin
                    next_state = RECV; 
                    next_tick_count = 4'b0;   //limpio el contador                    
                end
                else if(in_rx) begin
                    //si la entrada es 1 (no fue 0 por 7 ticks) entonces considero que fue ruido
                        next_state = ERROR;
                        rx_status = 3'b01;
                        next_tick_count = 4'b0;
                end                  
                else begin
                    next_tick_count = tick_count + 1;
                end                   
            end
        end
        
        RECV: begin
            if(in_tick) begin
                if(tick_count == (TICK_WAIT - 1)) begin
                    next_tick_count = 4'b0;
                    //rx_status = 2'b0;
                    next_buffer[bit_count] = in_rx; //almacena en la posicion bit_count el valor ingresado
                    if(bit_count == (WORD_SIZE - 1)) begin //complete la palabra
                        next_state = STOP;
                        next_bit_count = 3'b0;                 
                    end
                    else begin
                        next_bit_count = bit_count + 1;                            
                    end
                end
                else begin
                    next_tick_count = tick_count + 1;
                end
            end
        end
        
        STOP: begin
            if(in_tick) begin
                if(tick_count == (TICK_WAIT - 1)) begin
                    next_tick_count = 4'b0;
                    if(in_rx) begin
                        if(bit_count == (STOP-1)) begin
                            next_state = IDLE;
                            rx_status = 3'b0; //ok                                
                        end
                        else begin
                            next_bit_count = bit_count + 1;
                        end
                    end                        
                end
                else begin
                    next_tick_count = tick_count + 1;
                end
                
                if(in_rx == 0) begin
                    next_state = ERROR;
                    rx_status = 3'b10;
                    next_tick_count = 4'b0;
                end 
            end
        end

        ERROR: begin
            next_buffer = 7'b0; //limpio el buffer
            next_state = IDLE;
            next_tick_count = 4'b0;
            //podra prender un led? no se
        end 
        
        default: begin
            next_state = IDLE;
            next_tick_count = 4'b0;
            next_buffer = 7'b0;
            rx_status = 2'b11; //unknown
        end

    endcase  
    end
    
    assign out_rx_status = rx_status;
    assign out_data = current_buffer;
    
endmodule
