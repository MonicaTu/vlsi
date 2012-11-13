`include "pc_tick.v"
`include "ir_controller.v"
`include "regfile.v"
`include "alu32.v"
`include "alu12.v"
`include "mux4to1_select_mux.v"
`include "imm_reg_select_mux.v"
`include "writeback_select_mux.v"

module top (Cycle_cnt, Ins_cnt, DM_read, DM_write, DM_enable, DM_in, DM_address, IM_address, IM_read, IM_write, IM_enable, DM_out, instruction, rst, clk);
  parameter DataSize = 32;
  parameter MemSize = 10;
  parameter DMAddrSize = 12;
  parameter IMAddrSize = 10;
  parameter RegAddrSize = 5;
  parameter CycleSize = 128;
  parameter InsSize = 64;
  parameter AluResultSize = 12;

  // top
  input clk;
  input rst;
  input [DataSize-1:0] instruction; 
  input [DataSize-1:0] DM_out;
 
  output DM_read;
  output DM_write;
  output DM_enable;
  output [DataSize-1:0]DM_in;
  output [DMAddrSize-1:0]DM_address;

  output IM_read;
  output IM_write;
  output IM_enable;
  output [IMAddrSize-1:0]IM_address;
  output [CycleSize-1:0] Cycle_cnt;
  output [InsSize-1:0] Ins_cnt;

  output [MemSize-1:0] PC;

  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [RegAddrSize-1:0]write_address;
  wire [DataSize-1:0]DM_in = regfile1.rw_reg[write_address];
  wire [DMAddrSize-1:0]DM_address = alu12_result;
  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [IMAddrSize-1:0]IM_address;
  wire [MemSize-1:0]PC;

  // internal
  wire enable_alu_execute;
  wire enable_reg_read;
  wire enable_reg_write;
  wire [5:0] opcode;
  wire [4:0] sub_opcode_5bit;
  wire [7:0] sub_opcode_8bit;
  wire [1:0] sv;
  wire [4:0]imm5;
  wire [14:0]imm15;
  wire [19:0]imm20;
  wire [RegAddrSize-1:0]read_address1;
  wire [RegAddrSize-1:0]read_address2;
  wire [1:0] mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
  wire [CycleSize-1:0] Cycle_cnt;
  wire [InsSize-1:0] Ins_cnt;
  wire alu32_overflow;
  
  // others
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;
  //wire [DataSize-1:0]scr2;
  wire [DataSize-1:0]alu32_result;
  wire [AluResultSize-1:0]alu12_result;
  wire [DataSize-1:0]reg_write_data;
  wire [DataSize-1:0]mux4to1_out;
  wire [DataSize-1:0]imm_reg_out;

  pc_tick pc_tick1 (
    .clock(clk), 
    .reset(rst), 
    .pc(PC), 
    .cycle_cnt(Cycle_cnt));

  ir_controller ir_conrtoller1 (
    .Ins_cnt(Ins_cnt),
    .IM_address(IM_address),
    .enable_dm_fetch(DM_read), 
    .enable_dm_write(DM_write), 
    .enable_dm(DM_enable), 
    .enable_im_fetch(IM_read), 
    .enable_im_write(IM_write), 
    .enable_im(IM_enable), 
    .enable_alu_execute(enable_alu_execute),
    .enable_reg_read(enable_reg_read),
    .enable_reg_write(enable_reg_write),
    .opcode(opcode),
    .sub_opcode_5bit(sub_opcode_5bit),
    .sub_opcode_8bit(sub_opcode_8bit),
    .sv(sv),
    .imm5(imm5),
    .imm15(imm15),
    .imm20(imm20),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .mux4to1_select(mux4to1_select),
    .writeback_select(writeback_select),
    .imm_reg_select(imm_reg_select),
    .clock(clk),
    .reset(rst),
    .PC(PC),
    .ir(instruction));

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
    .imm_5bit(imm5),
    .imm_15bit(imm15),
    .imm_20bit(imm20),
    .mux4to1_select(mux4to1_select));

  imm_reg_select_mux imm_reg_select_mux1 (
    .imm_reg_out(imm_reg_out),
    .mux4to1_out(mux4to1_out),
    .read_data2(read_data2), 
    .imm_reg_select(imm_reg_select));

  writeback_select_mux writeback_select_mux1 (
    .write_data(reg_write_data),
    .DMout(DM_out),
    .alu_result(alu32_result),
    .mux2to1_select(writeback_select));
endmodule
