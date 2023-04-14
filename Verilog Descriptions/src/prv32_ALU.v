`include "defines.v"
/*******************************************************************
*
* Module: prv32_ALU.v
* Project: Project1_3abra_Sasa
* Author: Abdelrahman Said & Mostafa Ibrahim
* Description: The main module where all the processor components are connected together.
*
* Change history: 
* 25/10/21 - Changed the cases from the hard coded values to the constants defined in "defines.v"
* 27/10/21 - Implemented the shifter.
*
**********************************************************************/
module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] result,
	output  wire  cf, zf, vf, sf,//cf: carry flag, zf: zero flag, vf: overflow flag, sf: sign flag.
	input   wire [3:0]  alufn //ALUsel
);

    wire [31:0] add, op_b;
    //wire cfa, cfs, sub;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b); //op_b +1'b1 is the 2's complement of b
                                                                //If alufn[0] = 1 then add, if 0 then sub. 0 
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf); //a[31], ~b[31], add[31], carry flag
    
    wire[31:0] shift;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(shift));
    
    always @ * begin
        result = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            `ALU_ADD : result = add;
            `ALU_SUB : result = add;
            `ALU_PASS : result = b; //LUI immediate shifted 12. (PASS is only used for LUI)
            // logic
            `ALU_OR:  result = a | b;
            `ALU_AND:  result = a & b;
            `ALU_XOR:  result = a ^ b;
            // shift
            `ALU_SRL:  result=shift;
            `ALU_SLL:  result=shift;
            `ALU_SRA:  result=shift;
            // slt & sltu
            `ALU_SLT:  result = {31'b0,(sf != vf)}; 
            `ALU_SLTU:  result = {31'b0,(~cf)};
             
             default: result = 0;            	
        endcase
    end
endmodule