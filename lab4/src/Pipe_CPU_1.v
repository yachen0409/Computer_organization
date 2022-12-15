//109550073
`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] mux0_out, pc_out, im_out, add_pc_out;
wire [32-1:0] add_pc_out_id, im_out_id;

/**** ID stage ****/
wire [32-1:0] rsdata_out, rtdata_out, se_out;
wire [3-1:0] ALUop;
wire regdst, memtoreg, regwrite, ALUsrc, branch, memread, memwrite;
//control signal
wire [32-1:0] rsdata_out_ex, rtdata_out_ex, se_out_ex, add_pc_out_ex;
wire [21-1:0] im_out_ex;
wire [3-1:0] ALUop_ex;
wire regdst_ex, memtoreg_ex, regwrite_ex, ALUsrc_ex, branch_ex, memread_ex, memwrite_ex;

/**** EX stage ****/
wire [32-1:0] shifter_out, mux1_out, ALU_result, add_pc_branch_out;
wire [5-1:0] write_reg_address;
wire [4-1:0] ALU_control_out;
wire ALU_zero;
//control signal
wire [32-1:0] ALU_result_mem, add_pc_branch_out_mem, rtdata_out_mem;
wire [5-1:0] write_reg_address_mem;
wire memtoreg_mem, regwrite_mem, branch_mem, memread_mem, memwrite_mem, ALU_zero_mem;

/**** MEM stage ****/
wire [32-1:0] dm_out;
//control signal
wire [32-1:0] dm_out_wb, ALU_result_wb;
wire [5-1:0] write_reg_address_wb;
wire memtoreg_wb,regwrite_wb;

/**** WB stage ****/
wire [32-1:0] writedata;
//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(add_pc_out),
    .data1_i(add_pc_branch_out_mem),
    .select_i(branch_mem & ALU_zero_mem),
    .data_o(mux0_out)
);

ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(mux0_out),   
	.pc_out_o(pc_out)
);

Instruction_Memory IM(
	.addr_i(pc_out),  
	.instr_o(im_out)
);
			
Adder Add_pc(
	.src1_i(pc_out),     
	.src2_i(32'd4),
	.sum_o(add_pc_out)
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({add_pc_out, im_out}),
    .data_o({add_pc_out_id, im_out_id})
);


//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i) ,     
    .RSaddr_i(im_out_id[25:21]),  
    .RTaddr_i(im_out_id[20:16]),  
    .RDaddr_i(write_reg_address_wb),  
    .RDdata_i(writedata), 
    .RegWrite_i(regwrite_wb),
    .RSdata_o(rsdata_out),  
    .RTdata_o(rtdata_out)
);

Decoder Control(
	.instr_op_i(im_out_id[31:26]), 
	.RegWrite_o(regwrite), 
	.ALU_op_o(ALUop),   
	.ALUSrc_o(ALUsrc),   
	.RegDst_o(regdst),
	.Branch_o(branch),
	.MemRead_o(memread), 
	.MemWrite_o(memwrite), 
	.MemtoReg_o(memtoreg)
);

Sign_Extend Sign_Extend(
	.data_i(im_out_id[15:0]),
    .data_o(se_out)
);	

Pipe_Reg #(.size(159)) ID_EX(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({rsdata_out, rtdata_out, im_out_id[20:0], add_pc_out_id, regwrite, 
             regdst, ALUsrc, branch, memread, memwrite, memtoreg, ALUop, se_out}),
    .data_o({rsdata_out_ex, rtdata_out_ex, im_out_ex, add_pc_out_ex, regwrite_ex, 
             regdst_ex, ALUsrc_ex, branch_ex, memread_ex, memwrite_ex, memtoreg_ex, ALUop_ex, se_out_ex})
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
	.data_i(se_out_ex),
    .data_o(shifter_out)
);

ALU ALU(
	.src1_i(rsdata_out_ex),
	.src2_i(mux1_out),
	.ctrl_i(ALU_control_out),
	.result_o(ALU_result),
	.zero_o(ALU_zero)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(im_out_ex[5:0]),   
    .ALUOp_i(ALUop_ex),   
    .ALUCtrl_o(ALU_control_out)
);

MUX_2to1 #(.size(32)) Mux1(
	.data0_i(rtdata_out_ex),
    .data1_i(se_out_ex),
    .select_i(ALUsrc_ex),
    .data_o(mux1_out)
);
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(im_out_ex[20:16]),
    .data1_i(im_out_ex[15:11]),
    .select_i(regdst_ex),
    .data_o(write_reg_address)
);

Adder Add_pc_branch(
   	.src1_i(add_pc_out_ex),     
	.src2_i(shifter_out),
	.sum_o(add_pc_branch_out)   
);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({ALU_result, add_pc_branch_out, write_reg_address, rtdata_out_ex, 
             regwrite_ex, branch_ex, memread_ex, memwrite_ex, memtoreg_ex, ALU_zero}),
    .data_o({ALU_result_mem, add_pc_branch_out_mem, write_reg_address_mem, rtdata_out_mem, 
             regwrite_mem, branch_mem, memread_mem, memwrite_mem, memtoreg_mem, ALU_zero_mem})
);


//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i), 
	.addr_i(ALU_result_mem), 
	.data_i(rtdata_out_mem), 
	.MemRead_i(memread_mem), 
	.MemWrite_i(memwrite_mem), 
	.data_o(dm_out)
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.data_i({dm_out, ALU_result_mem, write_reg_address_mem, memtoreg_mem, regwrite_mem}),
    .data_o({dm_out_wb, ALU_result_wb, write_reg_address_wb, memtoreg_wb, regwrite_wb})
);




//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(ALU_result_wb),
        .data1_i(dm_out_wb),
        .select_i(memtoreg_wb),
        .data_o(writedata)
);

/****************************************
signal assignment
****************************************/

endmodule

