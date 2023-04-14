`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: Control_Unit.v
* Project: Project1_3abra_Sasa
* Author: Abdelrahman Said & Mostafa Ibrahim
* Description: The main module where all the processor components are connected together.
*
* Change history: 
* 25/10/21 - Added cases to accomodate JAL, JALR, LUI, AUIPC, and Immediate instructions.
*
**********************************************************************/


module Control_Unit(
input [4:0]instr,
output reg Branch, MemRead, ALUSrc, RegWrite, MemWrite, JALRflag, JALflag, LUIflag, HaltFlag,
output reg[1:0]ALUOp,  WriteBack); //WriteBack signal is the select for the mux before the write back port in the reg file
    always @(*) begin
    case(instr)
    `OPCODE_Arith_R: begin //R-Format
        Branch = 0;
        MemRead = 0; 
        WriteBack = 2'b00; //MUX to regfile
        ALUOp = 2'b10;
        MemWrite = 0;
        ALUSrc = 0; 
        RegWrite = 1;
        JALRflag = 1'b0;
        JALflag = 1'b0;
        HaltFlag = 1'b0;
        LUIflag = 1'b0;
    end
    `OPCODE_Arith_I: begin //I-Format
        Branch = 0;
        MemRead = 0; 
        WriteBack = 2'b00; //MUX to regfile
        ALUOp = 2'b11;
        MemWrite = 0;
        ALUSrc = 1; 
        RegWrite = 1;
        JALRflag = 1'b0;
        JALflag = 1'b0;
        HaltFlag = 1'b0;
        LUIflag = 1'b0;
       end
    `OPCODE_LUI: begin
        Branch = 0;
        MemRead = 0; 
        WriteBack = 2'b00; //Coming from the ALU
        ALUOp = 2'b10; //Modify the ALU Control to handle this
        MemWrite = 0;
        ALUSrc = 1; //ALUSrc is different because we need the value from the immGen. 
        RegWrite = 1;
        JALRflag = 1'b0;
        JALflag = 1'b0;
        HaltFlag = 1'b0;
        LUIflag = 1'b1;
    end
     (`OPCODE_JALR): begin //JAL/JALR use addition
       Branch = 0;
       MemRead = 0; 
       WriteBack = 2'b01; 
       ALUOp = 2'b00;
       MemWrite = 0;
       ALUSrc = 1; 
       RegWrite = 1;
       JALRflag = 1'b1;
       JALflag = 1'b0;
       HaltFlag = 1'b0;
       LUIflag = 1'b0;
   end
    (`OPCODE_JAL): begin //JAL/use addition
       Branch = 0;
       MemRead = 0; 
       WriteBack = 2'b01; 
       ALUOp = 2'b00;
       MemWrite = 0;
       ALUSrc = 1; 
       RegWrite = 1;
       JALRflag = 1'b0;
       JALflag = 1'b1;
       HaltFlag = 1'b0;
       LUIflag = 1'b0;
   end
    `OPCODE_Load: begin //LW use addition
     Branch = 0;
     MemRead = 1; 
     WriteBack = 2'b10; 
     ALUOp = 2'b00;
     MemWrite = 0;
     ALUSrc = 1; 
     RegWrite = 1;
     JALRflag = 1'b0;
     JALflag = 1'b0;
     HaltFlag = 1'b0;
     LUIflag = 1'b0;
    end
     `OPCODE_AUIPC: begin //auipc use addition
     Branch = 0;
     MemRead = 0; 
     WriteBack = 2'b11; //Coming from the ALU
     ALUOp = 2'b10; //Modify the ALU Control to handle this
     MemWrite = 0;
     ALUSrc = 1; //
     RegWrite = 1;
     JALRflag = 1'b0;
     JALflag = 1'b0;
     HaltFlag = 1'b0;
     LUIflag = 1'b0;
    end
    `OPCODE_Store: begin //SW
       Branch = 0;
       MemRead = 0; 
       WriteBack = 0; //Don't care
       ALUOp = 2'b00;
       MemWrite = 1;
       ALUSrc = 1; 
       RegWrite = 0;
       JALRflag = 1'b0;
       JALflag = 1'b0;
       HaltFlag = 1'b0;
       LUIflag = 1'b0;
   end
    `OPCODE_Branch: begin //Branch uses subtraction
       Branch = 1;
       MemRead = 0; 
       WriteBack = 2'b00; 
       ALUOp = 2'b01;
       MemWrite = 0;
       ALUSrc = 0; 
       RegWrite = 0;
       JALRflag = 1'b0;
       JALflag = 1'b0;
       HaltFlag = 1'b0;
       LUIflag = 1'b0;
   end
   `OPCODE_SYSTEM ,
    `OPCODE_FENCE:
     begin
       Branch = 0;
       MemRead = 0; 
       WriteBack = 2'b00; 
       ALUOp = 2'b00;
       MemWrite = 0;
       ALUSrc = 0; 
       RegWrite = 0;
       JALRflag = 1'b0;
       JALflag = 1'b0;
       HaltFlag = 1'b1;
       LUIflag = 1'b0;
   end
   //OPCODE for FENCE, ECALL, EBREAK to halt the execution
   //Add default case.
   default: begin
      Branch = 0;
      MemRead = 0; 
      WriteBack = 2'b00; 
      ALUOp = 2'b00;
      MemWrite = 0;
      ALUSrc = 0; 
      RegWrite = 0;
      JALRflag = 1'b0;
      JALflag = 1'b0;
      HaltFlag = 1'b0;
      LUIflag = 1'b0;
   end
   endcase
end
endmodule
