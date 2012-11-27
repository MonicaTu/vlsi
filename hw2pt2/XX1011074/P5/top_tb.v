`include "DM.v"
`include "IM.v"
`include "rom.v"
`include "memory.v"

`define PERIOD 10
`define IR_CYCLE 8

module top_tb;

  parameter DataSize = 32;
  parameter AddrSize = 5;

  reg clk,rst;
  reg system_enable;
 
  integer i;
   
  wire [31:0]instruction;
  wire [DataSize-1:0] DM_out;
    
  //ROM
  wire [36:0] rom_out;
  wire rom_enable, rom_read;
  wire [7:0] rom_address;
  wire [31:0] IM_in;

  //IM 
  wire IM_enable;


  //DM
  wire DM_enable;

  //MEM
  wire MEM_en;
  wire MEM_read;
  wire MEM_write;
  wire [15:0] MEM_addr;
  wire [31:0] MEM_data;
  
  //IM
  wire IM_read, IM_write;
  wire [9:0] IM_address;
   
  //DM
  wire DM_read;
  wire DM_write;
  wire [31:0] DM_in;
  wire [11:0] DM_address;
  
  //performance counter
  wire [127:0] cycle_cnt;
  wire [63:0] ins_cnt;
 
  top TOP(.clk(clk)
  			, .rst(rst)
  			, .instruction(instruction)
  			, .DM_out(DM_out)
  			, .rom_out(rom_out)
  			, .system_enable(system_enable)
  			, .rom_enable(rom_enable)
  			, .rom_read(rom_read)
  			, .rom_address(rom_address)
  			, .MEM_en(MEM_en)
  			, .MEM_read(MEM_read)
  			, .MEM_write(MEM_write)
  			, .MEM_addr(MEM_addr)
  			, .MEM_data(MEM_data)
  			, .IM_read(IM_read)
  			, .IM_write(IM_write)
  			, .IM_in(IM_in)
  			, .IM_enable(IM_enable)
  			, .IM_address(IM_address)
        , .DM_read(DM_read)
        , .DM_write(DM_write)
        , .DM_enable(DM_enable)
        , .DM_in(DM_in)
        , .DM_address(DM_address)
        , .cycle_cnt(cycle_cnt)
        , .ins_cnt(ins_cnt)
        ); 
 
  DM DM1(.clk(clk)
  		 , .rst(rst)
  		 , .enable_fetch(DM_read)
  		 , .enable_writeback(DM_write)
  		 , .enable_mem(DM_enable)
  		 , .DMin(DM_in)
  		 , .DMout(DM_out)
  		 , .DM_address(DM_address)
  		 );

  IM IM1(.clk(clk)
  		 , .rst(rst)
  		 , .IM_address(IM_address)
  		 , .enable_fetch(IM_read)
  		 , .enable_write(IM_write)
  		 , .enable_mem(IM_enable)
  		 , .IMin(IM_in)
  		 , .IMout(instruction)
  		 ); 
  
  rom ROM1(.clk(clk)
  			 , .read(rom_read)
  			 , .enable(rom_enable)
  			 , .address(rom_address)
  			 , .dout(rom_out)
  			 );
   
  memory MEM1( .clk(clk)
  					 , .rst(rst)
  					 , .enable(MEM_en)
  					 , .read(MEM_read)
  					 , .write(MEM_write)
  					 , .address(MEM_addr)
  					 , .Din(32'd0)
  					 , .Dout(MEM_data) 
  					 );
  
  
  `ifdef syn
  //post_syn simulation
    initial $sdf_annotate("top_syn.sdf", TOP);
  `endif
  
  
  //clock gen.
  always #5 clk=~clk;

  initial begin
  clk=0;
  rst=1'b0;
  system_enable = 1'b0;

  #5 rst=1'b1; 
  #5 rst=1'b0;
    	
  //load verification program here
  `ifdef prog 
  		  //verification program 1
        $readmemb("rom.prog", ROM1.mem_data);
        $readmemb("mins.prog", MEM1.mem);
  `endif
  
  `ifdef prog1
  		  //verification program 1
        $readmemb("rom1.prog", ROM1.mem_data);
        $readmemb("mins1.prog", MEM1.mem);
  `endif
  
  `ifdef prog2
  		  //verification program 2
        $readmemb("rom2.prog", ROM1.mem_data);
        $readmemb("mins2.prog", MEM1.mem);
  `endif

  #5 system_enable = 1'b1;
      
  #(`PERIOD*(18)); // for boot
  #(`PERIOD*`IR_CYCLE*(19)); // for instructions
			
      $display("**************************END OF SIMULATION****************************");
    
      for( i=128;i<180;i=i+1 ) $display( "IM[%h]=%h",i,IM1.mem_data[i] );  
      for( i=0;i<40;i=i+1 ) $display( "DM[%d]=%d",i,DM1.mem_data[i] );
      
      $display("Cycle Count=%d\nInstruction Count=%d",cycle_cnt,ins_cnt);
      $finish;
  end

//  always@(negedge clk)begin
//    if( (instruction == 32'd0) && (TOP.rom_done == 1'b1) && (IM_address != 30'h80))begin 
//      $display("**************************END OF SIMULATION****************************");
//    
//      for( i=128;i<180;i=i+1 ) $display( "IM[%h]=%h",i,IM1.mem_data[i] );  
//      for( i=0;i<40;i=i+1 ) $display( "DM[%d]=%d",i,DM1.mem_data[i] );
//      
//      $display("Cycle Count=%d\nInstruction Count=%d",cycle_cnt,ins_cnt);
//      $finish;
//    end
//  end
  
  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars;
//  $fsdbDumpfile("top.fsdb");
//  $fsdbDumpvars(0, top_tb);
  end
  
endmodule
