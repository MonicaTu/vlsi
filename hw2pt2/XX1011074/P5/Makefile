tb:
	rm a.out
	rm top_tb.vcd
	iverilog top_tb.v top.v -Dprog=1
	./a.out
	gtkwave top_tb.vcd

tb1:
	rm a.out
	rm top_tb.vcd
	iverilog top_tb.v top.v -Dprog1=1
	./a.out
	gtkwave top_tb.vcd

tb2:
	rm a.out
	rm top_tb.vcd
	iverilog top_tb.v top.v -Dprog2=1
	./a.out
	gtkwave top_tb.vcd

tb3:
	rm a.out
	rm top_tb.vcd
	iverilog top_tb.v top.v -Dprog3=1
	./a.out
	gtkwave top_tb.vcd

tb4:
	rm a.out
	rm top_tb.vcd
	iverilog top_tb.v top.v -Dprog4=1
	./a.out
	gtkwave top_tb.vcd

tb5:
	rm a.out
	rm top_tb.vcd
	iverilog top_tb.v top.v -Dprog5=1
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
