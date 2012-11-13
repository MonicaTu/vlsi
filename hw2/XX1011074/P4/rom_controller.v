module rom_controller(rom_pc, rom_initial, ROM_enable, ROM_read, load_im_done, system_enable, clock);

  parameter rom_ir_cnt = 3;
  parameter cycle = 4; // FIXME

  input clock;
  input system_enable;
  input load_im_done;

  output ROM_enable;
  output ROM_read;
  output rom_initial;

  output [7:0]rom_pc;

  // internel
  reg ROM_enable;
  reg ROM_read;
  reg rom_initial;

  reg [7:0]rom_pc;
  reg [127:0]clock_cnt;

  reg ir_cnt = 0;

  parameter rom_size = 1;

  initial begin
    rom_pc <= 0;
    clock_cnt <= 0;
  end
  
  always @ (negedge clock) begin
    clock_cnt = clock_cnt + 1;
    if (clock_cnt % cycle == 0 && load_im_done == 1)
      rom_pc = rom_pc + 1;
    else
      rom_pc = rom_pc;
  end

  always @ (negedge clock) begin
    if (rom_pc == rom_size)
      rom_initial = 0;
    else
      rom_initial = 1;
  end

  always @ (negedge clock) begin
    if (system_enable) begin
      ROM_enable <= 1;
      ROM_read <= 1;
    end
    else begin
      ROM_enable <= 0;
      ROM_read <= 0;
    end
  end

endmodule
