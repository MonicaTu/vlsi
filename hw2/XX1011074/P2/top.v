`include "p4_top.v"

module top (PC, IM_read, IM_write, IM_enable, instruction, clk, reset);
  
  parameter DataSize = 32;
  parameter MemSize = 10;

  input clk;
  input reset;
  input [DataSize-1:0] instruction;

  output IM_read;
  output IM_write;
  output IM_enable;
  output [MemSize-1:0] PC;
//  output [9:0]IM_address;

  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [MemSize-1:0] PC;
//  wire [9:0]IM_address;

  p4_top p4 (
    .clk(clk), 
    .reset(reset),
    .instruction(instruction), 
    .PC(PC),
    .IM_read(IM_read), 
    .IM_write(IM_write), 
    .IM_enable(IM_enable)); 

endmodule
