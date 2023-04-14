`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 07:04:38 PM
// Design Name: 
// Module Name: ShiftLeft_32bit
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


module ShiftLeft_32bit(
input [31:0] in,
input [4:0] shamt,
output [31:0] out
    );
    assign out = in << shamt;
endmodule
