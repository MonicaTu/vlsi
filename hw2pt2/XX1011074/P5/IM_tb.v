`define DISPLAY_SIZE  20
`define MEM_SIZE  1024
`define DATA_SIZE 32

module IM_tb;

  reg in = 0;
  wire out;
  
  IM IM1 (
    .clk(clk), 
    .rst(rst), 
    .IM_address(IM_address), 
    .enable_fetch(enable_fetch), 
    .enable_write(enable_write), 
    .enable_mem(enable_mem), 
    .IMin(in), 
    .IMout(out));
  
  initial begin
    $readmemb("mins.prog", IM1.mem_data);
  end
  
  integer k;
  
  initial begin
    $display("Contents of Mem after reading data file:");
//    for (k=0; k<`MEM_SIZE; k=k+1) $display("%d:%b",k,IM1.mem_data[k]);
    for (k=0; k<`DISPLAY_SIZE; k=k+1) $display("%d:%b",k,IM1.mem_data[k]);
    #100 $finish;
  end

endmodule
