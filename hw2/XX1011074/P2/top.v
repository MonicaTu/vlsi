`include "p4_top.v"

module top (DM_read, DM_write, DM_enable, DM_in, DM_address, PC, IM_read, IM_write, IM_enable, DM_out, instruction, clk, reset);
// FIXME: use Ins_cnt, cycle_cnt instead of PC.
  
  parameter DataSize = 32;
  parameter MemSize = 10;

  input clk;
  input reset;
  input [DataSize-1:0] instruction;
  input [DataSize-1:0] DM_out;

  output DM_read;
  output DM_write;
  output DM_enable;
  output [DataSize-1:0]DM_in;
  output [11:0]DM_address;
  output IM_read;
  output IM_write;
  output IM_enable;
  output [MemSize-1:0] PC;
//  output [9:0]IM_address;

  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [DataSize-1:0]DM_in;
  wire [11:0]DM_address;
  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [MemSize-1:0] PC;
//  wire [9:0]IM_address;

  p4_top p4 (
    .clk(clk), 
    .reset(reset),
    .instruction(instruction), 
    .DM_out(DM_out),
    .DM_read(DM_read),
    .DM_write(DM_write),
    .DM_enable(DM_enable),
    .DM_in(DM_in),
    .DM_address(DM_address),
    .PC(PC),
    .IM_read(IM_read), 
    .IM_write(IM_write), 
    .IM_enable(IM_enable)); 

endmodule
