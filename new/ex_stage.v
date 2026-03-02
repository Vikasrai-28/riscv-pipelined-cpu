module ex_stage (
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    input  wire [31:0] imm,
    input  wire alusrc,
    input  wire [2:0] aluop,
    output wire [31:0] alu_out,
    output wire zero
);
    wire [31:0] b = alusrc ? imm : rs2;
    assign alu_out = rs1 + b;
    assign zero = (alu_out == 0);
endmodule
