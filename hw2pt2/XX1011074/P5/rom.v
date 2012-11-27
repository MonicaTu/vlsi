module rom(clk, read, enable, address, dout);

parameter data_size=37;
parameter mem_size=256;

input clk, read, enable;
input [7:0]address;

output [data_size-1:0]dout;

reg [data_size-1:0]dout;
reg [data_size-1:0]mem_data[mem_size-1:0];

// for test
wire [data_size-1:0]rom_mem_data_0 = mem_data[0];
wire [data_size-1:0]rom_mem_data_1 = mem_data[1];
wire [data_size-1:0]rom_mem_data_2 = mem_data[2];
wire [data_size-1:0]rom_mem_data_3 = mem_data[3];
wire [data_size-1:0]rom_mem_data_4 = mem_data[4];


always@(posedge clk)begin
  if(enable)begin
    if(read)begin
      dout<=mem_data[address];
      #1; // FIXME: workaround for time delay
    end
  end
end

endmodule
