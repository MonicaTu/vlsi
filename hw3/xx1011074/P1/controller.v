//module Control(RegDst, o_branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, opcode );
module controller(o_branch, o_jump, i_opcode, rst);
  
   input rst;
   input [5:0]i_opcode;
//   output 	RegDst, o_branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
//   output [2:0] ALUOp;
   output o_branch;
   output o_jump;
   
   // internal
   reg [10:0]	out;
   
   assign o_jump = out[10];
//   assign RegDst = out[9];
   assign o_branch = out[8];
//   assign MemRead = out[7];
//   assign MemtoReg = out[6];
//   assign MemWrite = out[5];
//   assign ALUSrc = out[4];
//   assign RegWrite = out[3];
//   assign ALUOp = out[2:0];
   
   always @(i_opcode)
     if (rst) // FIXME
        out = 11'b0;
     else begin
     case(i_opcode)
      6'b100000: //type-4
        out = 11'b01000001100;
      6'b101000: //ADDI
        out = 11'b00000011010;
      6'b101100: //ORI
        out = 11'b00000011001;
      6'b001010: //SW(I)
        out = 11'b00000110010;
      6'b000010: //LW(I)
        out = 11'b00011011010;
      6'b100110: //BEQ
        out = 11'b00100000011;
      6'b100100: //J
        out = 11'b10100000011;
     endcase // case (opcode)
     end 
endmodule
