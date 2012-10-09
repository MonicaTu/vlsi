//`timescale 1ns/10ps
`timescale 1ns/1ns
`include "ucounter16.v"

module ucounter16_tb;

//parameter DEFAULT_VAL = 8'b10011010;
parameter DEFAULT_VAL = 8'hF8;
parameter MAX16BIT_VAL = 16'hFFFF;

reg clk, _areset, _aset, _load, _updown, _wrapstop;
reg  [15:0] preld_val;
reg  carry_in;

wire [15:0] dcount;
wire overflow;

reg [15:0] tb_dcount;
reg tb_overflow;
integer i;

    ucounter16 g(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop, carry_in);

    initial begin
        clk = 0;
	    _areset = 0; 
	    _aset = 0;
        _load = 0;
        preld_val = DEFAULT_VAL;
        _updown = 1;
        _wrapstop = 1;
        carry_in = 1;
    end

	//setup clk
    always begin
        #10 clk = ~clk;
    end

    // _areset test
	initial begin // 0-50
        #20 _areset = 1; //20
	    #20 _areset = 0; //40
	end

//    initial begin
//        #20 tb_dcount = 0;
//        #20;
//    end
/*
    // _aset test
    initial begin //50-100
	    	_aset = 0;
        #50 _aset = 1; //50
	    #10	_aset = 0; //60
	end	

    initial begin
        for ( i = 0; i < 5; i = i + 1 ) begin
            #10 tb_dcount = tb_dcount + 1;
        end
        #10 tb_dcount = MAX16BIT_VAL;
    end
*/
    // _laod test
//    initial begin //100-200
//        #100 _load = 1; //100
//        #90	 _load = 0; //190
//    end

//    initial begin
//        #10 tb_dcount = DEFAULT_VAL; 
//    end
/*
    // _updown test
	initial begin //200-1000
        	  _updown = 1;
	    #200  _updown = 0;
	    #1000 _updown = 1;
	end	

    initial begin
        for ( i = 0; i < 80; i = i + 1 ) begin
            #10 tb_dcount = tb_dcount + 1;
        end
    end

    // _wrapstop test
    initial begin //1200 Before circle, After fullStop
		  _wrapstop = 0;
	#1000 _wrapstop = 1;
	end

    initial begin
        for ( i = 0; i < 100; i = i + 1 ) begin
            #10 tb_dcount = tb_dcount + 1;
            if (tb_dcount == MAX16BIT_VAL ) begin
                tb_dcount = tb_dcount;
                tb_overflow = 1;
            end
        end
    end

    initial begin //total 1500
    #5000 $finish;
    end

    initial begin
        for ( i = 0; i < 500; i = i + 1 ) begin
            #10 tb_dcount = tb_dcount + 1;
            if (tb_dcount == MAX16BIT_VAL ) begin
                tb_dcount = 0;
                $finish;
            end
        end
    end
*/
/* 
    initial begin //1200 Before circle, After fullStop
			_wrapstop = 0;
	end	
    
    initial begin //total 1500
    #50000 $finish;
    end
 */    
    initial begin
        $dumpfile("ucounter16_tb.vcd");
        $dumpvars;
        #100000 $finish;
    end

//    initial begin
//        $fsdDumpfile("ucounter16_tb.fsdb");
//        $fsdDumpvars;
//    end


endmodule
