module mem_controller(total_ir, eop, ir_enable, load_im_done, im_enable, im_en_read, im_en_write, im_addr, mem_enable, mem_en_read, mem_en_write, mem_addr, rom_ir, reset, clock);

  parameter im_start = 'h80;
  
  // state
  parameter stopState = 2'b00, resetState = 2'b01, loadState = 2'b10;

  // TODO: DM
  input clock;
  input reset;
  input [35:0]rom_ir;
  
  output im_enable;
  output im_en_read;
  output im_en_write;
  output [9:0]im_addr;

  output mem_enable;
  output mem_en_read; 
  output mem_en_write; 
  output [13:0]mem_addr;

  output eop; 
  output load_im_done; 
  output ir_enable; 
  output [15:0]total_ir;

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
  
//  reg [127:0]clock_cnt;
  reg load_im_done;
  reg ir_enable;
  reg eop; 
  
  // internal 
  reg [2:0] current_state;
  reg [2:0] next_state;
  
  assign total_ir = ir_size >> 5;

  always @(posedge clock)
  begin
    if(reset)
      current_state <= stopState;
    else
      current_state <= next_state;
  end
  
  always @(current_state) begin
    case(current_state)
      stopState: begin
        next_state = resetState;
//        im_reset = 0;
        im_enable = 0;
        im_en_read = 0;
        im_en_write = 0;
        mem_enable = 0;
        mem_en_read = 0;
        mem_en_write = 0;
      end
      resetState: begin
        next_state = loadState;
        if (ir_select == 0) begin // IM
//          im_reset = 1;
          im_enable = 0;
          im_en_read = 0;
          im_en_write = 0;
          mem_enable = 0;
          mem_en_read = 0;
          mem_en_write = 0;
        end else begin // DM
//          im_reset = 0;
          im_enable = 0;
          im_en_read = 0;
          im_en_write = 0;
          mem_enable = 0;
          mem_en_read = 0;
          mem_en_write = 0;
        end
      end
      loadState: begin
        next_state = stopState;
        if (ir_select == 0) begin // IM
//          im_reset = 0;
          im_enable = 1;
          im_en_read = 0;
          im_en_write = 1;
          mem_enable = 1;
          mem_en_read = 1;
          mem_en_write = 0;
        end else begin // DM
//          im_reset = 0;
          im_enable = 0;
          im_en_read = 0;
          im_en_write = 0;
          mem_enable = 1;
          mem_en_read = 1;
          mem_en_write = 0;
        end
      end
      default: begin
        next_state = stopState;
//        im_reset = 0;
        im_enable = 0;
        im_en_read = 0;
        im_en_write = 0;
        mem_enable = 0;
        mem_en_read = 0;
        mem_en_write = 0;
      end
    endcase
  end
  
  always @ (reset or im_en_write) begin
    if (reset) begin
      im_addr <= im_start;
      mem_addr <= 0; 
    end else begin
      if (im_en_write) begin
        im_addr <= im_addr + 4;
        mem_addr <= mem_addr + 1;
      end else begin
        im_addr <= im_addr;
        mem_addr <= mem_addr;
      end
    end
  end
  
  always @ (posedge clock) begin
    if (reset) begin
      load_im_done = 0;
    end else begin
      if (((im_addr - im_start) << (5-2)) > ir_size)
        load_im_done = 1;
      else
        load_im_done = load_im_done;
    end
  end
  
  always @ (reset or ir_en) begin
    if (reset) begin
      ir_enable = 0;
    end else begin
      if (ir_en)
        ir_enable = 1;
      else
        ir_enable = 0;
    end
  end

  always @ (reset or rom_ir) begin
    if (reset) begin
      eop = 0;
    end else begin
      if (rom_ir == 0)
        eop = 1;
      else
        eop = eop;
    end
  end

endmodule
