`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 04:39:54 PM
// Design Name: 
// Module Name: shifter
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


module shifter(
input [31:0] a, 
input [4:0]shamt,
input [1:0] type,
output reg [31:0]  r);

always@(*) begin

case(type)
2'b00: //srl
    r = $unsigned(a) >> shamt;
2'b01: //sll
    r = $unsigned(a) << shamt;
2'b10: //sra
    r = $signed(a) >>> shamt;
default:
    r = a;
endcase
end
endmodule
