`timescale 1ns / 1ps

module mem_wb_reg (
    input  wire        clk,
    input  wire        reset,

    // ===== Inputs from MEM stage =====
    input  wire [31:0] alu_result_m,
    input  wire [31:0] mem_read_data_m,
    input  wire [4:0]  rd_m,
    input  wire        reg_write_m,
    input  wire        mem_to_reg_m,

    // ===== Outputs to WB stage =====
    output reg  [31:0] alu_result_w,
    output reg  [31:0] mem_read_data_w,
    output reg  [4:0]  rd_w,
    output reg         reg_write_w,
    output reg         mem_to_reg_w
);

    always @(posedge clk) begin
        if (reset) begin
            alu_result_w     <= 32'b0;
            mem_read_data_w  <= 32'b0;
            rd_w             <= 5'b0;
            reg_write_w      <= 1'b0;
            mem_to_reg_w     <= 1'b0;
        end else begin
            alu_result_w     <= alu_result_m;
            mem_read_data_w  <= mem_read_data_m;
            rd_w             <= rd_m;
            reg_write_w      <= reg_write_m;
            mem_to_reg_w     <= mem_to_reg_m;
        end
    end

endmodule
