module ROM(clk, read, enable, address, dout);

parameter data_size=36;
parameter mem_size=256;

input clk, read, enable;
input [7:0]address;

output [data_size-1:0]dout;

reg [data_size-1:0]dout;
reg [data_size-1:0]mem_data[mem_size-1:0];

always@(posedge clk)begin
  if(enable)begin
    if(read)begin
      dout<=mem_data[address];
    end
  end
end

endmodule
