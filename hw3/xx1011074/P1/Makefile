basic:
	iverilog top_tb.v top.v -Dbasic=1 -DVCD=1
	./a.out
	gtkwave top.vcd

lwsw:
	iverilog top_tb.v top.v -Dlwsw=1 -DVCD=1
	./a.out
	gtkwave top.vcd

individual:
	iverilog top_tb.v top.v -Dprog1=1 -DVCD=1
	./a.out
	gtkwave top.vcd

sorting:
	iverilog top_tb.v top.v -Dprog2=1 -DVCD=1
	./a.out
	gtkwave top.vcd

fibonacci:
	iverilog top_tb.v top.v -Dprog3=1 -DVCD=1
	./a.out
	gtkwave top.vcd

ta:
	iverilog top_tb.v top.v -Dprog4=1 -DVCD=1
	./a.out
	gtkwave top.vcd

mins:
	iverilog top_tb.v top.v -Dmins=1 -DVCD=1
	./a.out
	gtkwave top.vcd

mins1:
	iverilog top_tb.v top.v -Dmins1=1 -DVCD=1
	./a.out
	gtkwave top.vcd

mins2:
	iverilog top_tb.v top.v -Dmins2=1 -DVCD=1
	./a.out
	gtkwave top.vcd

mins3:
	iverilog top_tb.v top.v -Dmins3=1 -DVCD=1
	./a.out
	gtkwave top.vcd

mins4:
	iverilog top_tb.v top.v -Dmins4=1 -DVCD=1
	./a.out
	gtkwave top.vcd

hazard1:
	iverilog top_tb.v top.v -Dhazard1=1 -DVCD=1
	./a.out
	gtkwave top.vcd

hazard2:
	iverilog top_tb.v top.v -Dhazard2=1 -DVCD=1
	./a.out
	gtkwave top.vcd

hazard3:
	iverilog top_tb.v top.v -Dhazard3=1 -DVCD=1
	./a.out
	gtkwave top.vcd

clean:
	rm a.out
	rm top.vcd
