`timescale 1ns/10ps
`define PERIOD 5

module top_tb1;

  parameter DataSize = 32;
//  parameter AddrSize = 5;

  reg [DataSize-1:0]instruction;
  reg clk;
  reg reset;
  
  //test &debug
  reg [DataSize-1:0]golden_reg[31:0];
  integer i;
  integer err_num; // TODO

top TOP (
  instruction,
  clk,
  reset
);
  
  always begin
  #`PERIOD clk = ~clk;
  end
  
  /* Set signal */
  initial begin
  clk = 1'b0;
  reset = 1'b0;
  instruction = 0_101000_00000_00000_0000_0000_0001_101; // ADDI

  #`PERIOD reset = 1'b1;  
  #`PERIOD reset = 1'b0; 
  
  instruction = 0_101000_00001_00001_0000_0000_0001_100; // ADDI

  #`PERIOD reset = 1'b1;  
  #`PERIOD reset = 1'b0; 

  // TODO: other instructions in p.14/17

  $finish;
  end

  /* Create tb waveform */
  initial begin
//  reset = 1'b0;
//  instruction = 0_101000_00000_00000_0000_0000_0001_101; // ADDI
  for ( i = DataSize; i > 0; i = i-1 ) begin
    golden_reg[i] = 32'd0;
  end
//  golden_reg[0] = golden_reg[0] + 5'b01101
  golden_reg[0] = 5'b01101;

  #`PERIOD; // reset = 1'b1  
  for ( i = DataSize; i > 0; i = i-1 ) begin
    golden_reg[i] = 32'd0;
  end
  #`PERIOD; // reset = 1'b0  

//  golden_reg[1] = golden_reg[1] + 5'b01100
  golden_reg[1] = 5'b01100;

  #`PERIOD; // reset = 1'b1  
  for ( i = DataSize; i > 0; i = i-1 ) begin
    golden_reg[i] = 32'd0;
  end
  #`PERIOD; // reset = 1'b0  

  // TODO: other operations
  end

  /* Dump and finish */
  initial begin
  $dumpfile("top_tb1.vcd");
  $dumpvars;
//  $fsdbDumpfile("top_tb1.fsdb");
//  $fsdbDumpvars;
  end

endmodule
