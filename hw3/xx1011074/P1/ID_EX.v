/* =============================================================================
 *
 * Name           : ID_EX.v
 * Author         : Hakki Caner Kirmizi
 * Date           : 2010-5-17
 * Description    : A module that implements the so-called ID-EX (instruction
 *					decode - execute) pipelined register.
 *
 * =============================================================================
*/

module ID_EX (
	clk,
	rst,
	RegWrite_in,
	MemtoReg_in,
	MemRead_in,
	MemWrite_in,
	ALUSrc_in,
	ALUOp_in,
	RegDst_in,
	RegRsData_in,
	RegRtData_in,
	Immediate_in,
	instr_Rs_addr_in,
	instr_Rt_addr_in,
	instr_Rd_addr_in,
	RegWrite_out,
	MemtoReg_out,
	MemRead_out,
	MemWrite_out,
	ALUSrc_out,
	ALUOp_out,
	RegDst_out,
	RegRsData_out,
	RegRtData_out,
	Immediate_out,
	instr_Rs_addr_out,
	instr_Rt_addr_out,
	instr_Rd_addr_out
);

// Input Ports
input			clk;
input			rst;
input			RegWrite_in;
input			MemtoReg_in;
input			MemRead_in;
input			MemWrite_in;
input			ALUSrc_in;
input	[2:0]	ALUOp_in;
input			RegDst_in;
input	[31:0]	RegRsData_in;
input	[31:0]	RegRtData_in;
input	[31:0]	Immediate_in;
input	[4:0]	instr_Rs_addr_in;
input	[4:0]	instr_Rt_addr_in;
input	[4:0]	instr_Rd_addr_in;

// Output Ports
output			RegWrite_out;
output			MemtoReg_out;
output			MemRead_out;
output			MemWrite_out;
output			ALUSrc_out;
output	[2:0]	ALUOp_out;
output			RegDst_out;
output	[31:0]	RegRsData_out;
output	[31:0]	RegRtData_out;
output	[31:0]	Immediate_out;
output	[4:0]	instr_Rs_addr_out;
output	[4:0]	instr_Rt_addr_out;
output	[4:0]	instr_Rd_addr_out;

// Registers
reg			RegWrite_out;
reg			MemtoReg_out;
reg			MemRead_out;
reg			MemWrite_out;
reg			ALUSrc_out;
reg	[2:0]	ALUOp_out;
reg			RegDst_out;
reg	[31:0]	RegRsData_out;
reg	[31:0]	RegRtData_out;
reg	[31:0]	Immediate_out;
reg	[4:0]	instr_Rs_addr_out;
reg	[4:0]	instr_Rt_addr_out;
reg	[4:0]	instr_Rd_addr_out;

// Procedure
always @(posedge clk or negedge rst) begin
	if(~rst) begin
		RegWrite_out	<= 1'b0;
		MemtoReg_out	<= 1'b0;
		MemRead_out		<= 1'b0;
		MemWrite_out	<= 1'b0;
		ALUSrc_out		<= 1'b0;
		ALUOp_out		<= 3'b0;
		RegDst_out		<= 1'b0;
		RegRsData_out	<= 32'b0;
		RegRtData_out	<= 32'b0;
		Immediate_out	<= 32'b0;
		instr_Rs_addr_out	<= 5'b0;
		instr_Rt_addr_out	<= 5'b0;
		instr_Rd_addr_out	<= 5'b0;
	end
	else begin
		RegWrite_out	<= RegWrite_in;
		MemtoReg_out	<= MemtoReg_in;
		MemRead_out		<= MemRead_in;
		MemWrite_out	<= MemWrite_in;
		ALUSrc_out		<= ALUSrc_in;
		ALUOp_out		<= ALUOp_in;
		RegDst_out		<= RegDst_in;
		RegRsData_out	<= RegRsData_in;
		RegRtData_out	<= RegRtData_in;
		Immediate_out	<= Immediate_in;
		instr_Rs_addr_out	<= instr_Rs_addr_in;
		instr_Rt_addr_out	<= instr_Rt_addr_in;
		instr_Rd_addr_out	<= instr_Rd_addr_in;		
	end
end

endmodule