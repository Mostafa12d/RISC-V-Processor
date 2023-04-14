`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 06:19:53 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile(
input clk, rst,
input [4:0] readreg1, readreg2, writereg,
input [31:0] writedata,
input regwrite,
output [31:0] readdata1, readdata2);

wire [31:0] dataOut [0:31];
reg [31:0] load;

assign readdata1 = dataOut[readreg1];
assign readdata2 = dataOut[readreg2];

genvar i;
generate
    for(i = 0; i < 32; i = i + 1) begin: loop1
        Register_32bit regs(clk, rst, load[i], writedata, dataOut[i]);
    end
endgenerate

always @ (*) begin
load = 32'b0;

if(writereg != 0)
    load [writereg] = regwrite;
    
end
endmodule
