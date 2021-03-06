module regfile(read_data1, read_data2, read_dataT, read_address1, read_address2,
        addressT, write_data, clk, reset, read, write);

  parameter DataSize = 32;
  parameter AddrSize = 5;

  output [DataSize-1:0]read_data1;
  output [DataSize-1:0]read_data2;
  output [DataSize-1:0]read_dataT;

  input [AddrSize-1:0]read_address1;
  input [AddrSize-1:0]read_address2;
  input [AddrSize-1:0]addressT;
  input [DataSize-1:0]write_data;
  input clk, reset, read, write;

  reg [DataSize-1:0]read_data1;
  reg [DataSize-1:0]read_data2;
  reg [DataSize-1:0]read_dataT;
  reg [DataSize-1:0]rw_reg[31:0];
  integer i;

  // for test and debug  
  wire [DataSize-1:0]rw_reg_0 = rw_reg[0];
  wire [DataSize-1:0]rw_reg_1 = rw_reg[1];
  wire [DataSize-1:0]rw_reg_2 = rw_reg[2];
  wire [DataSize-1:0]rw_reg_3 = rw_reg[3];
//  wire [DataSize-1:0]rw_reg_4 = rw_reg[4];
//  wire [DataSize-1:0]rw_reg_5 = rw_reg[5];
//  wire [DataSize-1:0]rw_reg_6 = rw_reg[6];
//  wire [DataSize-1:0]rw_reg_7 = rw_reg[7];
  wire [DataSize-1:0]rw_reg_28 = rw_reg[28];
  wire [DataSize-1:0]rw_reg_29 = rw_reg[29];
  wire [DataSize-1:0]rw_reg_30 = rw_reg[30];
  wire [DataSize-1:0]rw_reg_31 = rw_reg[31];

  always@(posedge clk or posedge reset)begin
    if(reset)begin
      for(i=0;i<32;i=i+1)
        rw_reg[i]<=32'b0;
    end
    else begin
      if(read)begin
        read_data1<=rw_reg[read_address1];
        read_data2<=rw_reg[read_address2];
        read_dataT<=rw_reg[addressT];
      end
      else if(write)begin
        rw_reg[addressT]<=write_data;
      end
      // FIXME
//      else begin
//        read_data1<=32'b0;
//        read_data2<=32'b0;
//      end
    end
  end
endmodule
