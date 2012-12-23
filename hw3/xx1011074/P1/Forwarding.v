module Forwarding(
    IFIDaddress1,
    IFIDaddress2,
    Branch,
    IDEXaddress1,
    IDEXaddress2,
    EXMEMRegWrite,
    EXMEMaddressT,
    MEMWBRegWrite,
    MEMWBaddressT,
    ForwardA_ALU,	
    ForwardB_ALU, 
    ForwardA_EQ,
    ForwardB_EQ
);

input [4:0] IDEXaddress1, IDEXaddress2, EXMEMaddressT, MEMWBaddressT, IFIDaddress1, IFIDaddress2; 
input EXMEMRegWrite,  MEMWBRegWrite, Branch;
output [1:0] ForwardA_ALU, ForwardB_ALU, ForwardA_EQ, ForwardB_EQ;

reg [1:0] ForwardA_ALU, ForwardB_ALU, ForwardA_EQ, ForwardB_EQ;

initial begin
ForwardA_ALU = 2'b00;
ForwardB_ALU = 2'b00;
ForwardA_EQ = 2'b00;
ForwardB_EQ = 2'b00;
end

always @ (IDEXaddress1 or IDEXaddress2 or EXMEMaddressT or MEMWBaddressT or IFIDaddress1 or IFIDaddress2 or EXMEMRegWrite or MEMWBRegWrite) begin

if (EXMEMRegWrite && (EXMEMaddressT != 5'b0) && (EXMEMaddressT == IDEXaddress1)) 
    ForwardA_ALU <= 2'b10;
else if (MEMWBRegWrite && (MEMWBaddressT != 5'b0) && (MEMWBaddressT == IDEXaddress1))
    ForwardA_ALU <= 2'b01;
  else
    ForwardA_ALU <= 2'b00;
    
if (EXMEMRegWrite && (EXMEMaddressT != 5'b0) && (EXMEMaddressT == IDEXaddress2))
    ForwardB_ALU <= 2'b10;
else if (MEMWBRegWrite && (MEMWBaddressT != 5'b0) && (MEMWBaddressT == IDEXaddress2))
    ForwardB_ALU <= 2'b01;
  else
    ForwardB_ALU <= 2'b00;


if (Branch) begin
  if (EXMEMRegWrite && (EXMEMaddressT != 5'b0) && (EXMEMaddressT == IFIDaddress1)) 
    ForwardA_EQ <= 2'b10;
  else if (MEMWBRegWrite && (MEMWBaddressT != 5'b0) && (MEMWBaddressT == IFIDaddress1))
    ForwardA_EQ <= 2'b01;
  else
    ForwardA_EQ <= 2'b00;
    
  if (EXMEMRegWrite && (EXMEMaddressT != 5'b0) && (EXMEMaddressT == IFIDaddress2))
    ForwardB_EQ <= 2'b10;
  else if (MEMWBRegWrite && (MEMWBaddressT != 5'b0) && (MEMWBaddressT == IFIDaddress2))
    ForwardB_EQ <= 2'b01;
  else
    ForwardB_EQ <= 2'b00;
    
  end
end


endmodule
