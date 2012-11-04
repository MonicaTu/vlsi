`include "DM.v"
`include "regfile.v"
`include "alu32.v"
`include "alu12.v"
`include "mux4to1_select_mux.v"
`include "imm_reg_select_mux.v"
`include "writeback_select_mux.v"

// according to spec 
module p3_top(clk, rst, read_address1, read_address2, write_address, enable_dm_fetch, enable_dm_write, enable_dm, enable_reg_read, enable_reg_write, imm_5bit, imm_15bit, imm_20bit, mux4to1_select, mux2to1_select, imm_reg_select, enable_alu_execute, opcode, sub_opcode_5bit, sub_opcode_8bit, sv, alu32_overflow);
  
  parameter DataSize = 32;
  parameter AddrSize = 5;
 
  input clk;
  input rst;
  //register
  input [AddrSize-1:0]read_address1;
  input [AddrSize-1:0]read_address2;
  input [AddrSize-1:0]write_address;
  input enable_dm_fetch;
  input enable_dm_write;
  input enable_dm;
  input enable_reg_read;
  input enable_reg_write;
  //imm_sel
  input [4:0]imm_5bit;
  input [14:0]imm_15bit;
  input [19:0]imm_20bit;
  //mux
  input [1:0]mux4to1_select;
  input mux2to1_select; // writeback_select
  input imm_reg_select;
  //ALU
  input enable_alu_execute;
  input [5:0]opcode;
  input [4:0]sub_opcode_5bit;
  input [7:0]sub_opcode_8bit;
  input [1:0]sv;
  // others
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;
  //wire [DataSize-1:0]scr2;
  wire [DataSize-1:0]alu32_result;
  wire [11:0]alu12_result;
  wire [DataSize-1:0]reg_write_data;
  wire [DataSize-1:0]mux4to1_out;
  wire [DataSize-1:0]imm_reg_out;
  wire [DataSize-1:0]DMout;
  
  output alu32_overflow;

  DM DM1 (
    .clk(clk), 
    .rst(rst), 
    .enable_fetch(enable_dm_fetch), 
    .enable_write(enable_dm_write), 
    .enable_dm(enable_dm), 
    .DMin(regfile1.rw_reg[write_address]),// FIXME 
    .DMout(DMout), 
    .DM_address(alu12_result)); // FIXME: Port 8 (DM_address) of DM expects 12 bits, got 32.

  regfile regfile1 (
    .read_data1(read_data1), 
    .read_data2(read_data2),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .write_data(reg_write_data),
    .clk(clk),
    .reset(rst),
    .read(enable_reg_read),
    .write(enable_reg_write));

  alu32 alu1 ( 
    .alu_result(alu32_result),
    .alu_overflow(alu32_overflow),
    .scr1(read_data1),
    .scr2(imm_reg_out),
    .opcode(opcode),
    .sub_opcode_5bit(sub_opcode_5bit),
    .enable_execute(enable_alu_execute),
    .reset(rst));

  alu12 alu2 ( 
    .alu_result(alu12_result),
    .scr1(read_address1),
    .scr2(read_address2),
    .sv(sv),
    .opcode(opcode),
    .sub_opcode_8bit(sub_opcode_8bit),
    .enable_execute(enable_alu_execute),
    .reset(rst));

  mux4to1_select_mux mux4to1_select_mux1 (
    .mux4to1_out(mux4to1_out),
    .imm_5bit(imm_5bit),
    .imm_15bit(imm_15bit),
    .imm_20bit(imm_20bit),
    .mux4to1_select(mux4to1_select));

  imm_reg_select_mux imm_reg_select_mux1 (
    .imm_reg_out(imm_reg_out),
    .mux4to1_out(mux4to1_out),
    .read_data2(read_data2), 
    .imm_reg_select(imm_reg_select));

  writeback_select_mux writeback_select_mux1 (
    .write_data(reg_write_data),
    .DMout(DMout),
    .alu_result(alu32_result),
    .mux2to1_select(mux2to1_select));

endmodule
