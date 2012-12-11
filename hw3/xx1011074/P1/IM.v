module IM(clk, rst, IM_address, IM_read, IM_write, IM_enable, IMin, instruction);

  parameter data_size=32;
  parameter address_size=10;
  parameter mem_size=(2**address_size);
  parameter im_start='h80;
  
  input clk, rst, IM_read, IM_write, IM_enable;
  input [address_size-1:0]IM_address;
  input [data_size-1:0]IMin;
  
  output [data_size-1:0]instruction;
  
  reg [data_size-1:0]instruction;
  reg [data_size-1:0]mem_data[mem_size-1:0];
  
  integer i;
  
  // for test and debug  
  wire [data_size-1:0]mem_data_0 = mem_data[im_start+0];
  wire [data_size-1:0]mem_data_1 = mem_data[im_start+1];
  wire [data_size-1:0]mem_data_2 = mem_data[im_start+2];
  wire [data_size-1:0]mem_data_3 = mem_data[im_start+3];
  wire [data_size-1:0]mem_data_4 = mem_data[im_start+4];
  wire [data_size-1:0]mem_data_5 = mem_data[im_start+5];
  wire [data_size-1:0]mem_data_6 = mem_data[im_start+6];
  wire [data_size-1:0]mem_data_7 = mem_data[im_start+7];
  wire [data_size-1:0]mem_data_8 = mem_data[im_start+8];
  wire [data_size-1:0]mem_data_9 = mem_data[im_start+9];
  wire [data_size-1:0]mem_data_10 = mem_data[im_start+10];
  wire [data_size-1:0]mem_data_11 = mem_data[im_start+11];
  wire [data_size-1:0]mem_data_12 = mem_data[im_start+12];
  wire [data_size-1:0]mem_data_13 = mem_data[im_start+13];
  wire [data_size-1:0]mem_data_14 = mem_data[im_start+14];
  wire [data_size-1:0]mem_data_15 = mem_data[im_start+15];
  wire [data_size-1:0]mem_data_16 = mem_data[im_start+16];
  wire [data_size-1:0]mem_data_17 = mem_data[im_start+17];
  wire [data_size-1:0]mem_data_18 = mem_data[im_start+18];
  wire [data_size-1:0]mem_data_19 = mem_data[im_start+19];
  wire [data_size-1:0]mem_data_20 = mem_data[im_start+20];
  wire [data_size-1:0]mem_data_21 = mem_data[im_start+21];
  wire [data_size-1:0]mem_data_22 = mem_data[im_start+22];
  wire [data_size-1:0]mem_data_23 = mem_data[im_start+23];
  wire [data_size-1:0]mem_data_24 = mem_data[im_start+24];

  always@(posedge clk)
  begin
    if(rst)begin
      for(i=0;i<mem_size;i=i+1)
        mem_data[i]<=0;
      instruction<=0;
//      $display("rst");
    end
    else if(IM_enable)begin
      if(IM_read)begin
        instruction<=mem_data[IM_address];
//        $display("instruction: %b", instruction);
      end
      else if(IM_write)begin
//        $display("IMin: %b", IMin);
        mem_data[IM_address] <= IMin;
      end
    end
  end

endmodule
