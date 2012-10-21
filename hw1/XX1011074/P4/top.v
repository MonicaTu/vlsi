`include "controller.v"
`include "regfile.v"
`include "alu32.v"

module top (instruction, clk, reset);
  parameter DataSize = 32;
  parameter AddrSize = 5;

  /* IN */
  input [DataSize-1:0]instruction;
  input clk;
  input reset;
  input rst; // FIXME

  // instruction
//  input [4:0] imm_5bit  = instruction[15:10];
//  input [14:0]imm_15bit = instruction[14:0];
//  input [19:0]imm_20bit = instruction[19:0];

  
  // controller
  wire enable_execute;
  wire enable_fetch;
  wire enable_writeback;
  wire [5:0]opcode; // FIXME: = instruction[30:25];
  wire [4:0]sub_opcode; // FIXME: = instruction[4:0];
  wire mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
//  input clock;
//  input reset;
  input [31:0] PC; // TODO: what is this?
//  input [31:0] ir; // instruction

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
    .reset(rst),
//    .reset(reset),
    .PC(PC),
    .ir(instruction));

  //regfile
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;

  input [AddrSize-1:0]read_address1;// FIXME: = instruction[19:15];
  input [AddrSize-1:0]read_address2;// FIXME: = instruction[14:10];
  input [AddrSize-1:0]write_address;// FIXME: = instruction[24:20];
  input [DataSize-1:0]write_data   ;// FIXME: = instruction[19:0];  // TODO: Rt32bit=SE(imm20bit)
//  input clk;
//  input reset;
//  input read;
//  input write;
  
  regfile regfile1 (
    .read_data1(read_data1), 
    .read_data2(read_data2),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .write_data(write_data),
    .clk(clk),
    .reset(rst),
//    .reset(reset),
    .read(enable_fetch),
    .write(enable_writeback));

  // alu
  wire [DataSize-1:0]alu_result;
  wire alu_overflow;

//  input [DataSize-1:0]scr1,scr2;
//  input [5:0]opcode; // FIXME: = instruction[30:25];
//  input [4:0]sub_opcode; // FIXME: = instruction[4:0];
//  input enable_execute;
//  input reset;

  alu32 alu1 ( 
    .alu_result(alu_result),
    .alu_overflow(alu_overflow),
    .scr1(read_data1),
    .scr2(read_data2),
    .opcode(opcode),
    .sub_opcode(sub_opcode),
    .enable_execute(enable_execute),
    .reset(rst));
//    .reset(reset));

endmodule
