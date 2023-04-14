`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2021 12:51:12 PM
// Design Name: 
// Module Name: Instruct_Mem
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


module Instruct_Mem(
input [5:0] addr,
output [31:0] data_out
    );
    
    reg [31:0] mem [0:63]; 
    assign data_out = mem[addr];
    
initial begin
//R-Type
//mem[0]=32'b00000000011000000000100010010011;
//mem[1]=32'b00000001000110001000100100110011;
//mem[2]=32'b01000001000110010000100110110011;
//mem[3]=32'b00000001001010011111101000110011;
//mem[4]=32'b00000001010010010110101010110011;
//mem[5]=32'b00000001001010101100101100110011;
//mem[6]=32'b01000001010110011000110000110011;
//mem[7]=32'b00000001010010011001110010110011;
//mem[8]=32'b00000000000100000000111010010011;
//mem[9]=32'b00000001110111000101110100110011;
//mem[10]=32'b01000001110111000101110110110011;
//mem[11]=32'b00000001001110100010101110110011;
//mem[12]=32'b00000001100010100011110000110011;
//mem[13]=32'b00000000010000000000111001101111;
//mem[14]=32'b00000001000100000000000000001111;
//mem[15]=32'b00000000000100000000000001110011;

mem[0]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
// //added to be skipped since PC starts with 4 after reset
 mem[1] = 32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
 mem[2] = 32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
 mem[3] = 32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
 mem[4] = 32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
 mem[5] = 32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4  pc 20 24 28    32 =>   40
 mem[6] = 32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
 mem[7] = 32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
 mem[8] = 32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
 mem[9] = 32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
 mem[10] = 32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
 mem[11] = 32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
 mem[12] = 32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
 mem[13] = 32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
 
//     mem[0]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     //added to be skipped since PC starts with 4 after reset
//     mem[1]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)     //x1 = 17
//     mem[2]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[3]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[4]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[5]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)     //x2 = 9
//     mem[6]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[7]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[8]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[9]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)     //x3 = 25
//    mem[10]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//    mem[11]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//    mem[12]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[13]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2  //x4 = 25
//    mem[14]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//    mem[15]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//    mem[16]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[17]=32'b0_000001_00011_00100_000_0000_0_1100011; //beq x4, x3, 16
//     mem[18]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[19]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//    mem[20]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[21]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
//     mem[22]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[23]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[24]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[25]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2  //x5 = 34
//     mem[26]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[27]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[28]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//     mem[29]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)   //mem[] = 34
//      mem[30]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[31]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[32]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[33]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)  //x6 = 34
//      mem[34]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[35]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[36]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[37]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1 //x7 = 51
//     mem[38]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[39]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[40]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[41]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2 //x8 = 1
//     mem[42]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[43]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[44]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[45]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2 //nothing
//     mem[46]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[47]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[48]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//      mem[49]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1 //x9 = 17
      end
endmodule