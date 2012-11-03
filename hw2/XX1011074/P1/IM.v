module IM(clk, rst, IM_address, enable_fetch, enable_write, enable_mem, IMin, IMout);

parameter data_size=32;
parameter mem_size=1024;

input clk, rst, enable_fetch, enable_write, enable_mem;
input [9:0]IM_address;
input [data_size-1:0]IMin;


output [data_size-1:0]IMout;

reg [data_size-1:0]IMout;
reg [data_size-1:0]mem_data[mem_size-1:0];

integer i;

always@(posedge clk)
begin
  if(rst)begin
    for(i=0;i<mem_size;i=i+1)
    mem_data[i]<=0;
    IMout<=0;
  end
  else if(enable_mem)begin
    if(enable_fetch)begin
      IMout<=mem_data[IM_address];
    end
    else if(enable_write)begin
      mem_data[IM_address] <= IMin;
    end
  end
end

endmodule
