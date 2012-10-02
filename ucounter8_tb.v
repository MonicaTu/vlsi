module ucounter8_tb;

reg  clk, _areset, _aset, _load, _updown, _wrapstop;
reg  [7:0] preld_val;
wire [7:0] dcount;
wire overflow;
reg  [7:0] dcount_tb;
reg  overflow_tb;

    ucounter8 g(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
    initial
    begin
        clk = 0;
        _areset = 0; 
        _aset = 0;
        _load = 1;
        _updown = 1;
        _wrapstop = 0;
        preld_val=8'b11111000;
        $dumpfile("ucounter8_tb");
        $dumpvars;
        #10000 $finish;
    end
    
    always
    begin
        #1 clk = ~clk;
    end
    
    always
    begin
        #3 _load = 0;
    end
endmodule
