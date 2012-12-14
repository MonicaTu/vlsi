module equal_32bit(o_result, i_data1, i_data2);

  input [31:0] i_data1;
  input [31:0] i_data2;

  output o_result;
//  reg    o_result;
  
  assign o_result = (i_data1 == i_data2) ? 1 : 0 ;

endmodule
