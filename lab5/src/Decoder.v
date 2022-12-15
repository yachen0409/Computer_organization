//109550073
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
);
// don't need jump
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o, MemtoReg_o;
output         Branch_o;
output         MemRead_o, MemWrite_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o, MemtoReg_o;
reg            Branch_o;
reg            MemRead_o, MemWrite_o;

//Parameter


//Main function
always @(*) begin
    RegDst_o <= (instr_op_i == 6'b000000)? 1'b1:1'b0; //rformat
    MemtoReg_o <= (instr_op_i == 6'b100011)? 1'b1:1'b0; //lw
    RegWrite_o <= (instr_op_i == 6'b000100 || instr_op_i == 6'b101011|| instr_op_i == 6'b000101|| instr_op_i == 6'b000001 || instr_op_i == 6'b000111)? 1'b0:1'b1; //beq sw
    Branch_o <= (instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000001 || instr_op_i == 6'b000111)? 1'b1:1'b0;
    ALUSrc_o <= (instr_op_i == 6'b001000||instr_op_i == 6'b001010||instr_op_i == 6'b100011||instr_op_i == 6'b101011)? 1'b1:1'b0; //add slt lwsw
    ALU_op_o <= (instr_op_i == 6'b000000)? 3'b100:   //rformat     
                (instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000001 || instr_op_i == 6'b000111)? 3'b001: //beq
                (instr_op_i == 6'b001010)? 3'b010: //slt 
                (instr_op_i == 6'b001000||instr_op_i == 6'b100011||instr_op_i == 6'b101011)? 3'b000: 3'bxxx;//addi lwsw 
    MemRead_o <= (instr_op_i == 6'b100011)? 1'b1:1'b0; //lw
    MemWrite_o <= (instr_op_i == 6'b101011)? 1'b1:1'b0; //sw
end
endmodule





                    
                    