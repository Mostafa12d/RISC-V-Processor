`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2021 07:06:15 PM
// Design Name: 
// Module Name: Halt_Execution
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


//module Halt_Execution(
//input [31:0] instruction,
//input HaltFlag,
//output reg loadSignal //Should enter in the load of the PC
//);
//always @(*) begin
//if((instruction[6:0] == 7'b0001111 || instruction[6:0] == 7'b1110011) )
//    loadSignal = 1'b1;
//else
//    loadSignal = 1'b0;
//end
//endmodule

module Halt_Execution(
input rst,
input HaltFlag, //Coming from the Control unit
output reg loadSignal //Should enter in the load of the PC
);
always @(*)
begin
if(rst)
    loadSignal = 1'b0;
if(HaltFlag)//else  
    loadSignal= 1'b1;
//else 
//    loadSignal = 1'b0;
end

endmodule
