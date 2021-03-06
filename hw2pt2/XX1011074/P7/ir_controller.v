/* TODO: 
*/
module ir_controller(exe_ir_done, Ins_cnt, IM_address, enable_pc_set, enable_dm_fetch, enable_dm_write, enable_dm, enable_im_fetch, enable_im_write, enable_im, enable_alu_execute, enable_reg_read, enable_reg_write, opcode, sub_opcode_5bit, sub_opcode_8bit, sv, imm5, imm15, imm20, read_address1, read_address2,addressT, imm_select, writeback_select, alu_scr_select1, alu_scr_select2, total_ir, clock, reset, PC, ir);
  parameter MemSize = 10;
  parameter DataSize = 32;
  parameter AddrSize = 5;
  parameter InsSize = 64;
  parameter IMAddrSize = 10;
  parameter im_start = 'h7F; // FIXME

  /* top */
  input clock;
  input reset;
  input [MemSize-1:0] PC;
  input [DataSize-1:0] ir;
  input [15:0] total_ir;

  output exe_ir_done;
  output [InsSize-1:0] Ins_cnt;
  output [IMAddrSize-1:0] IM_address;

  output enable_pc_set;

  output enable_im_fetch;
  output enable_im_write;
  output enable_im;
  output enable_dm_fetch;
  output enable_dm_write;
  output enable_dm;
  
  output enable_alu_execute;
  output enable_reg_read;
  output enable_reg_write;

  output [2:0] imm_select;
  output [1:0] writeback_select;
  output [1:0]alu_scr_select1;
  output [1:0]alu_scr_select2;

  output [5:0] opcode;
  output [4:0] sub_opcode_5bit;
  output [7:0] sub_opcode_8bit;
  output [1:0] sv; 
  output [4:0]  imm5;
  output [14:0] imm15;
  output [19:0] imm20;
  output [AddrSize-1:0]read_address1;
  output [AddrSize-1:0]read_address2;
  output [AddrSize-1:0]addressT;
  
  reg exe_ir_done;

  reg [InsSize-1:0] Ins_cnt;
  wire [IMAddrSize-1:0] IM_address;

  reg enable_pc_set;

  reg enable_im_fetch;
  reg enable_im_write;
  reg enable_im;
  reg enable_dm_fetch;
  reg enable_dm_write;
  reg enable_dm;
  
  reg enable_alu_execute;
  reg enable_reg_read;
  reg enable_reg_write;

  reg [2:0] imm_select;
  reg [1:0] writeback_select;
  reg [1:0]alu_scr_select1;
  reg [1:0]alu_scr_select2;
  
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
  wire [AddrSize-1:0]addressT = present_instruction[24:20];

  reg [3:0] current_state;
  reg [3:0] next_state;

  // op & sub_op
  parameter TYPE_BASIC=6'b100000;
  parameter NOP=5'b01001, ADD=5'b00000, SUB=5'b00001, AND=5'b00010,
            OR=5'b00100, XOR=5'b00011, SRLI=5'b01001, SLLI=5'b01000,
            ROTRI=5'b01011;

  parameter ADDI=6'b101000, ORI=6'b101100, XORI=6'b101011, LWI=6'b000010, SWI=6'b001010;

  parameter MOVI=6'b100010;
  parameter BEQ=6'b100110, J=6'b100100;

  parameter TYPE_LS=6'b011100;
  parameter LW=8'b00000010, SW=8'b00001010;

  // state
  parameter stopState = 4'b0000, fetchState = 4'b0001, exeState = 4'b0010, writeState =  4'b0011, lwFetchState = 4'b0100, lwWriteState = 4'b0101, swFetchState = 4'b0110, swWriteState = 4'b0111, updatePCState = 4'b1000;
  // imm_select
  parameter sel_imm5ZE = 3'b000, sel_imm15SE = 3'b001, sel_imm15ZE = 3'b010, sel_imm20SE = 3'b011, sel_imm14SE = 3'b100, sel_imm24SE = 3'b101;
  // writeback_select
  parameter sel_aluResult = 2'b00, sel_DMout = 2'b01, sel_regData = 2'b10; 
  // alu_scr_select1, alu_scr_select2
  parameter sel_reg = 2'b00, sel_imm = 2'b01, sel_addr = 2'b10;
     
  assign IM_address = PC;

  always @(posedge clock) begin
    if(reset || (present_instruction == 0))
      current_state = stopState;
    else
      current_state = next_state;
  end

  always @(current_state)
  begin
    case(current_state)
    stopState : begin
      next_state = fetchState;
      enable_pc_set = 0;
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
      enable_pc_set = 0;
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
      enable_pc_set = 0;
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
      enable_pc_set = 0;
      if ((opcode == TYPE_LS && sub_opcode_8bit == LW) || (opcode == LWI)) begin
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
      enable_pc_set = 0;
      if ((opcode == TYPE_LS && sub_opcode_8bit == LW) || (opcode == LWI)) begin
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
      enable_pc_set = 0;
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
      end else if ((opcode == TYPE_LS && sub_opcode_8bit == SW) || (opcode == SWI))begin
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
      enable_pc_set = 0;
      if ((opcode == TYPE_LS && sub_opcode_8bit == SW) || (opcode == SWI))begin
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
      next_state = updatePCState;
      enable_pc_set = 0;
      if ((opcode == TYPE_LS && sub_opcode_8bit == SW) || (opcode == SWI)) begin
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
    updatePCState : begin
      next_state = stopState;
      if ((opcode == BEQ) || (opcode == J)) begin
        enable_pc_set = 1;
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
        enable_pc_set = 0;
        enable_im = 0;
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
    default: begin
        next_state = stopState;
        enable_pc_set = 0;
        enable_im = 0;
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
    endcase
  end

  always @ (opcode or sub_opcode_5bit or sub_opcode_8bit) begin
    case(opcode)
      TYPE_BASIC : begin
               if (sub_opcode_5bit == SRLI | sub_opcode_5bit == SLLI | sub_opcode_5bit == ROTRI) begin
                    imm_select = sel_imm5ZE; 
                    alu_scr_select1 = sel_reg;
                    alu_scr_select2 = sel_imm;
                    writeback_select = sel_aluResult;
                 end
                 else begin
                    imm_select = sel_imm5ZE; 
                    alu_scr_select1 = sel_reg;
                    alu_scr_select2 = sel_reg;
                    writeback_select = sel_aluResult;
               end
               end
      ADDI : begin
               imm_select = sel_imm15SE;
               alu_scr_select1 = sel_reg;
               alu_scr_select2 = sel_imm;
               writeback_select = sel_aluResult;
             end
      ORI  : begin
               imm_select = sel_imm15ZE;
               alu_scr_select1 = sel_reg;
               alu_scr_select2 = sel_imm;
               writeback_select = sel_aluResult;
             end
      XORI : begin
               imm_select = sel_imm15ZE;
               alu_scr_select1 = sel_reg;
               alu_scr_select2 = sel_imm;
               writeback_select = sel_aluResult;
             end
      LWI  : begin
               imm_select = sel_imm15ZE;
               alu_scr_select1 = sel_reg;
               alu_scr_select2 = sel_imm;
               writeback_select = sel_DMout;
             end
      SWI  : begin
               imm_select = sel_imm15ZE;
               alu_scr_select1 = sel_reg;
               alu_scr_select2 = sel_imm;
               writeback_select = sel_regData;
             end
      MOVI : begin
               imm_select = sel_imm20SE;
               alu_scr_select1 = sel_imm;
               alu_scr_select2 = sel_imm;
               writeback_select = sel_aluResult;
             end
      BEQ  : begin
               imm_select = sel_imm14SE;
               alu_scr_select1 = sel_reg; // FIXME
               alu_scr_select2 = sel_reg; // FIXME
               writeback_select = sel_aluResult;
             end
      J    : begin
               imm_select = sel_imm24SE;
               alu_scr_select1 = sel_reg; // FIXME
               alu_scr_select2 = sel_reg; // FIXME
               writeback_select = sel_aluResult;
             end
      TYPE_LS : case (sub_opcode_8bit)
                  LW : begin
                          imm_select = sel_imm5ZE;
                          alu_scr_select1 = sel_reg;
                          alu_scr_select2 = sel_reg;
                          writeback_select = sel_DMout;
                       end
                  SW : begin
                          imm_select = sel_imm5ZE; 
                          alu_scr_select1 = sel_reg;
                          alu_scr_select2 = sel_reg;
                          writeback_select = sel_regData;
                       end
                endcase
      default : begin 
                imm_select = sel_imm5ZE; 
                alu_scr_select1 = sel_reg;
                alu_scr_select2 = sel_reg;
                writeback_select = sel_aluResult;
               end
    endcase
  end

  always @ (PC) begin
    if(PC == 0) begin
      present_instruction <= 0;
    end else begin
      present_instruction <= ir;
    end
//    $display("PC:%d, present_instruction:%b", PC, present_instruction);
  end

  always @ (reset or present_instruction) begin
    if (reset) begin
      Ins_cnt = 0;
    end else begin
      if (present_instruction)
          Ins_cnt = Ins_cnt + 1;
      else
          Ins_cnt = Ins_cnt;
    end
//    $display("PC:%d cnt:%d", IM_address, Ins_cnt);
  end

  always @ (reset, PC, current_state) begin
    //$display("PC: %d, total_ir:%d, Ins_cnt:%d", PC, total_ir, Ins_cnt);
    if (reset) begin
        exe_ir_done = 0;
    end else begin
      if ((((PC - im_start) >> 2) >= total_ir) && (current_state == swWriteState))
        exe_ir_done = 1;
      else
        exe_ir_done = exe_ir_done;
    end
//    $display("total_ir:%d, Ins_cnt:%d", total_ir, Ins_cnt);
  end


endmodule

