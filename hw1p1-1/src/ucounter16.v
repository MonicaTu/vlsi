`include "ucounter8.v"

module ucounter16 (overflow, dcount_top, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop, carry_in);

input clk, _areset, _aset, _load, _updown, _wrapstop, carry_in;
input  [15:0] preld_val;

output [15:0] dcount_top;
output overflow;

wire low_overflow;
wire high_overflow;

wire low_wrapstop;
wire high_wrapstop;

assign low_wrapstop  = _wrapstop;
assign high_wrapstop = 1;

assign overflow = _wrapstop ? 0 : high_overflow;

    ucounter8 high(high_overflow, dcount_top[15:8], clk, _areset, _aset, _load, preld_val[15:8], _updown, high_wrapstop, low_overflow);
    ucounter8 low(low_overflow, dcount_top[7:0], clk, _areset, _aset, _load, preld_val[7:0], _updown, low_wrapstop, carry_in);

endmodule
