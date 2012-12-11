module pc(o_pc, i_pc, i_rst, i_clk);
  
  parameter data_size = 32;

  input i_rst;
  input i_clk;
  input [data_size-1:0]o_pc;

  output [data_size-1:0]i_pc;
  reg    [data_size-1:0]i_pc;

  always @ (*) begin
    if (i_rst)
      o_pc = 0;
    else
      o_pc = i_pc;
  end

endmodule
