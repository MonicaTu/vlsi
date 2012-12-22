/* =============================================================================
 *
 * Name           : EX_MEM.v
 * Author         : Hakki Caner Kirmizi
 * Date           : 2010-5-17
 * Description    : A module that implements the so-called EX-MEM (execute -
 *					memory access) pipelined register.
 *
 * =============================================================================
*/

module EX_MEM(
	clk,
	rst,
	RegWrite_in,	// WB
	MemtoReg_in,	// WB
	MemRead_in,		// M
	MemWrite_in,	// M
	ALUData_in,
	MemWriteData_in,
	WBregister_in,
	RegWrite_out,	// WB
	MemtoReg_out,	// WB
	MemRead_out,	// M
	MemWrite_out,
	ALUData_out,
	MemWriteData_out,
	WBregister_out
);

// Input Ports
input			clk;
input			rst;
input			RegWrite_in;
input			MemtoReg_in;
input			MemRead_in;
input			MemWrite_in;
input	[31:0]	ALUData_in;
input	[31:0]	MemWriteData_in;
input	[4:0]	WBregister_in;

// Output Ports
output			RegWrite_out;
output			MemtoReg_out;
output			MemRead_out;
output			MemWrite_out;
output	[31:0]	ALUData_out;
output	[31:0]	MemWriteData_out;
output	[4:0]	WBregister_out;

// Registers
reg			RegWrite_out;
reg			MemtoReg_out;
reg			MemRead_out;
reg			MemWrite_out;
reg	[31:0]	ALUData_out;
reg	[31:0]	MemWriteData_out;
reg	[4:0]	WBregister_out;

// Procedure
always @(posedge clk or rst) begin
	if(rst) begin
		RegWrite_out	<= 1'b0;
		MemtoReg_out	<= 1'b0;
		MemRead_out		<= 1'b0;
		MemWrite_out	<= 1'b0;
		ALUData_out		<= 32'b0;
		MemWriteData_out<= 32'b0;
		WBregister_out	<= 5'b0;		
	end
	else begin
		RegWrite_out	<= RegWrite_in;
		MemtoReg_out	<= MemtoReg_in;
		MemRead_out		<= MemRead_in;
		MemWrite_out	<= MemWrite_in;
		ALUData_out		<= ALUData_in;
		MemWriteData_out<= MemWriteData_in;
		WBregister_out	<= WBregister_in;	
	end
end

endmodule
