module top_tb;

  parameter DataSize = 32;
  parameter AddrSize = 5;

  reg clk,rst;
  //Register
  reg [AddrSize-1:0]read_address1;
  reg [AddrSize-1:0]read_address2;
  reg [AddrSize-1:0]write_address;
  reg enable_fetch;
  reg enable_writeback;
  //imm_sel
  reg [4:0]imm_5bit;
  reg [14:0]imm_15bit;
  reg [19:0]imm_20bit;
  reg [1:0]mux3to1_select;
  reg mux2to1_select;
  reg imm_reg_select;
  //ALU
  reg enable_execute;
  reg [5:0] opcode;
  reg [4:0] sub_opcode;
  //OUT
  wire alu_overflow;
  integer i,err_num;
  //test &debug
  reg [DataSize-1:0]golden_reg[31:0];

top TOP(
  clk,
  rst,
  //Register
  read_address1,
  read_address2,
  write_address,
  enable_fetch,
  enable_writeback,
  //imm_sel
  imm_5bit,
  imm_15bit,
  imm_20bit,
  mux3to1_select,
  mux2to1_select,
  imm_reg_select,
  //ALU
  enable_execute,
  opcode,
  sub_opcode,
  //OUTPUT
  alu_overflow
);

  //clock gen.
  always #5 clk=~clk;

  initial begin
  clk=0;
  rst=1'b0;
//IDLE
  //Register
  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b0;
  enable_writeback=1'b0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  mux3to1_select=2'b0;
  mux2to1_select=1'b0;
  imm_reg_select=1'b0;
  //ALU
  enable_execute=1'b0;
  opcode='b0;
  sub_opcode='d0;

  #5 rst=1'b1;
  #5 rst=1'b0;

//TEST MOVEI Reg[0]=200(Dec)
  //Register
  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b0;
  enable_writeback=1'b1;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d200;
  mux3to1_select=2'b11;
  mux2to1_select=1'b1;
  imm_reg_select=1'b1;
  //ALU
  enable_execute=1'b0;
  opcode='d0;
  sub_opcode='d0;

//TEST ADDI Reg[1]=Reg[0]+100(Dec) read_cycle
  //Register
#10  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b1;
  enable_writeback=1'b0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d0;
  mux3to1_select=2'b1;
  mux2to1_select=1'b0;
  imm_reg_select=1'b1;
  //ALU
  enable_execute=1'b1;
  opcode='b101000;
  sub_opcode='d0;

//TEST ADDI Reg[1]=Reg[0]+100(Dec) writeback_cycle
  //Register
#10  read_address1='d0;
  read_address2='d0;
  write_address='d1;
  enable_fetch=1'b0;
  enable_writeback=1'b1;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d0;
  mux3to1_select=2'b1;
  mux2to1_select=1'b0;
  imm_reg_select=1'b1;
  //ALU
  enable_execute=1'b1;
  opcode='b101000;
  sub_opcode='d0;

//IDLE
#10  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  enable_fetch=1'b0;
  enable_writeback=1'b0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  mux3to1_select=2'b0;
  mux2to1_select=1'b0;
  imm_reg_select=1'b0;
  //ALU
  enable_execute=1'b0;
  opcode='b0;
  sub_opcode='d0;
 
  $dumpfile("top");
  $dumpvars;

//  $fsdbDumpfile("top.fsdb");
//  $fsdbDumpvars;

  $finish;
  end
endmodule
