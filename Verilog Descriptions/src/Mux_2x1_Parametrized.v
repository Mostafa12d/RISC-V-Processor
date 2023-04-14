`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2021 01:04:02 PM
// Design Name: 
// Module Name: Mux_2x1_Parametrized
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


module Mux_2x1_Parametrized #(parameter n = 32)(
input [n-1:0] x0, x1,
input select,
output [n-1:0] out
);
genvar i;
generate
    for(i = 0; i < n; i = i + 1)
    begin: loop
        Mux_2x1 mux (x0[i], x1[i], select, out[i]); 
    end
endgenerate
endmodule
