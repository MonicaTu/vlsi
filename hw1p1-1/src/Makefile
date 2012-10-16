test_ucounter16:
	ncverilog ucounter16_tb.v +access+r

test_ucounter8:
	ncverilog ucounter8_tb.v +access+r

test_alu32:
	iverilog alu32_tb.v
	./a.out
	gtkwave alu32_tb.vcd

clean:
	rm -f a.out ucounter8_tb.vcd
	rm -f a.out ucounter16_tb.vcd
	rm -f a.out alu32_tb.vcd
    
