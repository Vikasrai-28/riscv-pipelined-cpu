`timescale 1ns / 1ps

module cpu_top (
    input  wire        clk,
    input  wire        reset,

    // Debug outputs
    output wire [31:0] pc,
    output wire [31:0] instr,
    output wire        wb_we,
    output wire [4:0]  wb_rd,
    output wire [31:0] wb_data
);

    // ======================================================
    // IF STAGE
    // ======================================================
    wire [31:0] instr_f;
    wire        pc_write;
    wire        pc_src;
    wire [31:0] pc_branch;

    if_stage IF (
        .clk       (clk),
        .reset     (reset),
        .pc_write  (pc_write),
        .pc_src    (pc_src),
        .pc_branch (pc_branch),
        .pc        (pc),
        .instr_f   (instr_f)
    );

    // ======================================================
    // IF / ID PIPELINE REGISTER
    // ======================================================
    wire [31:0] pc_d, instr_d;
    wire        if_id_write;
    wire        if_id_flush;

    if_id_reg IF_ID (
        .clk         (clk),
        .reset       (reset),
        .if_id_write (if_id_write),
        .flush       (if_id_flush),
        .pc_f        (pc),
        .instr_f     (instr_f),
        .pc_d        (pc_d),
        .instr_d     (instr_d)
    );

    assign instr = instr_d;

    // ======================================================
    // ID STAGE
    // ======================================================
    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode;
    wire [31:0] imm;

    id_stage ID (
        .instr  (instr_d),
        .rs1    (rs1),
        .rs2    (rs2),
        .rd     (rd),
        .opcode (opcode),
        .imm    (imm)
    );

    // ======================================================
    // CONTROL UNIT
    // ======================================================
    wire reg_write_d, alu_src_d, branch_d;

    control_unit CU (
        .opcode    (opcode),
        .reg_write (reg_write_d),
        .alu_src   (alu_src_d),
        .branch    (branch_d)
    );

    // ======================================================
    // REGISTER FILE
    // ======================================================
    wire [31:0] rf_rd1, rf_rd2;

    regfile RF (
        .clk  (clk),
        .we   (wb_we),
        .ra1  (rs1),
        .ra2  (rs2),
        .wa   (wb_rd),
        .wd   (wb_data),
        .rd1  (rf_rd1),
        .rd2  (rf_rd2)
    );

    // ======================================================
    // ID / EX PIPELINE REGISTER
    // ======================================================
    wire [31:0] pc_e, rs1_e, rs2_e, imm_e;
    wire [4:0]  rd_e, rs1_idx_e, rs2_idx_e;
    wire        reg_write_e, alu_src_e, branch_e;
    wire        id_ex_flush;

    id_ex_reg ID_EX (
        .clk          (clk),
        .reset        (reset),
        .id_ex_flush  (id_ex_flush),

        .pc_d         (pc_d),
        .rs1_data_d   (rf_rd1),
        .rs2_data_d   (rf_rd2),
        .imm_d        (imm),
        .rd_d         (rd),
        .rs1_d        (rs1),
        .rs2_d        (rs2),

        .reg_write_d  (reg_write_d),
        .alu_src_d    (alu_src_d),
        .branch_d     (branch_d),

        .pc_e         (pc_e),
        .rs1_data_e   (rs1_e),
        .rs2_data_e   (rs2_e),
        .imm_e        (imm_e),
        .rd_e         (rd_e),
        .rs1_e        (rs1_idx_e),
        .rs2_e        (rs2_idx_e),
        .reg_write_e  (reg_write_e),
        .alu_src_e    (alu_src_e),
        .branch_e     (branch_e)
    );

    // ======================================================
    // FORWARDING UNIT
    // ======================================================
    wire [1:0] forward_a, forward_b;
    wire [31:0] alu_result_m;
    wire [4:0]  rd_m;
    wire        reg_write_m;

    forwarding_unit FU (
        .rs1_e        (rs1_idx_e),
        .rs2_e        (rs2_idx_e),
        .rd_m         (rd_m),
        .reg_write_m  (reg_write_m),
        .rd_w         (wb_rd),
        .reg_write_w  (wb_we),
        .forward_a    (forward_a),
        .forward_b    (forward_b)
    );

    // ======================================================
    // EX STAGE (ALU + BRANCH)
    // ======================================================
    wire [31:0] alu_result_e;
    wire [4:0]  rd_ex;
    wire        branch_taken_e;
    wire [31:0] branch_target_e;

    ex_stage EX (
        .pc_e            (pc_e),
        .rs1_data_e      (rs1_e),
        .rs2_data_e      (rs2_e),
        .imm_e           (imm_e),
        .alu_src_e       (alu_src_e),
        .branch_e        (branch_e),

        .alu_result_m    (alu_result_m),
        .wb_data         (wb_data),
        .forward_a       (forward_a),
        .forward_b       (forward_b),

        .rd_e            (rd_e),
        .alu_result_e    (alu_result_e),
        .rd_out          (rd_ex),
        .branch_taken_e  (branch_taken_e),
        .branch_target_e (branch_target_e)
    );

    // ======================================================
    // EX / MEM PIPELINE REGISTER  (✔ BRANCH FLUSH FIX)
    // ======================================================
   wire ex_mem_flush;
assign ex_mem_flush = branch_taken_e;

   ex_mem_reg EX_MEM (
    .clk           (clk),
    .reset         (reset),
    .flush         (ex_mem_flush),   // <<< ADD
    .alu_result_e  (alu_result_e),
    .rd_e          (rd_ex),
    .reg_write_e   (reg_write_e),
    .alu_result_m  (alu_result_m),
    .rd_m          (rd_m),
    .reg_write_m   (reg_write_m)
);

    // ======================================================
    // MEM / WB PIPELINE REGISTER
    // ======================================================
    mem_wb_reg MEM_WB (
        .clk           (clk),
        .reset         (reset),
        .alu_result_m  (alu_result_m),
        .rd_m          (rd_m),
        .reg_write_m   (reg_write_m),

        .alu_result_w  (wb_data),
        .rd_w          (wb_rd),
        .reg_write_w   (wb_we)
    );

    // ======================================================
    // HAZARD DETECTION UNIT (NO LOADS YET)
    // ======================================================
    wire if_id_write_hazard, id_ex_flush_hazard;

    hazard_detection_unit HDU (
        .reset        (reset),
        .rs1_d        (rs1),
        .rs2_d        (rs2),
        .mem_read_e   (1'b0),
        .rd_e         (rd_e),

        .pc_write     (pc_write),
        .if_id_write  (if_id_write_hazard),
        .id_ex_flush  (id_ex_flush_hazard)
    );

    // ======================================================
    // PIPELINE CONTROL & BRANCH HANDLING
    // ======================================================
    assign pc_src      = branch_taken_e;
    assign pc_branch   = branch_target_e;

    assign id_ex_flush = id_ex_flush_hazard | branch_taken_e;
    assign if_id_flush = branch_taken_e;
    assign if_id_write = if_id_write_hazard & ~branch_taken_e;

endmodule
