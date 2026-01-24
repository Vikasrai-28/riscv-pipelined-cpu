`timescale 1ns / 1ps

module ex_stage (
    input  wire [31:0] pc_e,
    input  wire [31:0] rs1_data_e,
    input  wire [31:0] rs2_data_e,
    input  wire [31:0] imm_e,
    input  wire        alu_src_e,
    input  wire        branch_e,

    // forwarding inputs
    input  wire [31:0] alu_result_m,
    input  wire [31:0] wb_data,
    input  wire [1:0]  forward_a,
    input  wire [1:0]  forward_b,

    input  wire [4:0]  rd_e,

    output wire [31:0] alu_result_e,
    output wire [4:0]  rd_out,
    output wire        branch_taken_e,
    output wire [31:0] branch_target_e
);

    // ================= Forwarded operands =================
    wire [31:0] a, b, alu_b;

    assign a = (forward_a == 2'b10) ? alu_result_m :
               (forward_a == 2'b01) ? wb_data :
                                      rs1_data_e;

    assign b = (forward_b == 2'b10) ? alu_result_m :
               (forward_b == 2'b01) ? wb_data :
                                      rs2_data_e;

    // ================= ALU =================
    assign alu_b        = alu_src_e ? imm_e : b;
    assign alu_result_e = a + alu_b;   // ADD only (fine for now)

    // ================= Branch unit =================
    branching_unit BU (
        .pc_e   (pc_e),
        .rs1    (a),
        .rs2    (b),
        .imm    (imm_e),
        .branch (branch_e),
        .taken  (branch_taken_e),
        .target (branch_target_e)
    );

    assign rd_out = rd_e;

endmodule
