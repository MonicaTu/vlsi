module mem_controller(im_enable, im_en_read, im_en_write, im_addr, mem_enable, mem_en_read, mem_en_write, mem_addr, rom_ir, clock);

  // TODO: DM
  input clock;
  input [35:0]rom_ir;
  
  output im_enable;
  output im_en_read;
  output im_en_write;
  output [12:0]im_addr;

  output mem_enable;
  output mem_en_read; 
  output mem_en_write; 
  output [12:0]mem_addr; 

  // internal
  reg im_enable;
  reg im_en_read;
  reg im_en_write;
  reg [12:0]im_addr;

  reg mem_enable;
  reg mem_en_read; 
  reg mem_en_write; 
  reg [12:0]mem_addr; 

  wire ir_rst    = rom_ir[35];
  wire ir_en     = rom_ir[34];
  wire ir_select = rom_ir[33];
  wire ir_read   = rom_ir[32];
  wire ir_start_address = rom_ir[31:16];
  wire ir_size   = rom_ir[15:0];

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
