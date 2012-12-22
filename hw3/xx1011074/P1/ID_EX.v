module ID_EX (
	clk,
	rst,
  RegWrite_in,
  MemtoReg_in,
  MemRead_in,
  MemWrite_in,
  ALUSrc_in,
  ALUOp_in,
  ALUSubOp_in,
  ALUsv_in,
  RegDst_in,
  address1_data_in,
  address2_data_in,
  addressT_data_in,
  Immediate_in,
  address1_in,
  address2_in,
  addressT_in,
	RegWrite_out,
	MemtoReg_out,
	MemRead_out,
	MemWrite_out,
	ALUSrc_out,
	ALUOp_out,
	ALUSubOp_out,
  ALUsv_out,
	RegDst_out,
	address1_data_out,
	address2_data_out,
	addressT_data_out,
	Immediate_out,
	address1_out,
	address2_out,
	addressT_out
);

// Input Ports
input			clk;
input			rst;
input			RegWrite_in;
input			MemtoReg_in;
input			MemRead_in;
input			MemWrite_in;
input			ALUSrc_in;
input	[5:0]	ALUOp_in;
input	[4:0]	ALUSubOp_in;
input	[1:0]	ALUsv_in;
input			RegDst_in;
input	[31:0]	address1_data_in;
input	[31:0]	address2_data_in;
input	[31:0]	addressT_data_in;
input	[31:0]	Immediate_in;
input	[4:0]	address1_in;
input	[4:0]	address2_in;
input	[4:0]	addressT_in;

// Output Ports
output			RegWrite_out;
output			MemtoReg_out;
output			MemRead_out;
output			MemWrite_out;
output			ALUSrc_out;
output	[5:0]	ALUOp_out;
output	[4:0]	ALUSubOp_out;
output	[1:0]	ALUsv_out;
output			RegDst_out;
output	[31:0]	address1_data_out;
output	[31:0]	address2_data_out;
output	[31:0]	addressT_data_out;
output	[31:0]	Immediate_out;
output	[4:0]	address1_out;
output	[4:0]	address2_out;
output	[4:0]	addressT_out;

// Registers
reg			RegWrite_out;
reg			MemtoReg_out;
reg			MemRead_out;
reg			MemWrite_out;
reg			ALUSrc_out;
reg	[5:0]	ALUOp_out;
reg	[4:0]	ALUSubOp_out;
reg	[1:0]	ALUsv_out;
reg			RegDst_out;
reg	[31:0]	address1_data_out;
reg	[31:0]	address2_data_out;
reg	[31:0]	addressT_data_out;
reg	[31:0]	Immediate_out;
reg	[4:0]	address1_out;
reg	[4:0]	address2_out;
reg	[4:0]	addressT_out;

// Procedure
always @(posedge clk or rst) begin
	if(rst) begin
		RegWrite_out	<= 1'b0;
		MemtoReg_out	<= 1'b0;
		MemRead_out		<= 1'b0;
		MemWrite_out	<= 1'b0;
		ALUSrc_out		<= 1'b0;
		ALUOp_out		  <= 6'b0;
		ALUSubOp_out	<= 5'b0;
		ALUsv_out	    <= 2'b0;
		RegDst_out		<= 1'b0;
		address1_data_out	<= 32'b0;
		address2_data_out	<= 32'b0;
		Immediate_out	<= 32'b0;
    address1_out	<= 5'b0;
    address2_out	<= 5'b0;
    addressT_out	<= 5'b0;
	end
	else begin
		RegWrite_out	<= RegWrite_in;
		MemtoReg_out	<= MemtoReg_in;
		MemRead_out		<= MemRead_in;
		MemWrite_out	<= MemWrite_in;
		ALUSrc_out		<= ALUSrc_in;
		ALUOp_out		  <= ALUOp_in;
		ALUSubOp_out  <= ALUSubOp_in;
		ALUsv_out     <= ALUsv_in;
		RegDst_out		<= RegDst_in;
		address1_data_out	<= address1_data_in;
		address2_data_out	<= address2_data_in;
		addressT_data_out	<= addressT_data_in;
		Immediate_out	<= Immediate_in;
    address1_out	<= address1_in;
    address2_out	<= address2_in;
    addressT_out	<= addressT_in;		
	end
end

endmodule
