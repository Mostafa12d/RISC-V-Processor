`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 06:32:47 PM
// Design Name: 
// Module Name: DFlipFlop
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


module DFlipFlop(
input clk, rst, D,
output reg Q);
 
 always @ (posedge clk or posedge rst) begin // Asynchronous Reset
 if (rst)
    Q <= 1'b0;
 else
    Q <= D;
 end
endmodule
