module ucounter8_tb;
    reg clk;
    reg _load, _updown, _areset;
    reg [7:0]preld_val;
    ucounter8 g(clk, _areset, _load, _updown, preld_val, dcount);
    initial
    begin
        clk = 0;
        _areset = 1; _load = 0;
        _updown = 1; 
        preld_val=8'b00010111;
        $dumpfile("ucounter8_tb");
        $dumpvars;
        #10000 $finish;
    end
    
    always
    begin
        #1 clk = ~clk;
    end
    
//    always
//    begin
//        #3 _load = 1;
//    end
    
    initial
    begin
        #2 _areset=0;
    end
endmodule
