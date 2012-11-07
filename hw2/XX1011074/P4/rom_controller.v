module rom_controller(cycle, ROM_enable, ROM_read, system_enable, clock);

  input clock;
  input system_enable;

  output ROM_enable;
  output ROM_read;
  output [2:0]cycle;

  // internel
  reg ROM_enable;
  reg ROM_read;
  reg cycle;

  always @ (negedge clock) begin
    if (system_enable) begin
      ROM_enable <= 1;
      ROM_read <= 1;
      cycle <= 'd4; // FIXME
    end
    else begin
      ROM_enable <= 0;
      ROM_read <= 0;
      cycle <= 'd4; // FIXME
    end
  end

endmodule
