`define S1_SELECTED 4'h1
`define S2_SELECTED 4'h2
`timescale 1ns/10ps

module Decoder (HRESETn, HADDR, HSELDefault, HSEL_Slave1, HSEL_Slave2);
 
  input        HRESETn;
  input [31:0] HADDR;
  
  output  HSELDefault;  // Default Slave
  output  HSEL_Slave1;  // S1
  output  HSEL_Slave2;  // S2

  assign HSEL_Slave1 = (/*complete by yourself*/) ? 1'b1 : 1'b0;
  assign HSEL_Slave2 = (/*complete by yourself*/) ? 1'b1 : 1'b0;
  assign HSELDefault = (/*complete by yourself*/) ? 1'b1 : 1'b0;  //  Reset (Default Slave)
  
endmodule
