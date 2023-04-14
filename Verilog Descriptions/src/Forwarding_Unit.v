`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2021 11:55:08 AM
// Design Name: 
// Module Name: Forwarding_Unit
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


module Forwarding_Unit(
input [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd,
input EX_MEM_RegWrite, MEM_WB_RegWrite,
output reg[1:0] ForwardA, ForwardB
);

always@ (*) begin
//MEM hazard
//if ( EX_MEM_RegWrite & (EX_MEM_Rd != 0)
//    & (EX_MEM_Rd == ID_EX_Rs1) )
//    ForwardA = 2'b10; //fwd from previous stage
//EX hazard
if ((MEM_WB_RegWrite & (MEM_WB_Rd != 0) & (MEM_WB_Rd == ID_EX_Rs1)))
    ForwardA = 2'b01; //fwd from 2 stages before  
//No hazard
else
    ForwardA = 2'b00; //no fwd

//MEM hazard
//if ( EX_MEM_RegWrite & (EX_MEM_Rd != 0)
//    & (EX_MEM_Rd == ID_EX_Rs2) )
//    ForwardB = 2'b10;

//EX hazard
if ((MEM_WB_RegWrite & (MEM_WB_Rd != 0) & (MEM_WB_Rd == ID_EX_Rs2)))
    ForwardB = 2'b01;
//No hazard
else
    ForwardB = 2'b00;
end
endmodule
