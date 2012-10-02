test_ucounter8:
	iverilog ucounter8.v ucounter8_tb.v
	./a.out
	gtkwave ucounter8_tb

clean:
	rm -f a.out ucounter8_tb
