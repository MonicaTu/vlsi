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
  
  // internal // FIXME
  wire [DataSize-1:0] instruction; 
  wire enable_im_fetch;
  wire enable_im_write;
  wire enable_im;
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
  wire [AddrSize-1:0]read_address1;
  wire [AddrSize-1:0]read_address2;
  wire [AddrSize-1:0]write_address;
  wire [1:0] mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
  wire [MemSize-1:0] PC;
  wire [127:0] tick;
  wire alu_overflow;
  
  // FIXME: for test
  reg [DataSize-1:0] mem_data_in;
  
  IM IM1 (
    .clk(clk), 
    .rst(reset), 
    .IM_address(PC), 
    .enable_fetch(enable_im_fetch), 
    .enable_write(enable_im_write), 
    .enable_im(enable_im), 
    .IMin(mem_data_in), 
    .IMout(instruction));

  pc_tick pc_tick1 (
    .clock(clk), 
    .reset(reset), 
    .pc(PC), 
    .tick(tick));

  ir_controller ir_conrtoller1 (
    .enable_dm_fetch(enable_dm_fetch), 
    .enable_dm_write(enable_dm_write), 
    .enable_dm(enable_dm), 
    .enable_im_fetch(enable_im_fetch), 
    .enable_im_write(enable_im_write), 
    .enable_im(enable_im), 
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
    .reset(reset),
    .PC(PC),
    .ir(instruction));

  p3_top p3 (
    .clk(clk),
    .rst(reset),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .enable_dm_fetch(enable_dm_fetch), 
    .enable_dm_write(enable_dm_write), 
    .enable_dm(enable_dm), 
    .enable_reg_read(enable_reg_read),
    .enable_reg_write(enable_reg_write),
    .imm_5bit(imm5),
    .imm_15bit(imm15),
    .imm_20bit(imm20),
    .mux4to1_select(mux4to1_select),
    .mux2to1_select(writeback_select),
    .imm_reg_select(imm_reg_select),
    .enable_alu_execute(enable_alu_execute),
    .opcode(opcode),
    .sub_opcode_5bit(sub_opcode_5bit),
    .sub_opcode_8bit(sub_opcode_8bit),
    .sv(sv),
    .alu32_overflow(alu_overflow));

endmodule
