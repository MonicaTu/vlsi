`include "pc_tick.v"
`include "ir_controller.v"
`include "rom_controller.v"
`include "mem_controller.v"
`include "p3_top.v"

module top (MEM_en, MEM_read, MEM_write, MEM_addr, rom_read, rom_enable, rom_address, DM_read, DM_write, DM_enable, DM_in, DM_address, PC, IM_read, IM_write, IM_enable, rom_out, DM_out, instruction, clk, reset, system_enable);
  parameter DataSize = 32;
  parameter MemSize  = 10;
  parameter AddrSize = 5;

  // top
  input clk;
  input reset;
  input system_enable;
  input [DataSize-1:0] instruction; 
  input [DataSize-1:0] DM_out;
  input [35:0] rom_out;
  
  output rom_read;
  output rom_enable;
  output [7:0]rom_address;
  output DM_read;
  output DM_write;
  output DM_enable;
  output [DataSize-1:0]DM_in;
  output [11:0]DM_address;
  output IM_read;
  output IM_write;
  output IM_enable;
  output [9:0]IM_address;
  output [MemSize-1:0] PC;

  output MEM_en;
  output MEM_read; 
  output MEM_write; 
  output mem_en_write; 
  output [12:0]MEM_addr; 

  wire rom_read;
  wire rom_enable;
  wire [7:0]rom_address;
  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [DataSize-1:0] DM_in = p3.regfile1.rw_reg[write_address];
  wire [11:0]DM_address = p3.alu12_result;
  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [MemSize-1:0] PC;
//  wire [9:0]IM_address;
  
  wire im_reset;
  wire im_enable;
  wire im_en_write;
  wire [12:0]im_addr;

  wire MEM_en;
  wire MEM_read; 
  wire mem_en_write; 
  wire [12:0]MEM_addr; 

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
  wire [AddrSize-1:0]read_address1;
  wire [AddrSize-1:0]read_address2;
  wire [AddrSize-1:0]write_address;
  wire [1:0] mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
  wire [127:0] cycle_cnt;
  wire alu_overflow;
  wire [2:0]cycle;

  pc_tick pc_tick1 (
    .clock(clk), 
    .reset(reset), 
    .cycle(cycle),
    .pc(PC), 
    .cycle_cnt(cycle_cnt));

  rom_controller rom_controller1 (
    .cycle(cycle),
    .ROM_enable(rom_enable),
    .ROM_read(rom_read),
    .system_enable(system_enable),
    .clock(clk));

  mem_controller mem_controller1 (
    .im_enable(IM_enable), 
    .im_en_read(IM_read), 
    .im_en_write(IM_write), 
    .im_addr(IM_address), 
    .mem_enable(MEM_en), 
    .mem_en_read(MEM_read), 
    .mem_en_write(MEM_write), 
    .mem_addr(MEM_addr), 
    .rom_ir(rom_out), 
    .clock(clk));

  ir_controller ir_conrtoller1 (
    .enable_dm_fetch(DM_read), 
    .enable_dm_write(DM_write), 
    .enable_dm(DM_enable), 
    .enable_im_fetch(IM_read), 
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
    .reset(reset),
    .PC(PC),
    .ir(instruction));

  p3_top p3 (
    .clk(clk),
    .rst(reset),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .enable_dm_fetch(DM_read), 
    .enable_dm_write(DM_write), 
    .enable_dm(DM_enable), 
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
