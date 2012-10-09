`include "ucounter8.v"

module ucounter16 (overflow, dcount_top, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop, carry_in);

input clk, _areset, _aset, _load, _updown, _wrapstop, carry_in;
input  [15:0] preld_val;

output [15:0] dcount_top;
output overflow;

wire low_overflow;

    ucounter8 high(overflow, dcount_top[15:8], clk, _areset, _aset, _load, preld_val[15:8], _updown, _wrapstop, low_overflow);
    ucounter8 low(low_overflow, dcount_top[7:0], clk, _areset, _aset, _load, preld_val[7:0], _updown, _wrapstop, carry_in);

endmodule
