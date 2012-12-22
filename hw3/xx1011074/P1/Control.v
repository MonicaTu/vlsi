module Control(opcode, sub_opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
   
  input [5:0]opcode;
  input [4:0]sub_opcode;

  output RegDst;    // Rb = scr2
  output Branch;    //
  output MemRead;   // read Mem 
  output MemtoReg;  // from Mem to Rt
  output MemWrite;  // write to Mem
  output ALUSrc;    // from ALU
  output RegWrite;  // write to Reg 

  // internal
  reg [6:0]out;
  
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
        out = 7'b1000001;
        case (sub_opcode)
          5'b01001: // SRLI, FIXME: NOP
          5'b01000: // SLLI
          5'b01011: // ROTRI
            out = 7'b0000001;
        endcase
      6'b101000:    // ADDI
        out = 7'b0000001;
      6'b101100:    // ORI
        out = 7'b0000001;
      6'b101011:    // XORI
        out = 7'b0000001;
      6'b000010:    // LWI
        out = 7'b0011011;
      6'b001010:    // SWI
        out = 7'b0000110;
      6'b100010:    // MOVI
        out = 7'b0000001;
      6'b011100:
        case (sub_opcode)
          5'b00010: // LW
            out = 7'b0011011;
          5'b01010: // SW
            out = 7'b0000110;
        endcase
      6'b100110:    // BEQ
        out = 7'b0100000;
      6'b100100:    // J
        out = 7'b0100000;
    endcase
  end
endmodule
