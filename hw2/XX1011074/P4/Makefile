tb:
	iverilog top_tb.v top.v IM.v DM.v ROM.v
	./a.out
	gtkwave top_tb.vcd

tb1:
	iverilog top_tb1.v top.v IM.v DM.v ROM.v
	./a.out
	gtkwave top_tb1.vcd

tb2:
	iverilog top_tb2.v top.v IM.v DM.v ROM.v
	./a.out
	gtkwave top_tb2.vcd

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
	rm top_tb1.vcd
	rm top_tb2.vcd
	rm pc_tick_tb.vcd
