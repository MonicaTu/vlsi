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

  reg [DataSize-1:0]golden_reg[31:0];
  reg [DataSize-1:0]golden_mem[31:0];

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
  reg [31:0]tb_mem_data_8;
  reg [31:0]tb_mem_data_19;
  reg [31:0]tb_mem_data_23;

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
    
  $readmemb("mins2.prog", IM1.mem_data);

  #(`PERIOD*4*24) $finish;
  end

/* Create tb waveform */
  initial begin
  #(`PERIOD*2);

    for ( i = 0; i < DataSize; i = i+1) begin
      golden_reg[i] = 32'd0;
    end
    for ( i = 0; i < DataSize; i = i+1) begin
      golden_mem[i] = 32'd0;
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

  #(`PERIOD*4) //MOVI (R0=’d200)
  golden_reg[0] = 32'h00C8;

  #(`PERIOD*4) //SW MO=R0            M0=0xC8
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_mem[0] = 32'h00C8;

  #(`PERIOD*4) //ADDI (R1=R0+’d100)
  if (DM1.mem_data[0] != golden_mem[0])
    err_num = err_num + 1;
  golden_reg[1] = 32'h012C;

  #(`PERIOD*4) //SW M8=R1            M8=0x12C
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_mem[8] = 32'h012C;

  #(`PERIOD*4) //ADD (R2=R0+R1)
  if (DM1.mem_data[8] != golden_mem[8])
    err_num = err_num + 1;
  golden_reg[2] = 32'h01F4;

  #(`PERIOD*4) //SW M19=R2           M19=0x1F4
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_mem[19] = 32'h01F4;

  #(`PERIOD*4) //LW R2=M0            R2=0xC8
  if (DM1.mem_data[19] != golden_mem[19])
    err_num = err_num + 1;
  golden_reg[2] = 32'h00C8;

  #(`PERIOD*4) //SUB R2=R2-R1
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[2] = 32'h0064;

  #(`PERIOD*4) //SW M23=R2           M23=0x64
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_mem[23] = 32'h0064;

  #(`PERIOD*4) //LW R1=M19           R1=0x1F4
  if (DM1.mem_data[23] != golden_mem[23])
    err_num = err_num + 1;
  golden_reg[1] = 32'h01F4;

  #(`PERIOD*4) //AND R2=R0&R1
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[2] = 32'h00C0;

  #(`PERIOD*4) //LW R0=M8            R0=0x12C
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[0] = 32'h012C;

  #(`PERIOD*4) //OR R2=R0|R1
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_reg[2] = 32'h01FC;

  #(`PERIOD*4) //XOR R2=R0^R1
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[2] = 32'h00D8;

  #(`PERIOD*4) //SRLI R2=R0>>5'b00011
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[2] = 32'h0025;

  #(`PERIOD*4) //SLLI R2=R0<<5'b00011
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[2] = 32'h0960;

  #(`PERIOD*4) //LW R0=M23           R0=0x64
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[0] = 32'h0064;

  #(`PERIOD*4) //ROTRI R2=R0 ROT 5'b00011
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_reg[2] = 32'h8000000C;

  #(`PERIOD*4) //LW R3=M23           R3=0x64
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[3] = 32'h0064;

  #(`PERIOD*4) //ORI R4=R3|'d100
  if (top1.regfile1.rw_reg[3] != golden_reg[3])
    err_num = err_num + 1;
  golden_reg[4] = 32'h0064;

  #(`PERIOD*4) //SW M0=R4            M0=0x64
  if (top1.regfile1.rw_reg[4] != golden_reg[4])
    err_num = err_num + 1;
  golden_mem[0] = 32'h0064;

  #(`PERIOD*4) //XORI R4=R3^'d100
  if (DM1.mem_data[0] != golden_mem[0])
    err_num = err_num + 1;
  golden_reg[4] = 32'h0000;

  #(`PERIOD*4) //SW M8=R2            M8=0x8000000C
  if (top1.regfile1.rw_reg[4] != golden_reg[4])
    err_num = err_num + 1;
  golden_mem[8] = 32'h8000000C;

  #(`PERIOD*4); //IDEL
  if (DM1.mem_data[8] != golden_mem[8])
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
    tb_mem_data_8 = 32'd0;
    tb_mem_data_19 = 32'd0;
    tb_mem_data_23 = 32'd0;

    internel_err_num = 0;

  #(`PERIOD*1.5);
  #(`PERIOD*4);

  #(`PERIOD*4) //NOP

  #(`PERIOD*4) //MOVI (R0=’d200)
  tb_rw_reg_0 = 32'h00C8;

  #(`PERIOD*4) //SW MO=R0            M0=0xC8
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_0 = 32'h00C8;

  #(`PERIOD*4) //ADDI (R1=R0+’d100)
  if (tb_mem_data_0 != DM1.mem_data_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h012C;

  #(`PERIOD*4) //SW M8=R1            M8=0x12C
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_8 = 32'h012C;

  #(`PERIOD*4) //ADD (R2=R0+R1)
  if (tb_mem_data_8 != DM1.mem_data_8)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h01F4;

  #(`PERIOD*4) //SW M19=R2           M19=0x1F4
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_19 = 32'h01F4;

  #(`PERIOD*4) //LW R2=M0            R2=0xC8
  if (tb_mem_data_19 != DM1.mem_data_19)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h00C8;

  #(`PERIOD*4) //SUB R2=R2-R1
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h0064;

  #(`PERIOD*4) //SW M23=R2           M23=0x64
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_23 = 32'h0064;

  #(`PERIOD*4) //LW R1=M19           R1=0x1F4
  if (tb_mem_data_23 != DM1.mem_data_23)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h01F4;

  #(`PERIOD*4) //AND R2=R0&R1
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h00C0;

  #(`PERIOD*4) //LW R0=M8            R0=0x12C
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'h012C;

  #(`PERIOD*4) //OR R2=R0|R1
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h01FC;

  #(`PERIOD*4) //XOR R2=R0^R1
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h00D8;

  #(`PERIOD*4) //SRLI R2=R0>>5'b00011
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h0025;

  #(`PERIOD*4) //SLLI R2=R0<<5'b00011
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h0960;

  #(`PERIOD*4) //LW R0=M23           R0=0x64
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'h0064;

  #(`PERIOD*4) //ROTRI R2=R0 ROT 5'b00011
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h8000000C;

  #(`PERIOD*4) //LW R3=M23           R3=0x64
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_3 = 32'h0064;

  #(`PERIOD*4) //ORI R4=R3|'d100
  if (tb_rw_reg_3 != top1.regfile1.rw_reg_3)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_4 = 32'h0064;

  #(`PERIOD*4) //SW M0=R4            M0=0x64
  if (tb_rw_reg_4 != top1.regfile1.rw_reg_4)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_0 = 32'h0064;

  #(`PERIOD*4) //XORI R4=R3^'d100
  if (tb_mem_data_0 != DM1.mem_data_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_4 = 32'h0000;

  #(`PERIOD*4) //SW M8=R2            M8=0x8000000C
  if (tb_rw_reg_4 != top1.regfile1.rw_reg_4)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_8 = 32'h8000000C;

  #(`PERIOD*4); //IDEL
  if (tb_mem_data_8 != DM1.mem_data_8)
    internel_err_num = internel_err_num + 1;
  end

  /* Dump and finish */
  initial begin
    $dumpfile("top_tb2.vcd");
    $dumpvars;
//  $fsdbDumpfile("top_tb2.fsdb");
//  $fsdbDumpvars;
  end

endmodule
