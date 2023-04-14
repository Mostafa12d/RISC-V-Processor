`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: ALU_CU.v
* Project: Project1_3abra_Sasa
* Author: Abdelrahman Said & Mostafa Ibrahim
* Description: The main module where all the processor components are connected together.
*
* Change history: 
* 26/10/21 - Added Pass, xor, srl, sra, sll, slt, sltu cases.
*
**********************************************************************/


module ALU_CU(
input [2:0] func3, 
input in, 
input [1:0] ALUOp,
input LUIflag,
output reg[3:0] ALUsel
 );
 
 always @(*) begin
    
 casez ({ALUOp,in, func3, LUIflag}) 
 7'b00?????: begin //ADD
    ALUsel = `ALU_ADD;
 end
 7'b01?????: begin //SUB
    ALUsel = `ALU_SUB;
 end
 
 //R type
 7'b10_0_0000: //ADD
    ALUsel = `ALU_ADD;
 7'b10_1_0000: //SUB
    ALUsel = `ALU_SUB;
 7'b10_0_1110: //AND
    ALUsel = `ALU_AND;
 7'b10_0_1100: //OR
    ALUsel = `ALU_OR;
 7'b10_0_1000: //XOR
    ALUsel = `ALU_XOR;
 7'b10_0_1010: //SRL
    ALUsel = `ALU_SRL;
 7'b10_1_1010: //SRA
    ALUsel = `ALU_SRA;
 7'b10_0_0010: //SLL
    ALUsel = `ALU_SLL;
 7'b10_0_0100: //SLT
    ALUsel = `ALU_SLT;
 7'b10_0_0110: //SLTU
    ALUsel = `ALU_SLTU;
    
//I type
 7'b11?0000://ADDI
     ALUsel = `ALU_ADD;
 7'b11?0100://SLTI
     ALUsel = `ALU_SLT;
 7'b11?0110://SLTIU
     ALUsel = `ALU_SLTU;
 7'b11?1000://XORI
     ALUsel = `ALU_XOR;
 7'b11?1100://ORI
     ALUsel = `ALU_OR;
 7'b11?1110://ANDI
     ALUsel = `ALU_AND;
 7'b11_0_0010: //SLLI
     ALUsel = `ALU_SLL;
 7'b11_0_1010: //SRLI
     ALUsel = `ALU_SRL;
 7'b11_1_1010: //SRAI
     ALUsel = `ALU_SRA;
 7'b??????1: //LUIflag = 1
    ALUsel = `ALU_PASS;
 default:  //PASS
     ALUsel = `ALU_PASS; 
     
 endcase
 
 if(LUIflag)
     ALUsel = `ALU_PASS;
     
 end 
endmodule
