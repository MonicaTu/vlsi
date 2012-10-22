//concroller
`define OPCODE ir[30:25]
`define SUBOPCODE ir[4:0]
`define SRLI 5'b01001
`define SLLI 5'b01000
`define ROTRI 5'b01011

module controller(enable_execute, enable_fetch, enable_writeback, opcode, sub_opcode, mux4to1_select, writeback_select, imm_reg_select, clock, reset, PC, ir);
  input clock;
  input reset;
  input [31:0] PC;
  input [31:0] ir;

  output reg enable_execute;
  output reg enable_fetch;
  output reg enable_writeback;
  output [5:0] opcode;
  output [4:0] sub_opcode;
  output reg mux4to1_select;
  output reg writeback_select;
  output reg imm_reg_select;

  wire [5:0] opcode = ir[30:25];
  wire [4:0] sub_opcode = ir[4:0];
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [31:0] present_instruction;

  parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 =  2'b11;

  always @(posedge clock)
  begin
    if(reset)
      current_state = S0;
    else
      current_state = next_state;
  end

  always @(current_state)
  begin
    case(current_state)
    S0 : begin
      next_state = S1;
      enable_fetch = 0;
      enable_execute = 0;
      enable_writeback = 0;
      mux4to1_select = 0;
      writeback_select = 0;
      imm_reg_select = 0;
    end
    S1 : begin
      next_state = S2;
      enable_fetch = 1;
      enable_execute = 0;
      enable_writeback = 0;
      writeback_select = 0; 
      mux4to1_select = 0;
      if (imm_reg_select == 0) begin
        // read from register
      end
      else
        // read from imm
        begin
            case (mux4to1_select)
            00: begin
                // ZE
            end
            01: begin
                // SE
            end
            10: begin
                // ZE
            end
            11: begin
                // SE
            end
            endcase
        end
    end
    S2 : begin
      next_state = S3;
      enable_fetch = 0;
      enable_execute = 1;
      enable_writeback = 0;
      mux4to1_select = 0;
      writeback_select = 0;
      imm_reg_select = 0;
    end
    S3 : begin
      next_state = S0;
      enable_fetch = 0;
      enable_execute = 0;
      enable_writeback = 1;
      mux4to1_select = 0;
      if (writeback_select == 0) begin
        // imm_data; data = ir[] 
      end
      else
        // alu_result; data = ir[]
      if (imm_reg_select == 0) begin
        // read_data; data = ir[]
      end
      else
        begin
            case (mux4to1_select)
            00: begin
                // ZE
            end
            01: begin
                // SE
            end
            10: begin
                // ZE
            end
            11: begin
                // SE
            end
            endcase
        end
    end
    endcase
  end

  always @(posedge enable_fetch)
  begin
    if(PC == 0)
      present_instruction = 0;
    else
      present_instruction = ir;
  end

endmodule

