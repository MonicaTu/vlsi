`timescale 1ns/10ps
module MuxM2S (HCLK, HRESETn, HMASTER, HREADY, 
			   HADDR_M1, HTRANS_M1, HWRITE_M1, HSIZE_M1, HWDATA_M1,
			   HADDR_M2, HTRANS_M2, HWRITE_M2, HSIZE_M2, HWDATA_M2,
               HADDR, HTRANS, HWRITE, HSIZE, HWDATA);
 
  input         HCLK;
  input         HRESETn;
  input   [2:0] HMASTER;
  input         HREADY;

  input  [31:0] HADDR_M1;
  input   [1:0] HTRANS_M1;
  input         HWRITE_M1;
  input   [2:0] HSIZE_M1;
  input  [31:0] HWDATA_M1;

  input  [31:0] HADDR_M2;
  input   [1:0] HTRANS_M2;
  input         HWRITE_M2;
  input   [2:0] HSIZE_M2;
  input  [31:0] HWDATA_M2;
  
  output [31:0] HADDR;
  output  [1:0] HTRANS;
  output        HWRITE;
  output  [2:0] HSIZE;
  output [31:0] HWDATA;
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// HMASTER output encoding
  `define MST_0 3'b000
  `define MST_1 3'b001
  `define MST_2 3'b010
 
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
  reg  [2:0] HmasterPrev; // Previous HMASTER value

// Registered output signals
  reg [31:0] HADDR;
  reg  [1:0] HTRANS;
  reg        HWRITE;
  reg  [2:0] HSIZE;
  reg [31:0] HWDATA;

//------------------------------------------------------------------------------
// HMASTER register for write data multiplexer
//------------------------------------------------------------------------------
  always @(posedge HCLK or negedge HRESETn)
  begin
    if (!HRESETn)
      HmasterPrev <=#1 5'h0;
    else if (HREADY)
      HmasterPrev <=#1 HMASTER;
  end
 
//------------------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------------------
  always @(HMASTER or HADDR_M1 or HADDR_M2 )
  begin
    case (HMASTER)
      `MST_0 : HADDR = 32'h0000_0000;
      `MST_1 : HADDR = HADDR_M1;
      `MST_2 : HADDR = HADDR_M2;
      default  : HADDR = 32'h0000_0000;
    endcase
  end
  
  always @(HMASTER or HTRANS_M1 or HTRANS_M2 )
  begin
    /*complete this part by yourself*/
  end
  
  always @(HMASTER or HWRITE_M1 or HWRITE_M2 )
  begin
    /*complete this part by yourself*/
  end
  
  always @(HMASTER or HSIZE_M1 or HSIZE_M2 )
  begin
    /*complete this part by yourself*/
  end
  
  always @(HmasterPrev or HWDATA_M1 or HWDATA_M2 )
  begin
    case (HmasterPrev)
      `MST_0 : HWDATA = 32'h0000_0000;
      `MST_1 : HWDATA = HWDATA_M1;
      `MST_2 : HWDATA = HWDATA_M2;
      default  : HWDATA = 32'h0000_0000;
    endcase
  end

endmodule
