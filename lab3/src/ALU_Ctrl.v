//109550073

//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
always@(*) begin
    ALUCtrl_o <= (ALUOp_i == 3'b100 && funct_i == 6'b100000)? 4'b0010: //add 
                   (ALUOp_i == 3'b100 && funct_i == 6'b100010)? 4'b0110: //sub
                   (ALUOp_i == 3'b100 && funct_i == 6'b100101)? 4'b0001: //or    
                   (ALUOp_i == 3'b100 && funct_i == 6'b100100)? 4'b0000: //and 
                   (ALUOp_i == 3'b100 && funct_i == 6'b101010)? 4'b0111: //slt  
                   (ALUOp_i == 3'b000)? 4'b0010:  //addi lw sw
                   (ALUOp_i == 3'b001)? 4'b0110:  //beq  
                   (ALUOp_i == 3'b011)? 4'b0111: 4'b0010; //slt
       
//Select exact operation
end
endmodule     





                    
                    