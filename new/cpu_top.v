`timescale 1ns / 1ps
`default_nettype none

module cpu_top (
    input  wire clk,
    input  wire reset,
   output wire debug_out

);

    // ================= WB =================
    wire [31:0] wb_data;
    wire [4:0]  wb_rd;
    wire        wb_we;

    assign debug_out = wb_data[0];

    // ================= IF =================
    wire [31:0] pc_f, instr_f;
    wire        stall_f;

    // ================= IF/ID ===============
    wire [31:0] pc_d, instr_d;
    wire        flush_d;

    // ================= ID ==================
    wire [4:0]  rs1_d, rs2_d, rd_d;
    wire [31:0] imm_d, rs1_data_d, rs2_data_d;
    wire        reg_write_d, mem_read_d, mem_write_d, mem_to_reg_d;
    wire        alu_src_d, branch_d;
    wire [2:0]  alu_op_d;

    // ================= ID/EX ================
    wire [31:0] rs1_data_e, rs2_data_e, imm_e;
    wire [4:0]  rs1_e, rs2_e, rd_e;
    wire        reg_write_e, mem_read_e, mem_write_e, mem_to_reg_e;
    wire        alu_src_e, branch_e;
    wire [2:0]  alu_op_e;

    // ================= EX/MEM ===============
    wire [31:0] alu_result_m, rs2_data_m;
    wire [4:0]  rd_m;
    wire        reg_write_m, mem_read_m, mem_write_m, mem_to_reg_m;

    // ================= MEM/WB ===============
    wire [31:0] alu_result_w, mem_read_data_w;
    wire [4:0]  rd_w;
    wire        reg_write_w, mem_to_reg_w;

    // ================= FORWARDING ===========
    wire [1:0]  forward_a, forward_b;
    wire [31:0] alu_in1, alu_in2;



    /* ===================== IF ===================== */

    if_stage IF (
        .clk(clk),
        .reset(reset),
        .stall(stall_f),
        .pc_out(pc_f)
    );

    instr_mem IMEM (
        .addr(pc_f),
        .instr(instr_f)
    );

    /* ==================== IF/ID ================== */

    if_id_reg IF_ID (
        .clk(clk),
        .reset(reset),
        .stall(stall_f),
        .flush(flush_d),
        .pc_in(pc_f),
        .instr_in(instr_f),
        .pc_out(pc_d),
        .instr_out(instr_d)
    );

    /* ===================== ID ==================== */
  
 
    
  


    id_stage ID (
        .instr(instr_d),
        .rs1(rs1_d),
        .rs2(rs2_d),
        .rd(rd_d),
        .imm(imm_d)
    );

    control_unit CU (
        .opcode(instr_d[6:0]),
        .regwrite(reg_write_d),
        .memread(mem_read_d),
        .memwrite(mem_write_d),
        .memtoreg(mem_to_reg_d),
        .alusrc(alu_src_d),
        .branch(branch_d),
        .aluop(alu_op_d)
    );

    regfile RF (
        .clk(clk),
        .we(wb_we),
        .rs1(rs1_d),
        .rs2(rs2_d),
        .rd(wb_rd),
        .wd(wb_data),
        .rd1(rs1_data_d),
        .rd2(rs2_data_d)
    );

    /* ============== HAZARD DETECTION ============== */
    wire stall_d, flush_e;

    hazard_detection_unit HDU (
        .id_rs1(rs1_d),
        .id_rs2(rs2_d),
        .ex_rd(rd_e),
        .ex_memread(mem_read_e),
        .stall(stall_d),
        .flush(flush_e)
    );

    assign stall_f = stall_d;
    assign flush_d = flush_e;

    /* ==================== ID/EX ================== */
 

    
  
   id_ex_reg ID_EX (
    .clk(clk),
    .reset(reset),
    .flush(flush_e),

    .rs1_data_in(rs1_data_d),
    .rs2_data_in(rs2_data_d),
    .imm_in(imm_d),

    .rs1_in(rs1_d),
    .rs2_in(rs2_d),
    .rd_in(rd_d),

    .regwrite_in(reg_write_d),
    .memread_in(mem_read_d),
    .memwrite_in(mem_write_d),
    .memtoreg_in(mem_to_reg_d),
    .alusrc_in(alu_src_d),
    .branch_in(branch_d),
    .aluop_in(alu_op_d),

    .rs1_data_out(rs1_data_e),
    .rs2_data_out(rs2_data_e),
    .imm_out(imm_e),

    .rs1_out(rs1_e),
    .rs2_out(rs2_e),
    .rd_out(rd_e),

    .regwrite_out(reg_write_e),
    .memread_out(mem_read_e),
    .memwrite_out(mem_write_e),
    .memtoreg_out(mem_to_reg_e),
    .alusrc_out(alu_src_e),
    .branch_out(branch_e),
    .aluop_out(alu_op_e)
);

        /* ============== FORWARDING ================== */
 
  
  forwarding_unit FU (
    .rs1_e(rs1_e),
    .rs2_e(rs2_e),
    .rd_m(rd_m),
    .reg_write_m(reg_write_m),
    .rd_w(rd_w),
    .reg_write_w(reg_write_w),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

    /* ============== FORWARDING MUXES ================== */

    // ALU operand A forwarding
    assign alu_in1 =
        (forward_a == 2'b00) ? rs1_data_e :
        (forward_a == 2'b10) ? alu_result_m :
        (forward_a == 2'b01) ? wb_data :
                               rs1_data_e;

    // Forwarded rs2
    wire [31:0] rs2_forwarded =
        (forward_b == 2'b00) ? rs2_data_e :
        (forward_b == 2'b10) ? alu_result_m :
        (forward_b == 2'b01) ? wb_data :
                               rs2_data_e;

    // ALUSRC applied AFTER forwarding
    assign alu_in2 = alu_src_e ? imm_e : rs2_forwarded;


    /* ===================== EX ===================== */
    wire [31:0] alu_result_e;
    wire        zero_e;

    ex_stage EX (
        .rs1(alu_in1),
        .rs2(alu_in2),
        .imm(imm_e),
        .alusrc(alu_src_e),
        .aluop(alu_op_e),
        .alu_out(alu_result_e),
        .zero(zero_e)
    );

    /* ==================== EX/MEM ================= */
   
  
   

    ex_mem_reg EX_MEM (
        .clk(clk),
        .reset(reset),
        .flush(branch_e & zero_e),

        .alu_result_e(alu_result_e),
        .rs2_data_e(rs2_data_e),
        .rd_e(rd_e),

        .reg_write_e(reg_write_e),
        .mem_read_e(mem_read_e),
        .mem_write_e(mem_write_e),
        .mem_to_reg_e(mem_to_reg_e),

        .alu_result_m(alu_result_m),
        .rs2_data_m(rs2_data_m),
        .rd_m(rd_m),

        .reg_write_m(reg_write_m),
        .mem_read_m(mem_read_m),
        .mem_write_m(mem_write_m),
        .mem_to_reg_m(mem_to_reg_m)
    );

    /* ===================== MEM =================== */
    wire [31:0] mem_read_data_m;

    data_mem DMEM (
        .clk(clk),
        .mem_read(mem_read_m),
        .mem_write(mem_write_m),
        .addr(alu_result_m),
        .write_data(rs2_data_m),
        .read_data(mem_read_data_m)
    );

    /* =================== MEM/WB ================= */
  
 
  

    mem_wb_reg MEM_WB (
        .clk(clk),
        .reset(reset),

        .alu_result_m(alu_result_m),
        .mem_read_data_m(mem_read_data_m),
        .rd_m(rd_m),
        .reg_write_m(reg_write_m),
        .mem_to_reg_m(mem_to_reg_m),

        .alu_result_w(alu_result_w),
        .mem_read_data_w(mem_read_data_w),
        .rd_w(rd_w),
        .reg_write_w(reg_write_w),
        .mem_to_reg_w(mem_to_reg_w)
    );

    /* ===================== WB ==================== */
  
    wb_stage WB (
        .alu_result_w(alu_result_w),
        .mem_data_w(mem_read_data_w),
        .rd_w(rd_w),
        .mem_to_reg_w(mem_to_reg_w),
        .reg_write_w(reg_write_w),

        .wb_data(wb_data),
        .wb_rd(wb_rd),
        .wb_we(wb_we)
    );

endmodule

