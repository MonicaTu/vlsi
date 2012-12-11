`timescale 1ns/10ps
module AHB
(HCLK, HRESETn,
 // AHB Signals
 HTRANS, HADDR, HWRITE, HSIZE, HWDATA,
 // Multiplexed slave output signals
 HRDATA, HREADY, HRESP, 
 // Slave specific output signals
 //S1
 HSEL_S1, HRDATA_S1, HREADY_S1, HRESP_S1,
 //S2
 HSEL_S2, HRDATA_S2, HREADY_S2, HRESP_S2,
 // Master specific signals
 //M1
 HADDR_M1, HTRANS_M1, HWRITE_M1, HSIZE_M1, HWDATA_M1, HBUSREQ_M1, HLOCK_M1, HGRANT_M1,
 //M2
 HADDR_M2, HTRANS_M2, HWRITE_M2, HSIZE_M2, HWDATA_M2, HBUSREQ_M2, HLOCK_M2, HGRANT_M2
);

input         HCLK;   		// External clock in
input         HRESETn;   	// Power on reset input

//--------------------------------------
// AHB Signals
//--------------------------------------
output  [1:0] HTRANS;  
output [31:0] HADDR;   
output        HWRITE;  
output  [2:0] HSIZE;   
output [31:0] HWDATA;  

// Multiplexed slave output signals
output [31:0] HRDATA;  
output        HREADY;  
output  [1:0] HRESP;   

// Slave specific output signals
//S1
output        HSEL_S1;   
input  [31:0] HRDATA_S1; 
input         HREADY_S1; 
input   [1:0] HRESP_S1;  
//S2
output        HSEL_S2;   
input  [31:0] HRDATA_S2; 
input         HREADY_S2; 
input   [1:0] HRESP_S2;  
//Defualt Slave             
wire          HSELDefault;
wire          HREADYDefault;
wire    [1:0] HRESPDefault;

// Master specific signals
//M0 Default Master
//M1
input  [31:0] HADDR_M1;   
input   [1:0] HTRANS_M1;  
input         HWRITE_M1;  
input   [2:0] HSIZE_M1;   
input  [31:0] HWDATA_M1;  
input         HBUSREQ_M1; 
input         HLOCK_M1;   
output        HGRANT_M1;  
//M2              
input  [31:0] HADDR_M2;   
input   [1:0] HTRANS_M2;  
input         HWRITE_M2;  
input   [2:0] HSIZE_M2;   
input  [31:0] HWDATA_M2;  
input         HBUSREQ_M2; 
input         HLOCK_M2;   
output        HGRANT_M2;

wire          HGRANTdummy;

// Arbiter signals
wire    [2:0] HMASTER;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The AHB system arbiter
Arbiter  uArbiter 
(.HCLK         (HCLK),
 .HRESETn      (HRESETn),
 .HTRANS       (HTRANS),
 .HREADY       (HREADY),
 .HRESP        (HRESP),
                    
 .HBUSREQ0     (1'b0),
 .HBUSREQ1     (HBUSREQ_M1),
 .HBUSREQ2     (HBUSREQ_M2),
                    
 .HLOCK0       (1'b0),
 .HLOCK1       (HLOCK_M1),
 .HLOCK2       (HLOCK_M2),
                    
 .HGRANT0      (HGRANTdummy),
 .HGRANT1      (HGRANT_M1),
 .HGRANT2      (HGRANT_M2),
                    
 .HMASTER      (HMASTER)  // Current bus master
);

// The system address Decoder
Decoder uDecoder 
(.HRESETn      (HRESETn),
 .HADDR        (HADDR),
           
 .HSELDefault  (HSELDefault),  // Default Slave
 .HSEL_Slave1  (HSEL_S1),  // S1
 .HSEL_Slave2  (HSEL_S2)  // S2
);

// Central multiplexer - masters to slaves
MuxM2S uMuxM2S 
(.HCLK         (HCLK),
 .HRESETn      (HRESETn),
 .HMASTER      (HMASTER),
 .HREADY       (HREADY),
               
 .HADDR_M1     (HADDR_M1),
 .HTRANS_M1    (HTRANS_M1),
 .HWRITE_M1    (HWRITE_M1),
 .HSIZE_M1     (HSIZE_M1),
 .HWDATA_M1    (HWDATA_M1),
               
 .HADDR_M2     (HADDR_M2),
 .HTRANS_M2    (HTRANS_M2),
 .HWRITE_M2    (HWRITE_M2),
 .HSIZE_M2     (HSIZE_M2),
 .HWDATA_M2    (HWDATA_M2),
               
 .HADDR        (HADDR),
 .HTRANS       (HTRANS),
 .HWRITE       (HWRITE),
 .HSIZE        (HSIZE),
 .HWDATA       (HWDATA)
);

// Central multiplexer - slaves to masters
MuxS2M uMuxS2M 
(.HCLK         (HCLK),
 .HRESETn      (HRESETn),
 
 .HSELDefault  (HSELDefault),  // Default Slave
 .HSEL_Slave1  (HSEL_S1),  // S1
 .HSEL_Slave2  (HSEL_S2),  // S2
 
 .HRDATA_S1    (HRDATA_S1),
 .HREADY_S1    (HREADY_S1),
 .HRESP_S1     (HRESP_S1),
 
 .HRDATA_S2    (HRDATA_S2),
 .HREADY_S2    (HREADY_S2),
 .HRESP_S2     (HRESP_S2),
 
 .HREADYDefault(1'b1),
 .HRESPDefault (2'b00),
 
 .HRDATA       (HRDATA),
 .HREADY       (HREADY),
 .HRESP        (HRESP) 
);

endmodule
