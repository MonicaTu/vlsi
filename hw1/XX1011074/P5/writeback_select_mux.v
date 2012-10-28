module writeback_select_mux(write_data, imm_reg_out, alu_result, mux2to1_select);

  parameter DataSize = 32;

  output [DataSize-1:0] write_data;
  input [DataSize-1:0] imm_reg_out;
  input [DataSize-1:0] alu_result;
  input mux2to1_select;

  assign write_data = (mux2to1_select) ? imm_reg_out : alu_result;

endmodule
