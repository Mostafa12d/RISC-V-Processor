`timescale 1ns / 1ps
/*******************************************************************
*
* Module: SC_Processor.v
* Project: Project1_3abra_Sasa
* Author: Abdelrahman Said & Mostafa Ibrahim
* Description: The main module where all the processor components are connected together.
*
* Change history: 
* 24/10/21 - Changed the ALU used in lab 6 to the ALU module provided (ALU result).
*
**********************************************************************/
`include "defines.v"
module SC_Processor(
input rst, input clk
//input [1:0] ledSel,
//input [3:0] ssdSel,
//input ssdClk,
//output [7:0] AN,
//output [6:0] LED_out,
//output reg[15:0] LEDs
);
wire[31:0] immGen_wire;
wire [31:0] instruction, pc; //coming out of PC
wire Branch, MemRead, MemWrite, ALUSrc, RegWrite; //Control Unit Signals  // Most significant bit indicates MemRead/MemWrite the r
wire HaltFlag, loadSignal;
wire [1:0] WriteBack; 
reg [31:0] PC_input; //The value coming to the PC (either PC+4 or PC+Imm)

Halt_Execution halt_Execution(.rst(rst),.HaltFlag(HaltFlag), .loadSignal(loadSignal)); //Coming from the Control unit//Should enter in the load of the PC

Register_32bit PC(clk, loadSignal, rst, PC_input, pc); //Replace 1 with load signal from the Halt Execution unit

wire [31:0] Add4_wire; //coming out of the first adder (PC+4)
wire cout1, cout2;
RippleAdder_32bit Add4(.x1(pc), .x2(`PC_FOUR),.cin(`ZERO), .sum(Add4_wire), .cout(cout1));

wire [31:0] AddImm_wire; //coming out of the second adder (PC+Imm)
RippleAdder_32bit AddImm(.x1(pc), .x2(immGen_wire),.cin(`ZERO), .sum(AddImm_wire), .cout(cout2));

wire [31:0] dataMem_data_out;

wire cf, zf, vf ,sf; //zf = zero flag, sf = sign flag, vf = overflow flag, cf = carry flag
wire [1:0] PCsrc; //The select for the mux that chooses between PC+4 and Target Address
wire JALRflag, JALflag;         
wire [31:0] ALU_result; //coming out of the ALU
Branch_CU Branch_Control_Unit(.Branch(Branch), .zeroflag(zf), .carryflag(cf), .overflowflag(vf), .signflag(sf), .JALRflag(JALRflag), .JALflag(JALflag),
                              .func3(instruction[`IR_funct3]), .PCsrc(PCsrc));
always@(*) begin
case(PCsrc)
2'b00: PC_input = Add4_wire;
2'b01: PC_input = AddImm_wire;
2'b10: PC_input = ALU_result;

default: PC_input = Add4_wire;
endcase
end
                              
Instruct_Mem instructMem(pc [7:2], instruction); //instruction[7:2] = address.


reg [31:0] writeData_wire; //coming out of the right most mux next to data memory
//wire regWrite_wire; //coming out of Control unit
wire [31:0] readData1, readData2;

// This block is the MUX implementation for JAL/JALR/AUIPC/LUI [MUX]
always@(*) begin  
case(WriteBack)
2'b00: writeData_wire = ALU_result; //ALU output
2'b01: writeData_wire = Add4_wire; //jal/jalr
2'b10: writeData_wire = dataMem_data_out; //load
2'b11: writeData_wire = AddImm_wire; //auipc
default: writeData_wire = 0;
endcase

end
RegFile regFile(clk, rst, instruction[19:15], instruction[24:20], instruction[11:7], writeData_wire, RegWrite, readData1, readData2 );




wire [31:0] readData2_mux;
Imm_Gen immGen(instruction, immGen_wire);
Mux_2x1_32bit mux_RegImmgen(readData2, immGen_wire, ALUSrc, readData2_mux);

wire [1:0] ALUOp; //coming out of the Control Unit
wire LUIflag;
Control_Unit CU(instruction[6:2], Branch, MemRead, ALUSrc, RegWrite, MemWrite, JALRflag, JALflag, LUIflag, HaltFlag,ALUOp, WriteBack);

wire [3:0] ALUsel;
ALU_CU ALU_CONTROL(instruction[`IR_funct3], instruction[30], ALUOp, LUIflag, ALUsel);

prv32_ALU ALU_main(.a(readData1), .b(readData2_mux), .shamt(readData2_mux), .result(ALU_result), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUsel));

Data_Mem dataMem(clk, MemRead, MemWrite, instruction[`IR_funct3], ALU_result[7:0], readData2, dataMem_data_out);



//always @(*) begin 
//case (ledSel)
//2'b00: LEDs = instruction[15:0];
//2'b01: LEDs = instruction[31:16];
//2'b10: LEDs = {2'b00, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, ALUsel, zeroFlag_wire,(Branch & zeroFlag_wire)};
//endcase 
//end

//reg [12:0] Display;
//always @(*) begin
//case (ssdSel)
//4'b0000: Display = pc[12:0]; //PC_out
//4'b0001: Display = Add4_wire[12:0]; //PC_out + 4
//4'b0010: Display = AddImm_wire[12:0];
//4'b0011: Display = PC_input[12:0];
//4'b0100: Display = readData1[12:0];
//4'b0101: Display = readData2[12:0];
//4'b0110: Display = writeData_wire[12:0];
//4'b0111: Display = immGen_wire[12:0];
//4'b1000: Display = shiftleft_wire[12:0];
//4'b1001: Display = readData2_mux[12:0];
//4'b1010: Display = ALU_result[12:0];
//4'b1011: Display = dataMem_data_out[12:0];
//endcase
//end

//SSD ssd(ssdClk, Display, AN[3:0], AN[7:4],LED_out);


endmodule
