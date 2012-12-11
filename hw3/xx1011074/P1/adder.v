module adder(o_result, i_src1, i_src2);

  parameter data_size = 32;

  input  [data_size-1:0]i_src1;
  input  [data_size-1:0]i_src2;

  output [data_size-1:0]o_result;
  reg    [data_size-1:0]o_result;

  always @ (*) begin
    o_result = i_src1 + i_src2;
  end

endmodule
