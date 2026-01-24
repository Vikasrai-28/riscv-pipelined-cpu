module id_stage (
    input  wire [31:0] instr,
    output wire [4:0] rs1, rs2, rd,
    output wire [6:0] opcode,
    output wire [31:0] imm
);
    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign imm = {{20{instr[31]}}, instr[31:20]};
endmodule
