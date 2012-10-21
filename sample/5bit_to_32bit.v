module t;
reg [5:0]a;
reg [31:0]b;
reg [31:0]c;

initial begin
  assign a=6'b110100;
  assign b=32'b00000000_00000000_00000000_00000000;
  if ( a[5] == 1'b1 )begin
	assign c=a[4:0]|b[4:0];
	assign c[31]=a[5];
  end else begin
  	assign c=a|b;
  end

  $dumpfile("add.vcd");
  $dumpvars();
  #10 $finish;
end 
endmodule

