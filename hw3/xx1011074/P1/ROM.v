module ROM(clk, rom_enable, rom_address, rom_out);

parameter data_size=36;
parameter address_size=8;
parameter mem_size=(2**address_size);

input clk, rom_enable;
input [address_size-1:0]rom_address;

output [data_size-1:0]rom_out;

reg [data_size-1:0]rom_out;

// internal
reg [data_size-1:0]mem_data[mem_size-1:0];

// for test
wire [data_size-1:0]rom_mem_data_0 = mem_data[0];
wire [data_size-1:0]rom_mem_data_1 = mem_data[1];
wire [data_size-1:0]rom_mem_data_2 = mem_data[2];
wire [data_size-1:0]rom_mem_data_3 = mem_data[3];
wire [data_size-1:0]rom_mem_data_4 = mem_data[4];


always@(posedge clk)begin
  if(rom_enable)begin
      rom_out<=mem_data[rom_address];
      #1; // FIXME: workaround for time delay
  end
end

endmodule
