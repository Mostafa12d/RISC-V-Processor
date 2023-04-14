`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 07:02:09 PM
// Design Name: 
// Module Name: RippleAdder_32bit
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


module RippleAdder_32bit(
input[31:0]x1, x2,
input cin, 
output [31:0]sum, 
output cout
    );
    wire[31:0] w;
    Full_Adder FA1(.x1(x1[0]), .x2(x2[0]), .cin(cin), .sum(sum[0]), .cout(w[0]));
    assign cout = w[31];
    
    genvar i;
    generate
        for(i = 1; i < 32; i = i + 1) begin: RCAs
            Full_Adder FA(.x1(x1[i]), .x2(x2[i]), .cin(w[i-1]), .sum(sum[i]), .cout(w[i]));
        end
    endgenerate
endmodule