/* module: universal 8-bit  counter/timer */
module ucounter8 (overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
input  clk, _areset, _aset, _load, _updown, _wrapstop;
input  [7:0] preld_val;
output [7:0] dcount;
output overflow;
reg    [7:0] dcount;

    always @ (posedge clk, _areset, _updown) begin
        if (_areset)
            dcount <= 0;
        else
            if (_updown)
                dcount <= dcount + 1;
            else
                dcount <= dcount - 1;
    end
    
    always @ (posedge clk, _aset) begin
            dcount = 255;
    end

    always @ (posedge clk, _load) begin
            dcount = preld_val;
    end

    assign overflow = ( _wrapstop && dcount == 255 ) ? 1 : 0;

endmodule
