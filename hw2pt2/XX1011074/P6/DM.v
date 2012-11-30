module DM(clk, rst, enable_fetch, enable_writeback, enable_mem, DMin, DMout, DM_address);

  parameter DataSize=32;
  parameter mem_size=4096;
  
  input clk;
  input rst;
  input enable_fetch;
  input enable_writeback;
  input enable_mem;
  input [DataSize-1:0]DMin;
  input [11:0]DM_address;
  output [DataSize-1:0]DMout;
  reg [DataSize-1:0]DMout;
  reg [DataSize-1:0]mem_data[mem_size-1:0];
  
  integer i;
  
  // for test and debug  
//  wire [DataSize-1:0]mem_data_0 = mem_data[0];
//  wire [DataSize-1:0]mem_data_1 = mem_data[1];
//  wire [DataSize-1:0]mem_data_2 = mem_data[2];
//  wire [DataSize-1:0]mem_data_3 = mem_data[3];
//  wire [DataSize-1:0]mem_data_4 = mem_data[4];
//  wire [DataSize-1:0]mem_data_5 = mem_data[5];
//  wire [DataSize-1:0]mem_data_6 = mem_data[6];
//  wire [DataSize-1:0]mem_data_7 = mem_data[7];
//  wire [DataSize-1:0]mem_data_8 = mem_data[8];
//  wire [DataSize-1:0]mem_data_9 = mem_data[9];
//  wire [DataSize-1:0]mem_data_10 = mem_data[10];
//  wire [DataSize-1:0]mem_data_11 = mem_data[11];
//  wire [DataSize-1:0]mem_data_12 = mem_data[12];
//  wire [DataSize-1:0]mem_data_13 = mem_data[13];
//  wire [DataSize-1:0]mem_data_14 = mem_data[14];
//  wire [DataSize-1:0]mem_data_15 = mem_data[15];
//  wire [DataSize-1:0]mem_data_16 = mem_data[16];
//  wire [DataSize-1:0]mem_data_17 = mem_data[17];
//  wire [DataSize-1:0]mem_data_18 = mem_data[18];
//  wire [DataSize-1:0]mem_data_19 = mem_data[19];
//  wire [DataSize-1:0]mem_data_20 = mem_data[20];
//  wire [DataSize-1:0]mem_data_21 = mem_data[21];
//  wire [DataSize-1:0]mem_data_22 = mem_data[22];
//  wire [DataSize-1:0]mem_data_23 = mem_data[23];
//  wire [DataSize-1:0]mem_data_24 = mem_data[24];
//  wire [DataSize-1:0]mem_data_25 = mem_data[25];
//  wire [DataSize-1:0]mem_data_26 = mem_data[26];
//  wire [DataSize-1:0]mem_data_27 = mem_data[27];
  wire [DataSize-1:0]mem_data_28 = mem_data[28];
//  wire [DataSize-1:0]mem_data_29 = mem_data[29];
//  wire [DataSize-1:0]mem_data_30 = mem_data[30];
//  wire [DataSize-1:0]mem_data_31 = mem_data[31];
//  wire [DataSize-1:0]mem_data_32 = mem_data[32];
//  wire [DataSize-1:0]mem_data_33 = mem_data[33];
//  wire [DataSize-1:0]mem_data_34 = mem_data[34];
//  wire [DataSize-1:0]mem_data_35 = mem_data[35];
//  wire [DataSize-1:0]mem_data_36 = mem_data[36];
//  wire [DataSize-1:0]mem_data_37 = mem_data[37];
//  wire [DataSize-1:0]mem_data_38 = mem_data[38];
//  wire [DataSize-1:0]mem_data_39 = mem_data[39];

  always@(posedge clk)
  begin
    if(rst)begin
      for(i=0;i<mem_size;i=i+1)
        mem_data[i]<=0;
        DMout<=0;
    end
    else if(enable_mem==1)begin
      if(enable_fetch==1)
        DMout<=mem_data[DM_address];
      else if(enable_writeback==1)
        mem_data[DM_address]<=DMin;
    end
  end

endmodule
