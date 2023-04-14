`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2021 03:15:38 PM
// Design Name: 
// Module Name: Branch_CU
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


module Branch_CU( 
input Branch, zeroflag, carryflag, overflowflag, signflag, JALRflag, JALflag,
input [2:0] func3,
output reg[1:0] PCsrc);

always@(*) begin

if(Branch == 1) begin

case(func3)
3'b000: begin //BEQ
if(zeroflag)
    PCsrc = 2'b01;
else
    PCsrc = 2'b00;
end
3'b001: begin//BNE
if(~zeroflag) PCsrc = 2'b01;
else PCsrc = 2'b00;
end
3'b100: begin//BLT
if(signflag != overflowflag) PCsrc = 2'b01;
else PCsrc = 2'b00;
end
3'b101: begin//BGE
if(signflag == overflowflag)  PCsrc = 2'b01;
else PCsrc = 2'b00;
end
3'b110: begin//BLTU
if(~carryflag) PCsrc = 2'b01;
else  PCsrc = 2'b00;
end
3'b111: begin//BGEU
if(carryflag)  PCsrc = 2'b01;
else  PCsrc = 2'b00;
end
default: PCsrc = 0; //??
endcase
end //if end

else begin//if branch == 0
if(JALRflag == 1)    PCsrc = 2'b11;
else if(JALflag == 1)   PCsrc = 2'b01;
else   PCsrc = 2'b00;
end 

end //always end

endmodule
