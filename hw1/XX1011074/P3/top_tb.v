`timescale 1ns/10ps

module top_tb;

  parameter DataSize = 32;
  parameter AddrSize = 5;

  reg clk,rst;
  //Register
  reg [AddrSize-1:0]read_address1;
  reg [AddrSize-1:0]read_address2;
  reg [AddrSize-1:0]write_address;
  reg enable_fetch;
  reg enable_writeback;
  //imm_sel
  reg [4:0]imm_5bit;
  reg [14:0]imm_15bit;
  reg [19:0]imm_20bit;
  reg [1:0]mux4to1_select;
  reg mux2to1_select;
  reg imm_reg_select;
  //ALU
  reg enable_execute;
  reg [5:0] opcode;
  reg [4:0] sub_opcode;
  //OUT
  wire alu_overflow;
  wire [31:0]alu_result;
  integer i,err_num;
  //test &debug
  reg [DataSize-1:0]golden_reg[31:0];

  parameter imm5bitZE = 2'b00, imm15bitSE = 2'b01, imm15bitZE = 2'b10, imm20bitSE =  2'b11;
  parameter regOut = 1'b0, immOut = 1'b1;
  parameter scr2 = 1'b0, aluResult = 1'b1; 

top TOP(
  clk,
  rst,
  //Register
  read_address1,
  read_address2,
  write_address,
  enable_fetch,
  enable_writeback,
  //imm_sel
  imm_5bit,
  imm_15bit,
  imm_20bit,
  mux4to1_select,
  mux2to1_select,
  imm_reg_select,
  //ALU
  enable_execute,
  opcode,
  sub_opcode,
  //OUTPUT
  alu_overflow
);

  //clock gen.
  always #5 clk=~clk;

  initial begin
  clk=0;
  rst=1'b0;
  golden_reg[0] = 32'd200;
//IDLE
  //Register
  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b0;
  enable_writeback=1'b0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  mux4to1_select=imm5bitZE;
  mux2to1_select=scr2;
  imm_reg_select=regOut;
  //ALU
  enable_execute=1'b0;
  opcode='b0;
  sub_opcode='d0;

  #5 rst=1'b1;
  #5 rst=1'b0;

//TEST MOVEI Reg[0]=200(Dec)
  //Register
  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b0;
  enable_writeback=1'b1;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d200;
  mux4to1_select=imm20bitSE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  enable_execute=1'b0;
  opcode='d0;
  sub_opcode='d0;
//TEST ADDI Reg[1]=Reg[0]+100(Dec) read_cycle
  //Register
#10  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b1;
  enable_writeback=1'b0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d0;
  mux4to1_select=imm15bitSE;
  mux2to1_select=scr2;
  imm_reg_select=immOut;
  //ALU
  enable_execute=1'b1;
  opcode='b101000;
  sub_opcode='d0;

//TEST ADDI Reg[1]=Reg[0]+100(Dec) writeback_cycle
  //Register
#10  read_address1='d0;
  read_address2='d0;
  write_address='d1;
  enable_fetch=1'b0;
  enable_writeback=1'b1;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d0;
  mux4to1_select=imm15bitSE;
  mux2to1_select=scr2;
  imm_reg_select=immOut;
  //ALU
  enable_execute=1'b1;
  opcode='b101000;
  sub_opcode='d0;

//IDLE
#10  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b0;
  enable_writeback=1'b0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  mux4to1_select=imm5bitZE;
  mux2to1_select=scr2;
  imm_reg_select=regOut;
  //ALU
  enable_execute=1'b0;
  opcode='b0;
  sub_opcode='d0;
  $finish;
  end

  /* Dump and finish */
  initial begin
  $dumpfile("top_tb.vcd");
  $dumpvars;
//  $fsdbDumpfile("top_tb.fsdb");
//  $fsdbDumpvars;
  end

endmodule
