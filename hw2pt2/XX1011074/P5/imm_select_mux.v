module imm_select_mux(imm_out, imm_5bit, imm_15bit, imm_20bit, imm_14bit, imm_24bit, imm_select);

  parameter DataSize = 32;
  parameter imm5bitZE = 3'b000, imm15bitSE = 3'b001, imm15bitZE = 3'b010, imm20bitSE = 3'b011, imm14bitSE = 3'b100, imm24bitSE = 3'b101;

  input [4:0]imm_5bit;
  input [14:0]imm_15bit;
  input [19:0]imm_20bit;
  input [13:0]imm_14bit;
  input [23:0]imm_24bit;
  input [2:0]imm_select;
  
  output [DataSize-1:0]imm_out;
  
  reg [DataSize-1:0]imm_out;
  integer i;

  always @ (imm_5bit or imm_15bit or imm_20bit or imm_select) begin
    case (imm_select)
      imm5bitZE: begin
        imm_out = imm_5bit;
      end
      imm14bitSE: begin
        for (i = 31; i > 13; i = i-1)
          imm_out[i] = imm_14bit[13];
        imm_out[13:0] = imm_14bit;
      end
      imm15bitSE: begin
        for (i = 31; i > 14; i = i-1)
          imm_out[i] = imm_15bit[14];
        imm_out[14:0] = imm_15bit;
      end
      imm15bitZE: begin
        imm_out = imm_15bit;
      end
      imm20bitSE: begin
        for (i = 31; i > 19; i = i-1)
          imm_out[i] = imm_20bit[19];
        imm_out[19:0] = imm_20bit;
      end
      imm24bitSE: begin
        for (i = 31; i > 23; i = i-1)
          imm_out[i] = imm_24bit[23];
        imm_out[23:0] = imm_24bit;
      end
      default: imm_out = 32'b0;
    endcase
  end
endmodule
