module Control(ImmSelect, ALUOp, ALUSubOp, RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, opcode, sub_opcode);
   
  input [5:0]opcode;
  input [4:0]sub_opcode;

  output [3:0]ImmSelect;
  output [5:0]ALUOp;
  output [4:0]ALUSubOp;
  output RegDst;    // Rb = scr2
  output Branch;    //
  output MemRead;   // read Mem 
  output MemtoReg;  // from Mem to Rt
  output MemWrite;  // write to Mem
  output ALUSrc;    // from ALU
  output RegWrite;  // write to Reg 

  // internal
  reg [6:0]out;
  reg [3:0]ImmSelect;
  
  assign ALUOp = opcode;
  assign ALUSubOp = sub_opcode;
  assign RegDst = out[6];
  assign Branch = out[5];
  assign MemRead = out[4];
  assign MemtoReg = out[3];
  assign MemWrite = out[2];
  assign ALUSrc = out[1];
  assign RegWrite = out[0];
  
  // {RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite}
  always @ (opcode) begin
    case (opcode)
      6'b100000:    // ADD/SUB/AND/OR/XOR
        case (sub_opcode)
          5'b01001: begin// SRLI, FIXME: NOP
            ImmSelect = 3'b001; // imm5
            out = 7'b0000001;
          end
          5'b01000: begin// SLLI
            ImmSelect = 3'b001; // imm5
            out = 7'b0000001;
          end
          5'b01011: begin// ROTRI
            ImmSelect = 3'b001; // imm5
            out = 7'b0000001;
          end
          default: begin
            ImmSelect = 3'b000; // imm0
            out = 7'b1000001;
          end
        endcase
      6'b101000: begin   // ADDI
        ImmSelect = 3'b010; // imm15
        out = 7'b0000001;
        end
      6'b101100: begin   // ORI
        ImmSelect = 3'b010; // imm15
        out = 7'b0000001;
        end
      6'b101011: begin   // XORI
        ImmSelect = 3'b010; // imm15
        out = 7'b0000001;
        end
      6'b000010: begin   // LWI
        ImmSelect = 3'b010; // imm15
        out = 7'b0011011;
        end
      6'b001010: begin   // SWI
        ImmSelect = 3'b010; // imm15
        out = 7'b0000110;
        end
      6'b100010: begin   // MOVI
        ImmSelect = 3'b011; // imm20
        out = 7'b0000001;
        end
      6'b011100:
        case (sub_opcode)
          5'b00010: begin // LW
            ImmSelect = 3'b000; // imm0
            out = 7'b0011011;
            end
          5'b01010: begin // SW
            ImmSelect = 3'b000; // imm0
            out = 7'b0000110;
            end
        endcase
      6'b100110: begin   // BEQ
        ImmSelect = 3'b100; // imm14
        out = 7'b0100000;
        end
      6'b100100: begin   // J
        ImmSelect = 3'b101; // imm24
        out = 7'b0100000;
        end
    endcase
  end
endmodule
