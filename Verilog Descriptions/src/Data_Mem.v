`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2021 11:58:18 AM
// Design Name: 
// Module Name: Data_Mem
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


module Data_Mem (
input clk, 
input MemRead, MemWrite, 
input [2:0] func3, 
input [5:0] addr, 
input [31:0] data_in,
output reg [31:0] data_out
);

reg [7:0] mem [0:63]; //4kB Byte Addressable memory
//wire [7:0] wordstartaddr= {addr[7:2] , 2'b00};
 always @(posedge clk)
 begin
 case({MemWrite, func3})
 4'b1000: mem[addr] = data_in[7:0];  //sb  
 4'b1001: {mem[addr + 1], mem[addr]} = data_in[15:0]; //sh
 4'b1010: {mem[addr + 3], mem[addr + 2], mem[addr+1], mem[addr]} = data_in; //sw
 
 endcase 
 end
 
 always@(*) begin
 case({MemRead, func3})
 4'b1000: data_out = $signed(mem[addr]);//lb
 4'b1001: data_out = $signed({mem[addr + 1], mem[addr]});//lh
 4'b1010: data_out = $signed({mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]});//lw
 4'b1100: data_out = $unsigned(mem[addr]);//lbu
 4'b1101: data_out = $unsigned({mem[addr + 1], mem[addr]});//lhu
 default :data_out=0;
 endcase
  end
 
initial begin
{mem[3],mem[2],mem[1],mem[0]}=32'd17;
{mem[7],mem[6],mem[5],mem[4]}=32'd9;
{mem[11],mem[10],mem[9],mem[8]}=32'd25;
end

endmodule
