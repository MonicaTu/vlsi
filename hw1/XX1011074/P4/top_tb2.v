`timescale 1ns/10ps
`define PERIOD 10

module top_tb2;

  parameter DataSize = 32;

  reg [DataSize-1:0]instruction;
  reg clk;
  reg reset;
  
  //test &debug
  reg [DataSize-1:0]golden_reg[31:0];
  reg [31:0]tb_rw_reg_0;
  reg [31:0]tb_rw_reg_1;
  reg [31:0]tb_rw_reg_2;
/*  reg [31:0]tb_rw_reg_3;
  reg [31:0]tb_rw_reg_4;
  reg [31:0]tb_rw_reg_5;
  reg [31:0]tb_rw_reg_6;
  reg [31:0]tb_rw_reg_7;
  reg [31:0]tb_rw_reg_8;
  reg [31:0]tb_rw_reg_9;
*/
  integer i;
  integer err_num;

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
  #(`PERIOD*2.5);
  #(`PERIOD*4) instruction = 32'b0_100000_00000_00000_00000_00000_01001; //NOP
  reset = 1'b0;
  #(`PERIOD*4) instruction = 32'b0_100010_00000_0000_0000_0000_1100_1000; //MOVI
  #(`PERIOD*4) instruction = 32'b0_101000_00001_00000_0000_0000_1100_100; //ADDI
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00001_00000_00000; //ADD
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00001_00000_00000_00001; //SUB
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00001_00000_00010; //AND
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00001_00000_00100; //OR
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00001_00000_00011; //XOR
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00011_00000_01001; //SRLI
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00011_00000_01000; //SLLI
  #(`PERIOD*4) instruction = 32'b0_100000_00010_00000_00011_00000_01011; //ROTRI
  #(`PERIOD*4) instruction = 32'b0_101100_00010_00000_0000_0000_1100_100; //ORI
  #(`PERIOD*4) instruction = 32'b0_101011_00010_00000_0000_0000_1100_100; //XORI

  #(`PERIOD*4) $finish;
  end

  /* Create tb waveform */
  initial begin
  #(`PERIOD*2) 
    for ( i = 0; i < DataSize; i = i+1) begin
      golden_reg[i] = 32'd0;
    end

  tb_rw_reg_0 = 32'd0;
  tb_rw_reg_1 = 32'd0;
  tb_rw_reg_2 = 32'd0;
/*  tb_rw_reg_3 = 32'd0;
  tb_rw_reg_4 = 32'd0;
  tb_rw_reg_5 = 32'd0;
  tb_rw_reg_6 = 32'd0;
  tb_rw_reg_7 = 32'd0;
  tb_rw_reg_8 = 32'd0;
  tb_rw_reg_9 = 32'd0;
*/
  err_num = 0;

  #(`PERIOD*1.5)
  #(`PERIOD*4)
  #(`PERIOD*4) //NOP
  #(`PERIOD*4) //MOVI
  tb_rw_reg_0 = 32'h00C8;
  golden_reg[0] = 32'h00C8;

  #(`PERIOD*4) //ADDI
  tb_rw_reg_1 = 32'h012C;
  golden_reg[1] = 32'h012C;
  if (tb_rw_reg_0 != TOP.p3.regfile1.rw_reg_0)
    err_num = err_num + 1;

  #(`PERIOD*4) //ADD
  tb_rw_reg_2 = 32'h01F4;
  golden_reg[2] = 32'h01F4;
  if (tb_rw_reg_1 != TOP.p3.regfile1.rw_reg_1)
    err_num = err_num + 1;

  #(`PERIOD*4) //SUB
  tb_rw_reg_2 = 32'h0064;
  golden_reg[2] = 32'h0064;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //AND
  tb_rw_reg_2 = 32'h0008;
  golden_reg[2] = 32'h0008;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //OR
  tb_rw_reg_2 = 32'h01EC;
  golden_reg[2] = 32'h01EC;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //XOR
  tb_rw_reg_2 = 32'h01E4;
  golden_reg[2] = 32'h01E4;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //SRLI
  tb_rw_reg_2 = 32'h0019;
  golden_reg[2] = 32'h0019;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //SLLI
  tb_rw_reg_2 = 32'h0640;
  golden_reg[2] = 32'h0640;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //ROTRI
  tb_rw_reg_2 = 32'h0019;
  golden_reg[2] = 32'h0019;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //ORI
  tb_rw_reg_2 = 32'h00EC;
  golden_reg[2] = 32'h00EC;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4) //XORI
  tb_rw_reg_2 = 32'h00AC;
  golden_reg[2] = 32'h00AC;
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;
  
  #(`PERIOD*4) //IDEL
  if (tb_rw_reg_2 != TOP.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;
  end

  /* Dump and finish */
  initial begin
  $dumpfile("top_tb2.vcd");
  $dumpvars;
  $fsdbDumpfile("top_tb2.fsdb");
  $fsdbDumpvars;
  $fsdbDumpvars(0, top_tb2, "+mda");
  end

endmodule
