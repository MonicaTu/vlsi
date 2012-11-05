module MEMORY(clk, rst, enable, read, write, address, Din, Dout);

parameter data_size=32;
parameter mem_size=16384;

input clk, rst, enable, read, write;
input [13:0]address;
input [data_size-1:0]Din;

output [data_size-1:0]Dout;

reg [data_size-1:0]Dout;
reg [data_size-1:0]mem[mem_size-1:0];

integer i;

always@(posedge clk)begin
  if(rst)begin
    for(i=0;i<mem_size;i=i+1)
    mem[i]<=0;
    Dout<=0;
  end
  else if(enable)begin
    if(read)begin
      Dout<=mem[address];
    end
    else if(write)begin
      mem[address]<=Din;
    end
  end
end

endmodule
