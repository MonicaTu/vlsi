module mux4to1_select_mux(mux4to1_out, imm_5bit, imm_15bit, imm_20bit, mux4to1_select);

  parameter DataSize = 32;
  parameter imm5bitZE = 2'b00, imm15bitSE = 2'b01, imm15bitZE = 2'b10, imm20bitSE =  2'b11;

  input [4:0]imm_5bit;
  input [14:0]imm_15bit;
  input [19:0]imm_20bit;
  input [1:0]mux4to1_select;
  output reg [DataSize-1:0]mux4to1_out;
  
  integer i;

  always @ (imm_5bit or imm_15bit or imm_20bit or mux4to1_select) begin
    case (mux4to1_select)
      imm5bitZE: begin
        mux4to1_out <= imm_5bit;
      end
      imm15bitSE: begin
        for (i = 31; i > 14; i = i-1)
          mux4to1_out[i] = imm_15bit[14];
        mux4to1_out[14:0] = imm_15bit;
      end
      imm15bitZE: begin
        mux4to1_out <= imm_15bit;
      end
      imm20bitSE: begin
        for (i = 31; i > 19; i = i-1)
          mux4to1_out[i] = imm_20bit[19];
        mux4to1_out[19:0] = imm_20bit;
      end
      default: mux4to1_out <= 32'bx;
    endcase
  end
endmodule
