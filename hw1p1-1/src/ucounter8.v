/* module: universal 8-bit  counter/timer */

module ucounter8 (overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop, carry_in);

parameter MAX8BIT_VAL = 8'b11111111;
parameter MIN8BIT_VAL = 8'b00000000;
parameter RESET_VAL = 8'b00000000;

input  clk, _areset, _aset, _load, _updown, _wrapstop, carry_in;
input  [7:0] preld_val;

output [7:0] dcount;
output overflow;

reg    [7:0] dcount;
reg    overflow;

wire   carry_out;
wire   local_clk;

assign carry_out = ( dcount == MAX8BIT_VAL ) ? 1 : 0;
assign local_clk = ( carry_out && _wrapstop == 0 ) ? 1 : clk;

    always @ (posedge local_clk) begin
        if (_areset)
    	    overflow <= 0;
    	else begin
            if (carry_out == 1)
    		   overflow <= 1;
    		else
    		   overflow <= 0;
    	end
    end

    always @ (posedge local_clk) begin
        if (_areset)
    	    dcount <= RESET_VAL;
    	else if (_aset)
    	    dcount <= MAX8BIT_VAL;
    	else if (_load)
    	    dcount <= preld_val;
        else if (carry_in) begin
            if (_updown)
                dcount <= dcount + 8'd1;
            else
                dcount <= dcount - 8'd1;
        end
    end

endmodule
