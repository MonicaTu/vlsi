`include "ucounter8.v"

module ucounter16 (overflow_high, overflow_low, dcount_high, dcount_low, clk, _areset_high, _areset_low, _aset_high, _aset_low, _load_high, _load_low, preld_val_high, preld_val_low, _updown, _wrapstop);
input  clk, _areset_low, _aset_low, _load_low, _updown, _wrapstop;
input  [7:0] preld_val_low;
output [7:0] dcount_low;
output overflow_low;

input  _areset_high, _aset_high, _load_high;
input  [7:0] preld_val_high;
output [7:0] dcount_high;
output overflow_high;

    ucounter8 ucnt0(overflow_low, dcount_low, clk, _areset_low, _aset_low, _load_low, preld_val_low, _updown, _wrapstop);
    ucounter8 ucnt1(overflow_high, dcount_high, clk, _areset_high, _aset_high, _load_high, preld_val_high, _updown, _wrapstop);
    
    always @ (posedge clk) begin
        if (overflow_high)
            $finish;
        
//        if (overflow_low)
//            _areset_high = 0;
//        else
//            _areset_high = 1;
    end

endmodule
