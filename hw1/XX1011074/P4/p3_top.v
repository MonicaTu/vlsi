`include "regfile.v"
`include "alu32.v"

// according to spec 
module p3_top(clk, rst, read_address1, read_address2, write_address, enable_fetch, enable_writeback, imm_5bit, imm_15bit, imm_20bit, mux4to1_select, mux2to1_select, imm_reg_select, enable_execute, opcode, sub_opcode, alu_overflow);
  
  parameter DataSize = 32;
  parameter AddrSize = 5;
 
  input clk;
  input rst;
  //register
  input [AddrSize-1:0]read_address1;
  input [AddrSize-1:0]read_address2;
  input [AddrSize-1:0]write_address;
  input enable_fetch;
  input enable_writeback;
  //imm_sel
  input [4:0]imm_5bit;
  input [14:0]imm_15bit;
  input [19:0]imm_20bit;
  //mux
  input [1:0]mux4to1_select;
  input mux2to1_select; // writeback_select
  input imm_reg_select;
  //ALU
  input enable_execute;
  input [5:0]opcode;
  input [4:0]sub_opcode;
  output alu_overflow;
  // others
  wire [DataSize-1:0]read_data1;
  wire [DataSize-1:0]read_data2;
  wire [DataSize-1:0]scr2;
  wire [DataSize-1:0]alu_result;
  output reg [DataSize-1:0]mux4to1_out;

  always @ (imm_5bit or imm_15bit or imm_20bit or mux4to1_select) begin
    case (mux4to1_select)
      2'b00: mux4to1_out <= imm_5bit; // FIXME: ZE 
      2'b01: mux4to1_out <= imm_15bit; // FIXME: SE 
      2'b10: mux4to1_out <= imm_15bit; // FIXME: ZE
      2'b11: mux4to1_out <= imm_20bit; // FIXME: SE
      default: mux4to1_out <= 32'bx;
    endcase
  end
  assign scr2 = (imm_reg_select) ? mux4to1_out: read_data2;
  assign write_data = (mux2to1_select) ? alu_result : scr2;

  regfile regfile1 (
    .read_data1(read_data1), 
    .read_data2(read_data2),
    .read_address1(read_address1),
    .read_address2(read_address2),
    .write_address(write_address),
    .write_data(alu_result),
    .clk(clk),
    .reset(rst),
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
    .reset(rst));

endmodule
