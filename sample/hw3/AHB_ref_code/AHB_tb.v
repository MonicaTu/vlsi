`define PERIOD 10
//`define TEST1
`define TEST2
//`define TEST3
`define FSDB
`include "AHB.v"
`include "Arbiter.v"
`include "Decoder.v"
`include "MuxM2S.v"
`include "MuxS2M.v"
`timescale 1ns/10ps
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
  // HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11
  
  // HBURST transfer type signal encoding
  `define BUR_SINGLE 3'b000
  `define BUR_INCR   3'b001
  `define BUR_WRAP4  3'b010
  `define BUR_INCR4  3'b011
  `define BUR_WRAP8  3'b100
  `define BUR_INCR8  3'b101
  `define BUR_WRAP16 3'b110
  `define BUR_INCR16 3'b111
  
  // HRESP transfer response signal encoding
  `define RSP_OKAY   2'b00
  `define RSP_ERROR  2'b01
  `define RSP_RETRY  2'b10
  `define RSP_SPLIT  2'b11
  
  // Slave Address code
  `define S1_SELECTED 4'h1
  `define S2_SELECTED 4'h2
  `define S3_SELECTED 4'h3
  `define S4_SELECTED 4'h4
  `define S5_SELECTED 4'h5

module AHB_tb;

reg         HCLK;  // External clock in
reg         HRESETn;  // Power on reset reg

//--------------------------------------
// AHB Signals Declaration
//--------------------------------------
wire  [1:0] HTRANS;  
wire [31:0] HADDR;   
wire        HWRITE;  
wire  [2:0] HSIZE;   
wire [31:0] HWDATA;  

// Multiplexed slave wire signals
wire [31:0] HRDATA;  
wire        HREADY;  
wire  [1:0] HRESP;   

// Slave specific wire signals
//S1
wire        HSEL_S1;   
reg  [31:0] HRDATA_S1; 
reg         HREADY_S1; 
reg   [1:0] HRESP_S1;  
//S2
wire        HSEL_S2;   
reg  [31:0] HRDATA_S2; 
reg         HREADY_S2; 
reg   [1:0] HRESP_S2;  


// Master specific signals
//M1
reg  [31:0] HADDR_M1;   
reg   [1:0] HTRANS_M1;  
reg         HWRITE_M1;  
reg   [2:0] HSIZE_M1;   
reg  [31:0] HWDATA_M1;  
reg         HBUSREQ_M1; 
reg         HLOCK_M1;   
wire        HGRANT_M1;  
//M2              
reg  [31:0] HADDR_M2;   
reg   [1:0] HTRANS_M2;  
reg         HWRITE_M2;  
reg   [2:0] HSIZE_M2;   
reg  [31:0] HWDATA_M2;  
reg         HBUSREQ_M2; 
reg         HLOCK_M2;   
wire        HGRANT_M2;  


//--------------------------------------
// AHB Module
//--------------------------------------

 AHB AHB1(  .HCLK(HCLK),   
       .HRESETn(HRESETn),
       // AHB Signals
       .HTRANS(HTRANS),
       .HADDR(HADDR),
       .HWRITE(HWRITE),
       .HSIZE(HSIZE),
       .HWDATA(HWDATA),
       // Multiplexed slave wire signals
       .HRDATA(HRDATA),
       .HREADY(HREADY),
       .HRESP(HRESP), 
       // Slave specific wire signals
       //S1
       .HSEL_S1(HSEL_S1),  
       .HRDATA_S1(HRDATA_S1),
       .HREADY_S1(HREADY_S1),
       .HRESP_S1(HRESP_S1),
       //S2
       .HSEL_S2(HSEL_S2),  
       .HRDATA_S2(HRDATA_S2),
       .HREADY_S2(HREADY_S2),
       .HRESP_S2(HRESP_S2),
       // Master specific signals
       //M1
       .HADDR_M1(HADDR_M1),  
       .HTRANS_M1(HTRANS_M1), 
       .HWRITE_M1(HWRITE_M1), 
       .HSIZE_M1(HSIZE_M1),  
       .HWDATA_M1(HWDATA_M1), 
       .HBUSREQ_M1(HBUSREQ_M1),
       .HLOCK_M1(HLOCK_M1),  
       .HGRANT_M1(HGRANT_M1),
       //M2
       .HADDR_M2(HADDR_M2),  
       .HTRANS_M2(HTRANS_M2), 
       .HWRITE_M2(HWRITE_M2), 
       .HSIZE_M2(HSIZE_M2),  
       .HWDATA_M2(HWDATA_M2), 
       .HBUSREQ_M2(HBUSREQ_M2),
       .HLOCK_M2(HLOCK_M2),  
       .HGRANT_M2(HGRANT_M2) );

//--------------------------------------
// AHB Signals Initialization
//--------------------------------------
  //HCLK
  always #(`PERIOD/2) HCLK = ~HCLK;
  //AHB Signals
  initial begin
    HRESETn = 1;
	  HCLK = 1;
	// Master specific signals
    //M1
    HADDR_M1 = 0;   
    HTRANS_M1 = 0;  
    HWRITE_M1 = 0;  
    HSIZE_M1 = 0;   
    HWDATA_M1 = 0;  
    HBUSREQ_M1 = 0; 
    HLOCK_M1 = 0;   
    //M2              
    HADDR_M2 = 0;   
    HTRANS_M2 = 0;  
    HWRITE_M2 = 0;  
    HSIZE_M2 = 0;   
    HWDATA_M2 = 0;  
    HBUSREQ_M2 = 0; 
    HLOCK_M2 = 0;   
	
	// Slave specific wire signals
    //S1
    HRDATA_S1 = 0; 
    HREADY_S1 = 1; 
    HRESP_S1 = 0;  
    //S2
    HRDATA_S2 = 0; 
    HREADY_S2 = 1; 
    HRESP_S2 = 0;  
	
	#(`PERIOD) HRESETn = 0;
	#(`PERIOD) HRESETn = 1;
  end

//--------------------------------------
// AHB MASTER FUNCTION TEST
//--------------------------------------  
`ifdef TEST1
// AHB Signals MASTER
//M1
  initial begin
    #(`PERIOD*3+1) HBUSREQ_M1 = 1; HLOCK_M1 = 1;
    #(`PERIOD)
        HBUSREQ_M1 = 0;
        HADDR_M1 = {`S1_SELECTED,28'd4};
        HTRANS_M1 = `TRN_NONSEQ;
        HWRITE_M1 = 1;
        HLOCK_M1 = 0;
        HWDATA_M1 = 0;
    #(`PERIOD)
        HBUSREQ_M1 = 0;
        HADDR_M1 = 0;
        HTRANS_M1 = `TRN_IDLE;
        HWRITE_M1 = 1;
        HLOCK_M1 = 0;
        HWDATA_M1 = 7;
    end
//M2
  initial begin
    #(`PERIOD*4+1) HBUSREQ_M2 = 1; HLOCK_M2 = 0;
    #(`PERIOD*3)
        HBUSREQ_M2 = 0;
        HADDR_M2 = {`S2_SELECTED,28'd8};
        HTRANS_M2 = `TRN_BUSY;
        HWRITE_M2 = 1;
        HLOCK_M2 = 0;
        HWDATA_M2 = 0;
	  #(`PERIOD) HTRANS_M2 = `TRN_NONSEQ;
    #(`PERIOD)
        HBUSREQ_M2 = 0;
        HADDR_M2 = 0;
        HTRANS_M2 = `TRN_IDLE;
        HWRITE_M2 = 1;
        HLOCK_M2 = 0;
        HWDATA_M2 = 8;
  end

// AHB Signals SLAVE
//S1
  initial begin
  	#(`PERIOD*4+1)
      HRDATA_S1 = 0; 
      HREADY_S1 = 1;
      HRESP_S1 = `RSP_OKAY;
  end
//S2
  initial begin
  	#(`PERIOD*5+1)
      HRDATA_S2 = 0; 
      HREADY_S2 = 1; 
      HRESP_S2 = `RSP_OKAY;
  end
`endif

//--------------------------------------
// AHB SLAVE FUNCTION TEST
//--------------------------------------  
`ifdef TEST2
// AHB Signals MASTER
//M1
  initial begin
    #(`PERIOD*3+1) HBUSREQ_M1 = 1; HLOCK_M1 = 0;
    #(`PERIOD)
        HBUSREQ_M1 = 0;
        HADDR_M1 = {`S1_SELECTED,28'd4};
        HTRANS_M1 = `TRN_NONSEQ;
        HWRITE_M1 = 0;
        HLOCK_M1 = 0;
        HWDATA_M1 = 0;
    #(`PERIOD)
        HBUSREQ_M1 = 0;
        HADDR_M1 = 0;
        HTRANS_M1 = `TRN_IDLE;
        HWRITE_M1 = 0;
        HLOCK_M1 = 0;
        HWDATA_M1 = 0;
    end
//M2
  initial begin
    #(`PERIOD*4+1) HBUSREQ_M2 = 1; HLOCK_M2 = 0;
    #(`PERIOD)
        HBUSREQ_M2 = 0;
        HADDR_M2 = {`S2_SELECTED,28'd8};
        HTRANS_M2 = `TRN_NONSEQ;
        HWRITE_M2 = 0;
        HLOCK_M2 = 0;
        HWDATA_M2 = 0;
    #(`PERIOD*2)
        HBUSREQ_M2 = 0;
        HADDR_M2 = 0;
        HTRANS_M2 = `TRN_IDLE;
        HWRITE_M2 = 0;
        HLOCK_M2 = 0;
        HWDATA_M2 = 0;
  end

// AHB Signals SLAVE
//S1
  initial begin
    #(`PERIOD*4+1)
      HREADY_S1 = 1;
    #(`PERIOD)
      HRDATA_S1 = 7; 
      HREADY_S1 = 0; 
      HRESP_S1 = `RSP_OKAY;
	  #(`PERIOD) HREADY_S1 = 1;
  end
//S2
  initial begin
    #(`PERIOD*7+1)
      HRDATA_S2 = 8; 
      HREADY_S2 = 0; 
      HRESP_S2 = `RSP_ERROR; 
    #(`PERIOD)
      HRDATA_S2 = 8; 
      HREADY_S2 = 1; 
      HRESP_S2 = `RSP_ERROR; 
  end
`endif

//--------------------------------------
// AHB MASTER & SLAVE FUNCTION TEST
//--------------------------------------  
`ifdef TEST3
// AHB Signals MASTER
//M1
  initial begin
    /*complete this part by yourself*/
    end
//M2
  initial begin
   /*complete this part by yourself*/
  end

// AHB Signals SLAVE
//S1
  initial begin
    /*complete this part by yourself*/
  end
//S2
  initial begin
    /*complete this part by yourself*/
  end
`endif

//sim-time limit
  initial #400 $finish;

  initial begin
  `ifdef FSDB
    $fsdbDumpfile("AHB.fsdb");
    $fsdbDumpvars;
  `else
    $dumpfile("AHB.vcd");
    $dumpvars;
  `endif
  end

endmodule