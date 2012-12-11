module EM(clk, rst, MEM_en, MEM_read, MEM_write, MEM_address, MEM_in, MEM_data);

parameter data_size = 32;
parameter in_size = 32;
parameter address_size = 16;
parameter mem_size = (2**address_size);

input clk, rst, MEM_en, MEM_read, MEM_write;
input [address_size-1:0]MEM_address;
input [in_size-1:0]MEM_in;

output [data_size-1:0]MEM_data;

reg [data_size-1:0]MEM_data;

// internal
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
    MEM_data<=0;
  end
  else if(MEM_en)begin
    if(MEM_read)begin
      MEM_data<=mem[MEM_address];
      #1; // FIXME: workaround for time delay
    end
    else if(MEM_write)begin
      mem[MEM_address]<=MEM_in;
    end
  end
end

endmodule
