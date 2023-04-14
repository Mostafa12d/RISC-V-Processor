`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 05:44:28 PM
// Design Name: 
// Module Name: temp_TB
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


module temp_TB();

reg clk, rst;

Pipelined_Processor Pprocessor(rst, clk);

initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin
rst = 1; 
#10;
rst =0 ; 
end

endmodule
