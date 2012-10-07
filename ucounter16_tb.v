//`timescale 1ns/10ps
`timescale 1ns/1ns

module ucounter16_tb;
parameter CLK_CYCLE = 2;
parameter DEFAULT_VAL = 8'b11111000;
reg  clk, _updown, _wrapstop;
reg  _areset_low, _aset_low, _load_low;
reg  _areset_high, _aset_high, _load_high;

input [7:0] preld_val_low;
input [7:0] preld_val_high;

wire  [7:0] dcount_low;
wire  overflow_low;
reg   [7:0] dcount_low_tb;
reg   overflow_low_tb;

wire  [7:0] dcount_high;
wire  overflow_high;
reg   [7:0] dcount_high_tb;
reg   overflow_high_tb;
integer i;

//    ucounter16 m(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
//    ucounter16 m(overflow_high, overflow_low, dcount_high, dcount_low, clk, _areset, _aset, _load, preld_val_high, preld_val_low, _updown, _wrapstop);
    ucounter16 m(overflow_high, overflow_low, dcount_high, dcount_low, clk, _areset_high, _areset_low, _aset_high, _aset_low, _load_high, _load_low, preld_val_high, preld_val_low, _updown, _wrapstop);
    initial
    begin
        clk = 0;
        _areset_low = 1; 
        _aset_low = 0;
        _load_low = 0;
        _updown = 1;
        _wrapstop = 1;
//        preld_val = DEFAULT_VAL;
        
        _areset_high = 1; 
        _aset_high = 0;
        _load_high = 0;
        
        $dumpfile("ucounter16_tb");
        $dumpvars;
        #10000 $finish;
    end
    
    always begin
        #(CLK_CYCLE/2) clk = ~clk;
    end
    
    initial begin
        #CLK_CYCLE _areset_low = 0;
        _areset_high = 0;
//        #(CLK_CYCLE*5) _load_low = 1;
//        #CLK_CYCLE _load_low = 0;
    end
 
    initial begin
        #1 dcount_low_tb = 0;
        for (i = 0; i < 5; i = i + 1) begin
            #(CLK_CYCLE) dcount_low_tb = dcount_low_tb + 1;
        end

        #(CLK_CYCLE) dcount_low_tb = DEFAULT_VAL;
        for (i = 0; i < 10; i = i + 1) begin
            #(CLK_CYCLE) dcount_low_tb = dcount_low_tb + 1;
        end
    end

endmodule
