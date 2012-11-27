module alu_scr_mux(scr_out, imm, data, addr, alu_scr_select);
  
    parameter sel_reg = 2'b00, sel_imm = 2'b01, sel_addr = 2'b10;

    parameter DataSize = 32;
    parameter AddrSize = 5;

    input [DataSize-1:0]imm;
    input [DataSize-1:0]data;
    input [AddrSize-1:0]addr;
    input [1:0]alu_scr_select;
    
    output [DataSize-1:0]scr_out;

    reg [DataSize-1:0]scr_out;

    always @(imm or data or addr or alu_scr_select) begin
      case (alu_scr_select)
        sel_reg  : begin 
                    scr_out = data;
                   end
        sel_imm  : begin 
                    scr_out = imm;
                   end
        sel_addr : begin 
                    scr_out = addr;
                   end
        default  : begin 
                    scr_out = data;
                   end
      endcase
    end
endmodule
