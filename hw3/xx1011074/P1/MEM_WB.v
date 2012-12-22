/* =============================================================================
 *
 * Name           : MEM_WB.v
 * Author         : Hakki Caner Kirmizi
 * Date           : 2010-5-17
 * Description    : A module that implements the so-called MEM-WB (memory
 *					access - write back) pipelined register.
 *
 * =============================================================================
*/

module MEM_WB(
	clk,
	rst,
	RegWrite_in,	// WB
	MemtoReg_in,	// WB
	MemData_in,
	ALUData_in,
	WBregister_in,
	RegWrite_out,	// WB
	MemtoReg_out,	// WB
	MemData_out,
	ALUData_out,
	WBregister_out
);

// Input Ports
input			clk;
input			rst;
input			RegWrite_in;
input			MemtoReg_in;
input	[31:0]	MemData_in;
input	[31:0]	ALUData_in;
input	[4:0]	WBregister_in;

// Output Ports
output			RegWrite_out;
output			MemtoReg_out;
output	[31:0]	MemData_out;
output	[31:0]	ALUData_out;
output	[4:0]	WBregister_out;

// Registers
reg			RegWrite_out;
reg			MemtoReg_out;
reg	[31:0]	MemData_out;
reg	[31:0]	ALUData_out;
reg	[4:0]	WBregister_out;

// Procedure
always @(posedge clk or rst) begin
	if(rst) begin
		RegWrite_out	<= 1'b0;
		MemtoReg_out	<= 1'b0;	
		MemData_out		<= 32'b0;
		ALUData_out		<= 32'b0;
		WBregister_out	<= 5'b0;
	end
	else begin
		RegWrite_out	<= RegWrite_in;
		MemtoReg_out	<= MemtoReg_in;	
		MemData_out		<= MemData_in;
		ALUData_out		<= ALUData_in;
		WBregister_out	<= WBregister_in;	
	end
end

endmodule
