`timescale 1ns/10ps
`define PERIOD 10

module top_tb;

  parameter DataSize = 32;
  parameter MemSize = 10;

  reg clk;
  reg reset;

  wire ROM_read;
  wire ROM_enable;
  wire [7:0]ROM_address;
  wire [DataSize-1:0]ROM_dout;

  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [MemSize-1:0] PC;
  wire [DataSize-1:0] instruction;

  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [DataSize-1:0] DM_in;
  wire [DataSize-1:0] DM_address;
  wire [DataSize-1:0] DM_out = DM1.mem_data[DM_address];
  
  // FIXME: for test
  reg [DataSize-1:0] mem_data_in;
  
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

  ROM ROM1 (
    .clk(clk), 
    .read(ROM_read), 
    .enable(ROM_enable), 
    .address(IM_address), 
    .dout(ROM_dout));

  IM IM1 (
    .clk(clk), 
    .rst(reset), 
    .IM_address(PC), 
    .enable_fetch(IM_read), 
    .enable_write(IM_write), 
    .enable_im(IM_enable), 
    .IMin(mem_data_in), 
    .IMout(instruction));
  
  DM DM1 (
    .clk(clk), 
    .rst(reset), 
    .enable_fetch(DM_read), 
    .enable_write(DM_write), 
    .enable_dm(DM_enable), 
    .DMin(DM_in),
    .DMout(DM_out), 
    .DM_address(DM_address));
  
  top top1 (
    .clk(clk), 
    .reset(reset),
    .instruction(instruction), 
    .DM_out(DM_out),
    .rom_out(ROM_dout),
    .rom_enable(ROM_enable),
    .rom_read(ROM_read),
    .rom_address(ROM_address),
    .DM_read(DM_read),
    .DM_write(DM_write),
    .DM_enable(DM_enable),
    .DM_in(DM_in),
    .DM_address(DM_address),
    .PC(PC),
    .IM_read(IM_read), 
    .IM_write(IM_write), 
    .IM_enable(IM_enable)); 
  
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
    
  $readmemb("mins.prog", IM1.mem_data);

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
/*
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
*/
  end

  /* Dump and finish */
  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars;
//  $fsdbDumpfile("top_tb.fsdb");
//  $fsdbDumpvars;
  end

endmodule
