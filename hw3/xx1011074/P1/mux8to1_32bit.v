module mux8to1_32bit (o_data, i_data0, i_data1, i_data2, i_data3, i_data4, i_data5, i_data6, i_data7, i_select);

  input [31:0]i_data0;
  input [31:0]i_data1;
  input [31:0]i_data2;
  input [31:0]i_data3;
  input [31:0]i_data4;
  input [31:0]i_data5;
  input [31:0]i_data6;
  input [31:0]i_data7;
  input [2:0] i_select;

  output [31:0]o_data;
  reg    [31:0]o_data;

  case (i_select) begin
    3'b000  : o_data = i_data0;
    3'b001  : o_data = i_data1;
    3'b010  : o_data = i_data2;
    3'b011  : o_data = i_data3;
    3'b100  : o_data = i_data4;
    3'b101  : o_data = i_data5;
    3'b110  : o_data = i_data6;
    3'b111  : o_data = i_data7;
  endcase

endmodule
