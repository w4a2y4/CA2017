module Sign_Extend 
(
    data_i,
    data_o
);

input	[15:0]	data_i;
output	[31:0]	data_o;

assign data_o[31:16] = data_i[15] ? 16'HFFFF : 16'H0000;
assign data_o[15:0] = data_i;

endmodule