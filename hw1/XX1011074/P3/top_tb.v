`timescale 1ns/10ps
`define PERIOD 10
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
  reg [1:0]mux4to1_select;
  reg mux2to1_select;
  reg imm_reg_select;
  //ALU
  reg enable_execute;
  reg [5:0] opcode;
  reg [4:0] sub_opcode;
  //OUT
  wire alu_overflow;
  wire [31:0]alu_result;
  integer i,err_num;
  //test &debug
  reg [DataSize-1:0]golden_reg[31:0];
  reg [31:0]tb_rw_reg_0;
  reg [31:0]tb_rw_reg_1;
  reg [31:0]tb_rw_reg_2;

  parameter imm5bitZE = 2'b00, imm15bitSE = 2'b01, imm15bitZE = 2'b10, imm20bitSE =  2'b11;
  parameter regOut = 1'b0, immOut = 1'b1;
  parameter aluResult = 1'b0, scr2 = 1'b1; 


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
  mux4to1_select,
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
  clk = 1'b0;
  #(`PERIOD) rst = 1'b0;
  #(`PERIOD) rst = 1'b1;  
  #(`PERIOD) rst = 1'b0;
  #(`PERIOD*1.5);

/* TEST NOP */
  //Register
  read_address1='d0;
  read_address2='d0;
  write_address='d0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=regOut;
  //ALU
  opcode='b100000; sub_opcode='b01001;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST MOVI Reg[0]=200(Dec)
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d0;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d200;
  //mux
  mux4to1_select=imm20bitSE;
  mux2to1_select=scr2;
  imm_reg_select=immOut;
  //ALU
  opcode='b100010; sub_opcode='d0;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST ADDI Reg[1]=Reg[0]+100(Dec)=300
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d1;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm15bitSE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  opcode='b101000; sub_opcode='d0;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST ADD. Rt=Ra+Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=regOut;
  //ALU
  opcode='b100000; sub_opcode='b00000;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST SUB  Rt=Rb-Ra
  //Register
  read_address1='d1;
  read_address2='d0;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=regOut;
  //ALU
  opcode='b100000; sub_opcode='b00001;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST AND  Rt=Ra&Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=regOut;
  //ALU
  opcode='b100000; sub_opcode='b00010;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST OR Rt=Ra|Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=regOut;
  //ALU
  opcode='b100000; sub_opcode='d00100;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST XOR Rt=Ra^Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=regOut;
  //ALU
  opcode='b100000; sub_opcode='b00011;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST SRLI  Rt=Ra>>Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d3;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  opcode='b100000; sub_opcode='d01001;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST SLLI Rt=Ra<<Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d3;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  opcode='b100000; sub_opcode='b01000;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST ROTRI Rt=Ra>>Rb
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d3;
  imm_15bit='d0;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm5bitZE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  opcode='b100000; sub_opcode='b01011;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST ORI Rt=Ra|ZE(imm)
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d00;
  //mux
  mux4to1_select=imm15bitSE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  opcode='b101100; sub_opcode='d0;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

//TEST XORI  Rt=Ra^ZE(imm)
  //Register
  read_address1='d0;
  read_address2='d1;
  write_address='d2;
  //imm_sel
  imm_5bit='d0;
  imm_15bit='d100;
  imm_20bit='d0;
  //mux
  mux4to1_select=imm15bitSE;
  mux2to1_select=aluResult;
  imm_reg_select=immOut;
  //ALU
  opcode='b101011; sub_opcode='d0;

//stopState
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//fetchState
  //controller
  enable_fetch=1'b1;
  enable_execute=1'b0;
  enable_writeback=1'b0;
#(`PERIOD);

//exeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b1;
  enable_writeback=1'b0;
#(`PERIOD);

//writeState
  //controller
  enable_fetch=1'b0;
  enable_execute=1'b0;
  enable_writeback=1'b1;
#(`PERIOD);

#(`PERIOD*4); $finish;
  end
  
  initial begin
        #(`PERIOD*3.5) 
        for ( i = 0; i < DataSize; i = i+1) begin
	  golden_reg[i] = 32'b0;
	end
        // NOP
        #(`PERIOD*4);
        // MOVI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h00C8;
	golden_reg[2] = 32'h00C8;
        // ADDI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h012C;
	golden_reg[2] = 32'h012C;
        // ADD
        #(`PERIOD*4) tb_rw_reg_2 = 32'h01F4;
	golden_reg[2] = 32'h01F4;
        // SUB
        #(`PERIOD*4) tb_rw_reg_2 = 32'h0064;
	golden_reg[2] = 32'h0064;
        // AND
        #(`PERIOD*4) tb_rw_reg_2 = 32'h0008;
	golden_reg[2] = 32'h0008;
        // OR
        #(`PERIOD*4) tb_rw_reg_2 = 32'h01EC;
	golden_reg[2] = 32'h01EC;
        // XOR
        #(`PERIOD*4) tb_rw_reg_2 = 32'h01E4;
	golden_reg[2] = 32'h01E4;
        // SRLI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h0019;
	golden_reg[2] = 32'h0019;
        // SLLI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h0640;
	golden_reg[2] = 32'h0640;
        // ROTRI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h0019;
	golden_reg[2] = 32'h0019;
        // ORI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h00EC;
	golden_reg[2] = 32'h00EC;
        // XORI
        #(`PERIOD*4) tb_rw_reg_2 = 32'h00AC;
	golden_reg[2] = 32'h00AC;
	// IDEL
        #(`PERIOD*4); $finish;
  end

  /* Dump and finish */
  initial begin
  $dumpfile("top_tb.vcd");
  $dumpvars;
  $fsdbDumpfile("top_tb.fsdb");
  $fsdbDumpvars;
  $fsdbDumpvars(0, top_tb, "+mda");
  end

endmodule
