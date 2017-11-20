module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] pc_curr, pc_next, inst;
wire [31:0] extended;

wire [1:0]  ctrl_ALUOp;
wire [2:0]  ALU_Ctrl;
wire  ctrl_RegDst, ctrl_ALUSrc, ctrl_RegWrite;
wire [31:0] RS_data, RD_data, ALU_o;

wire [4:0]  MUX_5;
wire [31:0] MUX_32;

wire        zero;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (ctrl_RegDst),
    .ALUOp_o    (ctrl_ALUOp),
    .ALUSrc_o   (ctrl_ALUSrc),
    .RegWrite_o (ctrl_RegWrite)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .start_i(start_i), 
    .pc_i(pc_next),
    .pc_o(pc_curr)
);

Adder Add_PC(
    .data1_i(pc_curr),
    .data2_i(32'd4),
    .data_o(pc_next)
);

Instruction_Memory Instruction_Memory(
    .addr_i(pc_curr),
    .instr_o(inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_5),
    .RDdata_i   (ALU_o),
    .RegWrite_i (ctrl_RegWrite),
    .RSdata_o   (RS_data),
    .RTdata_o   (RD_data) 
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (extended)
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (ctrl_ALUOp),
    .ALUCtrl_o  (ALU_Ctrl)
);

ALU ALU(
    .data1_i    (RS_data), 
    .data2_i    (MUX_32),
    .ALUCtrl_i  (ALU_Ctrl),
    .data_o     (ALU_o),
    .Zero_o     (zero)
);

MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]), 
    .data2_i    (inst[15:11]),
    .select_i   (ctrl_RegDst),
    .data_o     (MUX_5)
);

MUX32 MUX_ALUSrc(
    .data1_i    (RD_data),
    .data2_i    (extended),
    .select_i   (ctrl_ALUSrc),
    .data_o     (MUX_32)
);


endmodule