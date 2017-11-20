module Control
(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);

input 	[5:0]	Op_i;
output	RegDst_o;
output	[1:0]	ALUOp_o;
output	ALUSrc_o;
output	RegWrite_o;

always @( Op_i ) begin
	// R-type
	case( Op_i )

		6'b000000: 
		begin
			RegDst_o = 1'b1;
			ALUOp_o = 2'b01;
			ALUSrc_o = 1'b0;
			RegWrite_o = 1'b1;
		end

		// I-type
		6'b001000: 
		begin
			RegDst_o = 1'b0;
			ALUOp_o = 2'b10;
			ALUSrc_o = 1'b1;
			RegWrite_o = 1'b1;
		end

	endcase
end

endmodule