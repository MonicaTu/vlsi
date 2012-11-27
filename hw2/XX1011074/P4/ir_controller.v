/* TODO: 
*/
module ir_controller(Ins_cnt, IM_address, enable_dm_fetch, enable_dm_write, enable_dm, enable_im_fetch, enable_im_write, enable_im, enable_alu_execute, enable_reg_read, enable_reg_write, opcode, sub_opcode_5bit, sub_opcode_8bit, sv, imm5, imm15, imm20, read_address1, read_address2, write_address, mux4to1_select, writeback_select, imm_reg_select, clock, reset, PC, ir);
  parameter MemSize = 10;
  parameter DataSize = 32;
  parameter AddrSize = 5;
  parameter InsSize = 64;
  parameter IMAddrSize = 10;
  parameter im_start = 'h79; // FIXME

  /* top */
  input clock;
  input reset;
  input [MemSize-1:0] PC;
  input [DataSize-1:0] ir;

  output [InsSize-1:0] Ins_cnt;
  output [IMAddrSize-1:0] IM_address;

  output enable_im_fetch;
  output enable_im_write;
  output enable_im;
  output enable_dm_fetch;
  output enable_dm_write;
  output enable_dm;
  
  output enable_alu_execute;
  output enable_reg_read;
  output enable_reg_write;

  output [1:0] mux4to1_select;
  output writeback_select;
  output imm_reg_select;

  output [5:0] opcode;
  output [4:0] sub_opcode_5bit;
  output [7:0] sub_opcode_8bit;
  output [1:0] sv; 
  output [4:0]  imm5;
  output [14:0] imm15;
  output [19:0] imm20;
  output [AddrSize-1:0]read_address1;
  output [AddrSize-1:0]read_address2;
  output [AddrSize-1:0]write_address;
  
  reg [InsSize-1:0] Ins_cnt;
  reg [IMAddrSize-1:0] IM_address;

  reg enable_im_fetch;
  reg enable_im_write;
  reg enable_im;
  reg enable_dm_fetch;
  reg enable_dm_write;
  reg enable_dm;
  
  reg enable_alu_execute;
  reg enable_reg_read;
  reg enable_reg_write;

  reg [1:0] mux4to1_select;
  reg writeback_select;
  reg imm_reg_select;
  
  /* internal */
  reg [DataSize-1:0] present_instruction;
  wire [5:0] opcode = present_instruction[30:25];
  wire [4:0] sub_opcode_5bit = present_instruction[4:0];
  wire [7:0] sub_opcode_8bit = present_instruction[7:0];
  wire [1:0] sv = present_instruction[9:8]; 
  wire [4:0]   imm5 = present_instruction[14:10];
  wire [14:0] imm15 = present_instruction[14:0];
  wire [19:0] imm20 = present_instruction[19:0];
  wire [AddrSize-1:0]read_address1 = present_instruction[19:15];
  wire [AddrSize-1:0]read_address2 = present_instruction[14:10];
  wire [AddrSize-1:0]write_address = present_instruction[24:20];

  reg [2:0] current_state;
  reg [2:0] next_state;

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
  parameter stopState = 3'b000, fetchState = 3'b001, exeState = 3'b010, writeState =  3'b011, lwFetchState = 3'b100, lwWriteState = 3'b101, swFetchState = 3'b110, swWriteState = 3'b111;
  // mux4to1_select
  parameter sel_imm5ZE = 2'b00, sel_imm15SE = 2'b01, sel_imm15ZE = 2'b10, sel_imm20SE =  2'b11;
  // writeback_select
  parameter sel_aluResult = 1'b0, sel_DMout = 1'b1; 
  // imm_reg_select
  parameter sel_regOut = 1'b0, sel_immOut = 1'b1;
     
  initial begin
    Ins_cnt = 0;
  end

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
      next_state = fetchState;
      enable_im = 1;
      enable_im_fetch = 1;
      enable_im_write = 0;
      enable_dm = 0;
      enable_dm_fetch = 0;
      enable_dm_write = 0;
      enable_reg_read = 0;
      enable_alu_execute = 0;
      enable_reg_write = 0;
    end
    fetchState : begin
      next_state = exeState;
      enable_im = 0;
      enable_im_fetch = 0;
      enable_im_write = 0;
      enable_dm = 0;       // FIXME
      enable_dm_fetch = 0; // FIXME
      enable_dm_write = 0;
      enable_reg_read = 1; // FIXME
      enable_alu_execute = 0;
      enable_reg_write = 0;
    end
    exeState : begin
      next_state = lwFetchState;
//      if (opcode == TYPE_LS) begin
//        enable_im <= 0;
//        enable_im_fetch <= 0;
//        enable_im_write <= 0;
//        enable_alu_execute <= 0;
//        enable_reg_read <= 0;
//        enable_reg_write <= 0;
//        enable_dm <= 0;
//        enable_dm_fetch <= 0;
//        enable_dm_write <= 0;
//      end else begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
        enable_reg_read = 0;
        enable_alu_execute = 1;
        enable_reg_write = 0;
//      end
    end
    lwFetchState : begin
      next_state = lwWriteState;
      if (opcode == TYPE_LS && sub_opcode_8bit == LW) begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 1;
        enable_dm_fetch = 1;
        enable_dm_write = 0;
      end else begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end
    end
    lwWriteState : begin
      next_state = writeState;
      if (opcode == TYPE_LS && sub_opcode_8bit == LW) begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end else begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end
    end
    writeState : begin
      next_state = swFetchState;
      enable_im = 0;
      enable_im_fetch = 0;
      enable_im_write = 0;
      enable_alu_execute = 0;
      if (opcode == TYPE_BASIC && sub_opcode_5bit == SRLI && imm5 == 5'b0) begin// NOP
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end else if (opcode == TYPE_LS && sub_opcode_8bit == SW) begin
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end else begin
        enable_reg_read = 0; //FIXME
        enable_reg_write = 1;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end
    end
    swFetchState : begin
      next_state = swWriteState;
      if (opcode == TYPE_LS && sub_opcode_8bit == SW) begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 1;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end else begin 
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end
    end
    swWriteState : begin
      next_state = stopState;
      if (opcode == TYPE_LS && sub_opcode_8bit == SW) begin
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 1;
        enable_dm_fetch = 0;
        enable_dm_write = 1;
      end else begin 
        enable_im = 0;
        enable_im_fetch = 0;
        enable_im_write = 0;
        enable_alu_execute = 0;
        enable_reg_read = 0;
        enable_reg_write = 0;
        enable_dm = 0;
        enable_dm_fetch = 0;
        enable_dm_write = 0;
      end
    end
    endcase

    writeback_select = (opcode == LWI | (opcode == TYPE_LS && sub_opcode_8bit == LW) ) ? sel_DMout : sel_aluResult;

    case(opcode)
      TYPE_BASIC : begin
               if (sub_opcode_5bit == SRLI | sub_opcode_5bit == SLLI | sub_opcode_5bit == ROTRI) begin
                    mux4to1_select = sel_imm5ZE; 
                    imm_reg_select = sel_immOut;
                 end
                 else begin
                    mux4to1_select = sel_imm5ZE; 
                    imm_reg_select = sel_regOut;
               end
               end
      ADDI : begin
               mux4to1_select = sel_imm15SE;
               imm_reg_select = sel_immOut;
             end
      ORI  : begin
               mux4to1_select = sel_imm15ZE;
               imm_reg_select = sel_immOut;
             end
      XORI : begin
               mux4to1_select = sel_imm15ZE;
               imm_reg_select = sel_immOut;
             end
      LWI  : begin
               mux4to1_select = sel_imm15ZE;
               imm_reg_select = sel_immOut; // FIXME
             end
      SWI  : begin
               mux4to1_select = sel_imm15ZE;
               imm_reg_select = sel_immOut;
             end
      MOVI : begin
              mux4to1_select = sel_imm20SE;
              imm_reg_select = sel_immOut;
             end
      TYPE_LS : case (sub_opcode_8bit)
                  LW : begin
                          mux4to1_select = sel_imm5ZE;
                          imm_reg_select = sel_regOut; // FIXME
                       end
                  SW : begin
                            mux4to1_select = sel_imm5ZE; 
                          imm_reg_select = sel_regOut;
                       end
                endcase
      default : begin 
                mux4to1_select = sel_imm5ZE; 
                imm_reg_select = sel_regOut;
               end
    endcase
  end

  always @(negedge enable_im_fetch)
  begin
    if(PC == 0) begin
      present_instruction <= 0;
    end else begin
      present_instruction <= ir;
    end
  end

  always @ (PC) begin
      IM_address = (PC + im_start);
  end

  always @ (present_instruction) begin
    if (present_instruction)
        Ins_cnt = Ins_cnt + 1;
    else
        Ins_cnt = Ins_cnt;
//    $display("PC:%d cnt:%d ir:%b", IM_address, Ins_cnt, present_instruction);
  end


endmodule

