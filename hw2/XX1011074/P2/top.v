`include "p4_top.v"

module top (clk, reset);
  
  parameter DataSize = 32;

  input clk;
  input reset;

  p4_top p4 (
    .clk(clk),
    .reset(reset));

endmodule
