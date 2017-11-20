module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input	[31:0]	data1_i, data2_i;
input	[2:0]	ALUCtrl_i;
output	[31:0]	data_o;
output			Zero_o;

reg 	[31:0]	data_o;
reg		Zero_o;

always @( data1_i or data2_i or ALUCtrl_i) begin

	case(ALUCtrl_i)
	3'b000:	// and
	data_o = data1_i & data2_i ;
	3'b001:	// or
	data_o = data1_i | data2_i ;
	3'b010:	// add
	data_o = data1_i + data2_i ;
	3'b011:	// sub
	data_o = data1_i - data2_i ;
	3'b100:	// mul
	data_o = data1_i * data2_i ;
	endcase

	if(data_o == 32'b0) Zero_o = 1'b1;
	else Zero_o = 1'b0;
end

endmodule
