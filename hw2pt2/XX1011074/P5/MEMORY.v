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

// for iverilog testing
wire [data_size-1:0]mem_0 = mem[0];
wire [data_size-1:0]mem_1 = mem[1];
wire [data_size-1:0]mem_2 = mem[2];
wire [data_size-1:0]mem_3 = mem[3];
wire [data_size-1:0]mem_4 = mem[4];
wire [data_size-1:0]mem_5 = mem[5];
wire [data_size-1:0]mem_6 = mem[6];
wire [data_size-1:0]mem_7 = mem[7];
wire [data_size-1:0]mem_8 = mem[8];
wire [data_size-1:0]mem_9 = mem[9];


always@(posedge clk)begin
  if(rst)begin
    for(i=0;i<mem_size;i=i+1)
    mem[i]<=0;
    Dout<=0;
  end
  else if(enable)begin
    if(read)begin
      Dout<=mem[address];
      #1; // FIXME: workaround for time delay
    end
    else if(write)begin
      mem[address]<=Din;
    end
  end
end

endmodule
