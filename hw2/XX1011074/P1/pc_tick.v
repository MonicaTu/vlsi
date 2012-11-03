`define IR_CYCLE 'd4   // 4 clock per ir cycle
`define TICK_SIZE 128  // 128 bits
`define IR_SIZE 32     // 32 bits
`define IR_SIZE_BYTE 4 // 32 bits = 4 bytes

module pc_tick(input clock, reset, output reg [`IR_SIZE-1:0] pc, output reg [`TICK_SIZE-1:0] tick);

  always @(negedge clock) begin
    if (reset) begin
      pc = 0;
      tick = 0;
    end
    else begin
      tick = tick + 1;
      if ((tick % `IR_CYCLE) == 0) begin
        pc = pc + `IR_SIZE_BYTE;
      end
      else begin
        pc = pc;
      end
    end
  end

endmodule
