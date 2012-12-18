module sign_extend_20to32(o_data, i_data);

  input	 [19:0] i_data;
  
  output [31:0]o_data;
//  reg	   [31:0]o_data;
  
  assign o_data = {{(31-19){i_data[19]}}, i_data};
	
endmodule
