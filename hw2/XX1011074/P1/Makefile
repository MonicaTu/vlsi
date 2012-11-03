top:
	iverilog top_tb.v top.v 
	./a.out
	gtkwave top_tb.vcd

pc_tick:
	iverilog pc_tick_tb.v pc_tick.v 
	./a.out
	gtkwave pc_tick_tb.vcd

IM:
	iverilog IM_tb.v IM.v 
	./a.out

clean:
	rm a.out
	rm top_tb.vcd
	rm pc_tick_tb.vcd
