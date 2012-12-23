basic:
	iverilog top_tb.v top.v -Dbasic=1 -DVCD=1
	./a.out
	gtkwave top.vcd

lwsw:
	iverilog top_tb.v top.v -Dlwsw=1 -DVCD=1
	./a.out
	gtkwave top.vcd

tb1:
	iverilog top_tb.v top.v -Dprog1=1 -DVCD=1
	./a.out
	gtkwave top.vcd

tb2:
	iverilog top_tb.v top.v -Dprog2=1 -DVCD=1
	./a.out
	gtkwave top.vcd

tb3:
	iverilog top_tb.v top.v -Dprog3=1 -DVCD=1
	./a.out
	gtkwave top.vcd

tb4:
	iverilog top_tb.v top.v -Dprog4=1 -DVCD=1
	./a.out
	gtkwave top.vcd

tb5:
	iverilog top_tb.v top.v -Dprog5=1 -DVCD=1
	./a.out
	gtkwave top.vcd

clean:
	rm a.out
	rm top.vcd
