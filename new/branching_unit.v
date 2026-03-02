`timescale 1ns / 1ps

module branching_unit (
    input  wire [31:0] pc_e,
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    input  wire [31:0] imm,
    input  wire        branch,

    output wire        taken,
    output wire [31:0] target
);

    // BEQ condition
    assign taken  = branch && (rs1 == rs2);

    // Branch target = PC + immediate
    assign target = pc_e + imm;

endmodule
