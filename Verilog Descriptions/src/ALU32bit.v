`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 06:53:54 PM
// Design Name: 
// Module Name: ALU_32bit
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

module ALU32bit (
input [31:0] in1, in2,
input [3:0] aluSel,
output reg [31:0] result, output reg zero );
reg [31:0]addSub;
reg cin;
wire cout;
wire [31:0]sum;
RippleAdder_32bit add( .x1(in1), .x2(addSub), .cin(cin), .sum(sum), .cout(cout));

always@(*) begin
case(aluSel)
4'b0000://and
    result = in1 & in2;
4'b0001://or
    result = in1 | in2;
4'b0010: begin //add
    addSub = in2;
    cin = 1'b0;
    result = sum;
    end
4'b0110: begin//sub
    addSub = ~in2;
    cin = 1'b1;
    result = sum;
    end
default: result = 0;
endcase

end

always @(*) begin
if(result == 0) 
zero = 1;
else 
zero = 0; 
end
endmodule
