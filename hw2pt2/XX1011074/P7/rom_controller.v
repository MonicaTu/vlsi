module rom_controller(rom_done, rom_pc, ROM_enable, ROM_read, Ins_cnt, eop, exe_ir_done, load_im_done, rom_ctrl_reset, system_enable);

  parameter InsSize = 64;
  
  // state
  parameter stopState = 1'b0, readState = 1'b1;

  input reset;
  input system_enable;
  input load_im_done;
  input exe_ir_done;
  input eop;
  input [InsSize-1:0] Ins_cnt;

  output ROM_enable;
  output ROM_read;
//  output rom_initial;
  output rom_done;

  output [7:0]rom_pc;

  // internel
  reg ROM_enable;
  reg ROM_read;
//  reg rom_initial;
  reg rom_done;

  reg [7:0]rom_pc;
//  reg [127:0]clock_cnt;

//  parameter rom_size = 1;

//  initial begin
//    rom_pc <= 0;
//    clock_cnt <= 0;
//    rom_initial <= 1;
//  end
  
  reg [2:0] current_state;
  reg [2:0] next_state;
  
  always @(posedge clock)
  begin
    if(system_enable)
      current_state <= next_state;
    else
      current_state <= stopState;
  end
  
  always @(current_state) begin
    case(current_state)
      stopState: begin
        next_state = readState;
        ROM_enable = 0;
        ROM_read = 0;
      end
      readState: begin
        next_state = stopState;
        ROM_enable = 1;
        ROM_read = 1;
      end
    endcase
  end

  always @ (reset, load_im_done) begin
    if (reset) begin
      rom_pc = 0;
    end else begin
      if (load_im_done)
        rom_pc = rom_pc + 1;
      else
        rom_pc = rom_pc;
    end
  end

  always @ (reset, exe_ir_done) begin
    if (reset) begin
      rom_pc = 0;
    end else begin
      if (exe_ir_done)
        rom_pc = rom_pc + 1;
      else
        rom_pc = rom_pc;
    end
  end

  always @ (reset, eop) begin
    if (reset) begin
        rom_done = 0; 
    end else begin
      if (eop)
        rom_done = 1; 
      else
        rom_done = rom_done; 
    end
  end

//  always @ (posedge clock) begin
//    if (rom_pc > rom_size) begin
//      rom_initial = 0;
//      rom_done = 1;
//    end else begin
//      rom_initial = 1;
//      rom_done = 0;
//    end
//  end

//  always @ (posedge clock) begin
//    if (system_enable) begin
//      ROM_enable <= 1;
//      ROM_read <= 1;
//    end else begin
//      ROM_enable <= 0;
//      ROM_read <= 0;
//    end
//  end

endmodule
