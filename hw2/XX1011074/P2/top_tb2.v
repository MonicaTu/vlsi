//`timescale 1ns/10ps
`define PERIOD 10

module top_tb2;

  parameter DataSize = 32;
  parameter MemSize = 10;

  reg clk;
  reg reset;

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
    
  $readmemb("mins2.prog", IM1.mem_data);

  #(`PERIOD*4*24) $finish;
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

  #(`PERIOD*4) //NOP

  #(`PERIOD*4) //MOVI
  tb_rw_reg_0 = 32'h00C8;
  golden_reg[0] = 32'h00C8;

  #(`PERIOD*4) //SW MO=R0            M0=0xC8

  #(`PERIOD*4) //ADDI
  tb_rw_reg_1 = 32'h012C;
  golden_reg[1] = 32'h012C;
//  if (tb_rw_reg_0 != top1.p3.regfile1.rw_reg_0)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SW M8=R1            M8=0x12C

  #(`PERIOD*4) //ADD
  tb_rw_reg_2 = 32'h01F4;
  golden_reg[2] = 32'h01F4;
//  if (tb_rw_reg_1 != top1.p3.regfile1.rw_reg_1)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SW M19=R2           M19=0x1F4

  #(`PERIOD*4) //LW R2=M0            R2=0xC8
  tb_rw_reg_2 = 32'h00C8;
  golden_reg[2] = 32'h00C8;

  #(`PERIOD*4) //SUB
  tb_rw_reg_2 = 32'h0064;
  golden_reg[2] = 32'h0064;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SW M23=R2           M23=0x64

  #(`PERIOD*4) //LW R1=M19           R1=0x1F4
  tb_rw_reg_1 = 32'h01F4;
  golden_reg[1] = 32'h01F4;

  #(`PERIOD*4) //AND
  tb_rw_reg_2 = 32'h00C0;
  golden_reg[2] = 32'h00C0;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //LW R0=M8            R0=0x12C
  tb_rw_reg_0 = 32'h012C;
  golden_reg[0] = 32'h012C;

  #(`PERIOD*4) //OR
  tb_rw_reg_2 = 32'h01FC;
  golden_reg[2] = 32'h01FC;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //XOR
  tb_rw_reg_2 = 32'h00D8;
  golden_reg[2] = 32'h00D8;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SRLI
  tb_rw_reg_2 = 32'h0025;
  golden_reg[2] = 32'h0025;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SLLI
  tb_rw_reg_2 = 32'h0960;
  golden_reg[2] = 32'h0960;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //LW R0=M23           R0=0x64
  tb_rw_reg_0 = 32'h0064;
  golden_reg[0] = 32'h0064;

  #(`PERIOD*4) //ROTRI
  tb_rw_reg_2 = 32'h8000000C;
  golden_reg[2] = 32'h8000000C;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //LW R3=M23           R3=0x64
  tb_rw_reg_3 = 32'h0064;
  golden_reg[3] = 32'h0064;

  #(`PERIOD*4) //ORI
  tb_rw_reg_4 = 32'h0064;
  golden_reg[4] = 32'h0064;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SW M0=R4            M0=0x64

  #(`PERIOD*4) //XORI
  tb_rw_reg_4 = 32'h0000;
  golden_reg[4] = 32'h0000;
//  if (tb_rw_reg_2 != top1.p3.regfile1.rw_reg_2)
//    err_num = err_num + 1;

  #(`PERIOD*4) //SW M8=R2            M8=0x8000000C

  #(`PERIOD*4); //IDEL
//  if (tb_rw_reg_9 != top1.p3.regfile1.rw_reg_9)
//    err_num = err_num + 1;
  end

  /* Dump and finish */
  initial begin
    $dumpfile("top_tb2.vcd");
    $dumpvars;
//  $fsdbDumpfile("top_tb2.fsdb");
//  $fsdbDumpvars;
  end

endmodule
