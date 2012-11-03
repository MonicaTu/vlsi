top:
	iverilog top_tb.v top.v 
	./a.out
	gtkwave top_tb.vcd

pc_tick:
	iverilog pc_tick_tb.v pc_tick.v 
	./a.out
	gtkwave pc_tick_tb.vcd

clean:
	rm a.out top_tb.vcd
	rm a.out pc_tick_tb.vcd
