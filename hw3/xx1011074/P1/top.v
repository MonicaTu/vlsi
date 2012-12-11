`include "pc.v"
`include "pc_select_mux.v"
`include "adder.v"

module top(
  //SYSTEM SIGNAL
  clk,
  rst,
  system_enable,
  //IM
  instruction,
  IM_read,
  IM_write,
  IM_enable,
  IM_in,
  IM_address,
  //DM
  DM_out,
  DM_read,
  DM_write,
  DM_enable,
  DM_in,
  DM_address,
  //EM
  MEM_data,
  MEM_en,
  MEM_read,
  MEM_write,
  MEM_in,
  MEM_address,
  //ROM
  rom_out,
  rom_enable,
  rom_address,
  //PERFORMANCE COUNTER
  cycle_cnt,
  ins_cnt,
  load_stall_cnt,
  branch_stall_cnt,
  //I/O interrupt
  IO_interrupt
);

  //SYSTEM SIGNAL
  input clk;
  input rst;
  input system_enable;
  
  //IM
  input [31:0] instruction;
  output IM_read;
  output IM_write;
  output IM_enable;
  output [31:0] IM_in;
  output [9:0] IM_address;
  
  //DM
  input [31:0] DM_out;
  output DM_read;
  output DM_write;
  output DM_enable;
  output [31:0] DM_in;
  output [14:0] DM_address;
  
  //EM
  input [31:0] MEM_data;
  output MEM_en;
  output MEM_read;
  output MEM_write;
  output [31:0] MEM_in;
  output [15:0] MEM_address;
  
  //ROM
  input [35:0] rom_out;
  output rom_enable;
  output [7:0] rom_address;

  //PERFORMANCE COUNTER
  output [127:0] cycle_cnt;
  output [63:0] ins_cnt;
  output [63:0] load_stall_cnt;
  output [63:0] branch_stall_cnt;
  
  //I/O interrupt
  input IO_interrupt;

  //internal
  
  pc pc1 (
      .o_pc(pc_out)
    , .i_pc(o_pc)
  );

  pc_select_mux pc_select_mux1 (
      .o_pc(o_pc)
    , .i_add_4(adder1_result)
    , .i_add_imm_sl_1(adder2_result)
    , .i_exception(exception)
    , .i_pc_select(pc_select)
  );

  adder adder1 (
      .o_result(adder1_result)
    , .i_src1(adder1_src1)
    , .i_src2(adder1_src2)
  );

  adder adder2 (
      .o_result(adder2_result)
    , .i_src1(adder2_src1)
    , .i_src2(adder2_src2)
  );

endmodule
