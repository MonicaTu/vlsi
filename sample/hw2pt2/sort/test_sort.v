module test_sort;

  parameter length=8;           // the bits number of data
  parameter weikuan=8;         // the length of the memory
  
  wire[length-1:0] dataout;
  wire over;
  
  reg clk;
  reg rst;
  reg[length-1:0] datain;

  integer i;

  sort sort1(clk,rst,datain,dataout,over);
  
  always #5 clk=~clk;
  
  initial begin
    clk=0;
    rst=1'b1;
    #10 rst=1'b0; 
    #10 rst=1'b1;
    
    #10 datain=6;
    #10 datain=4;
    #10 datain=7;
    #10 datain=5;
    #10 datain=2;
    #10 datain=0;
    #10 datain=1;
    $display("============= input ================");
    for (i = 0; i < weikuan; i = i+1)
      $display("mem[%d]: %d", i, sort1.memo[i]);
    #10 datain=3;
    
    #100;
    $display("============= output ================");
    for (i = 0; i < weikuan; i = i+1)
      $display("mem[%d]: %d", i, sort1.memo[i]);
    $finish;
  end
  
  initial begin
    $dumpfile("test_sort.vcd");
    $dumpvars;
  end

endmodule
