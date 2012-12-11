`timescale 1ns/10ps
module MuxS2M (HCLK, HRESETn,
HSELDefault, HSEL_Slave1, HSEL_Slave2,
HRDATA_S1, HREADY_S1, HRESP_S1, //S1
HRDATA_S2, HREADY_S2, HRESP_S2, //S2        
HREADYDefault, HRESPDefault, //Default
HRDATA, HREADY, HRESP
);
 
  input         HCLK;
  input         HRESETn;
  
  input			HSELDefault;      // Default Slave
  input			HSEL_Slave1;			// S1
  input			HSEL_Slave2;			// S2
  
  input  [31:0] HRDATA_S1;
  input         HREADY_S1;
  input   [1:0] HRESP_S1;

  input  [31:0] HRDATA_S2;
  input         HREADY_S2;
  input   [1:0] HRESP_S2;

  input         HREADYDefault;
  input   [1:0] HRESPDefault;

  output [31:0] HRDATA;
  output        HREADY;
  output  [1:0] HRESP;
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// HselReg encoding. This must be extended if more than eight AHB peripherals
//  are used in the system.
  `define HSEL_1  			2'b01
  `define HSEL_2  			2'b10
 
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  wire  [4:0] HselNext; // HSEL input bus
  reg   [4:0] HselReg;  // HSEL input register

  reg  [31:0] HRDATA;   // Registered output signal
  reg         HREADY;
  reg   [1:0] HRESP;    // Registered output signal

//------------------------------------------------------------------------------
// HSEL bus and registers
//------------------------------------------------------------------------------
  assign HselNext = {HSEL_Slave2,HSEL_Slave1};

  always @(posedge HCLK or negedge HRESETn)
  begin
    if (!HRESETn)
      HselReg <=#1 2'b00;
    else if (HREADY)
      HselReg <=#1 HselNext;
  end
 
//------------------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------------------
  always @( HselReg or HRDATA_S1 or HRDATA_S2 )
  begin
    case (HselReg)
      `HSEL_1: HRDATA = HRDATA_S1;
      `HSEL_2: HRDATA = HRDATA_S2;
      default: HRDATA = 32'h0000_0001;
    endcase
  end
  
  always @( HselReg or HREADY_S1 or HREADY_S2 or HREADYDefault )
  begin
    /*complete this part by yourself*/
  end
  
  always @( HselReg or HRESP_S1 or HRESP_S2 or HRESPDefault )
  begin
    /*complete this part by yourself*/
  end

endmodule
