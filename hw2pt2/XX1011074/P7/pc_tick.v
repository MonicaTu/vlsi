`define TICK_SIZE    ('d128) // 128 bits
`define MEM_SIZE     ('d10)  // 10 bits
`define IR_SIZE      ('d32)  // 32 bits
`define IR_SIZE_BYTE ('d4)   // 32 bits = 4 bytes
`define IR_CYCLE     ('d9)

module pc_tick(pc, cycle_cnt, ir_enable, enable_pc_set, pc_set, reset, clock);
  
  parameter im_start = 'h80; // FIXME

  // interface
  input clock;
  input reset;
  input ir_enable;
  input enable_pc_set;
  input [31:0] pc_set;

  output [`MEM_SIZE-1:0] pc;
  output [`TICK_SIZE-1:0] cycle_cnt;

  reg [`MEM_SIZE-1:0] pc;
  reg [`TICK_SIZE-1:0] cycle_cnt;
  
  // internal
  reg [`TICK_SIZE-1:0] internal_cycle_cnt;
  wire local_clock;

  assign local_clock = (ir_enable & clock);

  always @(posedge local_clock or reset) begin
    if (reset) begin
      cycle_cnt <= 0;
    end else begin
      cycle_cnt <= cycle_cnt + 1;
    end
  end

//  always @(posedge local_clock or reset) begin
//    if (reset) begin
//      d <= 1;
//    end else begin
//      d <= d  + 1;
//    end
//  end

  always @ (posedge local_clock) begin
    if (reset) begin
      q <= 0;
    end else begin
      q <= d;
    end
  end
      
  always @(*) begin
//    d = q;
    d = q+1;
    if (reset) begin
      pc = im_start;
    end else if (enable_pc_set) begin
      pc = pc + (pc_set << 1);
      d = 0;
    end else if ((q % `IR_CYCLE) == 0) begin
      pc = pc + 4; 
    end else begin
      pc = pc;
    end
    //$display("pc:%d", pc);
  end

endmodule
