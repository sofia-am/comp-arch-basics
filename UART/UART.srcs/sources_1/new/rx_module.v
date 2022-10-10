`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2022 08:02:28 PM
// Design Name: 
// Module Name: rx_module
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


module rx_module
    #( 
        parameter   WORD_SIZE = 8,
                    STOP_SIZE = 1,
                    TICK_WAIT = 16
    )
    (
        input wire  clk, reset,
        input wire  rx_in, tick, 
        output wire [2:0]rx_status, 
        /* rx_status:
            00 -> OK
            01 -> RUIDO
            10 -> STOP
            11 -> UNKNOWN
        */
        output wire [7:0]data 
    );
    

// declaramos los distintos estados
localparam  [2:0]
    IDLE        =   3'b000,
    START       =   3'b001,
    RECV        =   3'b010, //recieving
    STOP        =   3'b011,
    ERROR       =   3'b100;  
    
//declaramos los registros que vamos a utilizar
reg [2:0]   state, update_state;
reg [3:0]   tick_count, update_tick; //con este registro contamos la cantidad de ticks que recibimos del baud rate generator
reg [2:0]   bit_count, update_count; //cant de bits que recibimos (max 8)
reg [7:0]   buffer, update_buffer;

always @(posedge clk, posedge reset)
//en este bloque se actualiza el estado/se realiza un reset.
    if(reset)   
        begin   
            state <= IDLE;
            tick_count <= 4'b0;
            bit_count <= 3'b0;
            buffer <= 8'b0;    
        end
    else
        begin
            state <= update_state;
            tick_count <= update_tick;
            bit_count <= update_count;
            buffer <= update_buffer;
        end

always @*
    begin
        update_state = state;
        //rx_status = 3'b00; //ok
        update_tick = tick_count;
        update_count = bit_count;
        update_buffer = buffer;
        
        case(state)
            IDLE: begin 
                if(rx_in) begin
                    update_state = IDLE; //mientras no me llegue un 0, me quedo en IDLE
                    update_tick = 0;
                end
                else begin 
                    update_state = START;
                    update_tick = 0;
                end 
            end
           
            START: begin
                if(tick) begin
                    if(tick_count == 4'd7) begin
                        update_state = RECV; 
                        update_tick = 4'b0;                       
                    end
                    else begin
                        update_tick = tick_count + 1;
                    end
                    if(rx_in) begin
                        //si la entrada es 1 (no fue 0 por 7 ticks) entonces considero que fue ruido
                            //update_state = ERROR;
                            rx_status = 3'b01;
                            update_tick = 4'b0;
                    end                                          
                end
            end
            
            RECV: begin
                if(tick) begin
                    if(tick_count == (TICK_WAIT - 1)) begin
                        update_tick = 4'b0;
                        update_buffer[bit_count] = rx_in; //almacena en la posición bit_count el valor ingresado
                        if(bit_count == (WORD_SIZE - 1)) begin //completó la palabra
                            update_state = STOP;  
                            update_count = 3'b0;                         
                        end
                        else begin
                            update_count = bit_count + 1;                            
                        end
                    end
                    else begin
                        update_tick = tick_count + 1;
                    end
                end
            end
            
            STOP: begin
                if(tick) begin
                    if(tick_count == (TICK_WAIT - 1)) begin
                        update_tick = 4'b0;
                        if(rx_in) begin
                            if(bit_count == (STOP-1)) begin
                                update_state = IDLE;
                                rx_status = 3'b0; //ok                                
                            end
                            else begin
                                update_count = bit_count + 1;
                            end
                        end                        
                    end
                    else begin
                        update_tick = tick_count + 1;                     
                    end
                    
                    if(rx_in == 0) begin
                        rx_status = 3'b10;
                        update_tick = 4'b0;
                    end 
                end
            end
           endcase  
            
                    
        
    
    

endmodule
