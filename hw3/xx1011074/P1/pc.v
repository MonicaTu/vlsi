module pc(o_pc, i_pc, rst, clk);
  
  input rst;
  input clk;
  input [31:0]i_pc;

  output [31:0]o_pc;
  reg    [31:0]o_pc;

  always @ (posedge clk or rst) begin
    if (rst)
      o_pc = 0;
    else
      o_pc = i_pc;
  end

endmodule
