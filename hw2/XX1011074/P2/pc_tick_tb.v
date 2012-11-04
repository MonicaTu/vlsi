`define TICK_SIZE 128  // 128 bits
`define IR_SIZE 32     // 32 bits

module pc_tick_tb;

  reg clock;
  reg reset;
  wire [`TICK_SIZE-1:0] tick;
  wire [`IR_SIZE-1:0] pc;

  pc_tick pc_tick1 (.clock(clock), .reset(reset), .pc(pc), .tick(tick));

  always 
    #50 clock=clock+1;
  
  initial begin
    clock = 0;
    reset = 1;
  end
  
  initial begin
    #100 reset = 0;
  end

  initial begin
    $dumpfile("pc_tick_tb.vcd");
    $dumpvars();
    #2000 $finish;
  end

endmodule
