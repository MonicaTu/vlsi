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

  `ifdef prog
  initial begin
//    clk = 0;
//    rst = 0;
//    #1 rst = 1;
//    #(`PERIOD) rst = 0;
  	clk = 0;
  	rst = 1;
  	#(`PERIOD/2) rst = 0;
  	$readmemb("mins.prog",IM1.mem_data);
  	#1100;
    $finish;
  end
  `endif
  
  ///////////Function Test//////////
  `ifdef prog1
  initial begin
  	clk = 0;
  	rst = 0;
  	system_enable = 0;
  	IO_interrupt = 0;
  	#1 rst = 1;
  	#(`PERIOD) rst = 0;
  	
  	$readmemb(/*your test program path*/,EM1.EM_REG);
  	$readmemb(/*your test program path*/,ROM1.ROM_REG);
  	
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
  `endif
  
  ///////////Sorting Test//////////
  `ifdef prog2
  initial begin
    /*...*/	
  end
  `endif
  
  ///////////Fibonacci Test//////////
  `ifdef prog3
  initial begin
    /*...*/	
  end
  `endif
  
  /////////////Cross Test////////////
  `ifdef prog4
  initial begin
    /*...*/	
  end
  `endif
 
  
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
