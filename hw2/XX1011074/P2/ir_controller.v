module ir_controller(enable_mem_fetch, enable_mem_write, enable_mem, enable_alu_execute, enable_reg_read, enable_reg_write, opcode, sub_opcode_5bit, sub_opcode_8bit, mux4to1_select, writeback_select, imm_reg_select, clock, reset, PC, ir);
  parameter MemSize = 10;
  parameter DataSize = 32;
  parameter AddrSize = 5;

  /* top */
  input clock;
  input reset;
  input [MemSize-1:0] PC;
  input [DataSize-1:0] ir;

  output reg enable_mem_fetch;
  output reg enable_mem_write;
  output reg enable_mem;
  
  output reg enable_alu_execute;
  output reg enable_reg_read;
  output reg enable_reg_write;
  output [5:0] opcode;
  output [4:0] sub_opcode_5bit;
  output [7:0] sub_opcode_8bit;
  output reg [1:0] mux4to1_select;
  output reg writeback_select;
  output reg imm_reg_select;
  
  /* internal */
  wire [5:0] opcode = present_instruction[30:25];
  wire [4:0] sub_opcode_5bit = present_instruction[4:0];
  wire [7:0] sub_opcode_8bit = present_instruction[7:0];
  wire [AddrSize-1:0] imm5ZE = present_instruction[14:10];

  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [DataSize-1:0] present_instruction;

  // op & sub_op
  parameter TYPE_BASIC=6'b100000;
  parameter NOP=5'b01001, ADD=5'b00000, SUB=5'b00001, AND=5'b00010,
            OR=5'b00100, XOR=5'b00011, SRLI=5'b01001, SLLI=5'b01000,
            ROTRI=5'b01011;

  parameter ADDI=6'b101000, ORI=6'b101100, XORI=6'b101011, LWI=6'b000010, SWI=6'b001010;

  parameter MOVI=6'b100010;

  parameter TYPE_LS=6'b011100;
  parameter LW=8'b00000010, SW=8'b00001010;

  // state
  parameter stopState = 2'b00, fetchState = 2'b01, exeState = 2'b10, writeState =  2'b11;
  // mux4to1_select
  parameter sel_imm5ZE = 2'b00, sel_imm15SE = 2'b01, sel_imm15ZE = 2'b10, sel_imm20SE =  2'b11;
  // writeback_select
  parameter sel_aluResult = 1'b0, sel_src2Out = 1'b1; 
  // imm_reg_select
  parameter sel_regOut = 1'b0, sel_immOut = 1'b1;

  always @(negedge clock)
  begin
    if(reset)
      current_state <= stopState;
    else
      current_state <= next_state;
  end

  always @(current_state)
  begin
    case(current_state)
    stopState : begin
      next_state <= fetchState;
      enable_mem <= 1;
      enable_mem_fetch <= 1;
      enable_mem_write <= 0;
      enable_reg_read <= 0;
      enable_alu_execute <= 0;
      enable_reg_write <= 0;
    end
    fetchState : begin
      next_state <= exeState;
      enable_mem <= 1;
      enable_mem_fetch <= 1;
      enable_mem_write <= 0;
      enable_reg_read <= 1;
      enable_alu_execute <= 0;
      enable_reg_write <= 0;
    end
    exeState : begin
      next_state <= writeState;
      enable_mem <= 1;
      enable_mem_fetch <= 1;
      enable_mem_write <= 0;
      enable_reg_read <= 0;
      enable_alu_execute <= 1;
      enable_reg_write <= 0;
    end
    writeState : begin
      next_state <= stopState;
      enable_mem <= 1;
      enable_mem_fetch <= 1;
      enable_mem_write <= 0;
      enable_reg_read <= 0;
      enable_alu_execute <= 0;
      if (opcode == TYPE_BASIC && sub_opcode_5bit == SRLI && imm5ZE == 5'b0) // NOP
        enable_reg_write <= 0;
      else
        enable_reg_write <= 1;
    end
    endcase

    writeback_select <= (opcode == MOVI) ? sel_src2Out : sel_aluResult;

    case(opcode)
      TYPE_BASIC : begin
               if (sub_opcode_5bit == SRLI | sub_opcode_5bit == SLLI | sub_opcode_5bit == ROTRI) begin
    	         	mux4to1_select <= sel_imm5ZE; 
    	         	imm_reg_select <= sel_immOut;
	             end
	             else begin
    	         	mux4to1_select <= sel_imm5ZE; 
    	         	imm_reg_select <= sel_regOut;
               end
	           end
      ADDI : begin
               mux4to1_select <= sel_imm15SE;
      	       imm_reg_select <= sel_immOut;
      	     end
      ORI  : begin
      	       mux4to1_select <= sel_imm15ZE;
      	       imm_reg_select <= sel_immOut;
      	     end
      XORI : begin
      	       mux4to1_select <= sel_imm15ZE;
      	       imm_reg_select <= sel_immOut;
      	     end
      LWI  : begin
//               mux4to1_select <= sel_imm15ZE;
//               imm_reg_select <= sel_immOut;
      	     end
      SWI  : begin
//               mux4to1_select <= sel_imm15ZE;
//               imm_reg_select <= sel_immOut;
      	     end
      MOVI : begin
      	      mux4to1_select <= sel_imm20SE;
      	      imm_reg_select <= sel_immOut;
      	     end
      TYPE_LS : case (sub_opcode_8bit)
                  LW : begin
//                        mux4to1_select <= sel_imm20SE;
//                        imm_reg_select <= sel_immOut;
                       end
                  SW : begin
//                        mux4to1_select <= sel_imm20SE;
//                        imm_reg_select <= sel_immOut;
                       end
                endcase
      default : begin 
    	        mux4to1_select <= sel_imm5ZE; 
    	        imm_reg_select <= sel_regOut;
    	       end
    endcase
  end

  // FIXME
//  always @(negedge enable_reg_read)
  always @(negedge clock)
  begin
  // FIXME
//    if(PC == 0)
//      present_instruction <= 0;
//    else
      present_instruction <= ir;
      
    if (ir)
      $display("(%d) %h:%h", PC, ir, present_instruction);
  end

endmodule

