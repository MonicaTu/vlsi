/* module: universal 8-bit  counter/timer */

module ucounter8 (clk, _areset, _load, _updown, preld_val, dcount);
input  clk, _areset, _load, _updown;
input  [7:0] preld_val;
output [7:0] dcount;
reg    [7:0] dcount;

    always @ (posedge clk)
    begin
        if (_areset)
        begin
            dcount = 0;
        end
        else 
//            if (_load)
//                dcount = preld_val;
//            else
                begin
//                    if (_updown)
                        dcount = dcount + 1'b1;
//                    else
//                        dcount = dcount-1;
                end
    end
endmodule
