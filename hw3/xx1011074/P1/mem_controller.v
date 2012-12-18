module mem_controller(rom_done, rom_enable, rom_addr, im_enable, im_en_read, im_en_write, im_addr, mem_enable, mem_en_read, mem_en_write, mem_addr, rom_ir, system_enable, reset, clock);

  parameter im_start = 'h80;
  
  // state
  parameter stopState = 3'b000, pcState = 3'b001, fetchIrState = 3'b010, rstState = 3'b011, enState = 3'b100, readState = 3'b101, cpuState = 3'b110;

  // TODO: DM
  input clock;
  input reset;
  input system_enable;
  input [35:0]rom_ir;

  output rom_enable;
  output [7:0]rom_addr;
  output rom_done;
  
  output im_enable;
  output im_en_read;
  output im_en_write;
  output [9:0]im_addr;

  output mem_enable;
  output mem_en_read; 
  output mem_en_write; 
  output [15:0]mem_addr;


  // internal
  reg rom_enable;
  reg [7:0]rom_addr;
  reg rom_done;

  reg im_enable;
  reg im_en_read;
  reg im_en_write;
  reg [9:0]im_addr;

  reg mem_enable;
  reg mem_en_read; 
  reg mem_en_write; 
  reg [15:0]mem_addr; 

  wire ir_rst    = present_rom_ir[35];
  wire ir_en     = present_rom_ir[34];
  wire ir_select = present_rom_ir[33];
  wire ir_read   = present_rom_ir[32];
  wire [15:0]ir_start_address = present_rom_ir[31:16];
  wire [15:0]ir_size = present_rom_ir[15:0];

  reg [15:0]size;
  
  // internal 
  reg [3:0] current_state;
  reg [35:0]present_rom_ir;
  
  always @ (posedge clock) begin
    case (current_state)
    stopState: // S0
      if (system_enable == 1)
        current_state <= pcState;
      else
        current_state <= stopState;

    pcState:  // S1
        current_state = fetchIrState;
    
    fetchIrState: // S2
//      if (present_rom_ir == 32'b0)
//        current_state <= cpuState;
//      else
        current_state <= rstState;

    rstState: // S3
      if (ir_rst == 1)
        current_state <= pcState;
      else
        current_state <= enState;

    enState: // S4
      if (rom_ir == 32'b0) // FIXME
        current_state <= cpuState;
      else begin
      if (ir_en == 1)
        current_state <= readState;
      else
        current_state <= stopState; // FIXME: should not be here.
      end

    readState: // S5
      if (size == 0)
        current_state <= pcState;
      else
        current_state <= readState;

    cpuState: // S6
      current_state <= cpuState;

    default:
      current_state <= stopState;
    endcase
  end
  
  always @ (posedge clock) begin
    if (reset) begin
      present_rom_ir = 32'b0;
      size = 0;
      rom_done <= 0;
      rom_addr <= 0;
      rom_enable <= 0;
      im_enable <= 0;
      im_en_read <= 0;
      im_en_write <= 0;
      im_addr <= 0;
      mem_enable <= 0;
      mem_en_read <= 0;
      mem_en_write <= 0;
      mem_addr <= 0;
    end
    else
    case(current_state)
      stopState: begin
        size <= 0;
        rom_done <= 0;
        rom_enable <= 1;
        rom_addr <= 0;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= im_addr;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= mem_addr;
      end
      pcState: begin
        size <= 0;
        rom_done <= 0;
        rom_enable <= 1;
        rom_addr <= rom_addr + 8'b1;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= im_addr;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= mem_addr;
      end
      fetchIrState: begin
        present_rom_ir <= rom_ir;
        size <= 0;
        rom_done <= 0;
        rom_enable <= 1;
        rom_addr <= rom_addr;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= im_addr; 
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= mem_addr;
      end
      rstState: begin
        size <= 0;
        rom_done <= 0;
        rom_addr <= rom_addr;
        rom_enable <= 1;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= im_addr;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= mem_addr;
      end
      enState: begin
        size <= present_rom_ir[15:0]; 
        rom_done <= 0;
        rom_enable <= 1;
        rom_addr <= rom_addr;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= 10'h80;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= present_rom_ir[31:16]; 
      end
      readState: begin
        size <= size - 16'b1; 
        rom_done <= 0;
        rom_addr <= rom_addr;
        rom_enable <= 1;
        mem_enable <= 1;
        mem_en_read <= 1;
        mem_en_write <= 0;
        mem_addr <= mem_addr + 16'b1;
        if (ir_select == 0) begin // IM
          im_enable <= 1;
          im_en_read <= 0;
          im_en_write <= 1;
          im_addr <= im_addr + 10'b1;
        end else begin // DM
          im_enable <= 0;
          im_en_read <= 0;
          im_en_write <= 0;
          im_addr <= im_addr;
          // TODO
//          dm_enable <= 0;
//          dm_en_read <= 0;
//          dm_en_write <= 0;
//          dm_addr <= dm_addr + 10'b1;
        end
      end
      cpuState: begin
        size <= 0; 
        rom_done <= 1;
        rom_enable <= 0;
        rom_addr <= 0;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= im_addr;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= mem_addr;
      end
      default: begin
        size <= 0; 
        rom_done <= 0;
        rom_enable <= 0;
        rom_addr <= 0;
        im_enable <= 0;
        im_en_read <= 0;
        im_en_write <= 0;
        im_addr <= im_addr;
        mem_enable <= 0;
        mem_en_read <= 0;
        mem_en_write <= 0;
        mem_addr <= mem_addr;
      end
    endcase
  end

endmodule
