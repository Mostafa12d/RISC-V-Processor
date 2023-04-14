`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 01:40:21 PM
// Design Name: 
// Module Name: Hazard_Detection_Unit
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


module Hazard_Detection_Unit(
input [4:0] IF_ID_Rs1, IF_ID_Rs2, ID_EX_Rd, 
input ID_EX_MemRead,
output reg stall
);

always@(*) begin
if (((IF_ID_Rs1 == ID_EX_Rd) | (IF_ID_Rs2 == ID_EX_Rd)) & (ID_EX_MemRead) & (ID_EX_Rd != 0))
    stall = 1'b1;
else
    stall = 1'b0;
end

endmodule
