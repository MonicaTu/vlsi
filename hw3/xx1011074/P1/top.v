`include "mem_controller.v"
`include "pc.v"
`include "adder.v"
`include "controller.v"
`include "equal_32bit.v"
`include "mux2to1_32bit.v"
`include "sign_extend_14to32.v"
`include "sign_extend_24to32.v"
`include "IF_ID.v"

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

/* ============
     internal
   ============ */

  // PC
  wire pc_clk;

  wire [31:0]pc1_out;
  wire [31:0]mux_pc_out;

  wire [31:0]adder1_result;
  wire [31:0]adder2_result;
  wire controller1_jump;
  wire controller1_branch;
  wire equal1_result;
  wire jump_taken;
  wire branch_taekn;
  wire zero;

  wire [31:0]IF_ID1_pc;
  wire [31:0]IF_ID1_instruction;

  wire [31:0]BEQ_J_offset;
  wire [31:0]mux_BEQ_J_data;
  wire [31:0]SE_14to32_data;
  wire [31:0]SE_24to32_data;

  wire [31:0]regfile_data1;
  wire [31:0]regfile_data2;

  //ROM
  wire rom_done;
  wire rom_enable;
  wire [7:0] rom_address;
  
  //EM
  wire MEM_en;
  wire MEM_read;
  wire MEM_write;
  wire [15:0] MEM_address;
 
  //IM
  wire mem_IM_read;
  wire mem_IM_write;
  wire mem_IM_enable;
  wire [9:0]mem_IM_address;
  wire ir_IM_read;
  wire ir_IM_write;
  wire ir_IM_enable;
  wire [9:0]ir_IM_address;
  
  // top
  assign ir_IM_address = pc1_out;

  assign pc_clk = rom_done & clk;

  assign BEQ_J_offset = mux_BEQ_J_data << 1;
  assign branch_taken = controller1_branch & equal1_result;
  assign jump_taken = controller1_jump;
  assign zero = branch_taken || jump_taken;
  
  assign IM_read    = (rom_done) ? 1 : mem_IM_read;
  assign IM_write   = (rom_done) ? 1 : mem_IM_write;
  assign IM_enable  = (rom_done) ? 1 : mem_IM_enable;
  assign IM_address = (rom_done) ? ir_IM_address : mem_IM_address;
  assign IM_in = MEM_data; 

  assign rom_read = rom_enable;
  
  mem_controller mem_controller1 (
    .rom_done(rom_done),
    .rom_enable(rom_enable),
    .rom_addr(rom_address),
    .im_enable(mem_IM_enable), 
    .im_en_read(mem_IM_read), 
    .im_en_write(mem_IM_write), 
    .im_addr(mem_IM_address), 
    .mem_enable(MEM_en), 
    .mem_en_read(MEM_read), 
    .mem_en_write(MEM_write), 
    .mem_addr(MEM_address), 
    .rom_ir(rom_out), 
    .system_enable(system_enable),
    .reset(rst),
    .clock(clk));

  pc pc1 (
      .o_pc(pc1_out)
    , .i_pc(mux_pc_out)
    , .rst(rst)
    , .clk(pc_clk)
  );

  mux2to1_32bit mux_pc (
      .o_data(mux_pc_out)
    , .i_data0(adder1_result)
    , .i_data1(adder2_result)
    , .i_select(zero)
  );

  adder adder1 (
      .o_result(adder1_result)
    , .i_src1(pc1_out)
    , .i_src2(32'd1)
  );

  adder adder2 (
      .o_result(adder2_result)
    , .i_src1(IF_ID1_pc)
    , .i_src2(BEQ_J_offset)
  );

  sign_extend_14to32 SE_14to32 (
      .o_data(SE_14to32_data)
    , .i_data(IF_ID1_instruction[13:0])
  );

  sign_extend_24to32 SE_24to32 (
      .o_data(SE_24to32_data)
    , .i_data(IF_ID1_instruction[23:0])
  );

  mux2to1_32bit mux_BEQ_J (
      .o_data(mux_BEQ_J_data)
    , .i_data0(SE_14to32_data)
    , .i_data1(SE_24to32_data)
    , .i_select(IF_ID1_instruction[26]) // FIXME
  );

  equal_32bit equal1 (
      .o_result(equal1_result)
    , .i_data1(regfile_data1)
    , .i_data2(regfile_data2)
  );

  controller controller1 (
      .o_branch(controller1_branch)
    , .o_jump(controller1_jump)
//    , .RegDst
//    , .MemRead
//    , .MemtoReg
//    , .ALUOp
//    , .MemWrite
//    , .ALUSrc
//    , .RegWrite
    , .i_opcode(IF_ID1_instruction[30:25])
    , .rst(rst)
  );

  IF_ID IF_ID1 (
      .o_pc(IF_ID1_pc)
    , .o_instruction(IF_ID1_instruction)
    , .i_pc(adder1_result)
    , .i_instruction(instruction) // top
    , .rst(rst)
    , .clk(clk)
  );

endmodule
