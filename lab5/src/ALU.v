//109550073
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	op_i,
	result_o,
	branch_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [6-1:0]   op_i;

output [32-1:0]	 result_o;
output           branch_o;

//Internal signals
reg    [32-1:0]  result_o;
reg              branch_o;

//Parameter
//Main function
always @(ctrl_i,src1_i,src2_i)begin
    case(ctrl_i)
        0: result_o <= src1_i & src2_i; //and
        1: result_o <= src1_i | src2_i; //or
        2: result_o <= src1_i + src2_i; //addu
        3: result_o <= src1_i * src2_i;
        6: result_o <= src1_i - src2_i; //subu
        7: result_o <= (src1_i < src2_i)? 1 : 0; //slt
        8: begin
           case(op_i)
           6'b000100: branch_o = (src1_i == src2_i)?1:0;
           6'b000101: branch_o = (src1_i != src2_i)?1:0;
           6'b000001: branch_o = (src1_i >= src2_i)?1:0;
           6'b000111: branch_o = (src1_i > src2_i)?1:0;
           endcase
           end
        12: result_o <= ~(src1_i | src2_i);
        default : result_o <= 0;
    endcase
end
//Main function

endmodule





                    
                    