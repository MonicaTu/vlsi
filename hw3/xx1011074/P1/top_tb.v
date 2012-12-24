`define PERIOD 10
//`timscale 1ns/10ps
`include "./IM.v"
`include "./DM.v"
`include "./ROM.v"
`include "./EM.v"

module top_tb();

  //SYSTEM SIGNAL
  reg clk;
  reg rst;
  reg system_enable;
  
  //IM
  wire [31:0] instruction;
  wire IM_read;
  wire IM_write;
  wire IM_enable;
  wire [31:0] IM_in;
  wire [9:0] IM_address;
  
  //DM
  wire [31:0] DM_out;
  wire DM_read;
  wire DM_write;
  wire DM_enable;
  wire [31:0] DM_in;
  wire [14:0] DM_address;
  
  //EM
  wire [31:0] MEM_data;
  wire MEM_en;
  wire MEM_read;
  wire MEM_write;
  wire [31:0] MEM_in;
  wire [15:0] MEM_address;
  
  //ROM
  wire [35:0] rom_out;
  wire rom_enable;
  wire [7:0] rom_address;

  //PERFORMANCE COUNTER
  wire [127:0] cycle_cnt;
  wire [63:0] ins_cnt;
  wire [63:0] load_stall_cnt;
  wire [63:0] branch_stall_cnt;
  
  //I/O interrupt
  reg IO_interrupt;
  
  
  /////////////CPU/////////////
  top TOP1(
  //SYSTEM SIGNAL
  .clk(clk),
  .rst(rst),
  .system_enable(system_enable),
  //IM
  .instruction(instruction),
  .IM_read(IM_read),
  .IM_write(IM_write),
  .IM_enable(IM_enable),
  .IM_in(IM_in),
  .IM_address(IM_address),
  //DM
  .DM_out(DM_out),
  .DM_read(DM_read),
  .DM_write(DM_write),
  .DM_enable(DM_enable),
  .DM_in(DM_in),
  .DM_address(DM_address),
  //EM
  .MEM_data(MEM_data),
  .MEM_en(MEM_en),
  .MEM_read(MEM_read),
  .MEM_write(MEM_write),
  .MEM_in(MEM_in),
  .MEM_address(MEM_address),
  //ROM
  .rom_out(rom_out),
  .rom_enable(rom_enable),
  .rom_address(rom_address),
  //PERFORMANCE COUNTER
  .cycle_cnt(cycle_cnt),
  .ins_cnt(ins_cnt),
  .load_stall_cnt(load_stall_cnt),
  .branch_stall_cnt(branch_stall_cnt),
  //I/O interrupt
  .IO_interrupt(IO_interrupt)
  );
  
  /////////////IM/////////////
  IM IM1(
  .clk(clk),
  .rst(rst),
  .instruction(instruction),
  .IM_read(IM_read),
  .IM_write(IM_write),
  .IM_enable(IM_enable),
  .IM_in(IM_in),
  .IM_address(IM_address)
  );
  
  /////////////DM/////////////
  DM DM1(
  .clk(clk),
  .rst(rst),
  .DM_out(DM_out),
  .DM_read(DM_read),
  .DM_write(DM_write),
  .DM_enable(DM_enable),
  .DM_in(DM_in),
  .DM_address(DM_address)
  );
  
  /////////////EM/////////////
  EM EM1(
  .clk(clk),
  .rst(rst),
  .MEM_data(MEM_data),
  .MEM_en(MEM_en),
  .MEM_read(MEM_read),
  .MEM_write(MEM_write),
  .MEM_in(MEM_in),
  .MEM_address(MEM_address)
  );
  
  /////////////ROM/////////////
  ROM ROM1(
  .clk(clk),
  .rom_out(rom_out),
  .rom_enable(rom_enable),
  .rom_address(rom_address)
  );
  
  //clk gen.
  always #(`PERIOD/2) clk = ~clk;

  initial begin
  	clk = 0;
  	rst = 0;
  	system_enable = 0;
  	IO_interrupt = 0;
  	#1 rst = 1;
  	#(`PERIOD) rst = 0;
  	
    ///////////Function Test//////////
    `ifdef prog1
  	  $readmemb("individual_mem.prog",EM1.EM_REG);
  	  $readmemb("individual_rom.prog",ROM1.ROM_REG);
    `endif
  
    ///////////Sorting Test//////////
    `ifdef prog2
  	  $readmemb("sorting1_mem.prog",EM1.EM_REG);
  	  $readmemb("sorting1_rom.prog",ROM1.ROM_REG);
    `endif
    
    ///////////Fibonacci Test//////////
    `ifdef prog3
  	  $readmemb("fibonacci_mem.prog",EM1.EM_REG);
  	  $readmemb("fibonacci_rom.prog",ROM1.ROM_REG);
    `endif
    
    /////////////Cross Test////////////
    `ifdef prog4
  	  $readmemb("ex_mem.txt",EM1.EM_REG);
  	  $readmemb("rom.txt",ROM1.ROM_REG);
    `endif
 
    ///////////HWII-Part2-P5 Test//////////
    `ifdef mins
  	  $readmemb("mins.prog",EM1.EM_REG);
  	  $readmemb("rom.prog",ROM1.ROM_REG);
    `endif

    `ifdef mins1
  	  $readmemb("mins1.prog",EM1.EM_REG);
  	  $readmemb("rom1.prog",ROM1.ROM_REG);
    `endif

    `ifdef mins2
  	  $readmemb("mins2.prog",EM1.EM_REG);
  	  $readmemb("rom2.prog",ROM1.ROM_REG);
    `endif

    `ifdef mins3
  	  $readmemb("mins3.prog",EM1.EM_REG);
  	  $readmemb("rom3.prog",ROM1.ROM_REG);
    `endif

    `ifdef mins4
  	  $readmemb("mins4.prog",EM1.EM_REG);
  	  $readmemb("rom4.prog",ROM1.ROM_REG);
    `endif

    ///////////Hazard Test//////////
    `ifdef hazard1
  	  $readmemb("hazard1_mem.prog",EM1.EM_REG);
  	  $readmemb("hazard1_rom.prog",ROM1.ROM_REG);
    `endif

    `ifdef hazard2
  	  $readmemb("hazard2_mem.prog",EM1.EM_REG);
  	  $readmemb("hazard2_rom.prog",ROM1.ROM_REG);
    `endif

    `ifdef hazard3
  	  $readmemb("hazard3_mem.prog",EM1.EM_REG);
  	  $readmemb("hazard3_rom.prog",ROM1.ROM_REG);
    `endif

    ///////////Other Test//////////
    `ifdef basic
  	  $readmemb("basic_mem.prog",EM1.EM_REG);
  	  $readmemb("basic_rom.prog",ROM1.ROM_REG);
    `endif

    `ifdef lwsw
  	  $readmemb("lwsw_mem.prog",EM1.EM_REG);
  	  $readmemb("lwsw_rom.prog",ROM1.ROM_REG);
    `endif
  	
    system_enable = 1;
  	#(`PERIOD) system_enable = 0;
  	#1100
  	
  	$display("cycle_cnt=%d",cycle_cnt);
  	$display("ins_cnt=%d",ins_cnt);
  	$display("load_stall_cnt=%d",load_stall_cnt);
  	$display("branch_stall_cnt=%d",branch_stall_cnt);
  	
  	$display("\n");
    $display("\n");
    $display("        ****************************              ");
    $display("        **                        **        /|__/|");
    $display("        **  Congratulations !!    **      / O,O  |");
    $display("        **                        **    /_____   |");
    $display("        **  Simulation Complete!! **   /^ ^ ^ \\  |");
    $display("        **                        **  |^ ^ ^ ^ |w|");
    $display("        *************** ************   \\m___m__|_|");
    $display("\n");
  	$finish;
  end
  
  initial begin
  `ifdef FSDB
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars;
  `endif
  `ifdef VCD
    $dumpfile("top.vcd");
    $dumpvars;
  `endif
  end
  
endmodule
