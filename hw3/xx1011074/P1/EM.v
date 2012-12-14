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
reg [data_size-1:0]EM_REG[mem_size-1:0];
integer i;

// for iverilog testing
wire [data_size-1:0]EM_REG_0 = EM_REG[0];
wire [data_size-1:0]EM_REG_1 = EM_REG[1];
wire [data_size-1:0]EM_REG_2 = EM_REG[2];
wire [data_size-1:0]EM_REG_3 = EM_REG[3];
wire [data_size-1:0]EM_REG_4 = EM_REG[4];
wire [data_size-1:0]EM_REG_5 = EM_REG[5];
wire [data_size-1:0]EM_REG_6 = EM_REG[6];
wire [data_size-1:0]EM_REG_7 = EM_REG[7];
wire [data_size-1:0]EM_REG_8 = EM_REG[8];
wire [data_size-1:0]EM_REG_9 = EM_REG[9];


always@(posedge clk)begin
  if(rst)begin
    for(i=0;i<mem_size;i=i+1)
    EM_REG[i]<=0;
    MEM_data<=0;
  end
  else if(MEM_en)begin
    if(MEM_read)begin
      MEM_data<=EM_REG[MEM_address];
      #1; // FIXME: workaround for time delay
    end
    else if(MEM_write)begin
      EM_REG[MEM_address]<=MEM_in;
    end
  end
end

endmodule
