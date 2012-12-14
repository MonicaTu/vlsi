module ROM(clk, rom_enable, rom_address, rom_out);

parameter data_size=36;
parameter address_size=8;
parameter mem_size=(2**address_size);

input clk, rom_enable;
input [address_size-1:0]rom_address;

output [data_size-1:0]rom_out;

reg [data_size-1:0]rom_out;

// internal
reg [data_size-1:0]ROM_REG[mem_size-1:0];

// for test
wire [data_size-1:0]ROM_REG_0 = ROM_REG[0];
wire [data_size-1:0]ROM_REG_1 = ROM_REG[1];
wire [data_size-1:0]ROM_REG_2 = ROM_REG[2];
wire [data_size-1:0]ROM_REG_3 = ROM_REG[3];
wire [data_size-1:0]ROM_REG_4 = ROM_REG[4];


always@(posedge clk)begin
  if(rom_enable)begin
      rom_out<=ROM_REG[rom_address];
      #1; // FIXME: workaround for time delay
  end
end

endmodule
