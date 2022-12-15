//109550073
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2022 04:30:50 PM
// Design Name: 
// Module Name: Forwarding_Unit
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

module Forwarding_Unit(
          WB_regwrite,
          MEM_regwrite,
          EX_regRS,
          EX_regRT,
          MEM_regRD,
          WB_regRD,
          forwardA,
          forwardB            
          );
          
//I/O ports 
input      WB_regwrite;
input      MEM_regwrite;
input      [4:0] EX_regRS, EX_regRT, MEM_regRD, WB_regRD;
output     [1:0] forwardA, forwardB;    
     
//Internal Signals
reg        [1:0] forwardA;
reg        [1:0] forwardB;
//Parameter

       
//Select exact operation
always @*
    begin
        if ((MEM_regwrite) && (MEM_regRD) && (MEM_regRD == EX_regRS))
            forwardA <= 2'b01;
        else if ((WB_regwrite) && (WB_regRD) && (WB_regRD == EX_regRS))
            forwardA <= 2'b10;  
        else    
            forwardA <= 2'b00;

        if ((MEM_regwrite) && (MEM_regRD) && (MEM_regRD == EX_regRT))
            forwardB  <= 2'b01;
        else if ((WB_regwrite) && (WB_regRD) && (WB_regRD == EX_regRT))
            forwardB <= 2'b10;  
        else    
            forwardB <= 2'b00;
     end
endmodule     
