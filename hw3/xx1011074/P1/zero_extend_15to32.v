module zero_extend_15to32(o_data, i_data);

  input	 [14:0] i_data;
  
  output [31:0]o_data;
//  reg	   [31:0]o_data;
  
  assign o_data = {{(31-14){0}}, i_data};
	
endmodule
