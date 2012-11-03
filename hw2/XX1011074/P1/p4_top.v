`include "IM.v"
`include "pc_tick.v"
`include "ir_controller.v"
`include "p3_top.v"

module p4_top (clk, reset);
  parameter DataSize = 32;
  parameter MemSize  = 10;
  parameter AddrSize = 5;

  // top
  input clk;
  input reset;
  
  // ir_controller
  wire [DataSize-1:0] instruction; 
  wire enable_alu_execute;
  wire enable_reg_read;
  wire enable_reg_write;
  wire [5:0] opcode;
  wire [4:0] sub_opcode;
  wire [1:0] mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
  wire [MemSize-1:0] PC;
  wire [127:0] tick;
  
  /* p3_top */
  // regfile
  wire [AddrSize-1:0]read_address1 = instruction[19:15];
  wire [AddrSize-1:0]read_address2 = instruction[14:10];
  wire [AddrSize-1:0]write_address = instruction[24:20];
  //imm_sel
  wire [4:0]imm_5bit = instruction[14:10];
  wire [14:0]imm_15bit = instruction[14:0];
  wire [19:0]imm_20bit = instruction[19:0];
  // alu
  wire alu_overflow;
  
  // FIXME: for test
  reg enable_mem_fetch = 1;
  reg enable_mem_write = 0;
  reg enable_mem = 1;
  reg [DataSize-1:0] mem_data_in;
  
  IM IM1 (
    .clk(clk), 
    .rst(reset), 
    .IM_address(PC), 
    .enable_fetch(enable_mem_fetch), 
    .enable_write(enable_mem_write), 
    .enable_mem(enable_mem), 
    .IMin(mem_data_in), 
    .IMout(instruction));

  pc_tick pc_tick1 (
    .clock(clk), 
    .reset(reset), 
    .pc(PC), 
    .tick(tick));

  ir_controller ir_conrtoller1 (
    .enable_alu_execute(enable_alu_execute),
    .enable_reg_read(enable_reg_read),
    .enable_reg_write(enable_reg_write),
    .opcode(opcode),
    .sub_opcode(sub_opcode),
    .mux4to1_select(mux4to1_select),
    .writeback_select(writeback_select),
    .imm_reg_select(imm_reg_select),
    .clock(clk),
    .reset(reset),
    .PC(PC),
    .ir(instruction));

  p3_top p3 (
    .clk(clk),
    .rst(reset),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .enable_reg_read(enable_reg_read),
    .enable_reg_write(enable_reg_write),
    .imm_5bit(imm_5bit),
    .imm_15bit(imm_15bit),
    .imm_20bit(imm_20bit),
    .mux4to1_select(mux4to1_select),
    .mux2to1_select(writeback_select),
    .imm_reg_select(imm_reg_select),
    .enable_alu_execute(enable_alu_execute),
    .opcode(opcode),
    .sub_opcode(sub_opcode),
    .alu_overflow(alu_overflow));

endmodule
