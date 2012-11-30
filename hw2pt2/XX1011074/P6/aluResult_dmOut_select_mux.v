module aluResult_DMout_select_mux (aluResult_DMout_select_out, alu_result, DMout, aluResult_DMout_select);

  parameter DataSize = 32;

  output [DataSize-1:0] aluResult_DMout_select_out;
  input [DataSize-1:0] alu_result;
  input [DataSize-1:0] DMout;
  input aluResult_DMout_select;

  assign aluResult_DMout_select_out = (aluResult_DMout_select) ? alu_result : DMout;

endmodule
