`include "regfile.v"
`include "alu32.v"

module top(clk, rst, read_address1, read_address2, write_address, enable_fetch, enable_writeback, imm_5bit, imm_15bit, imm_20bit, mux4to1_select, mux2to1_select, imm_reg_select, enable_execute, opcode, sub_opcode, alu_overflow);
  
  parameter DataSize = 32;
  parameter AddrSize = 5;
  // top
//  input clk;
  input rst, enable_fetch, enable_writeback; 
  input [4:0]imm_5bit;
  input [14:0]imm_15bit;
  input [19:0]imm_20bit;
  input [1:0]mux4to1_select;
  input mux2to1_select, imm_reg_select;
//  input enable_execute;

  // alu
  output [DataSize-1:0]alu_result;
  output alu_overflow;
  
  wire [DataSize-1:0]scr1,scr2;
  input [5:0]opcode;
  input [4:0]sub_opcode;
//  wire reset;
  input enable_execute;
  
  reg [63:0]rotate;
  reg a,b;

  //regfile
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;

  input [AddrSize-1:0]read_address1;
  input [AddrSize-1:0]read_address2;
  input [AddrSize-1:0]write_address;
  input [DataSize-1:0]write_data;
  input clk, reset, read, write;

  reg [DataSize-1:0]rw_reg[31:0];

  regfile rf(read_data1, read_data2, read_address1, read_address2,
		write_address, write_data, clk, reset, read, write);
  alu32 alu(alu_result,alu_overflow,scr1,scr2,opcode,sub_opcode,enable_execute,reset);
//  alu32 alu(alu_result,alu_overflow,.scr1(read_data1),scr2(read_data2),opcode,sub_opcode,enable_execute,reset);
endmodule
