module ucounter8_tb;

reg  clk, _areset, _aset, _load, _updown, _wrapstop;
reg  [7:0] preld_val;
wire [7:0] dcount;
wire overflow;
reg  [7:0] dcount_tb;
reg  overflow_tb;
integer i;

    ucounter8 g(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop);
    initial
    begin
        clk = 0;
        _areset = 0; 
        _aset = 0;
        _load = 0;
        _updown = 1;
        _wrapstop = 0;
        preld_val = 8'b11111000;

        dcount_tb = 0;
        overflow_tb = 0;
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
        #5 _load = 1;
        #6 _load = 0;
        #47 _load = 1; 
        #48 _load = 0;
    end
    
    always
    begin
        #21 _updown = 0;
        #36 _updown = 1;
    end

    always
    begin
        #37 _aset = 1;
    end

    always
    begin
        #42 _areset = 1;
    end

    always
    begin
        #49 _wrapstop = 0;
    end

    always @ (posedge clk) // fixme: posedge vs. clock signal
    begin
        for (i = 0; i < 5; i = i+1) begin
                #1 dcount_tb = dcount_tb + 1;
        end
        
        #1 dcount_tb = 8'b11111000;
       
        for (i = 0; i < 15; i = i + 1) begin
            #1 dcount_tb = dcount_tb + 1;
        end

        for (i = 0; i < 15; i = i + 1) begin
            #1 dcount_tb = dcount_tb - 1;
        end
        
        for (i = 0; i < 5; i = i + 1) begin
            #1 dcount_tb = dcount_tb;
        end

        #1 dcount_tb = 0;
        
        for (i = 0; i < 5; i = i + 1) begin
            #1 dcount_tb = dcount_tb + 1;
        end

        #1 dcount_tb = 8'b11111000;
        for (i = 0; i < 15; i = i + 1) begin
            #1 dcount_tb = dcount_tb + 1;
            if (dcount_tb == 8'b11111111) begin
                #1 overflow_tb = 1;
                #1 $finish;
            end
        end
    end
endmodule
