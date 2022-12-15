//109550073

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
wire [1:0]reg_dst;
wire [4:0]mux_write_reg_out;
wire [31:0]alu_out;
wire Jumpregister;
wire reg_write;
wire [31:0]rsdata_out;
wire [31:0]rtdata_out;
wire [2:0]alu_op;
wire alu_src;
wire branch;
wire jump;
wire memread;
wire memwrite;
wire [1:0]memtoreg;
wire [3:0] ac_out;
wire [31:0] se_out;
wire [31:0] mux_alusrc_out;
wire alu_zero;
wire [31:0] datamemory_out;
wire [31:0] shifter_out;
wire [31:0] adder2_out;
wire [31:0] muxbranch_out;
wire [31:0] muxjump_out;
wire [31:0] muxmemtoreg_out;

assign Jumpregister = (im_out[31:26] == 6'd0 && im_out[5:0] == 6'd8)?1:0;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(from_mux) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(adder1_out)      
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(im_out)   
	    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(im_out[20:16]),
        .data1_i(im_out[15:11]),
	    .data2_i(5'b11111),
        .select_i(reg_dst),
        .data_o(mux_write_reg_out)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(im_out[25:21]) ,  
        .RTaddr_i(im_out[20:16]) ,  
        .RDaddr_i(mux_write_reg_out) ,  
        .RDdata_i(muxmemtoreg_out),    //WRONG!!! 
        .RegWrite_i (reg_write & (~Jumpregister)),
        .RSdata_o(rsdata_out) ,  
        .RTdata_o(rtdata_out)  
        );
	
Decoder Decoder(
        .instr_op_i(im_out[31:26]), 
	    .RegWrite_o(reg_write), 
	    .ALU_op_o(alu_op),   
	    .ALUSrc_o(alu_src),   
	    .RegDst_o(reg_dst),   
		.Branch_o(branch),   
		.Jump_o(jump), 
	    .MemRead_o(memread), 
	    .MemWrite_o(memwrite), 
	    .MemtoReg_o(memtoreg)
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
	
Data_Memory Data_Memory(
	.clk_i(clk_i), 
	.addr_i(alu_out), 
	.data_i(rtdata_out), 
	.MemRead_i(memread), 
	.MemWrite_i(memwrite), 
	.data_o(datamemory_out)
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
		
MUX_2to1 #(.size(32)) Mux_Branch(
        .data0_i(adder1_out),
        .data1_i(adder2_out),
        .select_i(branch & alu_zero),
        .data_o(muxbranch_out)
);
MUX_2to1 #(.size(32)) Mux_Jump(
        .data0_i(muxbranch_out),
        .data1_i({adder1_out[31:28], im_out[25:0], 2'b00}),
        .select_i(jump),
        .data_o(muxjump_out)
);	
MUX_2to1 #(.size(32)) Mux_JumpReg(
        .data0_i(muxjump_out),
        .data1_i(rsdata_out),
        .select_i(Jumpregister),
        .data_o(from_mux)
);	
MUX_3to1 #(.size(32)) Mux_MemtoReg(
        .data0_i(alu_out),
        .data1_i(datamemory_out),
	    .data2_i(adder1_out),
        .select_i(memtoreg),
        .data_o(muxmemtoreg_out)
);

endmodule
		  


