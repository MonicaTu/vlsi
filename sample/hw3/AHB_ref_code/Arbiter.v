`timescale 1ns/10ps
module Arbiter (HCLK, HRESETn, HTRANS, HREADY, HRESP,
                HBUSREQ0, HBUSREQ1, HBUSREQ2, HLOCK0, HLOCK1, HLOCK2, 
                HGRANT0,  HGRANT1,  HGRANT2, HMASTER);

  input       HCLK;
  input       HRESETn;
  input [1:0] HTRANS;
  input       HREADY;
  input [1:0] HRESP;
  input       HBUSREQ0;
  input       HBUSREQ1;
  input       HBUSREQ2;
  input       HLOCK0;
  input       HLOCK1;
  input       HLOCK2;

  output       HGRANT0;
  output       HGRANT1;
  output       HGRANT2;
  output [2:0] HMASTER;

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
  // HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11
  
  // HRESP transfer response signal encoding
  `define RSP_OKAY   2'b00
  `define RSP_ERROR  2'b01
  `define RSP_RETRY  2'b10
  `define RSP_SPLIT  2'b11
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  wire         HCLK;
  wire         HRESETn;
  wire [1:0]   HTRANS;
  wire [2:0]   HBURST;
  wire         HREADY;
  wire [1:0]   HRESP;
  wire         HBUSREQ0;
  wire         HBUSREQ1;
  wire         HBUSREQ2;
  wire         HLOCK0;
  wire         HLOCK1;
  wire         HLOCK2;
  reg          HGRANT0;
  reg          HGRANT1;
  reg          HGRANT2;
  
  // Request generation
  wire [2:0]   HBUSREQ;
  reg [2:0]    TopRequest;
  reg [2:0]    GrantMaster;
  reg [2:0]    AddrMaster;
  
  // Locked transfer logic
  reg          Lock;
  reg          iHMASTLOCK;
  reg          LockedData;
  wire         HoldLock;

//------------------------------------------------------------------------------
// Register request inputs
//------------------------------------------------------------------------------
  assign HBUSREQ = {HBUSREQ2, HBUSREQ1, HBUSREQ0};

//------------------------------------------------------------------------------
// Arbitration Priority Scheme
//------------------------------------------------------------------------------
  always @ (HBUSREQ or AddrMaster)
    begin
      /*complete this part by yourself using hybrid approach which is a mixture 
        of priority-based and the round robin.*/
    end 

  always @ (iHMASTLOCK or HoldLock or AddrMaster or TopRequest)
    begin
      if  ( (iHMASTLOCK  || HoldLock ) )
        GrantMaster  = AddrMaster ;
      else
        GrantMaster  = TopRequest ;
    end
  
  always @ ( GrantMaster )
    begin
      // Default assigments
      HGRANT0 = 1'b0;
      HGRANT1 = 1'b0;
      HGRANT2 = 1'b0;
      case ( GrantMaster ) /* synopsys parallel_case */
        3'b000: HGRANT0 = 1'b1;
        3'b001: HGRANT1 = 1'b1;
        3'b010: HGRANT2 = 1'b1;
      endcase 
    end 

//------------------------------------------------------------------------------
// HMASTER output generation and registers
//------------------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
    begin
      if (!HRESETn)
        AddrMaster <=#1 3'b000 ;
      else if  ( HREADY )
        AddrMaster  <=#1 ( HTRANS==`TRN_BUSY )? AddrMaster :GrantMaster ;
    end 
    
    assign HMASTER  = AddrMaster ;

//------------------------------------------------------------------------------
// LOCKED TRANSFERS
//------------------------------------------------------------------------------
  always @ ( GrantMaster or HLOCK0 or HLOCK1 or HLOCK2 )
  begin
    case ( GrantMaster )
      3'b000: Lock  = HLOCK0;
      3'b001: Lock  = HLOCK1;
      3'b010: Lock  = HLOCK2;
      default : Lock  = 1'b0;
    endcase
  end 

// The HMASTLOCK output indicates if the current address is a locked transfer.

  always @ (posedge HCLK or negedge HRESETn)
    begin
      if  (!HRESETn)
        iHMASTLOCK  <=#1 1'b0 ;
      else if  ( HREADY )
        iHMASTLOCK  <=#1 Lock ;
    end 

//------------------------------------------------------------------------------
// Last Locked Data
//------------------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
    begin
      if  (!HRESETn)
        LockedData  <=#1 1'b0 ;
      else if  ( HREADY )
        LockedData  <=#1 iHMASTLOCK ;
    end 

  assign HoldLock  = (LockedData ) ? 1'b1  : 1'b0 ;

endmodule
