`timescale 1ns/10ps
`define PERIOD 10

module top_tb;

  parameter DataSize = 32;
  parameter MemSize = 1024;

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
  integer err_num;

  top TOP (
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
  #(`PERIOD*4);
  reset = 1'b0;
    
  $readmemb("mins.prog", TOP.p4.IM1.mem_data);
  for (i = 0; i < MemSize; i = i+1) begin
    if (TOP.p4.IM1.mem_data[i])
      $display("memdata[%d]: %h", i, TOP.p4.IM1.mem_data[i]); 
  end

  #(`PERIOD*4*20) $finish;
  end

  /* Create tb waveform */
  initial begin
  #(`PERIOD*2); 
    for ( i = 0; i < DataSize; i = i+1) begin
      golden_reg[i] = 32'd0;
    end

    tb_rw_reg_0 = 32'd0;
    tb_rw_reg_1 = 32'd0;
    tb_rw_reg_2 = 32'd0;
    tb_rw_reg_3 = 32'd0;
    tb_rw_reg_4 = 32'd0;
    tb_rw_reg_5 = 32'd0;
    tb_rw_reg_6 = 32'd0;
    tb_rw_reg_7 = 32'd0;
    tb_rw_reg_8 = 32'd0;
    tb_rw_reg_9 = 32'd0;
    err_num = 0;

  #(`PERIOD*1.5);
  #(`PERIOD*4);

  #(`PERIOD*4); // MOVI R0=20'd4
  tb_rw_reg_0 = 32'h04;
  golden_reg[0] = 32'h04;

  #(`PERIOD*4); // ADDI R0=R0+4'b1101
  tb_rw_reg_0 = 32'h11;
  golden_reg[0] = 32'h11;
  if (tb_rw_reg_0 != TOP.p4.p3.regfile1.rw_reg_0)
    err_num = err_num + 1;

  #(`PERIOD*4); // ORI R1=R0|4'b0010
  tb_rw_reg_1 = 32'h13;
  golden_reg[1] = 32'h13;
  if (tb_rw_reg_0 != TOP.p4.p3.regfile1.rw_reg_0)
    err_num = err_num + 1;

  #(`PERIOD*4); // XORI R1=R1^4'b0111
  tb_rw_reg_1 = 32'h14;
  golden_reg[1] = 32'h14;
  if (tb_rw_reg_1 != TOP.p4.p3.regfile1.rw_reg_1)
    err_num = err_num + 1;

  #(`PERIOD*4); // NOP

  #(`PERIOD*4); // ADD R1=R0+R1
  tb_rw_reg_1 = 32'h25;
  golden_reg[1] = 32'h25;
  if (tb_rw_reg_1 != TOP.p4.p3.regfile1.rw_reg_1)
    err_num = err_num + 1;

  #(`PERIOD*4); // SUB R1=R1-R0
  tb_rw_reg_1 = 32'h14;
  golden_reg[1] = 32'h14;
  if (tb_rw_reg_1 != TOP.p4.p3.regfile1.rw_reg_1)
    err_num = err_num + 1;

  #(`PERIOD*4); // AND R1=R1&R0
  tb_rw_reg_1 = 32'h10;
  golden_reg[1] = 32'h10;
  if (tb_rw_reg_1 != TOP.p4.p3.regfile1.rw_reg_1)
    err_num = err_num + 1;

  #(`PERIOD*4); // OR R0=R0|R1
  tb_rw_reg_0 = 32'h11;
  golden_reg[0] = 32'h11;
  if (tb_rw_reg_1 != TOP.p4.p3.regfile1.rw_reg_1)
    err_num = err_num + 1;

  #(`PERIOD*4); // XOR R2=R0^R1
  tb_rw_reg_2 = 32'h01;
  golden_reg[2] = 32'h01;
  if (tb_rw_reg_0 != TOP.p4.p3.regfile1.rw_reg_0)
    err_num = err_num + 1;

  #(`PERIOD*4); // SRLI R2=R0 SRL(3)
  tb_rw_reg_2 = 32'h02;
  golden_reg[2] = 32'h02;
  if (tb_rw_reg_2 != TOP.p4.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4); // SLLI R2=R2 SLL(3)
  tb_rw_reg_2 = 32'h10;
  golden_reg[2] = 32'h10;
  if (tb_rw_reg_2 != TOP.p4.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  #(`PERIOD*4); // ROTRI R2=R0 ROTR(29)
  tb_rw_reg_2 = 32'h0088;
  golden_reg[2] = 32'h0088;
  if (tb_rw_reg_2 != TOP.p4.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;
  
  #(`PERIOD*4); //IDEL
  if (tb_rw_reg_2 != TOP.p4.p3.regfile1.rw_reg_2)
    err_num = err_num + 1;

  end

  /* Dump and finish */
  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars;
//  $fsdbDumpfile("top_tb.fsdb");
//  $fsdbDumpvars;
  end

endmodule
