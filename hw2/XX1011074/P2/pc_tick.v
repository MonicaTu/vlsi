`define TICK_SIZE 'd128  // 128 bits
`define MEM_SIZE 'd10    // 10 bits
`define IR_SIZE 'd32     // 32 bits
`define IR_SIZE_BYTE 'd4 // 32 bits = 4 bytes

module pc_tick(pc, cycle_cnt, reset, clock);

  parameter cycle = 4;

  // interface
  input clock;
  input reset;
  output [`MEM_SIZE-1:0] pc;
  output [`TICK_SIZE-1:0] cycle_cnt;

  // internal
  reg [`MEM_SIZE-1:0] pc;
  reg [`TICK_SIZE-1:0] cycle_cnt;

  always @(negedge clock) begin
    if (reset) begin
//      $display("reset");
      pc = 0;
      cycle_cnt = 0;
    end
    else begin
      cycle_cnt = cycle_cnt + 1;
      if ((cycle_cnt % cycle) == 0) begin
        pc = pc + 1; 
      end
      else begin
        pc = pc;
      end
    end
  end

endmodule
