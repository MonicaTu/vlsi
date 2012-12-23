module Hazard_Detection(
    IFIDaddress1,
    IFIDaddress2,
    IDEXRegDST,
    IDEXMemRead,
    IDEXRegWrite,
    Branch,
    Stall,
    clk
);

input [4:0] IFIDaddress1, IFIDaddress2, IDEXRegDST;
input IDEXMemRead, Branch, IDEXRegWrite, clk;
output Stall;

reg Stall, Stall2;

initial begin
  Stall <= 0;
  Stall2 <= 0;
end

always @ (negedge clk) begin
  Stall <= 0;
  if (Branch) begin
    if (IDEXMemRead && ((IFIDaddress1 == IDEXRegDST) || (IFIDaddress2 == IDEXRegDST))) begin
      Stall <= 1;
      Stall2 <= 1;
    end else if (IDEXRegWrite && ((IFIDaddress1 == IDEXRegDST) || (IFIDaddress2 == IDEXRegDST))) begin
      Stall <= 1;
      Stall2 <= 0;
    end else if (Stall2) begin
      Stall <= 1;
      Stall2 <= 0;
    end
  end else if (IDEXMemRead && ((IFIDaddress1 == IDEXRegDST) || (IFIDaddress2 == IDEXRegDST))) begin
      Stall <= 1;
      Stall2 <= 0;
  end else begin
      Stall <= 0; 
  end

end

endmodule
