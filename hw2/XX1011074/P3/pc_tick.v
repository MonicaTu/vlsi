`define TICK_SIZE    ('d128) // 128 bits
`define MEM_SIZE     ('d10)  // 10 bits
`define IR_SIZE      ('d32)  // 32 bits
`define IR_SIZE_BYTE ('d4)   // 32 bits = 4 bytes
`define IR_CYCLE     ('d8)

module pc_tick(pc, cycle_cnt, reset, clock);

  // interface
  input clock;
  input reset;
  output [`MEM_SIZE-1:0] pc;
  output [`TICK_SIZE-1:0] cycle_cnt;

  reg [`MEM_SIZE-1:0] pc;
  reg [`TICK_SIZE-1:0] cycle_cnt;
  
  // internal
  reg [`TICK_SIZE-1:0] internal_cycle_cnt;

  initial begin
    cycle_cnt = 0;
    internal_cycle_cnt = 0;
  end

  always @(negedge clock) begin
      cycle_cnt <= cycle_cnt + 1;
      internal_cycle_cnt <= internal_cycle_cnt + 1;
  end

  always @(negedge clock) begin
    if (reset) begin
      pc = 0;
      internal_cycle_cnt = (`IR_CYCLE-1);
    end
    else begin
      if ((internal_cycle_cnt % `IR_CYCLE) == 0) begin
        pc = pc + 1; 
      end
      else begin
        pc = pc;
      end
    end
  end

endmodule
