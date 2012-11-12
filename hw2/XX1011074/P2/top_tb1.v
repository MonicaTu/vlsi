//`timescale 1ns/10ps
`define PERIOD 10
`define IR_CYCLE 8

module top_tb1;

  parameter DataSize = 32;
  parameter MemSize = 10;

  parameter RegCnt = 32;
  parameter DataMemCnt = 4096;

  reg clk;
  reg reset;

  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [MemSize-1:0] PC;
  wire [DataSize-1:0] instruction;
  wire [127:0]cycle_cnt;

  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [DataSize-1:0] DM_in;
  wire [DataSize-1:0] DM_address;
  wire [DataSize-1:0] DM_out;
//  wire [DataSize-1:0] DM_out = DM1.mem_data[DM_address];
  
  // FIXME: for test
  reg [DataSize-1:0] mem_data_in;

  reg [DataSize-1:0]golden_reg[RegCnt-1:0];
  reg [DataSize-1:0]golden_mem[DataMemCnt-1:0];
  
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
  //reg [31:0]tb_mem_data_19; not used for this testbench
  //reg [31:0]tb_mem_data_35;

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
    .cycle_cnt(cycle_cnt), 
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
  #(`PERIOD*0.5);
  #(`PERIOD*`IR_CYCLE);
  reset = 1'b0;
    
  $readmemb("mins1.prog", IM1.mem_data);

  #(`PERIOD*`IR_CYCLE*22);
  $display("cycle count: %10d\n", cycle_cnt);
  $display("instruction count: %d\n", PC);
  $finish;
  end

  /* Create tb waveform */
  initial begin
  #(`PERIOD*2); 
    for ( i = 0; i < RegCnt; i = i+1) begin
      golden_reg[i] = 32'd0;
    end
    for ( i = 0; i < DataMemCnt; i = i+1) begin
      golden_mem[i] = 32'd0;
    end

    err_num = 0;

  #(`PERIOD*1.5);
//  #(`PERIOD*`IR_CYCLE);

  #(`PERIOD*`IR_CYCLE); // ADDI (R0=R0+5’b01101)
  golden_reg[0] = 32'b01101;

  #(`PERIOD*`IR_CYCLE); // ADDI (R1=R1+5’b01100)
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_reg[1] = 32'b01100;

  #(`PERIOD*`IR_CYCLE); // MOVI (R2= 5’b01000)
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[2] = 32'b10000;

  #(`PERIOD*`IR_CYCLE); // SW M0=R2
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_mem[0] = 32'b10000;

  #(`PERIOD*`IR_CYCLE); // ADD (R3=R0+R1)
  if (DM1.mem_data[0] != golden_mem[0])
    err_num = err_num + 1;
  golden_reg[3] = 32'b11001;

  #(`PERIOD*`IR_CYCLE); // SUB (R4=R0-R1)
  if (top1.regfile1.rw_reg[3] != golden_reg[3])
    err_num = err_num + 1;
  golden_reg[`IR_CYCLE] = 32'b00001;

  #(`PERIOD*`IR_CYCLE); // AND (R5=R3&R4)
  if (top1.regfile1.rw_reg[4] != golden_reg[4])
    err_num = err_num + 1;
  golden_reg[5] = 32'b00001;

  #(`PERIOD*`IR_CYCLE); // OR (R6=R3|R4)
  if (top1.regfile1.rw_reg[5] != golden_reg[5])
    err_num = err_num + 1;
  golden_reg[6] = 32'b11001;

  #(`PERIOD*`IR_CYCLE); // SW M8=R6
  if (top1.regfile1.rw_reg[6] != golden_reg[6])
    err_num = err_num + 1;
  golden_mem[8] = 32'b11001;

  #(`PERIOD*`IR_CYCLE); // XOR (R7= R3^R4)
  if (DM1.mem_data[8] != golden_mem[8])
    err_num = err_num + 1;
  golden_reg[7] = 32'b11000;

  #(`PERIOD*`IR_CYCLE); // SLLI (R8=R0<<5’b00100)
  if (top1.regfile1.rw_reg[7] != golden_reg[7])
    err_num = err_num + 1;
  golden_reg[8] = 32'b11010000;

  #(`PERIOD*`IR_CYCLE); // ROTRI (R9=R1>>5’b01000)
  if (top1.regfile1.rw_reg[8] != golden_reg[8])
    err_num = err_num + 1;
  golden_reg[9] = 32'h0C000000;

  #(`PERIOD*`IR_CYCLE); // ORI (R0=R0|5’b11111)
  if (top1.regfile1.rw_reg[9] != golden_reg[9])
    err_num = err_num + 1;
  golden_reg[0] = 32'b11111;

  #(`PERIOD*`IR_CYCLE); // XORI (R1=R1+5’b10101)
  if (top1.regfile1.rw_reg[0] != golden_reg[0])
    err_num = err_num + 1;
  golden_reg[1] = 32'b11001;
  
  #(`PERIOD*`IR_CYCLE); // ADD (R2=R0+R1)
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[2] = 32'h38;

  #(`PERIOD*`IR_CYCLE); // LW R1=M0
  if (top1.regfile1.rw_reg[2] != golden_reg[2])
    err_num = err_num + 1;
  golden_reg[1] = 32'h10;

  #(`PERIOD*`IR_CYCLE); // AND (R3=R1&R2)
  if (top1.regfile1.rw_reg[1] != golden_reg[1])
    err_num = err_num + 1;
  golden_reg[3] = 32'h10;

  #(`PERIOD*`IR_CYCLE); // ADDI (R4=R3+’d100)
  if (top1.regfile1.rw_reg[3] != golden_reg[3])
    err_num = err_num + 1;
  golden_reg[4] = 32'h74;

  #(`PERIOD*`IR_CYCLE); // MOVI (R5=’d300)
  if (top1.regfile1.rw_reg[4] != golden_reg[4])
    err_num = err_num + 1;
  golden_reg[5] = 32'h12C;

  #(`PERIOD*`IR_CYCLE); // XOR (R6=R4^R5)
  if (top1.regfile1.rw_reg[5] != golden_reg[5])
    err_num = err_num + 1;
  golden_mem[6] = 32'h158;

  #(`PERIOD*`IR_CYCLE); // LW R7=M8
  if (top1.regfile1.rw_reg[6] != golden_reg[6])
    err_num = err_num + 1;
  golden_reg[7] = 32'h19;

  #(`PERIOD*`IR_CYCLE); // R8=R7 ROT 5'b01000
  if (top1.regfile1.rw_reg[7] != golden_reg[7])
    err_num = err_num + 1;
  golden_reg[8] = 32'h19000000;

  #(`PERIOD*`IR_CYCLE); //IDEL
  if (top1.regfile1.rw_reg[8] != golden_reg[8])
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
    //tb_mem_data_19 = 32'd0; not used for this testbench
    //tb_mem_data_35 = 32'd0;

    internel_err_num = 0;

  #(`PERIOD*1.5);
  #(`PERIOD*`IR_CYCLE);

  #(`PERIOD*`IR_CYCLE) //ADDI
  tb_rw_reg_0 = 32'b01101;

  #(`PERIOD*`IR_CYCLE); //ADDI
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'b01100;

  #(`PERIOD*`IR_CYCLE); //MOVI
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'b10000;

  #(`PERIOD*`IR_CYCLE); //SW MO=R2
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_0 = 32'b10000;

  #(`PERIOD*`IR_CYCLE); //ADD
  if (tb_mem_data_0 != DM1.mem_data_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_3 = 32'b11001;

  #(`PERIOD*`IR_CYCLE); //SUB
  if (tb_rw_reg_3 != top1.regfile1.rw_reg_3)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_4 = 32'b00001;

  #(`PERIOD*`IR_CYCLE); //AND
  if (tb_rw_reg_4 != top1.regfile1.rw_reg_4)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_5 = 32'b00001;

  #(`PERIOD*`IR_CYCLE); //OR
  if (tb_rw_reg_5 != top1.regfile1.rw_reg_5)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_6 = 32'b11001;

  #(`PERIOD*`IR_CYCLE); //SW M8=R6
  if (tb_rw_reg_6 != top1.regfile1.rw_reg_6)
    internel_err_num = internel_err_num + 1;
  tb_mem_data_8 = 32'b11001;

  #(`PERIOD*`IR_CYCLE); //XOR
  if (tb_mem_data_8 != DM1.mem_data_8)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_7 = 32'b11000;

  #(`PERIOD*`IR_CYCLE); //SLLI
  if (tb_rw_reg_7 != top1.regfile1.rw_reg_7)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_8 = 32'b11010000;

  #(`PERIOD*`IR_CYCLE); //ROTRI
  if (tb_rw_reg_8 != top1.regfile1.rw_reg_8)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_9 = 32'h0C000000;

  #(`PERIOD*`IR_CYCLE); //ORI
  if (tb_rw_reg_9 != top1.regfile1.rw_reg_9)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_0 = 32'b11111;

  #(`PERIOD*`IR_CYCLE); //XORI
  if (tb_rw_reg_0 != top1.regfile1.rw_reg_0)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'b11001;
  
  #(`PERIOD*`IR_CYCLE); // ADD
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_2 = 32'h38;
  
  #(`PERIOD*`IR_CYCLE); // LW R1=M0
  if (tb_rw_reg_2 != top1.regfile1.rw_reg_2)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_1 = 32'h10;

  #(`PERIOD*`IR_CYCLE); // AND
  if (tb_rw_reg_1 != top1.regfile1.rw_reg_1)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_3 = 32'h10;
  
  #(`PERIOD*`IR_CYCLE); // ADDI
  if (tb_rw_reg_3 != top1.regfile1.rw_reg_3)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_4 = 32'h74;
  
  #(`PERIOD*`IR_CYCLE); // MOVI
  if (tb_rw_reg_4 != top1.regfile1.rw_reg_4)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_5 = 32'h12C;
  
  #(`PERIOD*`IR_CYCLE); // XOR
  if (tb_rw_reg_5 != top1.regfile1.rw_reg_5)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_6 = 32'h158;
  
  #(`PERIOD*`IR_CYCLE); // LW R7=M8
  if (tb_rw_reg_6 != top1.regfile1.rw_reg_6)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_7 = 32'h19;
  
  #(`PERIOD*`IR_CYCLE); // ROTI
  if (tb_rw_reg_7 != top1.regfile1.rw_reg_7)
    internel_err_num = internel_err_num + 1;
  tb_rw_reg_8 = 32'h19000000;
  
  #(`PERIOD*`IR_CYCLE); //IDEL
  if (tb_rw_reg_8 != top1.regfile1.rw_reg_8)
    internel_err_num = internel_err_num + 1;
  end

  /* Dump and finish */
  initial begin
    $dumpfile("top_tb1.vcd");
    $dumpvars;
//  $fsdbDumpfile("top_tb1.fsdb");
//  $fsdbDumpvars;
  end

endmodule
