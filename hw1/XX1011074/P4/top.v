`include "controller.v"
`include "regfile.v"
`include "alu32.v"

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
  wire mux4to1_select;
  wire writeback_select;
  wire imm_reg_select;
  input [31:0] PC; // TODO: what is this?
  
  // regfile
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;

  wire [AddrSize-1:0]read_address1;
  wire [AddrSize-1:0]read_address2;
  wire [AddrSize-1:0]write_address;
  wire [DataSize-1:0]write_data;
  
  // alu
  wire [DataSize-1:0]scr2;
  wire [DataSize-1:0]alu_result;
  output alu_overflow;
  
  // others
  reg  [DataSize-1:0]mux4to1_out;
  wire [4:0]imm_5bit;
  wire [14:0]imm_15bit;
  wire [19:0]imm_20bit;

  initial begin
    case (mux4to1_select)
      2'b00: begin
        // TODO: 5bit ZE; mux4to1_out = ZE(imm_5bit)
      end
      2'b01: begin
        // TODO: 15bit SE: mux4to1_out = SE(imm_15bit)
      end
      2'b10: begin
        // TODO: 15bit ZE; mux4to1_out = ZE(imm_15bit)
      end
      2'b11: begin
        // TODO: 20bit SE; mux4to1_out = SE(imm_20bit)
      end
    endcase
  end
  assign scr2 = (imm_reg_select) ? mux4to1_select_out: read_data2;
  assign write_data = (writeback_select) ? alu_result : scr2;

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

  regfile regfile1 (
    .read_data1(read_data1), 
    .read_data2(read_data2),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .write_data(write_data),
    .clk(clk),
    .reset(reset),
    .read(enable_fetch),
    .write(enable_writeback));

  alu32 alu1 ( 
    .alu_result(alu_result),
    .alu_overflow(alu_overflow),
    .scr1(read_data1),
    .scr2(scr2),
    .opcode(opcode),
    .sub_opcode(sub_opcode),
    .enable_execute(enable_execute),
    .reset(reset));

endmodule
