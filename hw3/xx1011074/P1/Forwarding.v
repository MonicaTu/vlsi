module Forwarding(
    IfIdRegRs,
    IfIdRegRt,
    Branch,
    IdExRegRs,
    IdExRegRt,
    ExMemRegWrite,
    ExMemRegRd,
    MemWbRegWrite,
    MemWbRegRd,
    ForwardA_ALU,	
    ForwardB_ALU, 
    ForwardA_EQ,
    ForwardB_EQ
);

input [4:0] IdExRegRs, IdExRegRt, ExMemRegRd, MemWbRegRd, IfIdRegRs, IfIdRegRt; 
input ExMemRegWrite,  MemWbRegWrite, Branch;
output [1:0] ForwardA_ALU, ForwardB_ALU, ForwardA_EQ, ForwardB_EQ;

reg [1:0] ForwardA_ALU, ForwardB_ALU, ForwardA_EQ, ForwardB_EQ;

initial begin
ForwardA_ALU = 2'b00;
ForwardB_ALU = 2'b00;
ForwardA_EQ = 2'b00;
ForwardB_EQ = 2'b00;
end

always @ (IdExRegRs or IdExRegRt or ExMemRegRd or MemWbRegRd or IfIdRegRs or IfIdRegRt or ExMemRegWrite or MemWbRegWrite) begin

if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IdExRegRs)) 
    ForwardA_ALU <= 2'b10;
else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IdExRegRs))
    ForwardA_ALU <= 2'b01;
  else
    ForwardA_ALU <= 2'b00;
    
if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IdExRegRt))
    ForwardB_ALU <= 2'b10;
else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IdExRegRt))
    ForwardB_ALU <= 2'b01;
  else
    ForwardB_ALU <= 2'b00;


if (Branch) begin
  if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IfIdRegRs)) 
    ForwardA_EQ <= 2'b10;
  else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRs))
    ForwardA_EQ <= 2'b01;
  else
    ForwardA_EQ <= 2'b00;
    
  if (ExMemRegWrite && (ExMemRegRd != 5'b0) && (ExMemRegRd == IfIdRegRt))
    ForwardB_EQ <= 2'b10;
  else if (MemWbRegWrite && (MemWbRegRd != 5'b0) && (MemWbRegRd == IfIdRegRt))
    ForwardB_EQ <= 2'b01;
  else
    ForwardB_EQ <= 2'b00;
    
  end
end


endmodule
