`timescale 1ns/10ps
`include "ucounter16.v"

`define PERIOD 10
module ucounter16_tb;

parameter DEFAULT_VAL = 16'hABC5;
parameter MAX16BIT_VAL = 16'hFFFF;

reg clk, _areset, _aset, _load, _updown, _wrapstop;
reg  [15:0] preld_val;
reg  _carry_in;

wire [15:0] dcount;
wire overflow;

reg [15:0] tb_dcount;
reg tb_overflow;
integer i;

    ucounter16 g(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop, _carry_in);

	// setup clk
    initial begin                                                                                      
        clk = 0; // Start clock from LOW                                                              
        forever #(`PERIOD/2) clk = ~clk;                                                            
    end   

    initial begin
//        _aset = 0;
//        _load = 0;
        preld_val = DEFAULT_VAL;
        _updown = 1;
//        _wrapstop = 1;
        _carry_in = 1;
        #100000 $finish;
    end

	initial begin // 0-50
        // _areset test
	                 _areset   = 0; 
        #(`PERIOD)   _areset   = 1;
	    #(`PERIOD)   _areset   = 0;
        // _load test
        #(`PERIOD*5) _load     = 1;
        #(`PERIOD)   _load     = 0;
        // _updown test 
        #(`PERIOD*5) _updown   = 0;
        #(`PERIOD*5) _updown   = 1;
        // _wrapstop test
                     _wrapstop = 1;
        // _aset test
                     _aset     = 1;
        #(`PERIOD)   _aset     = 0;
        // _wrapstop test
        #(`PERIOD*5) _wrapstop = 0;
        // _aset test
                     _aset     = 1;
        #(`PERIOD)   _aset     = 0;
        #(`PERIOD*5);
	end

    initial begin
        // _areset test
        #(`PERIOD*1.5) tb_dcount = 0;
        for ( i = 0; i < 5; i = i + 1 ) begin
            #(`PERIOD) tb_dcount = tb_dcount + 1;
        end
        // _load test
        #(`PERIOD) tb_dcount = DEFAULT_VAL; 
        for ( i = 0; i < 5; i = i + 1 ) begin
            #(`PERIOD) tb_dcount = tb_dcount + 1;
        end
        // _updown test
//        #(`PERIOD) tb_dcount = DEFAULT_VAL; 
        for ( i = 0; i < 5; i = i + 1 ) begin
            #(`PERIOD) tb_dcount = tb_dcount - 1;
        end
        // _aset test
        #(`PERIOD) tb_dcount = MAX16BIT_VAL; 
        // _wrapstop test
        for ( i = 0; i < 5; i = i + 1 ) begin
            #(`PERIOD) tb_dcount = tb_dcount + 1;
        end
        // _aset test
        #(`PERIOD) tb_dcount = MAX16BIT_VAL; 
        // _wrapstop test
        #(`PERIOD*5);
    end
    
    initial begin
        $dumpfile("ucounter16_tb.vcd");
        $dumpvars();
    end

//    initial begin
//        $fsdbDumpfile("ucounter16_tb.fsdb");
//        $fsdbDumpvars();
//    end


endmodule
