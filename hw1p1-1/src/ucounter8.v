/* module: universal 8-bit  counter/timer */

module ucounter8 (overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
parameter MAX8BIT_VAL = 8'b11111111;
parameter MIN8BIT_VAL = 8'b00000000;
parameter RESET_VAL = 8'b00000000;
input  clk, _areset, _aset, _load, _updown, _wrapstop;
input  [7:0] preld_val;
output [7:0] dcount;
output overflow;
reg    [7:0] dcount;
reg    overflow;

    // TODO: overflow --> clk when _wrapstop is 0.

    always @ (posedge clk) begin
        if (_areset)
    	    dcount <= RESET_VAL;
    	else if (_aset)
    	    dcount <= MAX8BIT_VAL;
    	else if (_load)
    	    dcount <= preld_val;
    	else begin
            if (_updown) begin
                  dcount <= ( dcount == MAX8BIT_VAL) ? ( ( _wrapstop == 1 ) ? RESET_VAL : dcount ) : dcount + 8'd1;
                  overflow <= ( dcount == MAX8BIT_VAL && _wrapstop == 0 ) ? 1 : 0;
            end else begin
                  dcount <= ( dcount == MIN8BIT_VAL) ? ( ( _wrapstop == 1 ) ? dcount : RESET_VAL ) : dcount - 8'd1;
                  overflow <= ( dcount == RESET_VAL && _wrapstop == 0 ) ? 1 : 0;
            end
    	end
    end

endmodule
