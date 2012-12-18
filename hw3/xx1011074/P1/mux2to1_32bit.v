module mux2to1_32bit (o_data, i_data0, i_data1, i_select);

 input [31:0] i_data0;
 input [31:0] i_data1;
 input i_select;

 output [31:0] o_data;
// reg    [31:0] o_data;

 assign o_data = (i_select) ? i_data1 : i_data0;

endmodule
