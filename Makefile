test_ucounter16:
	iverilog ucounter16.v ucounter16_tb.v
	./a.out
	gtkwave ucounter16_tb

test_ucounter8:
	iverilog ucounter8.v ucounter8_tb.v
	./a.out
	gtkwave ucounter8_tb

clean:
	rm -f a.out ucounter8_tb
