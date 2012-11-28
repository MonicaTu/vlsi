`include "pc_tick.v"
`include "rom_controller.v"
`include "mem_controller.v"
`include "ir_controller.v"
`include "regfile.v"
`include "alu32.v"
`include "mux4to1_select_mux.v"
`include "alu_scr_mux.v"
`include "writeback_select_mux.v"

module top (MEM_en, MEM_read, MEM_write, MEM_addr, rom_enable, rom_read, rom_address, cycle_cnt, ins_cnt, DM_read, DM_write, DM_enable, DM_in, DM_address, IM_in, IM_address, IM_read, IM_write, IM_enable, MEM_data, rom_out, DM_out, instruction, system_enable, rst, clk);
  parameter DataSize = 32;
  parameter IMSize = 10;
  parameter DMAddrSize = 12;
  parameter IMAddrSize = 10;
  parameter RegAddrSize = 5;
  parameter CycleSize = 128;
  parameter InsSize = 64;
  parameter AluResultSize = 12;
  parameter ROMAddrSize = 37;
  parameter MEMSize = 16;
  parameter ROMSize = 8;

  // top
  input clk;
  input rst;
  input system_enable;
  input [DataSize-1:0] instruction; 
  input [DataSize-1:0] DM_out;
  input [ROMAddrSize-1:0] rom_out;
  input [DataSize-1:0] MEM_data;
 
  output rom_enable;
  output rom_read;
  output [ROMSize-1:0]rom_address; // TODO: assign OR wire

  output MEM_en;
  output MEM_read;
  output MEM_write;
  output [MEMSize-1:0] MEM_addr;

  output DM_read;
  output DM_write;
  output DM_enable;
  output [DataSize-1:0]DM_in;
  output [DMAddrSize-1:0]DM_address;

  output IM_read;
  output IM_write;
  output IM_enable;
  output [IMAddrSize-1:0]IM_address;
  output [DataSize-1:0]IM_in;
  output [CycleSize-1:0] cycle_cnt;
  output [InsSize-1:0] ins_cnt;

  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [RegAddrSize-1:0]write_address;
  wire [DataSize-1:0]DM_in;
  wire [DMAddrSize-1:0]DM_address;
  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [IMAddrSize-1:0]IM_address;
  wire [DataSize-1:0]IM_in;

  // internal
  wire [IMSize-1:0]PC;
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
  wire [1:0]alu_scr_select1;
  wire [1:0]alu_scr_select2;
  wire [CycleSize-1:0] cycle_cnt;
  wire [InsSize-1:0] ins_cnt;
  wire alu32_overflow;
  wire exe_ir_done;
  wire load_im_done;
  
  // others
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;
  wire [DataSize-1:0]scr1;
  wire [DataSize-1:0]scr2;
  wire [DataSize-1:0]alu32_result;
  wire [DataSize-1:0]reg_write_data;
  wire [DataSize-1:0]mux4to1_out;
  wire [DataSize-1:0]scr_out1;
  wire [DataSize-1:0]scr_out2;
  
  wire mem_IM_read;
  wire mem_IM_write;
  wire mem_IM_enable;
  wire [IMAddrSize-1:0]mem_IM_address;
  wire ir_IM_read;
  wire ir_IM_write;
  wire ir_IM_enable;
  wire [IMAddrSize-1:0]ir_IM_address;
  wire ir_enable;
  wire rom_done;
  wire eop;
  wire [15:0]total_ir;

  assign DM_in = regfile1.rw_reg[write_address];
  assign DM_address = alu32_result[AluResultSize-1:0];
  
  assign IM_read    = (ir_enable) ? ir_IM_read    : mem_IM_read;
  assign IM_write   = (ir_enable) ? ir_IM_write   : mem_IM_write;
  assign IM_enable  = (ir_enable) ? ir_IM_enable  : mem_IM_enable;
  assign IM_address = (ir_enable) ? ir_IM_address : mem_IM_address;
  assign IM_in = MEM_data; 

  pc_tick pc_tick1 (
    .clock(clk), 
    .ir_enable(ir_enable), 
    .reset(rst), 
    .pc(PC), 
    .cycle_cnt(cycle_cnt));
  
  rom_controller rom_controller1 (
    .rom_done(rom_done),
    .rom_pc(rom_address),
//    .rom_initial(rom_initial),
    .ROM_enable(rom_enable),
    .ROM_read(rom_read),
    .Ins_cnt(ins_cnt),
    .eop(eop), 
    .exe_ir_done(exe_ir_done), 
//    .ir_enable(ir_enable), 
    .load_im_done(load_im_done), 
    .system_enable(system_enable),
    .reset(rst),
    .clock(clk));

  mem_controller mem_controller1 (
    .total_ir(total_ir), 
    .eop(eop), 
    .ir_enable(ir_enable), 
    .load_im_done(load_im_done), 
    .im_enable(mem_IM_enable), 
    .im_en_read(mem_IM_read), 
    .im_en_write(mem_IM_write), 
    .im_addr(mem_IM_address), 
    .mem_enable(MEM_en), 
    .mem_en_read(MEM_read), 
    .mem_en_write(MEM_write), 
    .mem_addr(MEM_addr), 
    .rom_ir(rom_out), 
    .reset(rst),
    .clock(clk));

  ir_controller ir_conrtoller1 (
    .exe_ir_done(exe_ir_done), 
    .Ins_cnt(ins_cnt),
    .IM_address(ir_IM_address),
    .enable_dm_fetch(DM_read), 
    .enable_dm_write(DM_write), 
    .enable_dm(DM_enable), 
    .enable_im_fetch(ir_IM_read), 
    .enable_im_write(ir_IM_write), 
    .enable_im(ir_IM_enable), 
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
    .alu_scr_select1(alu_scr_select1),
    .alu_scr_select2(alu_scr_select2),
    .total_ir(total_ir), 
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
    .scr1(scr_out1),
    .scr2(scr_out2),
    .opcode(opcode),
    .sub_opcode_5bit(sub_opcode_5bit),
    .sub_opcode_8bit(sub_opcode_8bit),
    .sv(sv),
    .enable_execute(enable_alu_execute),
    .reset(rst));

  mux4to1_select_mux mux4to1_select_mux1 (
    .mux4to1_out(mux4to1_out),
    .imm_5bit(imm5),
    .imm_15bit(imm15),
    .imm_20bit(imm20),
    .mux4to1_select(mux4to1_select));

  alu_scr_mux alu_scr_mux1 (
    .scr_out(scr_out1),
    .imm(mux4to1_out),
    .data(read_data1), 
    .addr(read_address1), 
    .alu_scr_select(alu_scr_select1));
  
  alu_scr_mux alu_scr_mux2 (
    .scr_out(scr_out2),
    .imm(mux4to1_out),
    .data(read_data2), 
    .addr(read_address2), 
    .alu_scr_select(alu_scr_select2));

  writeback_select_mux writeback_select_mux1 (
    .write_data(reg_write_data),
    .DMout(DM_out),
    .alu_result(alu32_result),
    .mux2to1_select(writeback_select));
endmodule
