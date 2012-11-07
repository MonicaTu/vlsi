module alu12(alu_result, scr1, scr2, sv, opcode, sub_opcode_8bit, enable_execute, reset);
  parameter ADDI=6'b101000, ORI=6'b101100, XORI=6'b101011, LWI=6'b000010, SWI=6'b001010;

  parameter TYPE_LS=6'b011100;
  parameter LW=8'b00000010, SW=8'b00001010;

  output reg [11:0]alu_result;
  
  input [4:0]scr1,scr2;
  input [5:0]opcode;
  input [7:0]sub_opcode_8bit;
  input [1:0]sv;
  input reset;
  input enable_execute;
  
  reg a,b;
  
  always @ ( * )begin
    if(reset)begin
      alu_result=12'b0;
    end
    else if(enable_execute)begin
      case (opcode)
        LWI : begin
                alu_result=scr1+(scr2<<2);
//                $display("scr1: %h, scr2: %h", scr1, scr2);
//                $display("(LWI)alu_result: %b", alu_result);
              end
        SWI : begin
                alu_result=scr1+(scr2>>2);
//                $display("scr1: %h, scr2: %h", scr1, scr2);
//                $display("(SWI)alu_result: %b", alu_result);
              end
      endcase
      case (sub_opcode_8bit)
        LW : begin
              alu_result=scr1+(scr2<<sv);
//              $display("scr1: %h, scr2: %h, sv: %h", scr1, scr2, sv);
//              $display("(LW)alu_result: %b", alu_result);
             end
        SW : begin
              alu_result=scr1+(scr2>>sv);
//              $display("scr1: %h, scr2: %h, sv: %h", scr1, scr2, sv);
//              $display("(SW)alu_result: %b", alu_result);
             end
      endcase
    end
//    else begin
//      alu_result=12'b0;
//    end
  end
endmodule                                                                                                                                                                                                                                                                              
