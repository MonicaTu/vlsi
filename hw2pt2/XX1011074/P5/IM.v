module IM(clk, rst, IM_address, enable_fetch, enable_write, enable_mem, IMin, IMout);

  parameter DataSize=32;
  parameter MemSize=1024;
  parameter im_start='h80;
  
  input clk, rst, enable_fetch, enable_write, enable_mem;
  input [9:0]IM_address;
  input [DataSize-1:0]IMin;
  
  
  output [DataSize-1:0]IMout;
  
  reg [DataSize-1:0]IMout;
  reg [DataSize-1:0]mem_data[MemSize-1:0];
  
  integer i;
  
  // for test and debug  
  wire [DataSize-1:0]mem_data_0 = mem_data[im_start+0];
  wire [DataSize-1:0]mem_data_1 = mem_data[im_start+1];
  wire [DataSize-1:0]mem_data_2 = mem_data[im_start+2];
  wire [DataSize-1:0]mem_data_3 = mem_data[im_start+3];
  wire [DataSize-1:0]mem_data_4 = mem_data[im_start+4];
  wire [DataSize-1:0]mem_data_5 = mem_data[im_start+5];
  wire [DataSize-1:0]mem_data_6 = mem_data[im_start+6];
  wire [DataSize-1:0]mem_data_7 = mem_data[im_start+7];
  wire [DataSize-1:0]mem_data_8 = mem_data[im_start+8];
  wire [DataSize-1:0]mem_data_9 = mem_data[im_start+9];
  wire [DataSize-1:0]mem_data_10 = mem_data[im_start+10];
  wire [DataSize-1:0]mem_data_11 = mem_data[im_start+11];
  wire [DataSize-1:0]mem_data_12 = mem_data[im_start+12];
  wire [DataSize-1:0]mem_data_13 = mem_data[im_start+13];
  wire [DataSize-1:0]mem_data_14 = mem_data[im_start+14];
  wire [DataSize-1:0]mem_data_15 = mem_data[im_start+15];
  wire [DataSize-1:0]mem_data_16 = mem_data[im_start+16];
  wire [DataSize-1:0]mem_data_17 = mem_data[im_start+17];
  wire [DataSize-1:0]mem_data_18 = mem_data[im_start+18];
  wire [DataSize-1:0]mem_data_19 = mem_data[im_start+19];
  wire [DataSize-1:0]mem_data_20 = mem_data[im_start+20];
  wire [DataSize-1:0]mem_data_21 = mem_data[im_start+21];
  wire [DataSize-1:0]mem_data_22 = mem_data[im_start+22];
  wire [DataSize-1:0]mem_data_23 = mem_data[im_start+23];
  wire [DataSize-1:0]mem_data_24 = mem_data[im_start+24];

  always@(posedge clk)
  begin
    if(rst)begin
      for(i=0;i<MemSize;i=i+1)
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
