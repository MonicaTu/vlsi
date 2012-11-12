//`timescale 1ns/10ps
`define PERIOD 10

module top_tb;

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
//  wire [DataSize-1:0] DM_out;
  wire [DataSize-1:0] DM_out = DM1.mem_data[DM_address];
  
  // FIXME: for test
  reg [DataSize-1:0] mem_data_in;

  reg [DataSize-1:0]golden_reg[31:0];
  reg [MemSize-1:0]golden_mem[10:0];
  
  integer i;
  integer err_num;
  
  // for iverilog which does not support 2-dimension array.
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
  
  reg [31:0]tb_mem_data_0;
  reg [31:0]tb_mem_data_19;
  reg [31:0]tb_mem_data_35;
  
  integer internel_err_num;

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
    
  $readmemb("mins.prog", IM1.mem_data);

  #(`PERIOD*4*20) $finish;
  end

  /* Create tb waveform */
  initial begin
  #(`PERIOD*2); 
    for ( i = 0; i < DataSize; i = i+1) begin
      golden_reg[i] = 32'd0;
    end
    for ( i = 0; i < MemSize; i = i+1) begin
      golden_mem[i] = 32'd0;
    end

    err_num = 0;

  #(`PERIOD*1.5);
  #(`PERIOD*4);

  #(`PERIOD*4); // ADDI R1=R1+4'b1001  => R1=9
  golden_reg[1] = 32'h09;

  #(`PERIOD*4); // XORI R1=R1^4'b1010  => R1=3
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[1] = 32'h03;

  #(`PERIOD*4); // MOVI R0=20'd3       => R0=3
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[0] = 32'h03;

  #(`PERIOD*4); // SW M0=R0           => M0=3
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_mem[0] = 32'h03;

  #(`PERIOD*4); // ORI R0=R0|4'b0100   => R0=7
  if (DM1.mem_data[0] != golden_mem[0])
    err_num = err_num + 1;
  golden_reg[0] = 32'h07;

  #(`PERIOD*4); // AND R1=R1&R0        => R1=3
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_reg[1] = 32'h03;

  #(`PERIOD*4); // LW R0=M0           => R0=3
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[0] = 32'h03;

  #(`PERIOD*4); // NOP

  #(`PERIOD*4); // ADD R1=R0+R1        => R1=6
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_reg[1] = 32'h06;

  #(`PERIOD*4); // OR R1=R1|R0         => R1=7
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[1] = 32'h07;

  #(`PERIOD*4); // SUB R1=R1-R0        => R1=4
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[1] = 32'h04;

  #(`PERIOD*4); // SW M19=R1          => M19=4
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_mem[0] = 32'h04;

  #(`PERIOD*4); // SRLI R2=R0 SRL(1)   => R2=1
  if (DM1.mem_data[19] != golden_mem[19])
    err_num = err_num + 1;
  golden_reg[2] = 32'h01;
  
  #(`PERIOD*4); // SLLI R2=R2 SLL(3)   => R2=8
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[2] = 32'h08;

  #(`PERIOD*4); // LW R1=M23          => R1=0
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[1] = 32'h00;

  #(`PERIOD*4); // AND R1=R1&R3        => R1=0
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[0] = 32'h00;

  #(`PERIOD*4); // SW M35=R2          => M35=8
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_mem[35] = 32'h08;

  #(`PERIOD*4); //IDEL
  if (DM1.mem_data[35] != golden_mem[35])
    err_num = err_num + 1;
  end

  // for iverilog which does not support 2-dimension array.
  initial begin
  #(`PERIOD*2); 
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

    tb_mem_data_0 = 32'd0;
    tb_mem_data_19 = 32'd0;
    tb_mem_data_35 = 32'd0;
    internel_err_num = 0;

  #(`PERIOD*1.5);
  #(`PERIOD*4);

  #(`PERIOD*4); // ADDI R1=R1+4'b1001  => R1=9
  tb_rw_reg_1 = 32'h09;

  #(`PERIOD*4); // XORI R1=R1^4'b1010  => R1=3
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h03;

  #(`PERIOD*4); // MOVI R0=20'd3       => R0=3
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'h03;

  #(`PERIOD*4); // SW M0=R0           => M0=3
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_0 = 32'h03;

  #(`PERIOD*4); // ORI R0=R0|4'b0100   => R0=7
  if (tb_mem_data_0 != DM1.mem_data_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'h07;

  #(`PERIOD*4); // AND R1=R1&R0        => R1=3
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h03;

  #(`PERIOD*4); // LW R0=M0           => R0=3
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'h03;

  #(`PERIOD*4); // NOP

  #(`PERIOD*4); // ADD R1=R0+R1        => R1=6
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h06;

  #(`PERIOD*4); // OR R1=R1|R0         => R1=7
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h07;

  #(`PERIOD*4); // SUB R1=R1-R0        => R1=4
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h04;

  #(`PERIOD*4); // SW M19=R1          => M19=4
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_19 = 32'h04;

  #(`PERIOD*4); // SRLI R2=R0 SRL(1)   => R2=1
  if (tb_mem_data_19 != DM1.mem_data_19)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h01;
  
  #(`PERIOD*4); // SLLI R2=R2 SLL(3)   => R2=8
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h08;

  #(`PERIOD*4); // LW R1=M23          => R1=0
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h00;

  #(`PERIOD*4); // AND R1=R1&R3        => R1=0
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'h00;

  #(`PERIOD*4); // SW M35=R2          => M35=8
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_35 = 32'h08;

  #(`PERIOD*4); //IDEL
  if (tb_mem_data_35 != DM1.mem_data_35)
    internel_err_num = internel_err_num + 1;
  end

  /* Dump and finish */
  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars;
//  $fsdbDumpfile("top_tb.fsdb");
//  $fsdbDumpvars;
  end

endmodule
