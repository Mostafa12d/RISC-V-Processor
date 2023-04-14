`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 06:39:31 PM
// Design Name: 
// Module Name: register_32bit
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


module Register_32bit #(parameter n = 32)(
input clk, rst, load,
input [n-1:0] D, 
output [n-1:0] Q
);
wire [n-1:0] out; //mux output

genvar i;
generate
    for(i = 0; i < n; i = i + 1)
    begin : loop
        Mux_2x1 mux( Q[i], D[i], load, out[i]);
        DFlipFlop DFF (clk, rst, out[i], Q[i]);
    end
endgenerate

endmodule
