/* module: universal 8-bit  counter/timer */
module ucounter8 (overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
input  clk, _areset, _aset, _load, _updown, _wrapstop;
input  [7:0] preld_val;
output [7:0] dcount;
output overflow;
reg    [7:0] dcount;
reg    overflow;

    always @ (posedge clk) // fixme
    begin
        if (_areset)
            dcount = 0;
        else
            if (_aset)
                dcount = dcount; // fixme
            else
                if (_load)
                    dcount = preld_val;
                else begin
                    if (_updown) begin
                        if (dcount == 255) begin
                            if (_wrapstop) begin
                                dcount = 0;
                            end
                            else begin
                                overflow = 1;
                                #5 $finish;    // stop
                            end
                        end
                        else
                            dcount = dcount + 1;
                    end
                    else
                        if (dcount == 0) begin
                            if (_wrapstop) begin
                                dcount = 255;
                            end
                            else begin
                                overflow = 1;
                                #5 $finish; // stop
                            end
                        end
                        else
                            dcount = dcount - 1;
                   end
    end
endmodule
