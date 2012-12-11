`define PC_SEL_ADD_4        2'b00
`define PC_SEL_ADD_IMM_SL_1 2'b01
`define PC_SEL_EXCEPTION    2'b10

module pc_select_mux (o_pc, i_add_4, i_add_imm_sl_1, i_exception, i_pc_select);

  parameter sel_size = 2;
  parameter pc_size = 32;

  input [pc_size-1:0]i_add_4;
  input [pc_size-1:0]i_add_imm_sl_1;
  input [pc_size-1:0]i_exception;
  input [sel_size-1:0]i_pc_select;

  output [pc_size-1:0]o_pc;

  reg [pc_size-1:0]o_pc;

  case (i_pc_select) begin
    `PC_SEL_ADD_4:        o_pc = i_add_4;
    `PC_SEL_ADD_IMM_SL_1: o_pc = i_add_imm_sl_1;
    `PC_SEL_EXCEPTION:    o_pc = i_add_exception;
    default: o_pc = 0;
  endcase

endmodule
