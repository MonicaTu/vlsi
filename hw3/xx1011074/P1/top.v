`include "mem_controller.v"
`include "mux2to1_32bit.v"
`include "mux3to1_32bit.v"
`include "mux8to1_32bit.v"
`include "adder.v"
`include "pc.v"
`include "IF_ID.v"
`include "sign_extend_5to32.v"
`include "sign_extend_15to32.v"
`include "zero_extend_15to32.v"
`include "sign_extend_20to32.v"
`include "sign_extend_14to32.v"
`include "sign_extend_24to32.v"
//`include "equal_32bit.v"
`include "mux2to1_7bit.v"
`include "Control.v"
`include "regfile.v"
`include "ID_EX.v"
`include "alu32.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "Forwarding.v"
`include "Hazard_Detection.v"

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

  parameter DataSize = 32;
  parameter IMSize = 10;
  parameter DMAddrSize = 15;
  parameter IMAddrSize = 10;
  parameter RegAddrSize = 5;
  parameter CycleSize = 128;
  parameter InsSize = 64;
  parameter AluResultSize = 12;
  parameter ROMAddrSize = 36;
  parameter MEMSize = 14;
  parameter ROMSize = 8;

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

  wire [31:0]IF_ID_pc;
  wire [31:0]IF_ID_instruction;

//  wire [31:0]BEQ_J_offset;
//  wire [31:0]mux_BEQ_J_data;
//  wire [31:0]SE_14to32_data;
//  wire [31:0]SE_24to32_data;

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
  
  // Control 
//  wire Branch_Zero, PCWrite, IFIDWrite, Stall;
  wire Stall;
  assign Stall = 1'b0; // FIXME

  wire [6:0]Control_Code;
  wire [2:0]ImmSelect;
  wire [31:0]Imm_ID;
  wire [31:0]Imm_EX;
  wire [5:0]ALUOp_ID;
  wire [5:0]ALUOp_EX;
  wire [4:0]ALUSubOp_ID;
  wire [4:0]ALUSubOp_EX;
  wire [1:0]ALUsv_ID;
  wire [1:0]ALUsv_EX;
  wire RegDST_ID; 
  wire Branch; 
  wire MemRead_ID;
  wire MemtoReg_ID; 
  wire MemWrite_ID; 
  wire ALUSrc_ID; 
  wire RegWrite_ID; 
  wire RegWrite_EX; 
  wire MemtoReg_EX; 
  wire MemRead_EX; 
  wire MemWrite_EX; 
  wire ALUSrc_EX; 
  wire RegDST_EX; 
  wire RegWrite_MEM; 
  wire MemtoReg_MEM; 
  wire MemRead_MEM;
  wire MemWrite_MEM; 
  wire RegWrite_WB; 
  wire MemtoReg_WB; 
  
  // SE/ZE extened
  wire [31:0]SE_5to32_data;
  wire [31:0]SE_15to32_data;
  wire [31:0]SE_20to32_data;
  wire [31:0]SE_14to32_data;
  wire [31:0]SE_24to32_data;
  wire [31:0]ZE_15to32_data;

  // regfile
  wire enable_reg_read;
  wire enable_reg_write;
  wire [RegAddrSize-1:0]address1_ID;
  wire [RegAddrSize-1:0]address1_EX;
  wire [RegAddrSize-1:0]address2_ID;
  wire [RegAddrSize-1:0]address2_EX;
  wire [RegAddrSize-1:0]addressT_ID;
  wire [RegAddrSize-1:0]addressT_EX;
  wire [RegAddrSize-1:0]addressT_MEM;
  wire [RegAddrSize-1:0]addressT_WB;
  wire [DataSize-1:0]address1_data_ID;
  wire [DataSize-1:0]address1_data_EX;
  wire [DataSize-1:0]address2_data_ID;
  wire [DataSize-1:0]address2_data_EX;
  wire [DataSize-1:0]addressT_data_ID;
  wire [DataSize-1:0]addressT_data_EX;
  wire [DataSize-1:0]addressT_data_MEM;
  wire [DataSize-1:0]addressT_data_WB;
//  wire [DataSize-1:0]write_data;

  assign addressT_ID = IF_ID_instruction[24:20];
  assign address1_ID = IF_ID_instruction[19:15];
  assign address2_ID = IF_ID_instruction[14:10];

  // internal
//  wire [IMSize-1:0]PC;
//  wire [IMSize-1:0]pc_start;
//  wire enable_alu_execute;
//  wire [5:0] opcode;
//  wire [4:0] sub_opcode;
//  wire [1:0] sv;
//  wire [4:0]imm5;
//  wire [14:0]imm15;
//  wire [19:0]imm20;
//  wire [13:0]imm14;
//  wire [23:0]imm24;
//  wire [2:0] imm_select;
//  wire [1:0] writeback_select;
//  wire [1:0]alu_scr_select1;
//  wire [1:0]alu_scr_select2;
//  wire [CycleSize-1:0] Cycle_cnt;
//  wire [InsSize-1:0] Ins_cnt;
//  wire alu32_overflow;
//  wire exe_ir_done;
//  wire load_im_done;
  
  // alu32
  wire [DataSize-1:0]mux_ALUsrc;
  wire [DataSize-1:0]muxA_ALUsrc;
  wire [DataSize-1:0]muxB_ALUsrc;
  wire [DataSize-1:0]ALUResult_EX;
  wire [DataSize-1:0]ALUResult_MEM;
  wire [DataSize-1:0]ALUResult_WB;
  wire ALUOverflow_EX;
//  wire ALUOverflow_MEM;
//  wire ALUOverflow_WB;

  // DM
  wire [31:0]MemData_MEM;
  wire [31:0]MemData_WB;

  assign MemData_MEM = DM_out;

  // WB
  wire [31:0]mux_MemtoReg;

  // Forwarding
  wire [1:0]ForwardA_ALU;
  wire [1:0]ForwardB_ALU;
//  assign ForwardA_ALU = 2'b00; // FIXME
//  assign ForwardB_ALU = 2'b00; // FIXME
  wire [1:0]ForwardA_EQ;
  wire [1:0]ForwardB_EQ;

//  wire mem_IM_read;
//  wire mem_IM_write;
//  wire mem_IM_enable;
//  wire [IMAddrSize-1:0]mem_IM_address;
//  wire ir_IM_read;
//  wire ir_IM_write;
//  wire ir_IM_enable;
//  wire [IMAddrSize-1:0]ir_IM_address;
//  wire rom_done;

//  wire enable_pc_set;
  
  // top
  assign ir_IM_address = pc1_out;

  assign pc_clk = rom_done & clk;

//  assign BEQ_J_offset = mux_BEQ_J_data << 1;
//  assign branch_taken = controller1_branch & equal1_result;
//  assign jump_taken = controller1_jump;
//  assign zero = branch_taken || jump_taken;
  
  assign IM_read    = (rom_done) ? 1 : mem_IM_read;
  assign IM_write   = (rom_done) ? 1 : mem_IM_write;
  assign IM_enable  = (rom_done) ? 1 : mem_IM_enable;
  assign IM_address = (rom_done) ? ir_IM_address : mem_IM_address;
  assign IM_in = MEM_data; 

  assign rom_read = rom_enable;

  // Boot block
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

  // IF block: instruction fetch
  pc pc1 (
      .o_pc(pc1_out)
//    , .i_pc(mux_pc_out)
    , .i_pc(adder1_result)
    , .rst(rst)
    , .clk(pc_clk)
  );

//  mux2to1_32bit mux_pc (
//      .o_data(mux_pc_out)
//    , .i_data0(adder1_result)
//    , .i_data1(adder2_result)
//    , .i_select(zero)
//  );

  adder adder1 (
      .o_result(adder1_result)
    , .i_src1(pc1_out)
    , .i_src2(32'd1)
  );

  IF_ID IF_ID (
      .o_pc(IF_ID_pc)
    , .o_instruction(IF_ID_instruction)
    , .i_pc(adder1_result)
    , .i_instruction(instruction) // top
    , .rst(rst)
    , .clk(clk)
  );

  // ID block: instruction decode
  Control Control1 (
//      .o_branch(controller1_branch)
//    , .o_jump(controller1_jump)
      .i_opcode(IF_ID_instruction[30:25])
    , .i_sub_opcode(IF_ID_instruction[4:0])
    , .i_sv(IF_ID_instruction[9:8])
    , .ImmSelect(ImmSelect)
    , .ALUOp(ALUOp_ID)
    , .ALUSubOp(ALUSubOp_ID)
    , .ALUsv(ALUsv_ID)
    , .RegDst(Control_Code[6])
    , .Branch(Control_Code[5])
    , .MemRead(Control_Code[4])
    , .MemtoReg(Control_Code[3])
    , .MemWrite(Control_Code[2])
    , .ALUSrc(Control_Code[1])
    , .RegWrite(Control_Code[0])
  );

  mux8to1_32bit mux_Imm (
      .o_data(Imm_ID)
    , .i_data0(32'b0)
    , .i_data1(SE_5to32_data)
    , .i_data2(SE_15to32_data)
    , .i_data3(SE_20to32_data)
    , .i_data4(SE_14to32_data)
    , .i_data5(SE_24to32_data)
    , .i_data6(ZE_15to32_data)
    , .i_data7(32'b0)
    , .i_select(ImmSelect)
  );

  sign_extend_5to32 SE_5to32 (
      .o_data(SE_5to32_data)
    , .i_data(IF_ID_instruction[14:10])
  );

  sign_extend_15to32 SE_15to32 (
      .o_data(SE_15to32_data)
    , .i_data(IF_ID_instruction[14:0])
  );

  zero_extend_15to32 ZE_15to32 (
      .o_data(ZE_15to32_data)
    , .i_data(IF_ID_instruction[14:0])
  );

  sign_extend_20to32 SE_20to32 (
      .o_data(SE_20to32_data)
    , .i_data(IF_ID_instruction[19:0])
  );

  sign_extend_14to32 SE_14to32 (
      .o_data(SE_14to32_data)
    , .i_data(IF_ID_instruction[13:0])
  );

  sign_extend_24to32 SE_24to32 (
      .o_data(SE_24to32_data)
    , .i_data(IF_ID_instruction[23:0])
  );

  mux2to1_7bit Control_Stall(
  	  .o_data({RegDst_ID, Branch, MemRead_ID, MemtoReg_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID})
  	, .i_data0(Control_Code)
  	, .i_data1(7'b0)
  	, .i_select(Stall)
  );
  
  regfile regfile1 (
      .read_data1(address1_data_ID) 
    , .read_data2(address2_data_ID)
    , .read_dataT(addressT_data_ID)
    , .read_address1(address1_ID)
    , .read_address2(address2_ID)
    , .addressT(addressT_WB)
    , .write_data(mux_MemtoReg)
    , .clk(clk)
    , .reset(rst)
    , .read(1'b1)   // FIXME
    , .write(1'b1)  // FIXME
  );

//  adder adder2 (
//      .o_result(adder2_result)
//    , .i_src1(IF_ID_pc)
//    , .i_src2(BEQ_J_offset)
//  );

//  equal_32bit equal1 (
//      .o_result(equal1_result)
//    , .i_data1(address1_data)
//    , .i_data2(address2_data)
//  );

  ID_EX ID_EX1 (
      .RegWrite_out(RegWrite_EX)
    , .MemtoReg_out(MemtoReg_EX)
    , .MemRead_out(MemRead_EX)
    , .MemWrite_out(MemWrite_EX)
    , .ALUSrc_out(ALUSrc_EX)
    , .RegDst_out(RegDst_EX)
    , .ALUOp_out(ALUOp_EX)
    , .ALUSubOp_out(ALUSubOp_EX)
    , .ALUsv_out(ALUsv_EX)
    , .Immediate_out(Imm_EX)
    , .address1_data_out(address1_data_EX)
    , .address2_data_out(address2_data_EX)
    , .addressT_data_out(addressT_data_EX)
    , .address1_out(address1_EX)
    , .address2_out(address2_EX)
    , .addressT_out(addressT_EX)
    , .RegWrite_in(RegWrite_ID)
    , .MemtoReg_in(MemtoReg_ID)
    , .MemRead_in(MemRead_ID)
    , .MemWrite_in(MemWrite_ID)
    , .ALUSrc_in(ALUSrc_ID)
    , .RegDst_in(RegDst_ID)
    , .ALUOp_in(ALUOp_ID)
    , .ALUSubOp_in(ALUSubOp_ID)
    , .ALUsv_in(ALUsv_ID)
    , .Immediate_in(Imm_ID)
    , .address1_data_in(address1_data_ID)
    , .address2_data_in(address2_data_ID)
    , .addressT_data_in(addressT_data_ID)
    , .address1_in(address1_ID)
    , .address2_in(address2_ID)
    , .addressT_in(addressT_ID)
    , .rst(rst)
    , .clk(pc_clk)
  );
  
  // EX block: ALU execute
  alu32 alu1 ( 
      .zero(zero)
    , .alu_result(ALUResult_EX)
    , .alu_overflow(ALUOverflow_EX)
    , .scr1(muxA_ALUsrc)
    , .scr2(mux_ALUsrc)
    , .opcode(ALUOp_EX)
    , .sub_opcode(ALUSubOp_EX)
    , .sv(ALUsv_EX)
    , .reset(rst)
  );

  mux3to1_32bit mux_alu_src_forwardA (    
      .o_data(muxA_ALUsrc)
    , .i_data0(address1_data_EX)
    , .i_data1(mux_MemtoReg)
    , .i_data2(ALUResult_MEM)
    , .i_select(ForwardA_ALU)
  );
  
  mux3to1_32bit mux_alu_src_forwardB (    
      .o_data(muxB_ALUsrc)
    , .i_data0(address2_data_EX)
    , .i_data1(mux_MemtoReg)
    , .i_data2(ALUResult_MEM)
    , .i_select(ForwardB_ALU)
  );
  
  mux2to1_32bit mux_alu_src (
      .o_data(mux_ALUsrc)
    , .i_data0(muxB_ALUsrc) 
    , .i_data1(Imm_EX) 
    , .i_select(ALUSrc_EX) 
  );

//  alu_scr_mux alu_scr_mux1 (
//    , .scr_out(scr_out1),
//    , .imm(imm_out),
//    , .data(read_data1), 
//    , .addr(read_address1), 
//    , .alu_scr_select(alu_scr_select1)
//  );
//  
//  alu_scr_mux alu_scr_mux2 (
//    , .scr_out(scr_out2),
//    , .imm(imm_out),
//    , .data(read_data2), 
//    , .addr(read_address2), 
//    , .alu_scr_select(alu_scr_select2)
//  );

  EX_MEM EX_MEM1 (
      .RegWrite_in(RegWrite_EX)	// WB
    , .MemtoReg_in(MemtoReg_EX)	// WB
    , .MemRead_in(MemRead_EX)		// M
    , .MemWrite_in(MemWrite_EX)	// M
  	, .ALUData_in(ALUResult_EX)
  	, .MemWriteData_in(muxB_ALUsrc)
  	, .WBregister_in(addressT_EX)
    , .RegWrite_out(RegWrite_MEM)	// WB
    , .MemtoReg_out(MemtoReg_MEM)	// WB
    , .MemRead_out(MemRead_MEM)	// M
    , .MemWrite_out(MemWrite_MEM)
  	, .ALUData_out(ALUResult_MEM)
  	, .MemWriteData_out(addressT_data_MEM)
  	, .WBregister_out(addressT_MEM)
  	, .clk(clk)
  	, .rst(rst)
  );

  // MEM block: Acceess Memory
  MEM_WB MEM_WB1 (
      .RegWrite_in(RegWrite_MEM)	// WB
    , .MemtoReg_in(MemtoReg_MEM)	// WB
	  , .MemData_in(MemData_MEM)
	  , .ALUData_in(ALUResult_MEM)
	  , .WBregister_in(addressT_MEM)
    , .RegWrite_out(RegWrite_WB)	// WB
    , .MemtoReg_out(MemtoReg_WB)	// WB
	  , .MemData_out(MemData_WB)
	  , .ALUData_out(ALUResult_WB)
	  , .WBregister_out(addressT_WB)
	  , .clk(clk)
	  , .rst(rst)
  );

  // WB block: Write back
  mux2to1_32bit Mux_MemtoReg (
      .o_data(mux_MemtoReg)
    , .i_data0(ALUResult_WB) 
    , .i_data1(MemData_WB) 
    , .i_select(MemtoReg_WB) 
  );

  // Forwarding
  Forwarding Forwarding (
      .IFIDaddress1(address1_ID)
    , .IFIDaddress2(address1_ID)
    , .IDEXaddress1(address2_EX)
    , .IDEXaddress2(address2_EX)
    , .EXMEMRegWrite(RegWrite_MEM)
    , .EXMEMaddressT(addressT_MEM)
    , .MEMWBRegWrite(RegWrite_WB)
    , .MEMWBaddressT(addressT_WB)
    , .Branch(Branch)
    , .ForwardA_ALU(ForwardA_ALU)	
    , .ForwardB_ALU(ForwardB_ALU) 
    , .ForwardA_EQ(ForwardA_EQ)
    , .ForwardB_EQ(ForwardB_EQ)
  );

  // Hazard Detection
  Hazard_Detection Hazard_Detection(
      .IFIDaddress1(address1_ID)
    , .IFIDaddress2(address2_ID)
    , .IDEXMemRead(MemRead_EX)
    , .IDEXRegDST(addressT_EX)
    , .Branch(Control_Code[5])
    , .IDEXRegWrite(RegWrite_EX)
    , .Stall(Stall)
    , .clk(clk)
  );

endmodule
