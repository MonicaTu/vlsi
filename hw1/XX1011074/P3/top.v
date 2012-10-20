`include "regfile.v"
`include "alu32.v"

module top(alu_result, alu_overflow, clk, rst, read_address1, read_address2, write_address, enable_fetch, enable_writeback, imm_5bit, imm_15bit, imm_20bit, mux4to1_select, mux2to1_select, imm_reg_select, enable_execute, opcode, sub_opcode);
  
  parameter DataSize = 32;
  parameter AddrSize = 5;
 
  /* OUT */
  output alu_overflow;
  output [DataSize-1:0]alu_result;

  /* IN */
  input clk;
  input rst;
  //Register
  input [AddrSize-1:0]read_address1;
  input [AddrSize-1:0]read_address2;
  input [AddrSize-1:0]write_address;
  input enable_fetch;
  input enable_writeback;
  //imm_sel
  input [4:0]imm_5bit;
  input [14:0]imm_15bit;
  input [19:0]imm_20bit;
  input [1:0]mux4to1_select;
  input mux2to1_select;
  input imm_reg_select;
  //ALU
  input enable_execute;
  input [5:0] opcode;
  input [4:0] sub_opcode;

  /* Wire */
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;
//  wire reset;

  regfile regfile1 (
    .read_data1(read_data1), 
    .read_data2(read_data2),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .write_data(alu_result),
    .clk(clk),
    .reset(rst),
//    .reset(reset),
    .read(enable_fetch),
    .write(enable_writeback));

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
