`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fifo
// Project Name: TP#2 UART - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya Plasencia, Matias
// Target Devices: Basys3
// Description: circular FIFO module
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module fifo
    #(
        parameter   B = 8, // number of bits per word
                    W = 4 // number of address bits
    )
    (
        input wire  clk, reset,
        input wire  rd, wr,
        input wire  [B-1:0]w_data,
        output wire full, empty,
        output wire [B-1:0]dout
    );
    
    // declaramos las señales que vamos a utilizar
    reg [B-1:0] array_reg [2**W-1:0] ; // register array 
    reg [W-1:0] w_ptr_reg, w_ptr_next , w_ptr_succ; 
    reg [W-1:0] r_ptr_reg , r_ptr_next , r_ptr_succ ; 
    reg full_reg, empty_reg, full_next, empty_next;
    wire wr_en;

    always @(posedge clk) begin
        if(wr) begin
            array_reg[w_ptr_reg] <= w_data;
        end
    end

    assign r_data = array_reg[r_ptr_reg];
    assign wr_en = wr & ~full_reg;

    always @(posedge clk, posedge reset) begin
              
        if(reset) begin
            w_ptr_reg <= 0;
            r_ptr_reg <= 0;
            full_reg <= 0;
            empty_reg <= 1;
        end
        else begin
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg <= full_next;
            empty_reg <= empty_next;
        end
    end    

    always @(*) begin
        w_ptr_succ = w_ptr_reg + 1;
        r_ptr_succ = r_ptr_reg + 1;
        w_ptr_next = wr_en ? w_ptr_succ : w_ptr_reg;
        r_ptr_next = rd ? r_ptr_succ : r_ptr_reg;
        full_next = full_reg;
        empty_next = empty_reg;

        case ({wr,rd})
            // 2'b00: // no operation
            2'b01: begin // read
                if(~empty_reg) begin
                    r_ptr_next = r_ptr_succ;
                    full_next = 1'b0;
                    if(r_ptr_succ == w_ptr_reg) begin
                        empty_next = 1'b1;
                    end
                end
            end
            2'b10: begin// write
                if(~full_reg) begin // not full
                    w_ptr_next = w_ptr_succ;
                    empty_next = 1'b0;
                    if(w_ptr_succ == r_ptr_reg) begin
                        full_next = 1'b1;
                    end
                end
            end
            2'b11: begin  // write and read
                w_ptr_next = w_ptr_succ;
                r_ptr_next = r_ptr_succ;
            end
        endcase
    end

    // salida de datos
    assign full = full_reg;
    assign empty = empty_reg;

endmodule

/* The code is divided into a register file and a FIFO controller. The controller consists of 
two pointers and two status FFs. Its next-state logic examines the wr and rd signals and takes 
actions accordingly. For example, let us consider the " 10" case, which implies that only a 
write operation occurs. The status FF is checked first to ensure that the buffer is not full. 
If this condition is met, we advance the write pointer by one position and clear the empty 
status FF. Storing one extra word to the buffer may make it full. This happens if the new 
write pointer "catches" the read pointer, which is expressed by the w-ptr-succ==r-ptr-reg 
expression. */