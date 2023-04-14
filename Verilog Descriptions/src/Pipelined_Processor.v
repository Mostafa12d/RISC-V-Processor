`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: Pipelined_Processor.v
* Project: Project1_3abra_Sasa
* Author: Abdelrahman Said & Mostafa Ibrahim
* Description: The main module where all the processor components are connected together.
*
* Change history: 
* 6/11/21 - Connected the different components of the datapath (Not tested). [No Forwarding CU, No Hazards CU, No Single memory]
* 7/11/21 - Fixed the Control signals and their propagation through the different stages (Not tested)
* 13/11/21 - Added the forwarding unit, hazard detection unit, and the flushing mechanism.
           - Tested these added features on the lab program
**********************************************************************/

module Pipelined_Processor(input rst, input clk,
input [3:0] ledSel,
input [3:0] ssdSel,
//input [4:0] regSel,
input ssdClk,
output [7:0] AN,
output [6:0] LED_out,
output reg[15:0] LEDs
);

//reg sclk;
//always @(posedge clk, posedge rst) begin
//begin
//    if(rst)
//        sclk = 0;
//    else
//        sclk = ~sclk;
//end
//end

//IF
//wire [31:0] instruction_to_IF_ID;
wire [31:0] PC_input;
wire [31:0] PC_out; //coming out of PC
wire [31:0] Add4_wire; //coming out of the first adder (PC+4)
wire [31:0] Mem_Out; // Address going to the single memory
//wire loadSignal;

reg [7:0] Mem_In;
//wire stall;

//ID
wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PC4;
wire[31:0] immGen_wire;
wire [31:0] readData1, readData2;
//wire [12:0] muxControlSignals;
wire [1:0] ALUOp, WriteBack; //coming out of the Control Unit
wire Branch, MemRead, MemWrite, ALUSrc, RegWrite, JALRflag, JALflag, LUIflag, HaltFlag; //Control Unit Signals

wire [31:0] ALU_result; //coming out of the ALU
wire [3:0] ALUsel;
wire cf, zf, vf, sf; //zf = zero flag, sf = sign flag, vf = overflow flag, cf = carry flag

//EX
wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_PC4;
wire [12:0] ID_EX_Ctrl; // all control signals concatinated 
wire [3:0] ID_EX_Func3;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
wire [7:0] ID_EX_Ctrl_mux;

wire [31:0] Branch_Add;
wire [1:0] ForwardA, ForwardB;
wire [31:0] rs2_new;
wire [1:0] PCsrc;
wire EX_MEM_Zero;
wire [31:0] ALU_A, ALU_B;


//MEM
wire [31:0] EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC4, EX_MEM_Imm;
wire [31:0] EX_MEM_BranchAddOut;
wire [7:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire [3:0] EX_MEM_ALUflags;
wire [2:0] EX_MEM_func3;



//WB
wire [2:0] MEM_WB_Ctrl;
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_PC4, MEM_WB_Imm;
wire [4:0] MEM_WB_Rd;
wire [31:0] writeData_wire; //coming out of the right most mux next to data memory

//wire [31:0] instruct_data_out; //coming out of instruction memory
//wire [31:0] Mem_data_out; //coming out of data memory


//wire regWrite_wire; //coming out of Control unit
//wire [31:0] dataMem_data_out; //coming out of data memory
//Not used
wire cout1;
wire cout2;

//*************STAGE 1*****************

always@(*) begin
case(clk)
1'b1: Mem_In = PC_out [7:0]; 
1'b0: Mem_In = EX_MEM_ALU_out[7:0]; 
endcase
end
//Mux_2x1_32bit Instr_Data_Mux(.x0(PC_out [5:0]), .x1(EX_MEM_ALU_out[5:0]), .select(clk), .out(Mem_In));

Memory Main_Memory(.clk(clk), .MemRead(EX_MEM_Ctrl[0]), .MemWrite(EX_MEM_Ctrl[1]),
                   .func3(EX_MEM_func3), .addr(Mem_In), .data_in(EX_MEM_RegR2), .finalOutput(Mem_Out));                                                             
                                                                //potential error
Mux_4x1_32bit Mux_PCsrc(.x0(Add4_wire), .x1(EX_MEM_BranchAddOut), .x2(Add4_wire), .x3(EX_MEM_ALU_out), .select(PCsrc), .out(PC_input));
 //wire temp =~(HaltFlag &PCsrc[1] &PCsrc[0]);
Register_32bit PC(.clk(clk), .rst(rst), .load(~(HaltFlag & PCsrc[1] & PCsrc[0])), .D(PC_input), .Q(PC_out)); //+ve //potential error

RippleAdder_32bit Add4( .x1(32'd4), .x2(PC_out), .cin(1'b0), .sum(Add4_wire), .cout(cout1));

//Instruct_Mem instructMem(PC_out [7:2], instruct_data_out); //instruction[7:2] = address. //FIX THIS AT THE END [MAKE IT BYTE ADDRESSABLE]

//Halt_Execution halt_Execution(.rst(rst),.HaltFlag(ID_EX_Ctrl[4]), .loadSignal(HaltFlag)); //Coming from the Control unit//Should enter in the load of the PC
//Halt_Execution halt_Execution(.instruction(PC_out),.HaltFlag(, .loadSignal(loadSignal)); //Should enter in the load of the PC

//Hazard_Detection_Unit hazardUnit(.IF_ID_Rs1(IF_ID_Inst[19:15]), .IF_ID_Rs2(IF_ID_Inst[24:20]), .ID_EX_Rd(ID_EX_Rd), 
//.ID_EX_MemRead(ID_EX_Ctrl[5]), .stall(stall));

//flushing
//Mux_2x1_32bit ID_EX_instruct_mux(.x0(Mem_Out), .x1(32'd51), .select(PCsrc[0]), .out(instruction_to_IF_ID));
                                                                            //error
//load should always be 1 in the IF_ID stage.
Register_32bit #(96) IF_ID (.clk(~clk), .rst(rst), .load(1'b1), .D({PC_out, Mem_Out, Add4_wire}), .Q({IF_ID_PC, IF_ID_Inst, IF_ID_PC4})); //IF/ID //-ve



//**************STAGE 2*****************

Control_Unit CU(.instr(IF_ID_Inst[6:2]), .Branch(Branch), .MemRead(MemRead), .ALUSrc(ALUSrc), .RegWrite(RegWrite),
                .MemWrite(MemWrite), .JALRflag(JALRflag), .JALflag(JALflag), .LUIflag(LUIflag), .HaltFlag(HaltFlag),
                 .ALUOp(ALUOp), .WriteBack(WriteBack)); //ALUOp 2 bits

Imm_Gen immGen(.IR(IF_ID_Inst), .Imm(immGen_wire));

RegFile regFile(.clk(~clk), .rst(rst), .readreg1(IF_ID_Inst[19:15]), .readreg2(IF_ID_Inst[24:20]),
                .writereg(MEM_WB_Rd), .writedata(writeData_wire),  .regwrite(MEM_WB_Ctrl[2]), 
                .readdata1(readData1), .readdata2(readData2)); //-ve


//flushing control signals
//Mux_2x1_Parametrized #(13) HazardControlMux(.x0({RegWrite, WriteBack, Branch, JALRflag, JALflag, MemWrite, MemRead, HaltFlag, LUIflag, ALUSrc, ALUOp}),
//                                            .x1(13'd0), .select(PCsrc[0]), .out(muxControlSignals));
                                                                        //error
Register_32bit #(192) ID_EX (.clk(clk),.rst(rst),.load(1'b1), //ID/EX +ve
 .D({{RegWrite, WriteBack, Branch, JALRflag, JALflag, MemWrite, MemRead, HaltFlag, LUIflag, ALUSrc, ALUOp}, IF_ID_PC, readData1, readData2, IF_ID_Inst[19:15], IF_ID_Inst[24:20], immGen_wire, 
   IF_ID_PC4, {IF_ID_Inst[30],IF_ID_Inst[14:12]}, IF_ID_Inst[11:7]}),
  .Q({ID_EX_Ctrl, ID_EX_PC, ID_EX_RegR1,ID_EX_RegR2, ID_EX_Rs1,ID_EX_Rs2, ID_EX_Imm, ID_EX_PC4, ID_EX_Func3, ID_EX_Rd}) ); //+ve

//**************STAGE 3*****************

//ID_EX_Ctrl[1:0] = ALUOp
//ID_EX_Ctrl[2] = ALUSrc
//ID_EX_Ctrl[3] = LUIflag
//ID_EX_Ctrl[4] = HALTflag

ALU_CU ALU_CONTROL(.func3(ID_EX_Func3[2:0]), .in(ID_EX_Func3[3]), .ALUOp(ID_EX_Ctrl[1:0]), .LUIflag(ID_EX_Ctrl[3]), .ALUsel(ALUsel));

Mux_2x1_Parametrized mux_RegImmgen(.x0(rs2_new), .x1(ID_EX_Imm), .select(ID_EX_Ctrl[2]), .out(ALU_B));

prv32_ALU ALU_main(.a(ALU_A), .b(ALU_B), .shamt(ALU_B), .result(ALU_result), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .alufn(ALUsel));
                                                    //ALU_B ERROR!!!!
RippleAdder_32bit BranchAdd(.x1(ID_EX_PC), .x2(ID_EX_Imm), .cin(1'b0), .sum(Branch_Add), .cout(cout2));

//FORWARDING
Forwarding_Unit Fwd( .ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd),
                     .EX_MEM_RegWrite(EX_MEM_Ctrl[7]), .MEM_WB_RegWrite(MEM_WB_Ctrl[2]),
                     .ForwardA(ForwardA), .ForwardB(ForwardB));
                     
//First ALU input mux
Mux_4x1_32bit Mux_FwdA(.x0(ID_EX_RegR1), .x1(writeData_wire), .x2(EX_MEM_ALU_out), .x3(`ZERO), .select(ForwardA), .out(ALU_A));

 //Second ALU input mux
Mux_4x1_32bit Mux_FwdB(.x0(ID_EX_RegR2), .x1(writeData_wire), .x2(EX_MEM_ALU_out), .x3(`ZERO), .select(ForwardB), .out(rs2_new));

//flushing
Mux_2x1_Parametrized #(8) ID_EX_Ctrl_Mux(.x0(ID_EX_Ctrl[12:5]), .x1(8'b0), .select(PCsrc[0]), .out(ID_EX_Ctrl_mux));


Register_32bit #(181) EX_MEM (.clk(~clk), .rst(rst), .load(1'b1), //EX/MEM -ve              //BranchAdd?
 .D({ID_EX_Ctrl_mux, Branch_Add, ALU_result, rs2_new, ID_EX_PC4, ID_EX_Imm, ID_EX_Rd, ID_EX_Func3[2:0], {cf, zf, vf, sf}}),
 .Q({EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PC4, EX_MEM_Imm, EX_MEM_Rd, EX_MEM_func3, EX_MEM_ALUflags}));
//EX_MEM_Ctrl = {RegWrite, WriteBack, Branch, JALRflag, JALflag, MemWrite, MemRead}

//**************STAGE 4*****************

//Data_Mem dataMem(clk, EX_MEM_Ctrl[0], EX_MEM_Ctrl[1], EX_MEM_func3, EX_MEM_ALU_out[5:0], EX_MEM_RegR2, dataMem_data_out); //+ve
                        //memRead       //memWrite

                                        //Branch
Branch_CU Branch_Control_Unit(.Branch(EX_MEM_Ctrl[4]), .zeroflag(EX_MEM_ALUflags[2]), .carryflag(EX_MEM_ALUflags[3]), 
                              .overflowflag(EX_MEM_ALUflags[1]), .signflag(EX_MEM_ALUflags[0]), .JALRflag(EX_MEM_Ctrl[3]), 
                              .JALflag(EX_MEM_Ctrl[2]), .func3(EX_MEM_func3), .PCsrc(PCsrc));              
                                        

Register_32bit #(139) MEM_WB (.clk(clk),.rst(rst),.load(1'b1), //MEM/WB
 .D({EX_MEM_Ctrl[7:5], Mem_Out,  EX_MEM_ALU_out, EX_MEM_PC4, EX_MEM_BranchAddOut, EX_MEM_Rd}), 
 .Q({MEM_WB_Ctrl, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_PC4, MEM_WB_Imm, MEM_WB_Rd})); //+ve
//MEM_WB_Ctrl = {RegWrite, WriteBack}

//**************STAGE 5*****************

//4x1 mux selecting between 32-bit inputs
Mux_4x1_32bit Mux_WriteBack(.x0(MEM_WB_ALU_out), .x1(MEM_WB_PC4), .x2(MEM_WB_Mem_out), .x3(MEM_WB_Imm), .select(MEM_WB_Ctrl[1:0]), .out(writeData_wire));

//// Display
always @(*) begin 
case (ledSel)
4'b0000: LEDs = PC_out[15:0];
4'b0001: LEDs = PC_out[31:16];
4'b0010: LEDs = {2'b00, Branch, MemRead, PCsrc, MemWrite, ALUSrc, RegWrite, WriteBack, ALUOp, ALUsel,JALRflag, JALflag, zf};
4'b0011: LEDs = {MEM_WB_Rd, EX_MEM_Rd, ID_EX_Rd};
4'b0100: LEDs = Mem_Out[15:0];
4'b0101: LEDs = Mem_Out[31:16];
4'b0110: LEDs = ID_EX_Ctrl[12:5];
4'b0101: LEDs = ID_EX_Ctrl_mux;

default: LEDs = 16'b0;
endcase
end

reg [12:0] Display;
always @(*) begin
case (ssdSel)
4'b0000: Display = PC_out[12:0]; //PC_out
4'b0001: Display = Add4_wire[12:0]; //PC_out + 4
4'b0010: Display = immGen_wire[12:0];
4'b0011: Display = PC_input[12:0];
4'b0100: Display = readData1[12:0];
4'b0101: Display = readData2[12:0];
4'b0110: Display = writeData_wire[12:0];
4'b0111: Display = immGen_wire[12:0];
4'b1000: Display = ALU_result[12:0];
4'b1001: Display = ALU_B[12:0];
4'b1010: Display = EX_MEM_BranchAddOut[12:0];
4'b1011: Display = Mem_Out[12:0];
4'b1100: Display = Mem_In;
default: Display = 13'b0;
endcase
end

SSD ssd(ssdClk, Display, AN[3:0], AN[7:4],LED_out);

//Board display(.ssdSel(ssdSel), .ledSel(ledSel), .inst_data_sel(`ZERO), .ssdClk(ssdClk), .readData1(readData1), .readData2(ALU_B), .writeData_wire(writeData_wire),
//.ALU_result(ALU_result), .Regfile_Data_Out(), .PC_out(PC_out), .PC_in(PC_input), .inst(Mem_Out), .data(MEM_WB_Mem_out), .LEDs(LEDs));

endmodule