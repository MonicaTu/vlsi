module pc_tick(pc, cycle_cnt, ir_enable, zero, pc_set, reset, clock);
  
  parameter im_start = 'h80; // FIXME
  parameter ir_cycle = 9; // FIXME:cycle per instruction 
  
  parameter data_size = 32;
  parameter tick_size = 128;
  parameter address_size = 10;

  // interface
  input clock;
  input reset;
  input ir_enable;
  input zero;
  input [data_size-1:0] pc_set;

  output [address_size-1:0] pc;
  output [tick_size-1:0] cycle_cnt;

  reg [address_size-1:0] pc;
  reg [tick_size-1:0] cycle_cnt;
  
  // internal
  reg [tick_size-1:0] internal_cycle_cnt;
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
    end else if (zero) begin
      pc = pc + (pc_set << 1);
      d = 0;
    end else if ((q % ir_cycle) == 0) begin
      pc = pc + 4; 
    end else begin
      pc = pc;
    end
    //$display("pc:%d", pc);
  end

endmodule
