`include "p4_top.v"

module top (instruction, clk, reset);
  
  parameter DataSize = 32;

  input [DataSize-1:0]instruction;
  input clk;
  input reset;

  p4_top p4 (
    .instruction(instruction),
    .clk(clk),
    .reset(reset));

endmodule
