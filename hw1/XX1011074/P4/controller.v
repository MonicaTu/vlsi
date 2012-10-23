//concroller
`define OPCODE ir[30:25]
`define SUBOPCODE ir[4:0]
`define SRLI 5'b01001
`define SLLI 5'b01000
`define ROTRI 5'b01011

module controller(enable_execute, enable_fetch, enable_writeback, opcode, sub_opcode, mux4to1_select, writeback_select, imm_reg_select, clock, reset, PC, ir);
  parameter DataSize = 32;
  parameter AddrSize = 5;

  /* top */
  input clock;
  input reset;
  input [DataSize-1:0] PC;
  input [DataSize-1:0] ir;

  output reg enable_execute;
  output reg enable_fetch;
  output reg enable_writeback;
  output [5:0] opcode;
  output [4:0] sub_opcode;
  output reg [1:0] mux4to1_select;
  output reg writeback_select;
  output reg imm_reg_select;
  
  /* module */
  //ALU
  wire [5:0] opcode = ir[30:25];
  wire [4:0] sub_opcode = ir[4:0];
  //register
  wire [AddrSize-1:0]read_address1 = ir[19:15];
  wire [AddrSize-1:0]read_address2 = ir[14:10];
  wire [AddrSize-1:0]write_address = ir[24:20];
  //imm_sel
  wire [4:0]imm_5bit = ir[14:10];
  wire [14:0]imm_15bit = ir[14:0];
  wire [19:0]imm_20bit = ir[19:0];

  /* others */
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [DataSize-1:0] present_instruction;

  parameter NOP=5'b01001,ADD=5'b00000,SUB=5'b00001,AND=5'b00010,
            OR=5'b00100,XOR=5'b00011,SRLI=5'b01001,SLLI=5'b01000,
            ROTRI=5'b01011;
  parameter stopState = 2'b00, fetchState = 2'b01, exeState = 2'b10, writeState =  2'b11;
  parameter imm5bitZE = 2'b00, imm15bitSE = 2'b01, imm15bitZE = 2'b10, imm20bitSE =  2'b11;
  parameter aluResult = 1'b0, scr2Out = 1'b1; 
  parameter regOut = 1'b0, immOut = 1'b1;

  always @(posedge clock)
  begin
    if(reset)
      current_state = stopState;
    else
      current_state = next_state;
  end

  always @(current_state)
  begin
    case(current_state)
    stopState : begin
      next_state = fetchState;
      enable_fetch = 0;
      enable_execute = 0;
      enable_writeback = 0;
      writeback_select = 0;
      imm_reg_select = 0;
    end
    fetchState : begin
      next_state = exeState;
      enable_fetch = 1;
      enable_execute = 0;
      enable_writeback = 0;
      case(opcode)
        6'b100000 : if (sub_opcode == SRLI | sub_opcode == SLLI | sub_opcode == ROTRI) begin
      			mux4to1_select = imm5bitZE; 
      			imm_reg_select = immOut;
	            end
        6'b101000 : begin
	              mux4to1_select = imm15bitSE;
		      imm_reg_select = immOut;
		    end
        6'b101100 : begin
		      mux4to1_select = imm15bitZE;
		      imm_reg_select = immOut;
		    end
        6'b101011 : begin
		      mux4to1_select = imm15bitZE;
		      imm_reg_select = immOut;
		    end
        6'b100010 : begin
      		      next_state = writeState; // MOVI
		      mux4to1_select = imm20bitSE;
		      imm_reg_select = immOut;
		    end
        default   : begin 
      		    mux4to1_select = imm5bitZE; 
      		    imm_reg_select = regOut;
      		    end
      endcase
      writeback_select = 0;
    end
    exeState : begin
      next_state = writeState;
      enable_fetch = 0;
      enable_execute = 1;
      enable_writeback = 0;
      writeback_select = 0;
      imm_reg_select = 0;
    end
    writeState : begin
      next_state = stopState;
      enable_fetch = 0;
      enable_execute = 0;
      enable_writeback = 1;
      writeback_select = (opcode == 6'b100010) ? scr2Out : aluResult;
      imm_reg_select = 0;
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

