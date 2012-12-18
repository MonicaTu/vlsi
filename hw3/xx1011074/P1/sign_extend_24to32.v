module sign_extend_24to32(o_data, i_data);

  input	 [23:0] i_data;
  
  output [31:0]o_data;
//  reg	   [31:0]o_data;
  
  assign o_data = {{(31-23){i_data[23]}}, i_data};
	
endmodule
