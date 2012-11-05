`define IR_CYCLE 'd4     // 4 clock per ir cycle
`define TICK_SIZE 'd128  // 128 bits
`define MEM_SIZE 'd10    // 10 bits
`define IR_SIZE 'd32     // 32 bits
`define IR_SIZE_BYTE 'd4 // 32 bits = 4 bytes

module pc_tick(input clock, reset, output reg [`MEM_SIZE-1:0] pc, output reg [`TICK_SIZE-1:0] tick);

  reg [9:0] internal_pc;

  always @(negedge clock) begin
    if (reset) begin
      $display("reset");
      internal_pc = 0;
      pc = 0;
      tick = 0;
    end
    else begin
      tick = tick + 1;
      if ((tick % `IR_CYCLE) == 0) begin
        internal_pc = internal_pc + `IR_SIZE; 
      end
      else begin
        internal_pc = internal_pc;
      end
      $display("pc: %d; internal_pc: %d", pc, internal_pc);
      pc = internal_pc >> 5; // internal_pc / 32 
//      $display("pc: %d; internal_pc: %d", pc, internal_pc);
    end
  end

endmodule
