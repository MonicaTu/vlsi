//`timescale 1ns/10ps
`timescale 1ns/1ns

module ucounter16_tb;
parameter CLK_CYCLE = 2;
parameter DEFAULT_VAL = 16'b0000_0000_11111_000;
reg  clk, _areset, _aset, _load, _updown, _wrapstop;
reg  [15:0] preld_val;
wire [15:0] dcount;
wire overflow;
reg  [15:0] dcount_tb;
reg  overflow_tb;
integer i;

    ucounter16 g(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
    initial
    begin
        clk = 0;
        _areset = 1; 
        _aset = 0;
        _load = 0;
        _updown = 1;
        _wrapstop = 1;
        preld_val = DEFAULT_VAL;
        
        $dumpfile("ucounter16_tb");
        $dumpvars;
        #10000 $finish;
    end
    
    always begin
        #(CLK_CYCLE/2) clk = ~clk;
    end
    
    initial begin
        #CLK_CYCLE _areset = 0;
//        #(CLK_CYCLE*5) _load = 1;
//        #CLK_CYCLE _load = 0;
    end
endmodule
