module imm_reg_select_mux(imm_reg_out, mux4to1_out, read_data2, imm_reg_select);

    parameter DataSize = 32;

    output [DataSize-1:0]imm_reg_out;

    input [DataSize-1:0]mux4to1_out;
    input [DataSize-1:0]read_data2;
    input imm_reg_select;
  
    assign imm_reg_out = (imm_reg_select) ? mux4to1_out : read_data2;

endmodule
