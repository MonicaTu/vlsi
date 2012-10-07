`include "ucounter8.v"

module ucounter16 (overflow, dcount_15, clk, _areset, _aset, _load, preld_val_15, _updown, _wrapstop);
input clk, _areset, _aset, _load, _updown, _wrapstop;
input  [15:0] preld_val_15;
output [15:0] dcount_15;
output overflow;
reg    [15:0] dcount_15;
reg    overflow;

input  clk_low;
output [7:0]dcount_low;
output overflow_low;

input  clk_high;
output [7:0]dcount_high;
output overflow_high;

    ucounter8 ucnt0(overflow_low, dcount_low, clk, _areset, _aset, _load, preld_val[7:0], _updown, _wrapstop);
    ucounter8 ucnt1(overflow_high, dcount_high, overflow_low, _areset, _aset, _load, preld_val[15:8], _updown, _wrapstop);

    initial begin
        
    end

    always @ (posedge clk) begin
        if (overflow_high)
            $finish;
    end

endmodule
