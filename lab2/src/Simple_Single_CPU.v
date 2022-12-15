//SID:109550073
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0]from_mux;
wire [31:0]pc_out;
wire [31:0]adder1_out;
wire [31:0]im_out;
wire reg_dst;
wire [4:0]mux_write_reg_out;
wire [31:0]alu_out;
wire reg_write;
wire [31:0]rsdata_out;
wire [31:0]rtdata_out;
wire [2:0]alu_op;
wire alu_src;
wire branch;
wire [3:0] ac_out;
wire [31:0] se_out;
wire [31:0] mux_alusrc_out;
wire alu_zero;
wire[31:0] shifter_out;
wire [31:0] adder2_out;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(from_mux) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out),     
	    .sum_o(adder1_out)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(im_out)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(im_out[20:16]),
        .data1_i(im_out[15:11]),
        .select_i(reg_dst),
        .data_o(mux_write_reg_out)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(im_out[25:21]) ,  
        .RTaddr_i(im_out[20:16]) ,  
        .RDaddr_i(mux_write_reg_out) ,  
        .RDdata_i(alu_out)  , 
        .RegWrite_i (reg_write),
        .RSdata_o(rsdata_out) ,  
        .RTdata_o(rtdata_out)   
        );
	
Decoder Decoder(
        .instr_op_i(im_out[31:26]), 
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(im_out[5:0]),   
        .ALUOp_i(alu_op),   
        .ALUCtrl_o(ac_out) 
        );
	
Sign_Extend SE(
        .data_i(im_out[15:0]),
        .data_o(se_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rtdata_out),
        .data1_i(se_out),
        .select_i(alu_src),
        .data_o(mux_alusrc_out)
        );	
		
ALU ALU(
        .src1_i(rsdata_out),
	    .src2_i(mux_alusrc_out),
	    .ctrl_i(ac_out),
	    .result_o(alu_out),
		.zero_o(alu_zero)
	    );
		
Adder Adder2(
        .src1_i(adder1_out),     
	    .src2_i(shifter_out),     
	    .sum_o(adder2_out)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se_out),
        .data_o(shifter_out)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(adder1_out),
        .data1_i(adder2_out),
        .select_i(branch & alu_zero),
        .data_o(from_mux)
        );	

endmodule
		  


