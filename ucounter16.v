`include "ucounter8.v"

module ucounter16 (overflow, dcount_top, clk, _areset, _aset, _load, preld_val_top, _updown, _wrapstop);
input clk, _areset, _aset, _load, _updown, _wrapstop;
input  [15:0] preld_val_top;
output [15:0] dcount_top;
output overflow;

input  clk_low;
output overflow_low;

input  clk_high;
output overflow_high;

    ucounter8 ucnt0(overflow_low, dcount_top[7:0], clk, _areset, _aset, _load, preld_val[7:0], _updown, _wrapstop);
    ucounter8 ucnt1(overflow_high, dcount_top[15:8], overflow_low, _areset, _aset, _load, preld_val[15:8], _updown, _wrapstop);

    always @ (posedge clk, _areset, _aset, _load, _updown, _wrapstop) begin
    
    end

endmodule
