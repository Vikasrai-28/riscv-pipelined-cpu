`timescale 1ns / 1ps

module id_ex_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        id_ex_flush,

    input  wire [31:0] pc_d,
    input  wire [31:0] rs1_data_d,
    input  wire [31:0] rs2_data_d,
    input  wire [31:0] imm_d,
    input  wire [4:0]  rd_d,
    input  wire [4:0]  rs1_d,
    input  wire [4:0]  rs2_d,

    input  wire        reg_write_d,
    input  wire        alu_src_d,
    input  wire        branch_d,

    output reg  [31:0] pc_e,
    output reg  [31:0] rs1_data_e,
    output reg  [31:0] rs2_data_e,
    output reg  [31:0] imm_e,
    output reg  [4:0]  rd_e,
    output reg  [4:0]  rs1_e,
    output reg  [4:0]  rs2_e,
    output reg         reg_write_e,
    output reg         alu_src_e,
    output reg         branch_e
);

    always @(posedge clk) begin
        if (reset || id_ex_flush) begin
            pc_e        <= 0;
            rs1_data_e  <= 0;
            rs2_data_e  <= 0;
            imm_e       <= 0;
            rd_e        <= 0;
            rs1_e       <= 0;
            rs2_e       <= 0;
            reg_write_e <= 0;
            alu_src_e   <= 0;
            branch_e    <= 0;
        end else begin
            pc_e        <= pc_d;
            rs1_data_e  <= rs1_data_d;
            rs2_data_e  <= rs2_data_d;
            imm_e       <= imm_d;
            rd_e        <= rd_d;
            rs1_e       <= rs1_d;
            rs2_e       <= rs2_d;
            reg_write_e <= reg_write_d;
            alu_src_e   <= alu_src_d;
            branch_e    <= branch_d;
        end
    end

endmodule
