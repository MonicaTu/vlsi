module alu32(alu_result,alu_overflow,scr1,scr2,opcode,sub_opcode_5bit, enable_execute,reset);
  parameter TYPE_BASIC=6'b100000;
  parameter NOP=5'b01001, ADD=5'b00000, SUB=5'b00001, AND=5'b00010,
            OR=5'b00100, XOR=5'b00011, SRLI=5'b01001, SLLI=5'b01000,
            ROTRI=5'b01011;

  parameter ADDI=6'b101000, ORI=6'b101100, XORI=6'b101011, LWI=6'b000010, SWI=6'b001010;

  parameter MOVI=6'b100010;

  parameter TYPE_LS=6'b011100;
  parameter LW=8'b00000010, SW=8'b00001010;

  output reg [31:0]alu_result;
  output reg alu_overflow;
  
  input [31:0]scr1,scr2;
  input [5:0]opcode;
  input [4:0]sub_opcode_5bit;
  input reset;
  input enable_execute;
  
  reg [63:0]rotate;
  reg a,b;
  
  always @ ( * )begin
    if(reset)begin
      alu_result=32'b0;
      alu_overflow=1'b0;
    end
    else if(enable_execute)begin
      case(opcode)
        TYPE_BASIC : case (sub_opcode_5bit)
                      ADD   : begin
                                {a,alu_result[30:0]}=scr1[30:0]+scr2[30:0];
                                {b,alu_result[31]}=scr1[31]+scr2[31]+a;
                              end
                      SUB   : begin
                                {a,alu_result[30:0]}=scr1[30:0]-scr2[30:0];
                                {b,alu_result[31]}=scr1[31]-scr2[31]-a;
                                alu_overflow=a^b;
                              end
                      AND   : begin
                                alu_overflow=1'b0;
                                alu_result=scr1&scr2;
                              end
                      OR    : begin
                                alu_overflow=1'b0;
                                alu_result=scr1|scr2;
                              end
                      XOR   : begin
                                alu_overflow=1'b0;
                                alu_result=scr1^scr2;
                              end
                      SRLI  : begin
                                if(scr2!=0)begin 
                                  alu_overflow=1'b0;
                                  alu_result=scr1>>scr2;
				                      end
                    //NOP   :
				                      else begin
                                  alu_result=32'b0;
                                  alu_overflow=1'b0;
                                end
                              end
                      SLLI  : begin
                                alu_overflow=1'b0;
                                alu_result=scr1<<scr2;
                              end
                      ROTRI : begin
                                alu_overflow=1'b0;
                                rotate={scr1,scr1}>>scr2;
                                alu_result=rotate[31:0];
                              end
                      default : begin
                                  alu_overflow=1'b0;
                                  alu_result=32'b0;
                              end
                    endcase
        ADDI       : begin
                       {a,alu_result[30:0]}=scr1[30:0]+scr2[30:0];
                       {b,alu_result[31]}=scr1[31]+scr2[31]+a;
                       alu_overflow=a^b;
                     end
        ORI        : begin
                       alu_overflow=1'b0;
                       alu_result=scr1|scr2;
                     end
        XORI       : begin
                       alu_overflow=1'b0;
                       alu_result=scr1^scr2;
                     end
        MOVI       : begin
                       alu_overflow=1'b0;
                       alu_result[31:0]=scr2[31:0];
                     end
        default    : begin
                         alu_overflow=1'b0;
                         alu_result=32'b0;
                     end
      endcase
    end
//    else begin
//      alu_result=32'b0;
//      alu_overflow=1'b0;
//    end
  end
endmodule                                                                                                                                                                                                                                                                              
