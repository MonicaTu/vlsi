//`timescale 1ns/10ps
`timescale 1ns/1ns

`include "ucounter8.v"

module ucounter8_tb;

parameter CLK_CYCLE = 2;
parameter DEFAULT_VAL = 8'b11111000;
parameter MAX8BIT_VAL = 8'b11111111;
parameter MIN8BIT_VAL = 8'b00000000;
parameter RESET_VAL = 8'b00000000;
parameter ON = 1'b1;
parameter OFF = 1'b0;

reg  clk, _areset, _aset, _load, _updown, _wrapstop, carry_in;
reg  [7:0] preld_val;

wire [7:0] dcount;
wire overflow;

reg  [7:0] tb_dcount;
reg  tb_overflow;

wire carry_out; 
integer i;
    
    ucounter8 g(overflow, dcount, clk, _areset, _aset, _load, preld_val, _updown, _wrapstop, carry_in);

    assign carry_out = ( dcount == MAX8BIT_VAL && _wrapstop ) ? 1 : 0;
    
    initial begin
        clk = 0;
        _areset = 1; 
        _aset = 0;
        _load = 0;
        _updown = 1;
        _wrapstop = 1;
        carry_in = 1;
        preld_val = DEFAULT_VAL;
        #10000 $finish;
    end
    
    always begin
        #(CLK_CYCLE/2) clk = ~clk;
    end
    
    initial begin
        #CLK_CYCLE _areset = 0;
        #(CLK_CYCLE*5) _load = 1;
        #CLK_CYCLE _load = 0;
    end
 
    initial begin
        #1 tb_dcount = RESET_VAL;
        for (i = 0; i < 5; i = i + 1) begin
            #(CLK_CYCLE) tb_dcount = tb_dcount + 1;
        end

        #(CLK_CYCLE) tb_dcount = DEFAULT_VAL;
        for ( i = 0; i < 10; i = i + 1 ) begin
            // _wrapstop = 1;
            if ( carry_out == 1 ) begin
                tb_dcount = 0;
                tb_overflow = 1;
            end else
                #(CLK_CYCLE) tb_dcount = tb_dcount + 1;
        end
    end
    
    initial
    begin
        $dumpfile("ucounter8_tb.vcd");
        $dumpvars;
    end
endmodule
