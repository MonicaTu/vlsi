module mux3to1_32bit (o_data, i_data0, i_data1, i_data2, i_select);

  input [31:0]i_data0;
  input [31:0]i_data1;
  input [31:0]i_data2;
  input [1:0] i_select;

  output [31:0]o_data;
  reg    [31:0]o_data;

  case (i_select) begin
    2'b00   : o_data = i_data0;
    2'b01   : o_data = i_data1;
    2'b10   : o_data = i_data2;
    default : o_data = 0;
  endcase

endmodule
