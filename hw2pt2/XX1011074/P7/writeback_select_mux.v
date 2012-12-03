module writeback_select_mux(write_data, DMout, alu_result, regData, writeback_select);

  parameter DataSize = 32;
  parameter sel_aluResult = 2'b00, sel_DMout = 2'b01, sel_regData = 2'b10; 

  input [DataSize-1:0] DMout;
  input [DataSize-1:0] alu_result;
  input [DataSize-1:0] regData;
  input [1:0]writeback_select;
  
  output [DataSize-1:0] write_data;
  
  reg [DataSize-1:0] write_data;

  always @ (alu_result or DMout or regData or writeback_select) begin
    case(writeback_select)
      sel_aluResult: write_data = alu_result;
      sel_DMout: write_data = DMout;
      sel_regData: write_data = regData;
      default: write_data = alu_result;
    endcase
  end

endmodule
