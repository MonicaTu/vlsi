module ir_controller(enable_im_fetch, enable_im_write, enable_im, enable_alu_execute, enable_reg_read, enable_reg_write, opcode, sub_opcode, imm5, imm15, imm20, read_address1, read_address2, write_address, mux4to1_select, writeback_select, imm_reg_select, clock, reset, PC, ir);
  parameter MemSize = 10;
  parameter DataSize = 32;
  parameter AddrSize = 5;

  /* top */
  input clock;
  input reset;
  input [MemSize-1:0] PC;
  input [DataSize-1:0] ir;

  output enable_im_fetch;
  output enable_im_write;
  output enable_im;
  
  output enable_alu_execute;
  output enable_reg_read;
  output enable_reg_write;

  output [1:0] mux4to1_select;
  output writeback_select;
  output imm_reg_select;

  output [5:0] opcode;
  output [4:0] sub_opcode;
  output [4:0]  imm5;
  output [14:0] imm15;
  output [19:0] imm20;
  output [AddrSize-1:0]read_address1;
  output [AddrSize-1:0]read_address2;
  output [AddrSize-1:0]write_address;
  
  reg enable_im_fetch;
  reg enable_im_write;
  reg enable_im;
  
  reg enable_alu_execute;
  reg enable_reg_read;
  reg enable_reg_write;

  reg [1:0] mux4to1_select;
  reg writeback_select;
  reg imm_reg_select;
  
  /* internal */
  reg [DataSize-1:0] present_instruction;

  wire [5:0] opcode = present_instruction[30:25];
  wire [4:0] sub_opcode = present_instruction[4:0];
  wire [4:0]   imm5 = present_instruction[14:10];
  wire [14:0] imm15 = present_instruction[14:0];
  wire [19:0] imm20 = present_instruction[19:0];
  wire [AddrSize-1:0]read_address1 = present_instruction[19:15];
  wire [AddrSize-1:0]read_address2 = present_instruction[14:10];
  wire [AddrSize-1:0]write_address = present_instruction[24:20];

  reg [1:0] current_state;
  reg [1:0] next_state;

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
      enable_im <= 1;
      enable_im_fetch <= 1;
      enable_im_write <= 0;
      enable_reg_read <= 0;
      enable_alu_execute <= 0;
      enable_reg_write <= 0;
    end
    fetchState : begin
      next_state <= exeState;
      enable_im <= 1;
      enable_im_fetch <= 1;
      enable_im_write <= 0;
      enable_reg_read <= 1;
      enable_alu_execute <= 0;
      enable_reg_write <= 0;
    end
    exeState : begin
      next_state <= writeState;
      enable_im <= 0;
      enable_im_fetch <= 0;
      enable_im_write <= 0;
      enable_reg_read <= 0;
      enable_alu_execute <= 1;
      enable_reg_write <= 0;
    end
    writeState : begin
      next_state <= stopState;
      enable_im <= 0;
      enable_im_fetch <= 0;
      enable_im_write <= 0;
      enable_alu_execute <= 0;
      if (opcode == TYPE_BASIC && sub_opcode == SRLI && imm5 == 5'b0) begin// NOP
        enable_reg_read <= 0;
        enable_reg_write <= 0;
      end
      else begin
        enable_reg_read <= 0;
        enable_reg_write <= 1;
      end
    end
    endcase

    writeback_select <= (opcode == MOVI) ? sel_src2Out : sel_aluResult;

    case(opcode)
      TYPE_BASIC : begin
               if (sub_opcode == SRLI | sub_opcode == SLLI | sub_opcode == ROTRI) begin
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
      MOVI : begin
      	      mux4to1_select <= sel_imm20SE;
      	      imm_reg_select <= sel_immOut;
      	     end
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
      
//    if (ir)
//      $display("(%d) %h:%h", PC, ir, present_instruction);
  end

endmodule

