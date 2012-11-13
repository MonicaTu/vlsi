module mem_controller(load_im_done, im_enable, im_en_read, im_en_write, im_addr, mem_enable, mem_en_read, mem_en_write, mem_addr, rom_ir, rom_initial, reset, clock);

  parameter cycle = 1; // FIXME
  parameter im_start = 'h80; // FIXME

  // TODO: DM
  input clock;
  input reset;
  input rom_initial; // FIXME
  input [35:0]rom_ir;
  
  output im_enable;
  output im_en_read;
  output im_en_write;
  output [9:0]im_addr;

  output mem_enable;
  output mem_en_read; 
  output mem_en_write; 
  output [13:0]mem_addr; // TODO

  output load_im_done; 

  // internal
  reg im_enable;
  reg im_en_read;
  reg im_en_write;
  reg [9:0]im_addr;

  reg mem_enable;
  reg mem_en_read; 
  reg mem_en_write; 
  reg [13:0]mem_addr; 

  wire ir_rst    = rom_ir[35];
  wire ir_en     = rom_ir[34];
  wire ir_select = rom_ir[33];
  wire ir_read   = rom_ir[32];
  wire [15:0]ir_start_address = rom_ir[31:16];
  wire [15:0]ir_size = rom_ir[15:0];
  
  // internal 
  reg [127:0]clock_cnt;
  reg load_im_done;

  always @ (negedge clock) begin
    if (reset)
      clock_cnt <= 1;
    else
      clock_cnt <= clock_cnt + 1; 
  end

  always @ (negedge clock) begin
    if (reset) begin
      im_addr <= im_start;
      mem_addr <= 0; 
      load_im_done <= 0;
    end else begin
      if (clock_cnt % cycle == 0) begin
        im_addr <= im_addr + 1;
        mem_addr <= mem_addr + 1;
      end else begin
        im_addr <= im_addr;
        mem_addr <= mem_addr;
      end
    end
  end
  
  always @ (negedge clock) begin
    if (((im_addr - im_start) << 5) == ir_size) 
      load_im_done <= 1;
    else
      load_im_done <= 0;
  end

  always @ (negedge clock) begin
    if (ir_rst) begin
      if (ir_select == 0) begin // reset IM
//        im_reset <= 1;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
      end else begin  // reset DM
//        im_reset <= 0;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
      end
    end else begin // load
      if (ir_select == 0) begin // load IM
//        im_reset <= 0;
        im_enable <= 1;
        im_en_read <= 0;
        im_en_write <= 1;
        mem_enable <= 1;
        mem_en_read <= 1;
        mem_en_write <= 0;
      end else begin // load DM
//        im_reset <= 0;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        mem_enable <= 1;
        mem_en_read <= 1;
        mem_en_write <= 0;
      end
    end
  end

endmodule
