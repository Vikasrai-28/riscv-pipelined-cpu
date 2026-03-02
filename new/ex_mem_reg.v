`timescale 1ns / 1ps

module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        flush,          // asserted on branch taken

    // ===== Inputs from EX stage =====
    input  wire [31:0] alu_result_e,
    input  wire [31:0] rs2_data_e,     // store data for SW
    input  wire [4:0]  rd_e,

    input  wire        reg_write_e,
    input  wire        mem_read_e,
    input  wire        mem_write_e,
    input  wire        mem_to_reg_e,

    // ===== Outputs to MEM stage =====
    output reg  [31:0] alu_result_m,
    output reg  [31:0] rs2_data_m,
    output reg  [4:0]  rd_m,

    output reg         reg_write_m,
    output reg         mem_read_m,
    output reg         mem_write_m,
    output reg         mem_to_reg_m
);

    always @(posedge clk) begin
        if (reset || flush) begin
            // ===== INSERT CLEAN BUBBLE =====
            alu_result_m <= 32'b0;
            rs2_data_m   <= 32'b0;
            rd_m         <= 5'b0;

            reg_write_m  <= 1'b0;
            mem_read_m   <= 1'b0;
            mem_write_m  <= 1'b0;
            mem_to_reg_m <= 1'b0;
        end else begin
            alu_result_m <= alu_result_e;
            rs2_data_m   <= rs2_data_e;
            rd_m         <= rd_e;

            reg_write_m  <= reg_write_e;
            mem_read_m   <= mem_read_e;
            mem_write_m  <= mem_write_e;
            mem_to_reg_m <= mem_to_reg_e;
        end
    end

endmodule
