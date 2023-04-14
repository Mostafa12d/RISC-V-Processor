`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2021 11:21:30 AM
// Design Name: 
// Module Name: Mux_4x1_32bit
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


module Mux_4x1_32bit(
input [31:0] x0, x1, x2, x3,
input [1:0] select,
output reg [31:0] out
);

always@(*) begin
case(select)
2'b00: out = x0; 
2'b01: out = x1;
2'b10: out = x2;
2'b11: out = x3;
//default: out = 0;
endcase
end

endmodule
