`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: display
// Project Name: TP1 ALU - Arquitectura de Computadoras
// Authors: Amallo, Sofia - Raya, Matias
// Target Devices: Basys2/3
// Description: mostramos el numero ingresado en un dislpay 7 segmentos
// Implementacion de una ALU basica con un testbench
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module display(
    input wire clock,
    input wire [5:0]numero,
    input wire load_1, //dato a
    input wire load_2, //dato b
    input wire load_3, //opcode
    output wire o_Segment_A,
    output wire o_Segment_B,
    output wire o_Segment_C,
    output wire o_Segment_D,
    output wire o_Segment_E,
    output wire o_Segment_F,
    output wire o_Segment_G,
    output wire o_load_1,
    output wire o_load_2,
    output wire o_load_3
   );
 
  reg [6:0]     r_Hex_Encoding_u = 7'h00;
  reg [3:0]     unidad;
  reg [3:0]     decena;
  // Purpose: Creates a case statement for all possible input binary numbers.
  // Drives r_Hex_Encoding_u appropriately for each input combination.
always @(posedge clock) begin
        unidad = numero % 10;
        decena = numero / 10;
        case (unidad) 
            4'b0000 : r_Hex_Encoding_u<=7'b0000001;    //Display 0
            4'b0001 : r_Hex_Encoding_u<=7'b1001111;    //Display 1
            4'b0010 : r_Hex_Encoding_u<=7'b0010010;    //Display 2
            4'b0011 : r_Hex_Encoding_u<=7'b0000110;    //Display 3
            4'b0100 : r_Hex_Encoding_u<=7'b1001100;    //Display 4
            4'b0101 : r_Hex_Encoding_u<=7'b0100100;    //Display 5
            4'b0110 : r_Hex_Encoding_u<=7'b0100000;    //Display 6
            4'b0111 : r_Hex_Encoding_u<=7'b0001111;    //Display 7
            4'b1000 : r_Hex_Encoding_u<=7'b0000000;    //Display 8
            4'b1001 : r_Hex_Encoding_u<=7'b0001100;    //Display 9
            4'b1010 : r_Hex_Encoding_u<=7'b0001000;    //Display A
            4'b1011 : r_Hex_Encoding_u<=7'b1100000;    //Display b
            4'b1100 : r_Hex_Encoding_u<=7'b0110001;    //Display C
            4'b1101 : r_Hex_Encoding_u<=7'b1000010;    //Display d
            4'b1110 : r_Hex_Encoding_u<=7'b0110000;    //Display E
            4'b1111 : r_Hex_Encoding_u<=7'b0111000;    //Display F
          endcase    
        end // always @ (posedge i_Clk)

  // r_Hex_Encoding_d[7] is unused  
  assign o_Segment_A = r_Hex_Encoding_u[6];
  assign o_Segment_B = r_Hex_Encoding_u[5];
  assign o_Segment_C = r_Hex_Encoding_u[4];
  assign o_Segment_D = r_Hex_Encoding_u[3];
  assign o_Segment_E = r_Hex_Encoding_u[2];
  assign o_Segment_F = r_Hex_Encoding_u[1];
  assign o_Segment_G = r_Hex_Encoding_u[0];
 
endmodule // Binary_To_7Segment

