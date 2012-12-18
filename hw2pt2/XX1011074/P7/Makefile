tb:
	iverilog top_tb.v top.v -Dprog=1
	./a.out
	gtkwave top.vcd

tb1:
	iverilog top_tb.v top.v -Dprog1=1
	./a.out
	gtkwave top.vcd

tb2:
	iverilog top_tb.v top.v -Dprog2=1
	./a.out
	gtkwave top.vcd

tb3:
	iverilog top_tb.v top.v -Dprog3=1
	./a.out
	gtkwave top.vcd

tb4:
	iverilog top_tb.v top.v -Dprog4=1
	./a.out
	gtkwave top.vcd

tb5:
	iverilog top_tb.v top.v -Dprog5=1
	./a.out
	gtkwave top.vcd

pc_tick:
	iverilog pc_tick_tb.v pc_tick.v 
	./a.out
	gtkwave pc_tick_tb.vcd

IM:
	iverilog IM_tb.v IM.v 
	./a.out

clean:
	rm a.out
	rm top.vcd
	rm pc_tick_tb.vcd
