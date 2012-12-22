module mux3to1_32bit (o_data, i_data0, i_data1, i_data2, i_select);

  input [31:0]i_data0;
  input [31:0]i_data1;
  input [31:0]i_data2;
  input [1:0]i_select;
  
  output [31:0]o_data;
  
  assign o_data = (i_select[1]) ? i_data2 : ((i_select[0]) ? i_data1 : i_data0);

endmodule
