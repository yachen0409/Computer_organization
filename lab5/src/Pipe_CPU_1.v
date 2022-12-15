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
wire [32-1:0] 	mux0_out, add_pc_out, pc_out, im_out;
wire [32-1:0]	add_pc_out_id, im_out_id;

/**** ID stage ****/
wire [32-1:0]	rsdata_out, rtdata_out, se_out;
wire [3-1:0]	ALUop;
wire regwrite, memtoreg, branch, memread, memwrite, regdst, ALUsrc;

//control signal
wire [32-1:0]	rsdata_out_ex, rtdata_out_ex, se_out_ex, add_pc_out_ex;
wire [5-1:0]	im_out_ex_2016, im_out_ex_1511;
wire [3-1:0]	ALUop_ex;
wire regwrite_ex, memtoreg_ex, branch_ex, memread_ex, memwrite_ex, regdst_ex, ALUsrc_ex;

/**** EX stage ****/
wire [32-1:0]	shifter_out, mux1_out, ALU_result, add_pc_branch_out;
wire [5-1:0]	write_reg_address;
wire [4-1:0]	ALU_control_out;
//control signal
wire [32-1:0]	ALU_result_mem, add_pc_branch_out_mem, mux_forwardB_mem;
wire [5-1:0]	write_reg_address_mem;
wire regwrite_mem, memtoreg_mem, branch_mem, memread_mem, memwrite_mem, ALU_branchtype_mem;

/**** MEM stage ****/
wire [32-1:0]	dm_out;
//control signal
wire [32-1:0]	dm_out_wb, ALU_result_wb;
wire [5-1:0]	write_reg_address_wb;
wire 		regwrite_wb, memtoreg_wb;
/**** WB stage ****/
wire [32-1:0]	write_data;
//control signal

wire [31:0]	mux_hazard_out;
wire [64-1:0]	mux_ID_hazard;
wire 		pcwrite;
wire 		IF_flush;
wire 		ID_write;
wire 		ID_flush;
wire            EX_flush;
wire [10-1:0]	mux_ID_Flush;
wire [64-1:0]	mux_IF_flush;
wire [107-1:0]	mux_EX_flush;
wire [6-1:0]	im_out_ex_3126;
wire [5-1:0]	im_out_ex_2521;
wire [2-1:0]	forwardA;
wire [2-1:0]	forwardB;
wire [32-1:0]	mux_forwardA, mux_forwardB;
wire 		ALU_branchtype;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) MUX0(
	.data0_i(add_pc_out),
        .data1_i(add_pc_branch_out_mem),
        .select_i(branch_mem & ALU_branchtype_mem),
        .data_o(mux0_out)
);

MUX_2to1 #(.size(32)) MUX_hazard(
	.data0_i(mux0_out),
        .data1_i(pc_out),
        .select_i(pcwrite),
        .data_o(mux_hazard_out)
);

ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(mux_hazard_out),   
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

MUX_2to1 #(.size(64)) MUX_hazard_ID(
        .data0_i({add_pc_out , im_out}),
        .data1_i({add_pc_out_id , im_out_id}),
        .select_i(ID_write),
        .data_o(mux_ID_hazard)
);

MUX_2to1 #(.size(64)) MUX_hazard_IF_Flush(
        .data0_i(mux_ID_hazard),
        .data1_i(64'b0),
        .select_i(IF_flush),
        .data_o(mux_IF_flush)
);


Pipe_Reg #(.size(64)) IF_ID(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i(mux_IF_flush),
	.data_o({add_pc_out_id , im_out_id})
);

//Instantiate the components in ID stage

HazardDetection_Unit HD(
        .EX_memread(memread_ex),
        .EX_regRT(im_out_ex_2016),
        .ID_regRS(im_out_id[25:21]),
        .ID_regRT(im_out_id[20:16]),
        .branch(branch_mem & ALU_branchtype_mem),
        .pcwrite(pcwrite),
        .ID_write(ID_write),
        .IF_flush(IF_flush),
        .ID_flush(ID_flush),
        .EX_flush(EX_flush) 
);


Reg_File RF(
        .clk_i(clk_i),
	.rst_i(rst_i),
        .RSaddr_i(im_out_id[25:21]),
        .RTaddr_i(im_out_id[20:16]),
        .RDaddr_i(write_reg_address_wb),
        .RDdata_i(write_data),
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

MUX_2to1 #(.size(10)) MUX_hazard_ID_flush(
        .data0_i({regwrite , memtoreg , branch , memread , memwrite , regdst , ALUop , ALUsrc}),
        .data1_i(10'b0),
        .select_i(ID_flush),
        .data_o(mux_ID_Flush)
);

Pipe_Reg #(.size(159)) ID_EX(
        .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({im_out_id[31:26], im_out_id[25:21], mux_ID_Flush, add_pc_out_id, rsdata_out, rtdata_out, se_out, im_out_id[20:16], im_out_id[15:11]}),
	.data_o({im_out_ex_3126, im_out_ex_2521, regwrite_ex, memtoreg_ex, branch_ex, memread_ex, memwrite_ex, regdst_ex, ALUop_ex, ALUsrc_ex, add_pc_out_ex, rsdata_out_ex, rtdata_out_ex, se_out_ex, im_out_ex_2016, im_out_ex_1511})
);

//Instantiate the components in EX stage

Forwarding_Unit FU(
        .WB_regwrite(regwrite_wb),
        .MEM_regwrite(regwrite_mem),
        .EX_regRS(im_out_ex_2521),
        .EX_regRT(im_out_ex_2016),
        .MEM_regRD(write_reg_address_mem),
        .WB_regRD(write_reg_address_wb),
        .forwardA(forwardA),
        .forwardB(forwardB)
);

Shift_Left_Two_32 Shifter(
	.data_i(se_out_ex),
        .data_o(shifter_out)
);

MUX_3to1 #(.size(32)) MUX_forwardA(
        .data0_i(rsdata_out_ex),
        .data1_i(ALU_result_mem),
        .data2_i(write_data),
        .select_i(forwardA),
        .data_o(mux_forwardA)
);

MUX_3to1 #(.size(32)) MUX_forwardB(
        .data0_i(rtdata_out_ex),
        .data1_i(ALU_result_mem),
        .data2_i(write_data),
        .select_i(forwardB),
        .data_o(mux_forwardB)
);

ALU ALU(
	.src1_i(mux_forwardA),
	.src2_i(mux1_out),
	.ctrl_i(ALU_control_out),
	.op_i(im_out_ex_3126),
	.result_o(ALU_result),
	.branch_o(ALU_branchtype)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(se_out_ex[5:0]),  
        .ALUOp_i(ALUop_ex),
        .ALUCtrl_o(ALU_control_out)
);

MUX_2to1 #(.size(32)) MUX1(
        .data0_i(mux_forwardB),
        .data1_i(se_out_ex),
        .select_i(ALUsrc_ex),
        .data_o(mux1_out)
);
		
MUX_2to1 #(.size(5)) MUX2(
        .data0_i(im_out_ex_2016),
        .data1_i(im_out_ex_1511),
        .select_i(regdst_ex),
        .data_o(write_reg_address)
);

Adder Add_pc_branch(
   	.src1_i(add_pc_out_ex),
	.src2_i(shifter_out),
	.sum_o(add_pc_branch_out)
);

MUX_2to1 #(.size(107)) MUX_hazard_EX_Flush(
        .data0_i({regwrite_ex, memtoreg_ex, branch_ex, memread_ex, memwrite_ex , add_pc_branch_out , ALU_branchtype , ALU_result , mux_forwardB , write_reg_address}),
        .data1_i(107'b0),
        .select_i(EX_flush),
        .data_o(mux_EX_flush)
);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i(mux_EX_flush),
	.data_o({regwrite_mem, memtoreg_mem, branch_mem, memread_mem, memwrite_mem, add_pc_branch_out_mem, ALU_branchtype_mem, ALU_result_mem, mux_forwardB_mem, write_reg_address_mem})
);

//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ALU_result_mem),
	.data_i(mux_forwardB_mem),
	.MemRead_i(memread_mem),
	.MemWrite_i(memwrite_mem),
	.data_o(dm_out)
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({regwrite_mem, memtoreg_mem, dm_out, ALU_result_mem, write_reg_address_mem}),
	.data_o({regwrite_wb, memtoreg_wb, dm_out_wb, ALU_result_wb, write_reg_address_wb})
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) MUX3(
	.data0_i(ALU_result_wb),
        .data1_i(dm_out_wb),
        .select_i(memtoreg_wb),
        .data_o(write_data)
);

/****************************************
signal assignment
****************************************/

endmodule
