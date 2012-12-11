module DM(clk, rst, DM_read, DM_write, DM_enable, DM_in, DM_out, DM_address);

  parameter data_size = 32;
  parameter address_size = 15;
  parameter mem_size = (2**address_size);
  
  input clk;
  input rst;
  input DM_read;
  input DM_write;
  input DM_enable;
  input [data_size-1:0]DM_in;
  input [address_size-1:0]DM_address;

  output [data_size-1:0]DM_out;

  reg [data_size-1:0]DM_out;

  // internal
  reg [data_size-1:0]mem_data[mem_size-1:0];
  integer i;
  
  // for test and debug  
//  wire [data_size-1:0]mem_data_0 = mem_data[0];
//  wire [data_size-1:0]mem_data_1 = mem_data[1];
//  wire [data_size-1:0]mem_data_2 = mem_data[2];
  wire [data_size-1:0]mem_data_3 = mem_data[3];
//  wire [data_size-1:0]mem_data_4 = mem_data[4];
//  wire [data_size-1:0]mem_data_5 = mem_data[5];
//  wire [data_size-1:0]mem_data_6 = mem_data[6];
//  wire [data_size-1:0]mem_data_7 = mem_data[7];
//  wire [data_size-1:0]mem_data_8 = mem_data[8];
//  wire [data_size-1:0]mem_data_9 = mem_data[9];
//  wire [data_size-1:0]mem_data_10 = mem_data[10];
//  wire [data_size-1:0]mem_data_11 = mem_data[11];
//  wire [data_size-1:0]mem_data_12 = mem_data[12];
//  wire [data_size-1:0]mem_data_13 = mem_data[13];
//  wire [data_size-1:0]mem_data_14 = mem_data[14];
//  wire [data_size-1:0]mem_data_15 = mem_data[15];
//  wire [data_size-1:0]mem_data_16 = mem_data[16];
//  wire [data_size-1:0]mem_data_17 = mem_data[17];
//  wire [data_size-1:0]mem_data_18 = mem_data[18];
  wire [data_size-1:0]mem_data_19 = mem_data[19];
//  wire [data_size-1:0]mem_data_20 = mem_data[20];
//  wire [data_size-1:0]mem_data_21 = mem_data[21];
//  wire [data_size-1:0]mem_data_22 = mem_data[22];
//  wire [data_size-1:0]mem_data_23 = mem_data[23];
//  wire [data_size-1:0]mem_data_24 = mem_data[24];
//  wire [data_size-1:0]mem_data_25 = mem_data[25];
//  wire [data_size-1:0]mem_data_26 = mem_data[26];
//  wire [data_size-1:0]mem_data_27 = mem_data[27];
  wire [data_size-1:0]mem_data_28 = mem_data[28];
//  wire [data_size-1:0]mem_data_29 = mem_data[29];
//  wire [data_size-1:0]mem_data_30 = mem_data[30];
//  wire [data_size-1:0]mem_data_31 = mem_data[31];
//  wire [data_size-1:0]mem_data_32 = mem_data[32];
//  wire [data_size-1:0]mem_data_33 = mem_data[33];
//  wire [data_size-1:0]mem_data_34 = mem_data[34];
//  wire [data_size-1:0]mem_data_35 = mem_data[35];
//  wire [data_size-1:0]mem_data_36 = mem_data[36];
//  wire [data_size-1:0]mem_data_37 = mem_data[37];
//  wire [data_size-1:0]mem_data_38 = mem_data[38];
//  wire [data_size-1:0]mem_data_39 = mem_data[39];

  always@(posedge clk)
  begin
    if(rst)begin
      for(i=0;i<mem_size;i=i+1)
        mem_data[i]<=0;
        DM_out<=0;
    end
    else if(DM_enable==1)begin
      if(DM_read==1)
        DM_out<=mem_data[DM_address];
      else if(DM_write==1)
        mem_data[DM_address]<=DM_in;
    end
  end

endmodule
