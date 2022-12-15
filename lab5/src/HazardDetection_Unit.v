//109550073
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2022 04:30:50 PM
// Design Name: 
// Module Name: HazardDetection_Unit
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


module HazardDetection_Unit(
    EX_memread,
    EX_regRT,
    ID_regRS,
    ID_regRT,
    branch,
    pcwrite,
    ID_write,
    IF_flush,
    ID_flush,
    EX_flush         
);
          
//I/O ports 
input      EX_memread, branch;
input      [4:0]  EX_regRT, ID_regRS, ID_regRT;
output     pcwrite;
output     ID_write;
output     IF_flush;
output     ID_flush;
output     EX_flush;    
     
//Internal Signals
reg        pcwrite;
reg        ID_write;
reg        IF_flush;
reg        ID_flush;
reg        EX_flush;    
//Parameter

       
//Select exact operation
always @*
    begin
        pcwrite <= 0;
        IF_flush <= 0;
        ID_write <= 0;
        ID_flush <= 0;
        EX_flush <= 0;
        if(EX_memread && ((EX_regRT == ID_regRS) || (EX_regRT == ID_regRT)))
            begin
                pcwrite <= 1;
                ID_write <= 1;
                ID_flush <= 1;
            end       
        if(branch == 1)
            begin
                IF_flush <= 1;
                ID_flush <= 1;
                EX_flush <= 1;
            end                    
     end
endmodule