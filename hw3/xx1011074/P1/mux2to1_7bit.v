module mux2to1_7bit (o_data, i_data0, i_data1, i_select);

 input [6:0] i_data0;
 input [6:0] i_data1;
 input i_select;

 output [6:0] o_data;
// reg    [6:0] o_data;

 assign o_data = (i_select) ? i_data1 : i_data0;

endmodule
