`include "controller.v"
`include "p3_top.v"

module top (instruction, clk, reset);
  parameter DataSize = 32;
  parameter AddrSize = 5;

  // top
  input [DataSize-1:0]instruction;
  input clk;
  input reset;
  
  // controller
  wire enable_execute;
  wire enable_fetch;
  wire enable_writeback;
  wire [5:0]opcode;
  wire [4:0]sub_opcode;
  wire [1:0]mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
  input [31:0] PC; // TODO: what is this?
  
  // regfile
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;
  wire [AddrSize-1:0]read_address1 = instruction[19:15];
  wire [AddrSize-1:0]read_address2 = instruction[14:10];
  wire [AddrSize-1:0]write_address = instruction[24:20];
  wire [DataSize-1:0]write_data;
  
  // alu
  output alu_overflow;
  
  /* others */
  wire [DataSize-1:0]mux4to1_out;
  //imm_sel
  wire [4:0]imm_5bit = instruction[14:10];
  wire [14:0]imm_15bit = instruction[14:0];
  wire [19:0]imm_20bit = instruction[19:0];

  controller conrtoller1 (
    .enable_execute(enable_execute),
    .enable_fetch(enable_fetch),
    .enable_writeback(enable_writeback),
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
    .enable_fetch(enable_fetch),
    .enable_writeback(enable_writeback),
    .imm_5bit(imm_5bit),
    .imm_15bit(imm_15bit),
    .imm_20bit(imm_20bit),
    .mux4to1_select(mux4to1_select),
    .mux2to1_select(mux2to1_select),
    .imm_reg_select(imm_reg_select),
    .enable_execute(enable_execute),
    .opcode(opcode),
    .sub_opcode(sub_opcode),
    .alu_overflow(alu_overflow));

endmodule
