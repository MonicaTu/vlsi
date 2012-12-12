module sign_extend_5to32(o_data, i_data);

  input	 [4:0] i_data;
  
  output [31:0]o_data;
  reg	   [31:0]o_data;
  
  assign o_data = {(31-5){{i_data[5]}}, i_data};
	
endmodule
