//STUDENT_ID:109550073
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
    clk, // system clock              (input)
    rst_n, // negative reset            (input)
    src1, // 32 bits source 1          (input)
    src2, // 32 bits source 2          (input)
    ALU_control, // 4 bits ALU control input  (input)
    result, // 32 bits result            (output)
    zero, // 1 bit when the output is 0, zero must be set (output)
    cout, // 1 bit carry out           (output)
    overflow // 1 bit overflow            (output)
);

    input           clk;
    input           rst_n;
    input  [32-1:0] src1;
    input  [32-1:0] src2;
    input   [4-1:0] ALU_control;

    output [32-1:0] result;
    output          zero;
    output          cout;
    output          overflow;

    reg    [32-1:0] result;
    reg             zero;
    reg             cout;
    reg             overflow;

    wire   [31:0]   temp_result; 
    wire   [31:0]   temp_cout;
    wire            less;
    wire            temp_overflow;
    

    
    alu_top a0( .src1(src1[0]),   .src2(src2[0]),   .less(less),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(ALU_control[2]), .operation(ALU_control[1:0]), .result(temp_result[0]),   .cout(temp_cout[0]));
    alu_top a1( .src1(src1[1]),   .src2(src2[1]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[0]),   .operation(ALU_control[1:0]), .result(temp_result[1]),   .cout(temp_cout[1]));
    alu_top a2( .src1(src1[2]),   .src2(src2[2]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[1]),   .operation(ALU_control[1:0]), .result(temp_result[2]),   .cout(temp_cout[2]));
    alu_top a3( .src1(src1[3]),   .src2(src2[3]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[2]),   .operation(ALU_control[1:0]), .result(temp_result[3]),   .cout(temp_cout[3]));
    alu_top a4( .src1(src1[4]),   .src2(src2[4]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[3]),   .operation(ALU_control[1:0]), .result(temp_result[4]),   .cout(temp_cout[4]));
    alu_top a5( .src1(src1[5]),   .src2(src2[5]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[4]),   .operation(ALU_control[1:0]), .result(temp_result[5]),   .cout(temp_cout[5]));
    alu_top a6( .src1(src1[6]),   .src2(src2[6]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[5]),   .operation(ALU_control[1:0]), .result(temp_result[6]),   .cout(temp_cout[6]));
    alu_top a7( .src1(src1[7]),   .src2(src2[7]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[6]),   .operation(ALU_control[1:0]), .result(temp_result[7]),   .cout(temp_cout[7]));
    alu_top a8( .src1(src1[8]),   .src2(src2[8]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[7]),   .operation(ALU_control[1:0]), .result(temp_result[8]),   .cout(temp_cout[8]));
    alu_top a9( .src1(src1[9]),   .src2(src2[9]),   .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[8]),   .operation(ALU_control[1:0]), .result(temp_result[9]),   .cout(temp_cout[9]));
    alu_top a10(.src1(src1[10]),  .src2(src2[10]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[9]),   .operation(ALU_control[1:0]), .result(temp_result[10]),  .cout(temp_cout[10]));
    alu_top a11(.src1(src1[11]),  .src2(src2[11]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[10]),  .operation(ALU_control[1:0]), .result(temp_result[11]),  .cout(temp_cout[11]));
    alu_top a12(.src1(src1[12]),  .src2(src2[12]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[11]),  .operation(ALU_control[1:0]), .result(temp_result[12]),  .cout(temp_cout[12]));
    alu_top a13(.src1(src1[13]),  .src2(src2[13]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[12]),  .operation(ALU_control[1:0]), .result(temp_result[13]),  .cout(temp_cout[13]));
    alu_top a14(.src1(src1[14]),  .src2(src2[14]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[13]),  .operation(ALU_control[1:0]), .result(temp_result[14]),  .cout(temp_cout[14]));
    alu_top a15(.src1(src1[15]),  .src2(src2[15]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[14]),  .operation(ALU_control[1:0]), .result(temp_result[15]),  .cout(temp_cout[15]));
    alu_top a16(.src1(src1[16]),  .src2(src2[16]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[15]),  .operation(ALU_control[1:0]), .result(temp_result[16]),  .cout(temp_cout[16]));
    alu_top a17(.src1(src1[17]),  .src2(src2[17]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[16]),  .operation(ALU_control[1:0]), .result(temp_result[17]),  .cout(temp_cout[17]));
    alu_top a18(.src1(src1[18]),  .src2(src2[18]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[17]),  .operation(ALU_control[1:0]), .result(temp_result[18]),  .cout(temp_cout[18]));
    alu_top a19(.src1(src1[19]),  .src2(src2[19]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[18]),  .operation(ALU_control[1:0]), .result(temp_result[19]),  .cout(temp_cout[19]));
    alu_top a20(.src1(src1[20]),  .src2(src2[20]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[19]),  .operation(ALU_control[1:0]), .result(temp_result[20]),  .cout(temp_cout[20]));
    alu_top a21(.src1(src1[21]),  .src2(src2[21]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[20]),  .operation(ALU_control[1:0]), .result(temp_result[21]),  .cout(temp_cout[21]));
    alu_top a22(.src1(src1[22]),  .src2(src2[22]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[21]),  .operation(ALU_control[1:0]), .result(temp_result[22]),  .cout(temp_cout[22]));
    alu_top a23(.src1(src1[23]),  .src2(src2[23]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[22]),  .operation(ALU_control[1:0]), .result(temp_result[23]),  .cout(temp_cout[23]));
    alu_top a24(.src1(src1[24]),  .src2(src2[24]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[23]),  .operation(ALU_control[1:0]), .result(temp_result[24]),  .cout(temp_cout[24]));
    alu_top a25(.src1(src1[25]),  .src2(src2[25]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[24]),  .operation(ALU_control[1:0]), .result(temp_result[25]),  .cout(temp_cout[25]));
    alu_top a26(.src1(src1[26]),  .src2(src2[26]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[25]),  .operation(ALU_control[1:0]), .result(temp_result[26]),  .cout(temp_cout[26]));
    alu_top a27(.src1(src1[27]),  .src2(src2[27]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[26]),  .operation(ALU_control[1:0]), .result(temp_result[27]),  .cout(temp_cout[27]));
    alu_top a28(.src1(src1[28]),  .src2(src2[28]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[27]),  .operation(ALU_control[1:0]), .result(temp_result[28]),  .cout(temp_cout[28]));
    alu_top a29(.src1(src1[29]),  .src2(src2[29]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[28]),  .operation(ALU_control[1:0]), .result(temp_result[29]),  .cout(temp_cout[29]));
    alu_top a30(.src1(src1[30]),  .src2(src2[30]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[29]),  .operation(ALU_control[1:0]), .result(temp_result[30]),  .cout(temp_cout[30]));
    alu_top a31(.src1(src1[31]),  .src2(src2[31]),  .less(0),     .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(temp_cout[30]),  .operation(ALU_control[1:0]), .result(temp_result[31]),  .cout(temp_cout[31]));
    
    assign temp_overflow = temp_cout[30]^temp_cout[31];
    assign less = (src1[31]^(~src2[31])^temp_cout[30]);
    
    always@( posedge clk or negedge rst_n )
    begin
        result <= temp_result;
        zero <= temp_result == 0 ? 1 : 0;
        cout <= (ALU_control[1:0] != 2'b10) ? 0 : temp_cout[31];
        overflow <= temp_overflow; 
    end

endmodule
