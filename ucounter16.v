`include "ucounter8.v"

module ucounter16 (overflow_high, overflow_low, dcount_high, dcount_low, clk_high, clk_low, _areset_high, _areset_low, _aset_high, _aset_low, _load_high, _load_low, preld_val_high, preld_val_low, _updown, _wrapstop);
input _updown, _wrapstop;
output  clk_low;
reg  clk_low;
input _areset_low, _aset_low, _load_low;
input  [7:0] preld_val_low;
output [7:0] dcount_low;
output overflow_low;

output  clk_high;
reg    clk_high; 
input  _areset_high, _aset_high, _load_high;
input  [7:0] preld_val_high;
output [7:0] dcount_high;
output overflow_high;

    ucounter8 ucnt0(overflow_low, dcount_low, clk_low, _areset_low, _aset_low, _load_low, preld_val_low, _updown, _wrapstop);
    ucounter8 ucnt1(overflow_high, dcount_high, clk_high, _areset_high, _aset_high, _load_high, preld_val_high, _updown, _wrapstop);
   
    initial begin
        clk_low = 0;
        clk_high = 0;
    end

    always begin
        #1 clk_low = ~clk_low;
    end

    always @ (posedge clk_low) begin
        if (overflow_high)
            $finish;

        if (overflow_low)
            #1 clk_high = ~clk_high;
    end

endmodule
