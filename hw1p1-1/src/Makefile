test_ucounter16:
	iverilog ucounter16_tb.v
	./a.out
	gtkwave ucounter16_tb.vcd

test_ucounter8:
	iverilog ucounter8_tb.v
	./a.out
	gtkwave ucounter8_tb.vcd

test_alu32:
	iverilog alu32_tb.v
	./a.out
	gtkwave alu32_tb.vcd

clean:
	rm -f a.out ucounter8_tb.vcd
	rm -f a.out ucounter16_tb.vcd
	rm -f a.out alu32_tb.vcd
    
