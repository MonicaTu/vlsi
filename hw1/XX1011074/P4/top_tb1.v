`timescale 1ns/10ps
`define PERIOD 10

module top_tb1;

  parameter DataSize = 32;

  reg [DataSize-1:0]instruction;
  reg clk;
  reg reset;
  
  //test &debug
  reg [DataSize-1:0]golden_reg[31:0];
  reg [31:0]tb_rw_reg_0;
  reg [31:0]tb_rw_reg_1;
  reg [31:0]tb_rw_reg_2;
  reg [31:0]tb_rw_reg_3;
  reg [31:0]tb_rw_reg_4;
  reg [31:0]tb_rw_reg_5;
  reg [31:0]tb_rw_reg_6;
  reg [31:0]tb_rw_reg_7;
  reg [31:0]tb_rw_reg_8;
  reg [31:0]tb_rw_reg_9;
  integer i;
  integer err_num; // TODO

top TOP (
  instruction,
  clk,
  reset
);
  
  always begin
  	#(`PERIOD/2) clk = ~clk;
  end
  /* Set signal */
  initial begin
  clk = 1'b0;
  #(`PERIOD) reset = 1'b0;
  #(`PERIOD) reset = 1'b1;  
  #(`PERIOD) reset = 1'b0;
  #(`PERIOD*1.5);
  #(`PERIOD*4) instruction = 32'b0_101000_00000_00000_0000_0000_0001_101; // ADDI
  #(`PERIOD*4) instruction = 32'b0_101000_00001_00001_0000_0000_0001_100; // ADDI
  #(`PERIOD*4) instruction = 32'b0_100010_00010_0000_0000_0000_0001_0000; // MOVI
  #(`PERIOD*4) instruction = 32'b0_100000_00011_00000_00001_00000_00000; // ADD
  #(`PERIOD*4) instruction = 32'b0_100000_00100_00000_00001_00000_00001; // SUB
  #(`PERIOD*4) instruction = 32'b0_100000_00101_00011_00100_00000_00010; // AND
  #(`PERIOD*4) instruction = 32'b0_100000_00110_00011_00100_00000_00100; // OR
  #(`PERIOD*4) instruction = 32'b0_100000_00111_00011_00100_00000_00011; // XOR
  #(`PERIOD*4) instruction = 32'b0_100000_01000_00000_00100_00000_01000; // SLLI
  #(`PERIOD*4) instruction = 32'b0_100000_01001_00001_01000_00000_01011; // ROTRI
  #(`PERIOD*4) instruction = 32'b0_101100_00000_00000_0000_0000_0011_111; // ORI
  #(`PERIOD*4) instruction = 32'b0_101011_00001_00001_0000_0000_0010_101; // XORI

  #(`PERIOD*4) $finish;
  end

  /* Create tb waveform */
  initial begin
  for ( i = DataSize; i > 0; i = i-1 ) begin
    golden_reg[i] = 32'd0;
  end

  #(`PERIOD) 
  #(`PERIOD) 
  #(`PERIOD) 
  #(`PERIOD*3.5)
  #(`PERIOD*4) //ADDI
  tb_rw_reg_0 = 32'b01101;

  #(`PERIOD*4) //ADDI
  tb_rw_reg_1 = 32'b01100;

  #(`PERIOD*4) //MOVI
  tb_rw_reg_2 = 32'b10000;

  #(`PERIOD*4) //ADD
  tb_rw_reg_3 = 32'b11001;

  #(`PERIOD*4) //SUB
  tb_rw_reg_4 = 32'b00001;

  #(`PERIOD*4) //AND
  tb_rw_reg_5 = 32'b00001;

  #(`PERIOD*4) //OR
  tb_rw_reg_6 = 32'b11001;

  #(`PERIOD*4) //XOR
  tb_rw_reg_7 = 32'b11000;

  #(`PERIOD*4) //SLLI
  tb_rw_reg_8 = 32'b11010000;

  #(`PERIOD*4) //ROTRI
  tb_rw_reg_9 = 32'h0C000000;

  #(`PERIOD*4) //ORI
  tb_rw_reg_0 = 32'b11111;
  
  #(`PERIOD*4) //XORI
  tb_rw_reg_1 = 32'b11001;

  #(`PERIOD*4) $finish;
  end
//  golden_reg[0] = golden_reg[0] + 5'b01101
//  golden_reg[0] = 5'b01101;

//  #`PERIOD; // reset = 1'b1  
//  for ( i = DataSize; i > 0; i = i-1 ) begin
//    golden_reg[i] = 32'd0;
//  end
//  #`PERIOD; // reset = 1'b0  

  /* Dump and finish */
  initial begin
  $dumpfile("top_tb1.vcd");
  $dumpvars;
//  $fsdbDumpfile("top_tb1.fsdb");
//  $fsdbDumpvars;
  end

endmodule
