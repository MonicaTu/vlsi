module IF_ID (o_pc, o_instruction, i_pc, i_instruction, rst, clk); 

  input clk;
  input rst;
  input [31:0]i_instruction;
  input [31:0]i_pc;

  output [31:0]o_instruction;
  output [31:0]o_pc;

  reg		 [31:0]o_instruction;
  reg		 [31:0]o_pc;

// Procedure
always @(posedge clk or rst) begin
	if (rst) begin
		o_pc <=  32'b0;
		o_instruction <= 32'b0;
	end else begin
		o_pc <= i_pc;
		o_instruction <= i_instruction;
	end
end

endmodule
