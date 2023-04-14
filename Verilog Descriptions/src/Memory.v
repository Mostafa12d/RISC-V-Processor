`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2021 03:19:02 PM
// Design Name: 
// Module Name: Memory
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

//add signal to indicate data or instruction
module Memory(
input clk,
input MemRead, MemWrite,
input [2:0] func3,
input [7:0] addr, //Assuming 4096 locations.
input [31:0] data_in,
output reg [31:0] finalOutput
);
parameter offset = 8'd128;
reg [7:0] mem [0:255];
reg [10:0] dataAddr;
reg [10:0] instrAddr;
reg [31:0] instructionOut;
reg [31:0] data_out;

always@(*) begin
//0: instruction
//1: data
if(clk) begin //instruction
    instrAddr = addr;
    //dataAddr = 0;
    finalOutput = instructionOut;
end
else begin
    dataAddr = addr + offset;
    //instrAddr = 0;
    finalOutput = data_out;
end
end

//Instructions
always@(*) begin
    instructionOut = {mem[instrAddr+3],mem[instrAddr+2],mem[instrAddr+1],mem[instrAddr]};
end
//Data
always@(posedge clk) begin
 case({MemWrite, func3})
4'b1000: mem[dataAddr] = data_in[7:0];  //sb  
4'b1001: {mem[dataAddr + 1], mem[dataAddr]} = data_in[15:0]; //sh
4'b1010: {mem[dataAddr + 3], mem[dataAddr + 2], mem[dataAddr+1], mem[dataAddr]} = data_in; //sw
endcase 
end

always@(*) begin
case({MemRead, func3})
4'b1000: data_out = $signed(mem[dataAddr]);//lb
4'b1001: data_out = $signed({mem[dataAddr + 1], mem[dataAddr]});//lh
4'b1010: data_out = $signed({mem[dataAddr + 3], mem[dataAddr + 2], mem[dataAddr + 1], mem[dataAddr]});//lw
4'b1100: data_out = $unsigned(mem[dataAddr]);//lbu
4'b1101: data_out = $unsigned({mem[dataAddr + 1], mem[dataAddr]});//lhu
default: data_out=0;
endcase
end

//instructions
initial begin
//lab test
{mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
// //added to be skipped since PC starts with 4 after reset
{mem[7],mem[6],mem[5],mem[4]} = 32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
 {mem[11],mem[10],mem[9],mem[8]}= 32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
 {mem[15],mem[14],mem[13],mem[12]}= 32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
 {mem[19],mem[18],mem[17],mem[16]}= 32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
 {mem[23],mem[22],mem[21],mem[20]}= 32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4  pc 20 24 28    32 =>   40
 {mem[27],mem[26],mem[25],mem[24]}= 32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
 {mem[31],mem[30],mem[29],mem[28]}= 32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
 {mem[35],mem[34],mem[33],mem[32]}= 32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
 {mem[39],mem[38],mem[37],mem[36]}= 32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
 {mem[43],mem[42],mem[41],mem[40]}= 32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
 {mem[47],mem[46],mem[45],mem[44]}= 32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
 {mem[51],mem[50],mem[49],mem[48]}= 32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
 {mem[55],mem[54],mem[53],mem[52]}= 32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
 {mem[59],mem[58],mem[57],mem[56]}= 32'b0000000_00001_00000_000_00000_1110011 ;

////R-type (Working)
//{mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//// //added to be skipped since PC starts with 4 after reset
//{mem[7],mem[6],mem[5],mem[4]} = 32'b00000000100100000000000010010011 ; 
//{mem[11],mem[10],mem[9],mem[8]}= 32'b00000000001000000000000100010011; 
//{mem[15],mem[14],mem[13],mem[12]}= 32'b11111111011000000000111110010011; 
//{mem[19],mem[18],mem[17],mem[16]}= 32'b00000000001000001000000110110011; 
//{mem[23],mem[22],mem[21],mem[20]}= 32'b01000000001000001000001000110011;
//{mem[27],mem[26],mem[25],mem[24]}= 32'b00000000001000001111001010110011 ; 
//{mem[31],mem[30],mem[29],mem[28]}= 32'b00000000001000001110001100110011;
//{mem[35],mem[34],mem[33],mem[32]}= 32'b00000000001000001100001110110011; 
//{mem[39],mem[38],mem[37],mem[36]}= 32'b00000000001000001001010000110011; 
//{mem[43],mem[42],mem[41],mem[40]}= 32'b00000000001011111101010010110011; 
//{mem[47],mem[46],mem[45],mem[44]}= 32'b01000000001011111101010100110011; 
//{mem[51],mem[50],mem[49],mem[48]}= 32'b00000000000111111010011010110011;
//{mem[55],mem[54],mem[53],mem[52]}= 32'b00000000000111111011010100110011;
//{mem[59],mem[58],mem[57],mem[56]}= 32'b00000000001000001000010110110011;
//{mem[63],mem[62],mem[61],mem[60]}= 32'b00000000001001011000010110110011 ;
//{mem[67],mem[66],mem[65],mem[64]}= 32'b00000000001101011000011000110011 ;

//auipc
//{mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//// //added to be skipped since PC starts with 4 after reset
//{mem[7],mem[6],mem[5],mem[4]} = 32'd51 ; 
//{mem[11],mem[10],mem[9],mem[8]}= 32'd51; 
//{mem[15],mem[14],mem[13],mem[12]}= 32'd51; 
//{mem[19],mem[18],mem[17],mem[16]} = 32'b00000000000000000010000100010111 ; 

//3 nop instructions were added to make sure that the PC is being added to the immediate and stored in the register file.

//load-store
//{mem[3],mem[2],mem[1],mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//// //added to be skipped since PC starts with 4 after reset
// {mem[7],mem[6],mem[5],mem[4]} = 32'b00000000100100000000000010010011 ; 
// {mem[11],mem[10],mem[9],mem[8]}= 32'b00000000100100000000000010010011; 
// {mem[15],mem[14],mem[13],mem[12]}= 32'h00400093; //12
// {mem[19],mem[18],mem[17],mem[16]}= 32'h0f000113; //16
// {mem[23],mem[22],mem[21],mem[20]}= 32'hff0ff1b7; //20
// {mem[27],mem[26],mem[25],mem[24]}= 32'h00302223; //24 //sw 
// {mem[31],mem[30],mem[29],mem[28]}= 32'h00201423; //28 //sh
// {mem[35],mem[34],mem[33],mem[32]}= 32'h00100623; //32 //sb
// {mem[39],mem[38],mem[37],mem[36]}= 32'h00402283; //36 //lw
// {mem[43],mem[42],mem[41],mem[40]}= 32'h00801303; //40 //lh
// {mem[47],mem[46],mem[45],mem[44]}= 32'h00c00383; //44 //lb
// {mem[51],mem[50],mem[49],mem[48]}= 32'hffb00413; //48
// {mem[55],mem[54],mem[53],mem[52]}= 32'h00802823; //52 //sw
// {mem[59],mem[58],mem[57],mem[56]}= 32'h01005483; //56 //lhu

//Branches
//{mem[3], mem[2], mem[1], mem[0]} = 32'h0000033;
//    {mem[7], mem[6], mem[5], mem[4]} = 32'b00000000010100000000000010010011;
//  {mem[11], mem[10], mem[9], mem[8]} = 32'b00000000010100000000000100010011;
//{mem[15], mem[14], mem[13], mem[12]} = 32'b00000000001000001000010001100011;
//{mem[19], mem[18], mem[17], mem[16]} = 32'b00000000001000001000000110110011;
//{mem[23], mem[22], mem[21], mem[20]} = 32'b00000000100100000000001000010011;
//{mem[27], mem[26], mem[25], mem[24]} = 32'b00000000010000001001010001100011;
//{mem[31], mem[30], mem[29], mem[28]} = 32'b01000000001000001000000110110011;
//{mem[35], mem[34], mem[33], mem[32]} = 32'b00000000010000001100010001100011;
//{mem[39], mem[38], mem[37], mem[36]} = 32'b00000000001000001000000110110011;
//{mem[43], mem[42], mem[41], mem[40]} = 32'b00000000000100100101010001100011;
//{mem[47], mem[46], mem[45], mem[44]} = 32'b00000000001000001000000110110011;
//{mem[51], mem[50], mem[49], mem[48]} = 32'b11111111011000000000001100010011;
//{mem[55], mem[54], mem[53], mem[52]} = 32'b00000000000100110110011001100011;
//{mem[59], mem[58], mem[57], mem[56]} = 32'b00000000010000001000001110110011;
//{mem[63], mem[62], mem[61], mem[60]} = 32'b00000000000100110100010001100011;
//{mem[67], mem[66], mem[65], mem[64]} = 32'b00000100010100001000010100010011;
//{mem[71], mem[70], mem[69], mem[68]} = 32'b00000100010100001000010110010011;
//{mem[75], mem[74], mem[73], mem[72]} = 32'b00000000000100110101011001100011;
//{mem[79], mem[78], mem[77], mem[76]} = 32'b00000100010100001000011000010011;
//{mem[83], mem[82], mem[81], mem[80]} = 32'b00000000000100110111010001100011;
//{mem[87], mem[86], mem[85], mem[84]} = 32'b00000100010100000000011010010011;
//{mem[91], mem[90], mem[89], mem[88]} = 32'b00000100010100000000011110010011;
//{mem[95], mem[94], mem[93], mem[92]} = 32'b00000000000000000000000001110011;
//{mem[99], mem[98], mem[97], mem[96]} = 32'b00000100010100000000111110010011;
//{mem[103], mem[102], mem[101], mem[100]} = 32'b00000011110000000000111100010011;
//{mem[107], mem[106], mem[105], mem[104]} = 32'b00000100010100000000111010010011;

//I-type and Jump
//{mem[3], mem[2], mem[1], mem[0]} = 32'h0000033; //nop
//{mem[7], mem[6], mem[5], mem[4]} = 32'b00000000000000000000000010110011;
//{mem[15], mem[14], mem[13], mem[12]} = 32'b00000000100100001000000010010011;
//{mem[19], mem[18], mem[17], mem[16]} = 32'b00000001010000001000000010010011;
//{mem[23], mem[22], mem[21], mem[20]} = 32'b11111111110000001000000010010011;
//{mem[27], mem[26], mem[25], mem[24]} = 32'b00000000111100000000000100010011;
//{mem[31], mem[30], mem[29], mem[28]} = 32'b00000001000100001100000110010011;
//{mem[35], mem[34], mem[33], mem[32]} = 32'b00000001010000001110001000010011;
//{mem[39], mem[38], mem[37], mem[36]} = 32'b00000001001100001111001010010011;
//{mem[43], mem[42], mem[41], mem[40]} = 32'b00000110010000001010001100010011;
//{mem[47], mem[46], mem[45], mem[44]} = 32'b11111111101100000000111110010011;
//{mem[51], mem[50], mem[49], mem[48]} = 32'b00000110010011111010001110010011;
//{mem[55], mem[54], mem[53], mem[52]} = 32'b00000110010011111011010000010011;
//{mem[59], mem[58], mem[57], mem[56]} = 32'b00000000001000001001010010010011;
//{mem[63], mem[62], mem[61], mem[60]} = 32'b00000000001000001101010100010011;
//{mem[67], mem[66], mem[65], mem[64]} = 32'b01000000001000001101010110010011;
//{mem[71], mem[70], mem[69], mem[68]} = 32'b00000001000000000000111101101111;
//{mem[75], mem[74], mem[73], mem[72]} = 32'b00000011001000000000101000010011;
//{mem[79], mem[78], mem[77], mem[76]} = 32'b00000011001000000000100110010011;
//{mem[83], mem[82], mem[81], mem[80]} = 32'b00000011001000000000100100010011;
//{mem[87], mem[86], mem[85], mem[84]} = 32'b11111010000111111100101011100011;
//{mem[91], mem[90], mem[89], mem[88]} = 32'b0000_0000_0001_00000000000001110011; //ebreak

//{mem[95], mem[94], mem[93], mem[92]} = 32'b00000000000000000000000001110011;
//{mem[99], mem[98], mem[97], mem[96]} = 32'b00000000000000000000000001110011;


//JALR
//{mem[3], mem[2], mem[1], mem[0]} = 32'h0000033; //nop
//{mem[7], mem[6], mem[5], mem[4]} =     32'b00000000100100000000000010010011;
//{mem[15], mem[14], mem[13], mem[12]} = 32'b00000000010000000000000100010011;
//{mem[19], mem[18], mem[17], mem[16]} = 32'b00000000110000000000111111101111;
//{mem[23], mem[22], mem[21], mem[20]} = 32'b00000100010100000000101000010011;
//{mem[27], mem[26], mem[25], mem[24]} = 32'b00000000000100000000000001110011;
//{mem[31], mem[30], mem[29], mem[28]} = 32'b00000000101000000000000110010011;
//{mem[35], mem[34], mem[33], mem[32]} = 32'b00000000111100000000001000010011;
//{mem[39], mem[38], mem[37], mem[36]} = 32'b00000000000011111000000001100111;

//Hazards
// {mem[3], mem[2], mem[1], mem[0]} =       32'h00002083; //nop
// {mem[7],mem[6],mem[5],mem[4]} =          32'h00a08093; 
// {mem[11],mem[10],mem[9],mem[8]}=         32'h00402083; 
// {mem[15],mem[14],mem[13],mem[12]}=       32'h00108233; //12
// {mem[19],mem[18],mem[17],mem[16]}=       32'h00802083; //16
// {mem[23],mem[22],mem[21],mem[20]}=       32'h001080b3; //20
// {mem[27],mem[26],mem[25],mem[24]}=       32'h00a00113; //24 //sw 
// {mem[31],mem[30],mem[29],mem[28]}=       32'h00f10113; //28 //sh
// {mem[35], mem[34], mem[33], mem[32]} =   32'h01410113;
// {mem[39], mem[38], mem[37], mem[36]} =   32'h00202223;
// {mem[43], mem[42], mem[41], mem[40]} =   32'h00402183;
// {mem[47], mem[46], mem[45], mem[44]} =   32'h00402183;
                                          
 end                                     
                                         
//data                                    
 initial begin
 {mem[3+ offset],mem[2+ offset],mem[1+ offset],mem[0+ offset]}=32'd17;
 {mem[7+ offset],mem[6+ offset],mem[5+ offset],mem[4+ offset]}=32'd9;
 {mem[11+ offset],mem[10+ offset],mem[9+ offset],mem[8+ offset]}=32'd25;
 end

//add mux to select instruction or data, and the selection line is the clk
endmodule
