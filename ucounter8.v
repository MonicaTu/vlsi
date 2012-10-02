/* module: universal 8-bit  counter/timer */

module ucounter8 (clk, _arest, _load, _updown, preld_val, dcount);
input  clk, _arest, _load, _updown, preld_val;
input  [7:0] preld_val;
output [7:0] dcount;
reg    [7:0] dcount;

    always @ (posedge clk)
    begin
        if (_arest)
            dcount = 0;
        else 
            if (_load)
                dcount = preld_val;
            else
                begin
                    if (_updown)
                        dcount = dcount+1;
                    else
                        dcount = dcount-1;
                end
    end
endmodule
